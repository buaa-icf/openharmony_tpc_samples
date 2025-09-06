# Spine

## Overview

SpineAr is a Spine 2D skeletal animation runtime library, whose core goal is to provide lightweight, high-performance, and developer-friendly APIs to meet the needs of skeletal animations in scenarios such as game development and dynamic content display.

![showlottie](./screenshot/Spine_screenshot_spine.gif)


## How to Install

```
 ohpm install @ohos/spine
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## Sample Code
### Example
```
import {
  AssetManager,
  AtlasAttachmentLoader,
  AnimationState,
  AnimationStateData,
  SkeletonRenderer,
  SkeletonJson,
  Skeleton,
  TextureAtlas,
  Physics,
  Delay,
  Bound
} from '@ohos/spine';

@Entry
@Component
struct Index {
  // Build the context.
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings);
  private _animator: AnimatorResult | undefined; 
  private animationState: AnimationState | undefined;
  private animations: Array<string> = ['death', 'aim', 'idle', 'jump', 'run', 'shoot', 'walk']; 
  private currentIndex: number = 0;
  private animationName: string = "walk";

  // Stop animation and clear canvas when the page is destroyed
  aboutToDisappear(): void {
    this._animator?.finish();
    this.canvasRenderingContext.clearRect(0, 0, this.canvasRenderingContext.width, this.canvasRenderingContext.height);
  }

  build() {
    Row() {
      // Associate with canvas.
      Canvas(this.canvasRenderingContext)
        .width(200)
        .height(200)
        .backgroundColor(Color.Gray)
        .onReady(() => {
          // Load the animation.
          this.loadAnimation();
        })
    }
  }

 async loadAnimation() {  // Load the JSON resource file.
    // 1. Initialize SkeletonRenderer.
    let skeletonRenderer = new SkeletonRenderer(this.canvasRenderingContext); // Create a SkeletonRenderer instance to render skeleton animation on the canvas. The canvasRenderingContext of the current class is passed as the rendering context.

    // 2. Create an asset manager and load resources.
    let assetManager = new AssetManager("animation/"); // Create an AssetManager instance and set the base path of resources to animation/.
    assetManager.loadText("spineboy-ess.json"); // Load the JSON data file ("spineboy-ess.json") required by Spine animation.
    assetManager.loadTextureAtlas("spineboy.atlas"); // Load the texture atlas file ("spineboy.atlas").
    await assetManager.loadAll(); // Wait until all resources are loaded.

    // 3. Create the texture atlas and skeleton data.
    let atlas: TextureAtlas = assetManager.require("spineboy.atlas"); // Obtain the texture atlas from the resource manager.
    let atlasLoader = new AtlasAttachmentLoader(atlas); // Create an AtlasAttachmentLoader to load attachments.
    let skeletonJson = new SkeletonJson(atlasLoader); // Create a SkeletonJson parser.
    let skeletonData = skeletonJson.readSkeletonData(assetManager.require("spineboy-ess.json")); // Read and parse the skeletal animation data file to generate skeletonData.

    // 4. Create a skeleton instance.
    let skeleton = new Skeleton(skeletonData); // Create a skeleton instance based on skeletonData.
    skeleton.setToSetupPose(); // Set the skeleton to the initial posture.
    skeleton.updateWorldTransform(Physics.update); // Update the world transformation of the skeleton.
    let bounds = skeleton.getBoundsRect(); // Obtain the boundary rectangle of the skeleton.

    // 5. Set the animation state.
    let animationStateData = new AnimationStateData(skeleton.data); // Create animation state data and pass the skeleton data.
    animationStateData.defaultMix = 0.2; // Set the default animation blending time to 0.2s.
    this.animationState = new AnimationState(animationStateData); // Create an animation state instance and store it in the animationState attribute of the class.

    let lastFrameTime = Date.now() / 1000; // Initialize the animation timer.

    // Clear the existing animation.
    if (this._animator) {
      this._animator.finish();
    }

    // Set animation options
    let options: AnimatorOptions = {
      duration: 20000,       // The animation duration is 20 seconds.
      easing: 'linear',      // Linear easing.
      delay: 0,              // No delay.
      fill: 'forwards',      // Retain the last frame after the animation is complete.
      direction: 'normal',   // Play in the normal direction.
      iterations: -1,        // Infinite loop.
      begin: 0,              // Start from frame 0.
      end: 1                 // End at frame 1.
    };

    // Set the expected frame rate range (minimum: 0, maximum: 120, expected: 60).
    let expectedFrameRate: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 60
    };

    // Create an animation.
    this._animator = animator.create(options);
    this._animator.setExpectedFrameRateRange(expectedFrameRate);

    // Initialize the rendering result object. Create a delay object, which contains the initial time and completion status flag.
    let result: Delay = { time: lastFrameTime, isFinish: true };

    // Set the callback for each frame of the animation.
    this._animator.onFrame = (value: number) => {
      if (result.isFinish) {
        result.isFinish = false;
        result = this.render(this.canvasRenderingContext, result.time, skeleton, this.animationState!, skeletonRenderer,
          bounds);
      }
    };
    // Play the animation.
    this._animator.play();
  }
  
  async loadAnimation() {  // Load the skeleton resource file.
    // 1. Initialize SkeletonRenderer.
    let skeletonRenderer = new SkeletonRenderer(this.canvasRenderingContext); // Create a SkeletonRenderer instance to render skeleton animation on the canvas. The canvasRenderingContext of the current class is passed as the rendering context.
    skeletonRenderer.triangleRendering = true; // true indicates that the drawTriangle mode is used for rendering. false indicates that the drawImages mode is used for rendering.

    // 2. Create an asset manager and load resources.
    let assetManager = new AssetManager("animation5/"); // Create an AssetManager instance and set the base path of resources to animation/.
    assetManager.loadBinary("dragon-ess.skel");; // Load the skeleton data file required by Spine animation.
    assetManager.loadTextureAtlas("dragon-pma.atlas"); // Load the texture atlas file ("spineboy.atlas").
    await assetManager.loadAll(); // Wait until all resources are loaded.

    // 3. Create the texture atlas and skeleton data.
    let atlas: TextureAtlas = assetManager.require("dragon-pma.atlas"); // Obtain the texture atlas from the resource manager.
    let atlasLoader = new AtlasAttachmentLoader(atlas); // Create an AtlasAttachmentLoader to load attachments.
    let skeletonBinary = new SkeletonBinary(atlasLoader);; // Create a SkeletonBinary parser.
    let skeletonData = skeletonBinary.readSkeletonData(assetManager.require("dragon-ess.skel")); // Read and parse the skeletal animation data file to generate skeletonData

    // 4. Create a skeleton instance.
    let skeleton = new Skeleton(skeletonData); // Create a skeleton instance based on skeletonData.
    skeleton.setToSetupPose(); // Set the skeleton to the initial posture.
    skeleton.updateWorldTransform(Physics.update); // Update the world transformation of the skeleton.
    let bounds = skeleton.getBoundsRect(); // Obtain the boundary rectangle of the skeleton.

    // 5. Set the animation state.
    let animationStateData = new AnimationStateData(skeleton.data); // Create animation state data and pass the skeleton data.
    animationStateData.defaultMix = 0.2; // Set the default animation blending time to 0.2s.
    this.animationState = new AnimationState(animationStateData); // Create an animation state instance and store it in the animationState attribute of the class.

    let lastFrameTime = Date.now() / 1000; // Initialize the animation timer.

    // Clear the existing animation.
    if (this._animator) {
      this._animator.finish();
    }

    // Set animation options
    let options: AnimatorOptions = {
      duration: 20000,       // The animation duration is 20 seconds.
      easing: 'linear',      // Linear easing.
      delay: 0,              // No delay.
      fill: 'forwards',      // Retain the last frame after the animation is complete.
      direction: 'normal',   // Play in the normal direction.
      iterations: -1,        // Infinite loop.
      begin: 0,              // Start from frame 0.
      end: 1                 // End at frame 1.
    };

    // Set the expected frame rate range (minimum: 0, maximum: 120, expected: 60).
    let expectedFrameRate: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 60
    };

    // Create an animation.
    this._animator = animator.create(options);
    this._animator.setExpectedFrameRateRange(expectedFrameRate);

    // Initialize the rendering result object. Create a delay object, which contains the initial time and completion status flag.
    let result: Delay = { time: lastFrameTime, isFinish: true };

    // Set the callback for each frame of the animation.
    this._animator.onFrame = (value: number) => {
      if (result.isFinish) {
        result.isFinish = false;
        result = this.render(this.canvasRenderingContext, result.time, skeleton, this.animationState!, skeletonRenderer,
          bounds);
      }
    };
    // Play the animation.
    this._animator.play();
  }

   render(
     context: CanvasRenderingContext2D,  // Canvas 2D rendering context
     lastFrameTime: number,             // Timestamp of the previous frame (second)
     skeleton: Skeleton,                // Spine skeleton object
     animationState: AnimationState,    // Animation state machine
     skeletonRenderer: SkeletonRenderer, // Skeleton renderer
     bounds: Bound                      // Bounding box of the animation (used for scaling calculation)
     ): Delay {
    // Calculate the delta time between this and the last frame in seconds.
    let now = Date.now() / 1000; // Obtain the current time (in seconds).
    let delta = now - lastFrameTime; // Calculate the time difference (in seconds) with the previous frame.
    lastFrameTime = now;   // Update the time of the previous frame to the current time.

    // Clear the canvas.

    context.clearRect(0, 0, context.width, context.height);

    // Center the skeleton and resize it so it fits inside the canvas.
    skeleton.x = context.width / 2;  // Center the skeleton horizontally (half of the canvas width).
    skeleton.y = context.height - context.height * 0.1; // Vertical position: close to the bottom of the canvas (with a 10% margin)
    let scale = context.height / bounds.height * 0.8; // Calculate the scale (based on the canvas height and animation bounding box height).
    skeleton.scaleX = scale; // Horizontal scaling
    skeleton.scaleY = -scale; // Vertical scaling (a negative value indicates that the Y axis is flipped, making the animation upward.)

    // Update and apply the animation state, update the skeleton's
    // world transforms and render the skeleton.
    animationState.update(delta);  // Update the animation status (drive-in animation based on the time difference).
    animationState.apply(skeleton);  // Apply the animation status to the skeleton (update the skeleton transformation).
    skeleton.updateWorldTransform(Physics.update);  // Update the global transformation of the skeleton.
    skeletonRenderer.draw(skeleton); // Render the skeleton to the canvas.

    let result: Delay = { time: lastFrameTime, isFinish: true };
    return result;
  }
}

