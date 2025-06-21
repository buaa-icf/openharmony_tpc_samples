# mime-db

## Introduction
mime-db is a large database that stores mime data and related information.
It consists of a single public JSON file and does not contain any logic.
This allows it to remain as un-opinionated as possible with an API.
It gathers data from the following sources:
https://www.iana.org/assignments/media-types/media-types.xhtml
https://svn.apache.org/repos/asf/httpd/httpd/trunk/docs/conf/mime.types
https://hg.nginx.org/nginx/raw-file/default/conf/mime.types

## How to Install

```
ohpm install mime-db@1.52.0
```
OpenHarmony
For details about the ohpm environment configuration, see [Installing the OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```js
import * as db from 'mime-db'
// grab data on .js files
let data = db['application/javascript']
```
## Available APIs

db['application/javascript']

## Constraints
This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

```
|mime_db       # Root directory of the project
      ├── entry                  # Sample code  
          ├── src  
              ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
```

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/mime_db/LICENSE).
