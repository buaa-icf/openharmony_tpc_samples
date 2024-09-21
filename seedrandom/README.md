# seedrandom

## Overview

seedrandom is a library that implements a pseudo-random number generator. It is applicable to various application scenarios that require high-quality pseudo-random numbers and can be customized to address specific requirements.

## Display Effects
<img height="400" src="./screenshot/effect.gif"/>

## How to Install

````
ohpm install seedrandom@3.0.5
ohpm install @types/querystringify  // A syntax error is reported if the seedrandom package does not contain the type declaration. You need to download the declaration file of the package from @types/seedrandom to rectify the syntax error.
````

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```typescript
// Introduce seedrandom.
import seedrandom from 'seedrandom'
// Example API call
rng = seedrandom('hello.');
console.log(rng());                  // Always 0.9282578795792454

// Global PRNG: set Math.random.
seedrandom('hello.', { global: true });
console.log(Math.random());          // Always 0.9282578795792454

// Autoseeded ARC4-based PRNG.
rng = seedrandom();
console.log(rng());                  // Reasonably unpredictable.

// Mixing accumulated entropy.
rng = seedrandom('added entropy.', { entropy: true });
console.log(rng());                  // As unpredictable as added entropy.

// Using alternate algorithms, as listed above.
rng2 = seedrandom.xor4096('hello.')
console.log(rng2());
```

## Available APIs

1. SeededRandom(seed, options): Creates a new **SeededRandom** instance. **seed** is the seed value, and **options** is an optional configuration object.
2. seedrandom.alea(seed, options): Generates pseudo-random numbers using the alea algorithm.
3. seedrandom.xor128(seed, options): Generates pseudo-random numbers using the xor128 algorithm.
4. seedrandom.tychei(seed, options): Generates pseudo-random numbers using the tychei algorithm.
5. seedrandom.xorwow(seed, options): Generates pseudo-random numbers using the xorwow algorithm.
6. seedrandom.xor4096(seed, options): Generates pseudo-random numbers using the xor4096 algorithm.
7. seedrandom.xorshift7(seed, options): Generates pseudo-random numbers using the xorshift7 algorithm.
8. seedrandom.quick(seed, options): Generates pseudo-random numbers using the quick algorithm.


## Constraints

seedrandom has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

````
|---- seedrandom 
|     |---- entry  # Sample code
|     |---- README_EN.md  # Readme     
````

## How to Contribute
If you find any problem when using seedrandom, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project follows the [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/seedrandom/LICENSE).
