##
## INet
## 
## Low-level bindings for the `inet` library in the NAppGUI SDK.
##

import ../private/libnappgui
import sewer, core

# =============================================================================
{. push header: "nappgui/inet/inet.hxx" .}
{. pragma: cenum, importc, size: sizeof(cint) .}

# inet types
type
  ierror_t* {.cenum.} = enum
    ekINONET = 1
    ekINOHOST
    ekITIMEOUT
    ekISTREAM
    ekISERVER
    ekINOIMPL
    ekIUNDEF
    ekIOK

  Url* {.importc.}      = object
  Http* {.importc.}     = object
  Json* {.importc.}     = object
  JsonOpts* {.importc.} = object

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/inet/httpreq.h" .}

# HTTP

proc http_create*(host: cstring, port: uint16_t): ptr Http
proc http_secure*(host: cstring, port: uint16_t): ptr Http
proc http_destroy*(http: ptr ptr Http)
proc http_clear_headers*(http: ptr Http)
proc http_add_header*(http: ptr Http, name: cstring, value: cstring)
proc http_get*(http: ptr Http, path: cstring, data: ptr byte_t, size: uint32_t,
               error: ptr ierror_t): bool_t
proc http_post*(http: ptr Http, path: cstring, data: ptr byte_t, size: uint32_t,
                error: ptr ierror_t): bool_t               
proc http_response_status*(http: ptr Http): uint32_t
proc http_response_protocol*(http: ptr Http): cstring
proc http_response_message*(http: ptr Http): cstring
proc http_response_size*(http: ptr Http): uint32_t
proc http_response_name*(http: ptr Http, index: uint32_t): cstring
proc http_response_value*(http: ptr Http, index: uint32_t): cstring
proc http_response_header*(http: ptr Http, name: cstring): cstring
proc http_response_body*(http: ptr Http, body: ptr Stream,
                         error: ptr ierror_t): bool_t
proc http_dget*(url: cstring, result: ptr uint32_t,
                error: ptr ierror_t): ptr Stream
proc http_exists*(url: cstring)

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/inet/json.h" .}

# JSON

proc json_read_imp*(stm: ptr Stream, opts: ptr JsonOpts, ty: cstring): pointer
proc json_write_imp*(stm: ptr Stream, data: pointer, opts: ptr JsonOpts,
                     ty: cstring)
proc json_destroy_imp*(data: ptr pointer, ty: cstring)
proc json_destopt_imp*(data: ptr pointer, ty: cstring)

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/inet/url.h" .}

# URL

proc url_parse*(url: cstring): ptr Url
proc url_destroy*(url: ptr ptr Url)
proc url_scheme*(url: ptr Url): cstring
proc url_user*(url: ptr Url): cstring
proc url_pass*(url: ptr Url): cstring
proc url_host*(url: ptr Url): cstring
proc url_path*(url: ptr Url): cstring
proc url_params*(url: ptr Url): cstring
proc url_query*(url: ptr Url): cstring
proc url_fragment*(url: ptr Url): cstring
proc url_resource*(url: ptr Url): ptr String
proc url_port*(url: ptr Url): uint16_t

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/inet/base64.h" .}

# Base64

proc b64_encoded_size*(dataSize: uint32_t): uint32_t
proc b64_decoded_size*(encodedSize: uint32_t): uint32_t
proc b64_encode*(data: ptr byte_t, size: uint32_t, base64: ptr char_t,
                 esize: uint32_t): uint32_t
proc b64_decode*(base64: ptr char_t, size: uint32_t, data: ptr byte_t): uint32_t

{. pop .} #====================================================================
