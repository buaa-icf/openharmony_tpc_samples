# OhosVideoCache

## Overview

OhosVideoCache is a library that supports caching during playback. You only need to pass the URL of the media to OhosVideoCache for processing and then set it to the player. OhosVideoCache can download media data and save it locally while reading the local cache and returning it to the player, without requiring users to perform any other operations. OhosVideoCache also supports offline playback after download and resumable download. It will automatically clean up the cache according to the parameters set by the user to avoid excessive cache files occupying disk space. Additionally, OhosVideoCache supports adding of request headers and customization of cache file names.

## How to Install

```
ohpm install @ohos/video-cache 
```

OpenHarmony ohpm
For details about the environment configuration, see [Installing the OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## Usage

After installing OhosVideoCache library, import the APIs provided by OhosVideoCache before use.

```typescript
import { HttpProxyCacheServer, HttpProxyCacheServerBuilder,CacheListener,FileNameGenerator ,HeaderInjector} from '@ohos/video-cache';
```

### Step 1: Initialize the proxy server.

You are advised to set the proxy server to the singleton mode, so that only one proxy server object is maintained in the entire project. This eliminates the need to generate multiple server proxies for one request, avoiding resource and traffic waste and performance deterioration.

  ```typescript
import common from '@ohos.app.ability.common';
import { HttpProxyCacheServer } from '@ohos/video-cache';

export default class GlobalProxyServer {
  private CONTEXT_STR: string = 'getContext';
  private SERVER_STR: string = 'getServer';
  private static instance: GlobalProxyServer;
  private _objects: Map<string, Object | null> = new Map<string, Object | null>();

  private constructor() {
  }

  public static getInstance(): GlobalProxyServer {
    if (!GlobalProxyServer.instance) {
      GlobalProxyServer.instance = new GlobalProxyServer()
    }
    return GlobalProxyServer.instance;
  }

  getContext(): common.UIAbilityContext {
    return this._objects.get(this.CONTEXT_STR) as common.UIAbilityContext;
  }

  setContext(objectClass: common.UIAbilityContext) {
    this._objects.set(this.CONTEXT_STR, objectClass);
  }

  getServer(): HttpProxyCacheServer {
    return this._objects.get(this.SERVER_STR) as HttpProxyCacheServer;
  }

  setServer(objectClass: HttpProxyCacheServer) {
    try {
      let currentServer: HttpProxyCacheServer = this.getServer();
      currentServer.shutdown()
    } catch (err) {
    }
    this._objects.set(this.SERVER_STR, objectClass);
  }
}
  ```

Initialize the proxy server.

```typescript
let server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext()).build();
GlobalProxyServer?.getInstance()?.setServer(server);
```

Get the URL of the proxy server.

```typescript
let tempUrl = await GlobalProxyServer?.getInstance()?.getServer()?.getProxyUrl(originUrl)
```



### Step 2: Send the original media URL to **OhosVideoCache**.

```typescript
 let tempUrl = await GlobalProxyServer?.getInstance()?.getServer()?.getProxyUrl(originUrl)
 let proxyUrl: string|undefined = tempUrl ? tempUrl : originUrl
```



### Step 3: Set the processed URL to the player.



```typescript
this.avPlayer!.url = proxyUrl;
```

After the preceding operations are complete, the player is able to cache while playing. This means that the player can play the cached media even if the network is disconnected. In addition, OhosVideoCache supports resumable download. This allows a video download to the paused and then resumed at a later time without having to start from the beginning.



### Step 4: Configure advanced settings.

#### 4.1 Setting the Cache Folder

```typescript
import { HttpProxyCacheServer, HttpProxyCacheServerBuilder,CacheListener,FileNameGenerator ,HeaderInjector } from '@ohos/video-cache';

let server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext())
    .cacheDirectory(getContext().cacheDir) // Set the cache folder (that is, folder that stores the cached files) to the cache directory of the application sandbox. 
   .build()
```

**cacheDirectory** is optional. By default, OhosVideoCache uses the **cache** directory of the sandbox as the cache folder.

Currently, OhosVideoCache uses the **@ohos.file.fs** module to cache files. Therefore, the cache folder must be set to a path supported by **@ohos.file.fs**. You are advised to use the **cache** or **files** directory of the application sandbox and their subdirectories.

#### 4.2 Setting the Cache Clearing Policy

#####  4.2.1 Setting the Maximum Cache Size

```typescript
import { HttpProxyCacheServer, HttpProxyCacheServerBuilder,CacheListener,FileNameGenerator ,HeaderInjector } from '@ohos/video-cache';

let server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext())
   .maxCacheSize(1024 * 1024 * 1024) // Set the maximum cache size to 1 GB. 
   .build()

```

The **maxCacheSize** parameter is optional. By default, OhosVideoCache uses the maximum cache size as the cache clearing policy. The maximum cache size of the cache folder is 512 MB.

#### 4.2.2 Setting the Maximum Number of Cached Files

```typescript
import { HttpProxyCacheServer, HttpProxyCacheServerBuilder,CacheListener,FileNameGenerator ,HeaderInjector } from '@ohos/video-cache';

let server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext())
   .maxCacheFilesCount(10) // Set the maximum number of cached files to 10.
   .build()
```

The **maxCacheFilesCount** parameter is optional.



Tips:

1. You can set either **maxCacheSize** or **maxCacheFilesCount**. If both of them are present, the one set a later point of time take effect.

2. If the cache clearing policy is **maxCacheSize**, OhosVideoCache automatically checks the configured cache folder before each request and after the cache is complete. If the total size of cached media files plus the size of files to be cached exceeds the maximum cache size (for example, 1 GB), OhosVideoCache deletes redundant cache files to make sure that the remaining space is sufficient for caching the current files. 

3. If the cache clearing policy is **maxCacheFilesCount**, OhosVideoCache automatically checks the configured cache folder before each request and after the cache is complete. If the total number of cached media files plus the number of files to be cached exceeds the maximum number (for example, 10), OhosVideoCache deletes redundant cached files to make sure that the number of cached files in the folder plus the number of files to be cached does not exceed the maximum number.

#### 4.3 Adding a Request Header

```typescript
import { HttpProxyCacheServer, HttpProxyCacheServerBuilder,CacheListener,FileNameGenerator ,HeaderInjector } from '@ohos/video-cache';

class MyHeaderInject implements HeaderInjector {
      addHeaders(url: string): HashMap<string, string> {
        let header: HashMap<string, string> = new HashMap<string, string>();
        header.set('allowCrossProtocolRedirects', "true")
        header.set ('name', "Tom")
        header.set('fakeToken', "123456789")
        return header;
      }
    }
let server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext())
  .setHeaderInjector(new MyHeaderInject())
  .build()
```

The **setHeaderInjector** parameter is optional. By default, OhosVideoCache uses an empty request header injector and does not add additional request header parameters.

If you want to carry the additional parameters in the request initiated by OhosVideoCache using the media URL, you can use the custom **MyHeaderInject** parameter.

#### 4.4 Customizing File Naming Rules

  ```typescript
import { HttpProxyCacheServer, HttpProxyCacheServerBuilder,CacheListener,FileNameGenerator ,HeaderInjector } from '@ohos/video-cache';

 class MyFileNameGenerator implements FileNameGenerator {
   generate(url: string): string {
     let start: number = url.lastIndexOf("/");
     let end: number = url.lastIndexOf(".");
     let newName: string = url.substring(start, end)
     return newName
   }
 }
let server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext())
 .setFileNameGenerator(new MyFileNameGenerator())
 .build()
  ```

The **setFileNameGenerator** parameter is optional. By default, OhosVideoCache uses MD5 to encrypt the original media URLs as the names of cached files.

If you do not want to name cached files in this way, you can implement **FileNameGenerator** and use the **generate** method to implement your own naming rules. In the preceding example, the original file name is used as the cached file name. Note that the media URLs and cached file names must be in one-to-one mapping. The file name obtained each time by using this method must be the same for one URL. Otherwise, the video needs to be downloaded and cached again each time to generate a new cached file.

#### 4.5 Registering or Unregistering a Cache Progress Listener

  ```typescript
import { HttpProxyCacheServer, HttpProxyCacheServerBuilder,CacheListener,FileNameGenerator ,HeaderInjector } from '@ohos/video-cache';

let server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext()).build()

class MyCacheListener implements CacheListener {
  onCacheAvailable(cacheFilePath: string, url: string, percentsAvailable: number) {
  }
}
let listener:MyCacheListener = new MyCacheListener()
server?.registerCacheListener(listener); // Register the cache progress listener.
server?.unregisterCacheListener(listener); // Unregister the cache progress listener.
  ```

You can use a cache listener to monitor the cache progress of media files and display the progress on the UI.

#### 4.6 Setting Custom Cache File Clearing Rules

```typescript
import { HttpProxyCacheServer, HttpProxyCacheServerBuilder,CacheListener,FileNameGenerator ,HeaderInjector,DiskUsage } from '@ohos/video-cache';

class MyDiskUsage implements DiskUsage {
  touch(filePath: string) {
   // You need to define the logic for obtaining and deleting the cached files in the cache folder.
  }
}
let server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext())
  .setDiskUsage(new MyDiskUsage())
 .build()
```

The **setDiskUsage** parameter is optional. By default, OhosVideoCache clears cached files based on **LruDiskUsage**.

The rules for clearing files are as follows:

4.6.1 Each time the player obtains the processed media URLs and each time a cached file is downloaded, the player checks the cache folder and determines whether to clear the cached files in the cache folder based on the configured cache clearing policy.

4.6.2 If cached files need to be cleared, the files are cleared based on their idle time until the remaining space of the cache folder is sufficient for caching new files (or the number of remaining files plus the number of cached files to be downloaded does not exceed the preset maximum number).



If you need to use different file clearing rules, you can refer to the preceding sample to create a custom class that extends **DiskUsage** and override the **touch** method.  After that, run **setDiskUsage** to set the disk usage for the proxy server.

#### 4.7 Additional Information

OhosVideoCache allows multiple media files to be downloaded and cached at the same time. To avoid application freezing or memory overflow, you are not advised to enable this function.

The file types supported by OhosVideoCache are the same as those supported by the **@ohos.file.fs** module.

OhosVideoCache initiates only one download request for the same media URL. The second download request is initiated only after this request is terminated.

OhosVideoCache supports drag-and-play. If the difference between the destination position and the current playback position is less than or equal to 20% of the media, OhosVideoCache starts to read the data in the local cached file and returns the data to the player for playback only when the file download cache reaches the destination position. If the destination position minus the current playback position is greater than 20% of the entire media, OhosVideoCache directly returns the requested media data to the player.

During the playback process of OhosVideoCache, if the network is disconnected, the playback will stop at the cached position. At this point, AvPlayer will report an error 5400103. To handle this, you can call the reset method of AvPlayer within the on('error', async (err) => {} callback to reset the playback and reinitialize AvPlayer. Then, re-execute the playback process to start playing again from the beginning.

## Available APIs

### OhosVideoCache

| Name                 | Parameter                                                        | Return Value                     | Description                                                        |
| ----------------------- | ------------------------------------------------------------ | --------------------------- | ------------------------------------------------------------ |
| getProxyUrl             | url: string, <br>allowCachedFileUri: boolean = true         | Promise<string>             | Obtains the original media URL for the proxy server to intercept player requests. |
| registerCacheListener   | cacheListener: CacheListener, <br>url: string \| null = null | void                        | Registers a cache progress listener.                                        |
| unregisterCacheListener | cacheListener: CacheListener, <br>url: string               | void                        | Unregisters the cache progress listener.                                      |
| shutdown                | N/A                                                          | void                        | Shuts dow the proxy server.                                              |
| cacheDirectory          | file: string                                                 | HttpProxyCacheServerBuilder | Sets the directory for storing cache files.                                    |
| setFileNameGenerator    | fileNameGenerator: FileNameGenerator                         | HttpProxyCacheServerBuilder | Sets the custom cached file name generator.                                |
| maxCacheSize            | maxSize: number                                              | HttpProxyCacheServerBuilder | Sets the maximum cache size as the cache clearing policy.                    |
| maxCacheFilesCount      | count: number                                                | HttpProxyCacheServerBuilder | Sets the maximum number of cached files as the cache clearing policy.                |
| setDiskUsage            | diskUsage: DiskUsage                                         | HttpProxyCacheServerBuilder | Sets the custom logic for clearing cache files.                          |
| setHeaderInjector       | headerInjector: HeaderInjector                               | HttpProxyCacheServerBuilder | Sets a custom request header injector.                                  |
| build()                 | N/A                                                          | HttpProxyCacheServer        | Constructor used to construct a proxy server.                              |



For details, see [Official Documentation](https://github.com/danikula/AndroidVideoCache/blob/master/README.md) and [Unit Test Cases](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/OhosVideoCache/TEST.md).


## Constraints

RxJS has been verified in the following versions:

DevEco Studio:NEXT Developer Beta1(5.0.3.326), SDK: API12 (5.0.0.25)
DevEco Studio:NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)

## Directory Structure

```typescript
|---- OhosVideoCache  
|     |---- entry  # Sample code
			|---- pages  # Application pages, which may vary depending on the test scenario
			    |---- DiyCacheCountPage.ets  # Example CacheCount policy
                |---- DiyCacheHeaderPage.ets  # Example request header injector
                |---- DiyCacheSizePage.ets  # Example CacheSize policy
                |---- DiyFileNameGeneratorPage.ets  # Example FileNameGenerator implementation
                |---- HttpsPlayer.ets  # Example of AvPlayer using OhosVideoCache
                |---- IjkVideoPlayerPage.ets  # Example of IjkPlayer using OhosVideoCache
                |---- Index.ets # Homepage
            |---- CommonConstants.ets  # Media URL constants
            |---- JumpPathConfig.ts  # UI redirection paths
            |---- Logger.ts  # Log printing tool
            |---- MediaLibraryUtils.ts  # Media file utility
            |---- PlayStatus.ts  # Playback status enumeration
            |---- RouterParam.ts  # UI redirection parameters
|     |---- library  # OhosVideoCache core code
			|---- bean # Bean for parameter transfer
            |---- constants # Constants for emitter message transfer
            |---- file  # Configuration for cached file clearing and naming
            |---- headers # Request header injector
            |---- interfaces # Callback APIs
            |---- sourcestorage # Media files
            |---- HttpProxyCacheServer.ets  # Proxy server
            |---- HttpProxyCacheServerClients.ets # Proxy client, which is used to initiate requests, cache files, and read cached files
            |---- HttpProxyCache.ets  # Implementation of media file reading for the proxy client
            |---- HttpUrlSource.ets  # Implementation of media file download for the proxy client
            |---- GetRequest.ets  # Request information parsing
            
            
|     |---- README_EN.MD  # Readme file                
```

## How to Contribute

If you find any problem when using OhosVideoCache, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or
a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under the terms of the [Apache License ](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/OhosVideoCache/LICENSE).