```
### Rendering Process
- 1. **animationState.update(delta)**: advances the animation timeline.
- 2. **animationState.apply(skeleton)**: applies animation data to the skeleton.
- 3. **skeleton.updateWorldTransform**: calculates the global transformation matrix of the skeleton (such as the position, rotation, and scale).
- 4. **skeletonRenderer.draw**: draws the skeleton on the canvas.

## How to Use

### To start off, get required data prepared.



### 1. Importing Component to the Corresponding Class

```
import {
  AssetManager,
  AtlasAttachmentLoader,
  AnimationState,
  AnimationStateData,
  SkeletonRenderer,
  SkeletonJson,
  Skeleton,
  TextureAtlas,
  Physics,
  Delay,
  Bound
} from '@ohos/spine';
```

### 2. Building a Rendering Context

```
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private mainCanvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings);
```


### 3. Associating with the Canvas

```
       Canvas(this.mainCanvasRenderingContext)
        .width('100%')
        .height(200)
        .backgroundColor(Color.Gray)
        .onReady(()=>{
       
        })
```

### 4. Loading Data

#### 1. Initializing the Skeleton Renderer
```
      let skeletonRenderer = new SkeletonRenderer(this.canvasRenderingContext);

```

- Function: Create a SkeletonRenderer instance to render the Spine skeleton animation on the canvas.
- Parameter: **this.canvasRenderingContext** is the 2D rendering context of the canvas.

#### 2. Loading Animation Resources

```
      let assetManager = new AssetManager("animation/");
      assetManager.loadText("spineboy-ess.json");
      assetManager.loadTextureAtlas("spineboy.atlas");
      await assetManager.loadAll();

