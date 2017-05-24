# "Guess the gun" game in Prolog

It is a simple guessing game in Prolog.

## Installation and running:
An easy way to run it on Mac OS X is using [SWI-Prolog](https://en.wikipedia.org/wiki/SWI-Prolog)
If you have Homebrew installed, just open a terminal and run:

`
brew install swi-prolog
`
which will build it from source in one command.
You can then run the interpreter using the `swipl` command and build a stand alone app:

`
swipl --stand_alone=true --goal=menu -o weapons.exe -g weapons -c weapons.pro
`

which you can run using:

`
./weapons.exe
`
