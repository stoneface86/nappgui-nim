# nappgui-nim

Nim wrapper for [NAppGUI](https://nappgui.com/en/home/web/home.html),
a cross-platform GUI toolkit. This wrapper contains both low-level bindings and
a high-level API. The low-level bindings are available in `nappgui/bindings`
and the high level API is located in `nappgui/`.

This wrapper contains a copy of the source code of NAppGUI, and also
automatically compiles and links it to your project when this wrapper is used.
See [libnappgui.nim](src/nappgui/private/libnappgui.nim) for details on how
this is done.

Note that these bindings do not cover all of NAppGUI. This is due to the fact
that Nim and the Nim standard library already implement certain parts of
NAppGUI. Most of the sewer, osbs and inet libraries within NAppGUI are not
wrapped.

## Status

| NAppGUI library | Bindings? | API?                 |
|-----------------|-----------|----------------------|
| sewer           | partial   | not started          |
| osbs            | done      | partial (just types) |
| core            | done      | in progress          |
| geom2d          | done      | in progress          |
| draw2d          | done      | done                 |
| gui             | done      | not started          |
| osapp           | done      | not started          |
| inet            | done      | not started          |

Misc things:
 - [ ] Dynamic linking option
 - [ ] Support GCC on Windows
 - [ ] Nim version of NRC, available at compile-time

Contributions welcomed! Feel free to submit a PR for any of the above not
started, or contact [me](https://github.com/stoneface86).

## Versioning

This library uses semantic versioning that adds an extra patch number. The
syntax is `[nappgui-version].[library-patch]` where:

- `nappgui-version` is the version of NAppGUI being wrapped
- `library-patch` is the revision number of the wrapper

No versions have been released yet as this library is currently a WIP.

## Dependencies

Nim v1.4.0 and up is required.

A vendored copy of NAppGUI is included in this repository so you will only
need to install NAppGUI's dependencies:

 - Linux: GTK3, OpenGL, Curl (optional)
 - OSX: None
 - Windows: None

## Compiler support

Only the following compilers are supported, attempting to use an unsupported
compiler will result in a compile-time error.

| OS      | Compiler    | Nim argument |
|---------|-------------|--------------|
| Linux   | GCC         | `--cc:gcc`   |
| Mac OSX | Apple Clang | `--cc:clang` |
| Windows | MSVC        | `--cc:vcc`   |

Only Windows users will have to specify the `cc` argument, as the defaults on
Linux and Mac OS are supported.

## Install

Install nim and nimble, then install using nimble

```sh
nimble install "https://github.com/stoneface86/nappgui-nim"
```

Then you can use in your project, ie:
```nim
import nappgui      # all of nappgui
import nappgui/...  # specific imports (recommended)
```

## Options

| Define         | Default     | Description                                      |
|----------------|-------------|--------------------------------------------------|
| `nappguiInet`  | not present | Enables compilation of the `inet` library        |
| `nappguiRoot`  | `""`        | Build directory of the nappgui C library         |
| `nappguiTrace` | not present | Log when building nappgui during project compile |

By default, the `inet` library is not compiled, as Nim already provides this
functionality in its standard library. To enable this library, define
`-d:nappguiInet` when compiling your project.

This library compiles and links the NAppGUI library automatically. By default
the location of the build library is in this repo's `bin` directory. To
override this location, define `nappguiRoot` with the path to the desired
location.

## Documentation

TBD

## Examples

See the [examples](examples/) directory for some example programs that use
this library. Just run via `nim r examples/<nim-file>`

## License

This library is licensed under the [MIT License](LICENSE). NAppGUI is licensed
under the [MIT License](src/nappgui/private/nappgui/LICENSE).
