unit Nullpobug.Sandbox.QuickSort;

interface

uses
  Generics.Collections
  ;

type
  (*
    値の比較に使うインタフェース
  *)
  IComparer<T> = interface
    function Equal(Value1, Value2: T): Boolean;
    function LessThan(Value1, Value2: T): Boolean;
    function GreaterThan(value1, Value2: T): Boolean;
  end;

  TQuickSort<T> = class
  private
    FTarget: TList<T>;
    FValues: array of T;
    FComparer: IComparer<T>;
    procedure InnerSort(Left, Right: Integer);
  protected
    function SelectPivot(Left, Right: Integer): T;
    function CompareValue(Value1, Value2: T): Boolean;
  public
    constructor Create(Target: TList<T>; Comparer: IComparer<T>);
    procedure Sort;
  end;

  (*
    値の比較に使うクラス(Integer型)
  *)
  TIntegerComparer = class(TInterfacedObject, IComparer<Integer>)
  public
    function Equal(Value1, Value2: Integer): Boolean;
    function LessThan(Value1, Value2: Integer): Boolean;
    function GreaterThan(value1, Value2: Integer): Boolean;
  end;

implementation

function TIntegerComparer.Equal(Value1, Value2: Integer): Boolean;
begin
  Result := Value1 = Value2;
end;

function TIntegerComparer.LessThan(Value1, Value2: Integer): Boolean;
begin
  Result := Value1 < Value2;
end;

function TIntegerComparer.GreaterThan(value1, Value2: Integer): Boolean;
begin
  Result := Value1 > Value2;
end;

constructor TQuickSort<T>.Create(Target: TList<T>; Comparer: IComparer<T>);
var
  I: Integer;
begin
  FTarget := Target;
  FComparer := Comparer;
  // ソート対象の値を配列に代入
  SetLength(FValues, FTarget.Count);
  for I := 0 to FTarget.Count - 1 do
    FValues[I] := FTarget[I];
end;

procedure TQuickSort<T>.Sort;
var
  I: Integer;
begin
  InnerSort(Low(FValues), High(FValues));
  // 結果をリストに反映
  FTarget.Clear;
  for I := Low(FValues) to High(FValues) do
    FTarget.Add(FValues[I]);
end;

procedure TQuickSort<T>.InnerSort(Left, Right: Integer);
var
  LeftCursor, RightCursor: Integer;
  Pivot, Temporary: T;
begin
  if Left < Right then
  begin
    LeftCursor := Left;
    RightCursor := Right;
    Pivot := SelectPivot(Left, Right);
    while True do
    begin
      while FComparer.LessThan(FValues[LeftCursor], Pivot) do
        Inc(LeftCursor);
      while FComparer.LessThan(Pivot, FValues[RightCursor]) do
        Dec(RightCursor);
      if LeftCursor >= RightCursor then break;
      // 値を交換
      Temporary := FValues[LeftCursor];
      FValues[LeftCursor] := FValues[RightCursor];
      FValues[RightCursor] := Temporary;
      Inc(LeftCursor);
      Dec(RightCursor);
    end;
    InnerSort(Left, LeftCursor - 1);
    InnerSort(RightCursor + 1, Right);
  end;
end;

function TQuickSort<T>.CompareValue(Value1, Value2: T): Boolean;
begin
  Result := FComparer.LessThan(Value1, Value2);
end;

function TQuickSort<T>.SelectPivot(Left, Right: Integer): T;
(*
  中間値を返す
*)
var
  Value1, Value2, Value3: T;
begin
  // Left, Rightと間の値の3値を比較して、中央値を返す
  Value1 := FValues[Left];
  Value2 := FValues[Right];
  Value3 := FValues[Left + (Right - Left) div 2];
  if CompareValue(Value1, Value2) then
  begin
    if CompareValue(Value2, Value3) then
      Result := Value2
    else
      Result := Value3
  end
  else
  begin
    if CompareValue(Value1, Value3) then
      Result := Value1
    else
      Result := Value3
  end;
end;

end.
