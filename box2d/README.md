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
   `CreateFixture()`
2. Destroys a fixture.
   `DestroyFixture()`
3. Sets the transformation.
   `SetTransform()`
4. Obtains the transformation.
   `GetTransform()`
5. Obtains the position.
   `GetPosition()`
6. Sets the position.
   `SetPosition()`
7. Obtains the world center.
   `GetWorldCenter()`
8. Obtains the local center.
   `GetLocalCenter()`
9. Sets the linear speed.
   `SetLinearVelocity()`

### b2World APIs
1. Sets the substep.
   `setSubStepping()`
2. Sets the destruction listener.
   `SetDestructionListener()`
3. Sets the contact filter.
   `SetContactFilter()`
4. Sets the contact listener.
   `SetContactListener()`
5. Sets the debugging drawing.
   `SetDebugDraw()`
6. Creates a rigid body.
   `CreateBody()`
7. Destroys a rigid body.
   `DestroyBody()`
8. Creates a joint.
   `CreateJoint()`
9. Destroys a joint.
   `DestroyJoint()`

### b2Contact APIs
1. Performs a reset.
   `Reset`
2. Obtains the manifold.
   `GetManifold`
3. Obtains the world manifold.
   `GetWorldManifold`
4. Sets the tangent speed.
   `SetTangentSpeed`
5. Resets the friction.
   `ResetFriction`
6. Set the friction.
   `SetFriction`
7. Specifies whether to enable the function.
   `SetEnabled`
8. Obtains fixture A.
   `GetFixtureA`

### b2Shape APIs
1. Performs a ray cast.
   `RayCast`
2. Obtains the type.
   `GetType`
3. Performs a copy.
   `Copy`
4. Obtains the child count.
   `GetChildCount`
5. Computes AABB.
   `ComputeAABB`
6. Computes the quality.
   `ComputeMass`
7. Computes the distance.
   `ComputeDistance`
8. Performs a clone.
   `clone`

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
