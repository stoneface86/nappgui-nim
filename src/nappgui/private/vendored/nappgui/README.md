
# nappgui source

This folder contains most of the source code in the [nappgui_src](https://github.com/frang75/nappgui_src)
repository. The code is vendored by this wrapper.

The following is copied from the repository to following destinations:
 - `src/core` -> `core`
 - `src/draw2d` -> `draw2d`
 - `src/geom2d` -> `geom2d`
 - `src/gui` -> `gui`
 - `src/inet` -> `inet`
 - `src/osapp` -> `osapp`
 - `src/osbs` -> `osbs`
 - `src/osgui` -> `osgui`
 - `src/sewer` -> `sewer`

This wrapper builds the library from this vendored source and links it into the
project's binary when used. No external dependencies are needed on the user's
part.

## Version info

 - Git tag: v1.3.0
 - Git url: https://github.com/frang75/nappgui_src
