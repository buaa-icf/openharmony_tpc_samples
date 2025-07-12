# javascript_natural_sort

## Introduction

> Natural Sort algorithm for Javascript

## How to Install

```shell
ohpm  install javascript-natural-sort@0.7.1
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```js
import { naturalSort } from "javascript-natural-sort"

['10',9,2,'1','4'].sort(naturalSort)
// ['1',2,'4',9,'10']

['10.0401',10.022,10.042,'10.021999'].sort(naturalSort)
// ['10.021999',10.022,'10.0401',10.042]

['10.04f','10.039F','10.038d','10.037D'].sort(naturalSort)
// ['10.037D','10.038d','10.039F','10.04f']

['1.528535047e5','1.528535047e7','1.528535047e3'].sort(naturalSort)
// ['1.528535047e3','1.528535047e5','1.528535047e7']

['192.168.0.100','192.168.0.1','192.168.1.1'].sort(naturalSort)
// ['192.168.0.1','192.168.0.100','192.168.1.1']

['car.mov','01alpha.sgi','001alpha.sgi','my.string_41299.tif'].sort(naturalSort)
// ['001alpha.sgi','01alpha.sgi','car.mov','my.string_41299.tif']

['10/12/2008','10/11/2008','10/11/2007','10/12/2007'].sort(naturalSort)
// ['10/11/2007', '10/12/2007', '10/11/2008', '10/12/2008']

['$10002.00','$10001.02','$10001.01'].sort(naturalSort)
// ['$10001.01','$10001.02','$10002.00']

['1 Title - The Big Lebowski','1 Title - Gattaca','1 Title - Last Picture Show'].sort(naturalSort)
// ['1 Title - Gattaca','1 Title - Last Picture Show','1 Title - The Big Lebowski']

['a', 'B'].sort(naturalSort);
// ['B', 'a']

naturalSort.insensitive = true;
['a', 'B'].sort(naturalSort);
// ['a', 'B']
```
For details about unit test cases, see [TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/javascript_natural_sort/TEST.md).

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Available APIs

| API        | Parameter | Description     |
|--------------|-----|---------|
| naturalSort  | N/A  |  Natural sorting  |

## Directory Structure

````
|---- javascript_natural_sort
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme    
|     |---- README_zh.md  # Readme               
````

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/javascript_natural_sort/LICENSE).
    
