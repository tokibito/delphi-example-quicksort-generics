.PHONY: all clean

all:
	dcc32 Main.dpr

clean:
	del Main.exe
