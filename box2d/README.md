# box2d

## Overview

This library is used for game development to make the object motion more realistic and the game scenes more interactive, such as Angry Birds.

## Display Effects
<img src="screenshot/box2d.gif"/>

## How to Install

```shell
ohpm install @ohos/box2d
```

For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

   ```
   import * as box2d from '@ohos/box2d'
   ...
   
  aboutToAppear() {
    selectArr = [];
    
    for (let i: number = 0; i < g_testEntries.length; ++i) {
      let o = {};
      o['value'] = g_testEntries[i].name;
      selectArr[i] = o;// Initialize data.
    }
        // Invoke rendering cyclically.
        this.init();
    }
    private init() {
        setTimeout(inits, timeStep);
    }
    const inits = function (time) {
      setTimeout(loop, timeStep);
    }
    
    const loop = function (time) {
      setTimeout(loop, timeStep);
      app.SimulationLoop(time);
    }

   ...
       // Switch the animation.
       Select(selectArr)
              .selected(this.index)
              .value(selectArr[this.index].value)
              .font({ size: 20, weight: 200, family: 'serif', style: FontStyle.Normal })
              .selectedOptionFont({ size: 30, weight: 300, family: 'serif', style: FontStyle.Normal })
              .optionFont({ size: 20, weight: 200, family: 'serif', style: FontStyle.Normal })
              .onSelect((index: number) => {
                this.index = index;
                if (app) {
                  app.m_test_index = index;
                  // Load the animation.
                  app.LoadTest();
                }
              })
   ```

## Available APIs

### b2Body APIs
1. Creates a fixture.
   `CreateFixture(def: b2FixtureDef): b2Fixture`
   • Input: def - Fixture definition (shape, density, friction, etc.)  
   • Output: Newly created fixture object

2. Destroys a fixture.
   `DestroyFixture(fixture: b2Fixture): void`  
   • Input: fixture - Fixture object to destroy  
   • Output: None

3. Sets the transformation.
   `SetTransform(position: XY): void`  
   • Input: position - World coordinate position  
   • Output: None

4. Obtains the transformation.
   `GetTransform(): b2Transform`  
   • Output: Current body's transformation matrix (position and angle)

5. Obtains the position.
   GetPosition(): b2Vec2  
   • Output: World coordinates of body's center

6. Sets the position.
   `SetPosition(position: XY): void`  
   • Input: position - Target world coordinates  
   • Output: None

7. Obtains the world center.
   `GetWorldCenter(): b2Vec2`  
   • Output: World coordinates of body's centroid

8. Obtains the local center.
   `GetLocalCenter(): b2Vec2`  
   • Output: Offset of centroid relative to local coordinate system

9. Sets the linear speed. 
   `SetLinearVelocity(velocity: XY): void`  
   • Input: velocity - Target linear velocity vector  
   • Output: None

### b2World APIs
1. Sets the substep. 
   `setSubStepping(flag: boolean): void`  
   • Input: flag - Whether to enable sub-stepping (for complex simulations)  
   • Output: None

2. Sets the destruction listener.
   `SetDestructionListener(listener: b2DestructionListener | null): void`  
   • Input: listener - Callback interface (handles object destruction events)  
   • Output: None

3. Sets the contact filter. 
   `SetContactFilter(filter: b2ContactFilter): void`  
   • Input: filter - Callback interface (determines collision allowance)  
   • Output: None

4. Sets the contact listener.
   `SetContactListener(listener: b2ContactListener): void`  
   • Input: listener - Callback interface (handles collision events)  
   • Output: None

5. Sets the debugging drawing.
   `SetDebugDraw(debugDraw: b2Draw | null): void`  
   • Input: debugDraw - Debug drawing interface  
   • Output: None

6. Creates a rigid body.
   `CreateBody(def: b2BodyDef): b2Body`  
   • Input: def - Body definition (type, position, damping, etc.)  
   • Output: Newly created body object

7. Destroys a rigid body.
   `DestroyBody(body: b2Body): void`  
   • Input: body - Body to destroy  
   • Output: None

8. Creates a joint.
   `CreateJoint(def: b2JointDef): b2Joint`  
   • Input: def - Joint definition (connected bodies, anchors, etc.)  
   • Output: Newly created joint object

9. Destroys a joint.
   `DestroyJoint(joint: b2Joint): void`  
   • Input: joint - Joint to destroy  
   • Output: None

### b2Contact APIs
1. Performs a reset.
   `Reset(): void`  
   • Output: None (resets contact state)

2. Obtains the manifold.
   `GetManifold(): b2Manifold` 
   • Output: Collision manifold data (contact point collection)

3. Obtains the world manifold.
   `GetWorldManifold(worldManifold: b2WorldManifold): void`  
   • Input/Output: worldManifold - Stores manifold data in world coordinates

4. Sets the tangent speed.
   `SetTangentSpeed(speed: number): void`  
   • Input: speed - Tangential velocity value  
   • Output: None

5. Resets the friction.
   `ResetFriction(): void`  
   • Output: None (restores default friction)

6. Set the friction.
   `SetFriction(friction: number): void`  
   • Input: friction - New friction coefficient  
   • Output: None

7. Specifies whether to enable the function.
   `SetEnabled(flag: boolean): void`  
   • Input: flag - Whether to enable contact  
   • Output: None

8. Obtains fixture A.
   `GetFixtureA(): b2Fixture`  
   • Output: First fixture in the contact

