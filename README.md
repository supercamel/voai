# A Simple OpenAI Api Client

Written in Vala using libsoup. Used to connect to various AI back ends. 

## Building

On Linux (Ubuntu 20.04 tested)
```
  meson --prefix=/usr builddir
  cd builddir
  sudo meson install
```

On Windows / MSYS2
```
  meson builddir
  cd builddir
  meson install
```

Then you can run the test.py script to test.