```
- Process:
- 1. Create an AssetManager instance and set the resource root path to **animation/**.
- 2. Load the spine animation data file **spineboy-ess.json** and texture atlas **spineboy.atlas**.
- 3. Call **await assetManager.loadAll()** to wait until all resources are loaded asynchronously.


#### 3. Creating a Texture Set and Skeletal Data
```
      let atlas: TextureAtlas = assetManager.require("spineboy.atlas");
      let atlasLoader = new AtlasAttachmentLoader(atlas);
      let skeletonJson = new SkeletonJson(atlasLoader);
      let skeletonData = skeletonJson.readSkeletonData(assetManager.require("spineboy-ess.json"));

```

- Process:
- 1. Call **AssetManager** to obtain the loaded texture atlas (**TextureAtlas**).
- 2. Create an AtlasAttachmentLoader to load attachments (such as textures and regions) from the graph set.
- 3. Create a SkeletonJson parser to read Spine JSON data.
- 4. Parse the **spineboy-ess.json** file to generate skeletonData (skeleton animation data).


#### 4. Initializing a Skeleton Instance
```
      let skeleton = new Skeleton(skeletonData);
      skeleton.setToSetupPose();
      skeleton.updateWorldTransform(Physics.update);
      let bounds = skeleton.getBoundsRect();

