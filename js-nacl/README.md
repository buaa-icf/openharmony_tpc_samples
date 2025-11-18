# js-nacl

## Introduction

> js-nacl OpenHarmony application that integrates the NaCl cryptographic library, providing advanced API interfaces based on modern cryptographic algorithms, including hash computation, digital signatures, public-key encryption, and private-key encryption.

The project is developed for the OpenHarmony system and includes the following core modules:
- AppScope: Global application resources
- entry: Main module with EntryAbility, UI pages, and test code
- library: Public library module providing NaCl encryption capabilities


## Installation

To install and run this project, you need to set up the OpenHarmony development environment:

1. Install DevEco Studio
2. Configure the OpenHarmony SDK
3. Import the project into DevEco Studio
4. Build and run the project


## Project Structure

````

js-nacl

├── AppScope/                   # Global application resources
├── entry/                      # Main module
│   ├── src/
│   │   ├── main/               # Main source code directory
│   │   ├── ohosTest/           # OpenHarmony test directory
│   │   └── test/               # Unit test directory
│   ├── oh-package.json5        # Module package configuration
│   └── ...                     # Other configuration files
├── library/                    # Public library module
│   ├── src/
│   │   └── main/
│   │       └── lib/
│   │           ├── naclType.ts      # Type definitions
│   │           ├── nacl_factory.ets # Core functionality 
│   │           └── utils.ts         # Core functionality implementation
│   ├── oh-package.json5        # Package metadata and dependencies
│   ├── index.ets               # Library entry point
│   └── index.d.ts              # Type definitions
│   └── ...                     # Other configuration files
├── README.md                   # Project documentation in English
├── README_zh.md                # Project documentation in Chinese
├── oh-package.json5            # Project configuration file
└── ...                         # Other configuration files               

````


## Core Features

### Cryptographic Functions
- Hash computation (SHA-512, SHA-256)
- Public-key authenticated encryption (crypto_box)
- Secret-key authenticated encryption (crypto_secretbox)
- Digital signatures (crypto_sign)
- Stream encryption (crypto_stream)
- Message authentication (crypto_auth, crypto_onetimeauth)
- Key derivation functions

### Library Module
The library module provides NaCl encryption capabilities for other modules:
- nacl_factory.ets: Main entry point for the NaCl library
- naclType.ts: Type definitions for the NaCl library
- utils.ts: Core implementation of cryptographic functions

### Testing
- Unit tests in the entry/src/test/ directory
- OpenHarmony tests in the entry/src/ohosTest/ directory


## Usage

To use the cryptographic functions in your OpenHarmony application:

1. Import the library module
2. Instantiate the NaCl factory
3. Use the provided API functions for cryptographic operations

Example:
```javascript
import nacl_factory from '@ohos/js-nacl'

nacl_factory.instantiate(function (nacl) {
  // Use nacl API
  console.log(nacl.to_hex(nacl.random_bytes(16)));
});
```


## Dependencies

- OpenHarmony SDK API12 (5.0.0.12) or higher
- DevEco Studio 5.1  (5.1.1.830) or higher


## Contributing

If you encounter any issues while using this project, please feel free to submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) to us. We also welcome you to submit [Pull Requests](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to contribute code.


## License

This project is licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0). Feel free to enjoy and participate in open source development.