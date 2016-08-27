program Main;

{$APPTYPE CONSOLE}

uses
  Generics.Collections,
  Nullpobug.Sandbox.QuickSort in './Nullpobug.Sandbox.QuickSort.pas'
  ;

var
  Values: TList<Integer>;
  Value: Integer;
  QuickSort: TQuickSort<Integer>;

begin
  // Memory leak detection
  ReportMemoryLeaksOnShutdown := True;
  // ソート対象のリストを準備
  Values := TList<Integer>.Create;
  try
    Values.Add(57);
    Values.Add(10);
    Values.Add(88);
    Values.Add(24);
    Values.Add(4);
    Values.Add(99);
    Values.Add(30);
    Values.Add(75);
    Values.Add(12);
    Values.Add(44);
    QuickSort := TQuickSort<Integer>.Create(Values, TIntegerComparer.Create);
    try
      QuickSort.Sort;
    finally
      QuickSort.Free;
    end;
    for Value in Values do
      WriteLn(Value);
  finally
    Values.Free;
  end;
end.