```
- Process:
- 1. Create a Skeleton instance based on skeletonData.
- 2. Call **setToSetupPose()** to reset the skeleton to the initial posture.
- 3. Call **updateWorldTransform(Physics.update)** to update the global transformation of the skeleton.
- 4. Call **getBoundsRect()** to obtain the bounding box of the animation (for subsequent scaling and centering).

#### 5. Configuring the Animation State
```
      let animationStateData = new AnimationStateData(skeleton.data);
      animationStateData.defaultMix = 0.2;
      this.animationState = new AnimationState(animationStateData);
```
- Process:
- 1. Create an AnimationStateData object and bind the skeleton data.
- 2. Set the default animation blending time to 0.2s (for animation transition).
- 3. Create an AnimationState instance to manage the animation playback state.

#### 6. Initializing the Animation Controller
```
      let lastFrameTime = Date.now() / 1000;
      if (this._animator) {
        this._animator.finish();
      }
      let options: AnimatorOptions = {
        duration: 20000,
        easing: 'linear',
        delay: 0,
        fill: 'forwards',
        direction: 'normal',
        iterations: -1,
        begin: 0,
        end: 1
      };
      let expectedFrameRate: ExpectedFrameRateRange = {
        min: 0,
        max: 120,
        expected: 60
      };
```
- Process:
- 1. Record the current timestamp (used to calculate the frame interval).
- 2. If **this._animator** already exists, stop it.
- 3. Define the configuration options (**AnimatorOptions**): If the value of **duration** is **20000**, the total duration of the animation is 20 seconds; if the value of **iterations** is **-1**, the loop is infinite; other options include slow movement, delay, and fill mode.
- 4. Define the expected frame rate range (**ExpectedFrameRateRange**).


#### 4. Creating and Starting the Animation Controller
```
      this._animator = animator.create(options);
      this._animator.setExpectedFrameRateRange(expectedFrameRate);
      let result: Delay = { time: lastFrameTime, isFinish: true };
      this._animator.onFrame = (value: number) => {
        if (result.isFinish) {
          result.isFinish = false;
          result = this.render(this.canvasRenderingContext, result.time, skeleton, this.animationState!, skeletonRenderer, bounds);
        }
      };
      this._animator.play();

