# behaviortree

## Introduction

behaviortree is a JavaScript implementation of behavior trees, workable in both Node.js and browsers. It is verified against [behaviortree](https://github.com/Calamari/BehaviorTree.js) v2.1.0.

## How to Install

```javascript
ohpm install behaviortree
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```javascript
import { BehaviorTree } from "behaviortree";
```

## Example

### 1. Creating a Simple Task

```javascript
import { Task, SUCCESS } from "behaviortree";

const myTask = new Task({
  // (optional) this function is called directly before the run method
  // is called. It allows you to setup things before starting to run
  start: function (blackboard) {
    blackboard.isStarted = true;
  },

  // (optional) this function is called directly after the run method
  // is completed with either this.success() or this.fail(). It allows you to clean up
  // things, after you run the task.
  end: function (blackboard) {
    blackboard.isStarted = false;
  },

  // This is the meat of your task. The run method does everything you want it to do.
  run: function (blackboard) {
    return SUCCESS;
  },
});
```

Methods:

- **start**: called before the **run** method. However, if the task resumes after ending with **this.running()**, it will not be called.
- **end**: called after the **run** method. However, if the task ends with **this.running()**, it will not be called.
- **run**: contains what you want the task to do.

### 2. Creating a Sequence

```javascript
import { Sequence } from "behaviortree";

const mySequence = new Sequence({
  nodes: [
    // here comes in a list of nodes (Tasks, Sequences or Priorities)
    // as objects or as registered strings
  ],
});
```

### 3. Creating a Priority Selector

```javascript
import { Selector } from "behaviortree";

const mySelector = new Selector({
  nodes: [
    // here comes in a list of nodes (Tasks, Sequences or Priorities)
    // as objects or as registered strings
  ],
});
```

### 4. Creating a Random Selector

```javascript
import { Random } from "behaviortree";

const mySelector = new Random({
  nodes: [
    // here comes in a list of nodes (Tasks, Sequences or Priorities)
    // as objects or as registered strings
  ],
});
```

### 5. Creating a BehaviorTree Instance

```javascript
import { BehaviorTree } from "behaviortree";

var bTree = new BehaviorTree({
  tree: mySelector,
  blackboard: {},
});
```

### 6. Traversing the Behavior Tree

```javascript
bTree.step();
```

For details about unit test cases, see [TEST.md](https://gitcode.com/tybrave/openharmony_tpc_samples/tree/master/behaviortree/TEST.md).

## Available APIs

|    API   |     Description    |
| :----------: | :--------------: |
|   Sequence   |     Creates a sequence.    |
|   Selector   | Creates a priority selector.|
|    Random    |  Creates a random selector. |
| BehaviorTree |  Creates a **BehaviorTree** instance. |
|     step     |    Traverses the behavior tree.   |


## Constraints

This project has been verified in the following versions:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta1 (3.1.0.400), OpenHarmony SDK: API 9 (3.2.11.9)

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/behaviorTree/LICENSE).
