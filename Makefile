.PHONY: all osx clean

all:
	dcc32 Main.dpr

osx:
	dccosx Main.dpr

clean:
	del Main.exe