```
- Process:
- 1. Create an animation controller instance (animator.create) and pass the configuration options.
- 2. Set the expected frame rate range.
- 3. Initialize the result object and record the timestamp and completion status.
- 4. Bind the **onFrame** callback function. When the animation controller triggers a new frame, the **this.render** method is called to render the animation. Call **result.isFinish** to prevent repeated rendering of the same frame.
- 5. Call **this._animator.play()** to start the animation controller.

    

### 9. About Obfuscation
- For details, see [Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/en/application-dev/arkts-utils/source-obfuscation.md).
- To prevent the spine library from being obfuscated, add exclusion rules to the **obfuscation-rules.txt** configuration file.
```
-keep
./oh_modules/@ohos/spine
```



## Available APIs
| class | Name             | Parameter  | Description             |
|------------------|----------------------|----------------------------------------|-------------------------------------------|
|  AssetManager     | loadText         | path       | Loads the text data file required for Spine animation. |
|  AssetManager     | loadBinary       | path       | Loads the binary data file required for Spine animation.|
| AssetManager     | loadJson             | path                                   | Loads the JSON data file required for Spine animation.                 |
| AssetManager     | loadTexture          | path                                   | Loads the data file required for Spine animation.                      |
|  AssetManager     | loadTextureAltas | path       | Loads the texture atlas file.               |
|  AssetManager     | require          | path       | Obtains data from the assets array.         |
| AssetManager     | loadAll              | N/A                                     | Waits for all resources to be loaded.                               |
| AssetManager     | get                  | path                                   | Obtains the loaded resources.                                 |
| AssetManager     | remove               | path                                   | Removes a single cached resource.                                 |
| AssetManager     | removeAll            | N/A                                     | Clears all cached resources.                                 |
|  AnimationState   | update           | delta      | Updates the animation state.                 |
|  AnimationState   | apply            | skeleton   | Applies the animation state to the skeleton.             |
| AnimationState   | addListener          | AnimationStateListener                 | Adds a listener.                                     |
| AnimationState   | removeListener       | AnimationStateListener                 | Removes a listener.                                   |
| AnimationState   | clearListeners       | N/A                                     | Removes all listeners.                                   |
| AnimationState   | getCurrent           | trackIndex                             | Returns the track item of the animation that is currently playing on the track.                       |
| AnimationState   | setAnimation         | trackIndex, animation, loop            | Sets an animation by name.                                 |
| AnimationState   | setAnimationWith     | trackIndex, animationName, loop        | Sets the current animation of the track, discarding any queued animations.                      |
| AnimationState   | addAnimation         | trackIndex, animationName, loop, delay | Adds an animation to the queue by name.                              |
| AnimationState   | addAnimationWith     | trackIndex, animationName, loop, delay | Adds an animation to the track after the current or last queued animation.               |
| AnimationState   | clearTrack           | trackIndex                             | Removes all animations from the track, keeping the skeleton in its current pose.                    |
| AnimationState   | clearTracks          | N/A                                     | Removes all animations from the track, keeping the skeleton in its current pose.                  |
| AnimationState   | setEmptyAnimations   | mixDuration                            | Sets an empty animation for each track, discards any queued animations, and blends them within the specified blend duration.|
| AnimationState   | clearNext            | TrackEntry                             | Clears the subsequent animation queue of a specified animation entry.                          |
| AnimationState   | setEmptyAnimation    | trackIndex, mixDuration                | Forcibly sets an empty animation to a specified track.                             |
| AnimationState   | addEmptyAnimation    | trackIndex, mixDuration, delay         | Adds an empty animation to the end of the animation queue.                             |
|  SkeletonRenderer | draw             | N/A        | Renders animations.                   |
| Skeleton  | setToSetupPose            | N/A        | Sets the skeleton, constraint, and slot to their set posture values.     |
| Skeleton  | updateWorldTransform      |  physics      | Updates the world transformation of each skeleton and applies all constraints.     |
| Skeleton  | getBoundsRect             | clipper       | Aligns the bounding box of the region and mesh attachment with the current posture and returns the result.|
| SkeletonJson  | readSkeletonData      | json         | Reads and parses the skeleton animation data file, and generates skeletonData.    |

## Constraints

This project has been verified in the following versions:
- DevEco Studio: NEXT Developer Beta3 (5.0.3.524), SDK: API 12 (5.0.0.25)
- DevEco Studio: NEXT Developer Beta1 (5.0.3.122), SDK: API 12 (5.0.0.18)

## Directory Structure

````
/Spine        # Project root directory
├── entry      # Sample code
├── library    # Lottie library
│    └─ src/main/ets   # Core code, including JSON parsing, animation drawing, and animation manipulation
│          └─ spine-canvas    # Implementation library of the Spine animation system in the Canvas 2D rendering environment
│          └─ spine-core  # Data structures and logic for processing Spine animations, including the core algorithms, data parsing, and state management of skeleton animations                
├── README.md     # Readme   
                   
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project complies with [Spine Runtimes License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Spine/LICENSE).