### b2Shape APIs
1. Performs a ray cast.
   `RayCast(output: b2RayCastOutput, input: b2RayCastInput, transform: b2Transform, childIndex: number): boolean`  
   • Input: input - Ray parameters; transform - Transformation matrix; childIndex - Child shape index  
   • Output: output - Stores intersection info; returns whether hit occurred

2. Obtains the type.
   `GetType(): b2ShapeType`  
   • Output: Shape type enum (circle, polygon, etc.)

3. Performs a copy. 
   `Copy(other: b2Shape): b2Shape`  
   • Output: Returns a deep copy of the shape

4. Obtains the child count. 
   `GetChildCount(): number`  
   • Output: Number of child shapes (for composite shapes)

5. Computes AABB.
   `ComputeAABB(aabb: b2AABB, xf: b2Transform, childIndex: number): void`  
   • Input: xf - Transformation matrix; childIndex - Child shape index  
   • Output: aabb - Stores computation results

6. Computes the quality.
   `ComputeMass(massData: b2MassData, density: number): void`  
   • Input: density - Density value  
   • Output: massData - Stores mass, centroid, etc.

7. Computes the distance.
   `ComputeDistance(xf: b2Transform, p: b2Vec2, normal: b2Vec2, childIndex: number): number`  
   • Input: xf - Transformation matrix; p - Point in world coordinates; normal - Direction of increasing distance; childIndex - the child shape index  
   • Output: Minimum distance

8. Performs a clone.
   `clone(): b2Shape`  
   • Output: Returns new instance (same as Copy)

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the box2d library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/box2d
```

## Constraints

box2d has been verified in the following version:

- DevEco Studio Version: 4.1 Canary (4.1.3.317)

- OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure
````
|---- box2d
|     |---- entry
|	        |----src
|                |----main
|                     |----ets
|                          |----pages
|                               |----Index.ets                          # Main page
|                          |----Testbed
|                               |----Framework 
|                                    |----DebugDraw.ets                 # Core code for effect drawing
|                                    |----FullscreenUI.ts               # Global page initiaization with particle parameters
|                                    |----Main.ets                      # Entry to effect drawing
|                                    |----ParticleEmitter.ts            # Particle emitter
|                                    |----ParticleParameter.ts          # Particle parameters
|                                    |----Test.ets                      # Canvas initialization settings
|                               |----Tests                              # Implementation of all effects
|                               |----Testbed.ts                         # External APIs
|     |---- library                                                       # box2d core library
|	        |----src
|                |----main
|                     |----ets
|                          |----Box2D
|                               |----Collision                          # Collision directory
|                                    |----Shapes                        # Shape directory
|                                         |----b2ChainShape.ts          # Chain shape
|                                         |----b2CircleShape.ts         # Circle shape
|                                         |----b2EdgeShape.ts           # Edge shape
|                                         |----b2PolygonShape.ts        # Polygon shape
|                                         |----b2Shape.ts               # Shape abstraction class
|                                    |----b2BroadPhase.ts               # Broad-phase
|                                    |----b2CollideCircle.ts            # Circle collision
|                                    |----b2CollideEdge.ts              # Edge collision
|                                    |----b2CollidePolygon.ts           # Polygon collision
|                                    |----b2Collision.ts                # Collision class
|                                    |----b2Distance.ts                 # Distance class
|                                    |----b2DynamicTree.ts              # Dynamic tree
|                                    |----b2TimeOfImpact.ts             # Time of impact
|                               |----Common                             # Common code: drawing, setting, and timer
|                                    |----b2BlockAllocator.ts           # Block allocator
|                                    |----b2Draw.ts                     # Drawing class
|                                    |----b2GrowableStack.ts            # Growable stack
|                                    |----b2Math.ts                     # Math class
|                                    |----b2Settings.ts                 # Setting class
|                                    |----b2StackAllocator.ts           # Stack allocator
|                                    |----b2Timer.ts                    # Timer class
|                               |----Controllers                        # Controller directory
|                                    |----b2BuoyancyController.ts       # Buoyancy controller
|                                    |----b2ConstantAccelController.ts  # Constant acceleration controller
|                                    |----b2ConstantForceController.ts  # Constant force controller
|                                    |----b2Controller.ts               # Gravity controller
|                                    |----b2GravityController.ts        # Tensor damping controller
|                               |----Dynamics
|                                    |----Contacts                      # Contact directory
|                                    |----Joints                        # Joints
|                                    |----b2Body.ts                     # Body
|                                    |----b2ContactManager.ts           # Contact management
|                                    |----b2Fixture.ts                  # Fixtures
|                                    |----b2Island.ts                   # Islands
|                                    |----b2TimeStep.ts                 # Time steps
|                                    |----b2World.ts                    # World
|                                    |----b2WorldCallbacks.ts           # World callbacks
|                               |----Particle                           # Particle directory
|                                    |----b2Particle.ts                 # Particles
|                                    |----b2ParticleGroup.ts            # Particle groups
|                                    |----b2ParticleSystem.ts           # Particle systems
|                                    |----b2StackQueue.ts               # Stack queues
|                                    |----b2VoronoiDiagram.ts           # Voronoi diagrams
|                               |----Rope                               # Rope directory
|                                    |----b2Rope.ts                     # Ropes
|                               |----Box2D.ts                           # API export
|                               |----box2d.umd.js                       # API export implementation
|     |---- README.md                                                   # Readme  
|     |---- README_zh.md                                                # Readme                   
````

## How to Contribute

If you find any problem when using box2d, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/box2d/LICENSE).
