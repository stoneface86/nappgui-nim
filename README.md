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

## Versioning

This library uses semantic versioning that adds an extra patch number. The
syntax is `[nappgui-version].[library-patch]` where:

- `nappgui-version` is the version of NAppGUI being wrapped
- `library-patch` is the revision number of the wrapper

No versions have been released yet as this library is currently a WIP.

## Dependencies

A vendored copy of NAppGUI is included in this repository so you will only
need to install NAppGUI's dependencies:

 - Linux: GTK3, OpenGL, Curl (optional)
 - OSX: None
 - Windows: None

## Install

Install nim and nimble, then install using nimble

```sh
nimble install "https://github.com/stoneface86/nappgui-nim"
```

## Options

By default, the `inet` library is not compiled, as Nim already provides this
functionality in its standard library. To enable this library, define
`-d:nappguiInet` when compiling your project.

## Documentation

TBD

## Examples

TBD

## License

This library is licensed under the [MIT License](LICENSE). NAppGUI is licensed
under the [MIT License](src/nappgui/private/nappgui/LICENSE).
