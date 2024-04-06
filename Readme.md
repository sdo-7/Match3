to build
```
git clone git@github.com:sdo-7/Match3.git
cd Match3
mkdir build
cd build
cmake ..
cmake --build .
```

to launch
```
./game.exe
```
commands
```
q for quit

m for move
m X Y DESTINATION
DESTINATION = l | r | u | d
m 10 2 l
```

to test lua code
```
luarocks test
```