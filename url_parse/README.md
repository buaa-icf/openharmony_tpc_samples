# url-parse

## Introduction
> A small-space URL parser that can work seamlessly in Node.js and browser environments.

## How to Install
```shell
ohpm install url-parse
ohpm install @types/url-parse@1.4.11  // If a syntax error is reported, the url-parse package does not contain the type declaration. You need to download the declaration file of the package from @types/url-parse to rectify the syntax error.
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
1. Absolute or relative URL string
 ```
 import URLParse from "url-parse"
 
 const url = new URLParse('https://www.example.com:8080/path?param1=value1&param2=value2#section');
 
 ```

## Available APIs
- Url(address, location, parser): Generates a URL object based on input parameters.
- set(part, value, fn): Sets the value of a specified part of a URL.
- toString(stringify):string: Converts the attribute back to a valid complete URL string.
- location(loc): Parses a URL string and assigns the parsed object to the **urlObj** variable. Then, we can access the attributes of **urlObj** to obtain the parts of the URL, such as the protocol, host, port, path, and query parameters.
- extractProtocol(address, location): Extracts the protocol part from a specified URL.

## Directory Structure
````
|---- url_parse
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme  
|     |---- README_zh.md  # Readme                   
````

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.
## License
This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/url_parse/LICENSE).
