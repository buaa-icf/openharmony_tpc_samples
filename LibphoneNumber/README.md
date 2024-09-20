# libphonenumber-js

This project demonstrates how to use **libphonenumber-js** in OpenHarmony. **libphonenumber-js** is an open-source JavaScript library for formatting and parsing phone numbers.


## How to Install

```sh
ohpm install libphonenumber-js@1.9.53
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
```javascript
    import { parsePhoneNumber, AsYouType, findPhoneNumbersInText, ParseError } from "libphonenumber-js";
    import customData from ."/customData.json"; // Custom metadata
    import Log from './../util/Log';
    import {
        parsePhoneNumberWithError,
        parsePhoneNumber as coreParsePhoneNumber,
        AsYouType as coreAsYouType
    } from 'libphonenumber-js/core'

    const number = '213-373-4253';
    const phoneNumber = parsePhoneNumber(number, 'US');
    const asYouType = new AsYouType('US');
    const findPhoneNumbers = 'For tech support call +7 (800) 555-35-35 internationally or reach a local US branch at (213) 373-4253 ext. 1234.';

    // Phone number, for example, +12133734253.
    Log.showInfo('number: ' + phoneNumber.number.toString())

    // Country, for example, the US.
    Log.showInfo('country: ' + phoneNumber.country);

    // National number format, for example, (213) 373-4253.
    Log.showInfo('national: ' + phoneNumber.formatNational());

    // International number format, for example, +1 213 373 4253.
    Log.showInfo('international: ' + phoneNumber.formatInternational());

    // Phone number in URI format, for example, tel: +12133734253.
    Log.showInfo('uri: ' + phoneNumber.getURI());

    // Type of the phone number, for example, fixed line or mobile.
    Log.showInfo('type: ' + phoneNumber.getType());

    // Check whether the number is a phone number based on the quantity of digits.
    Log.showInfo('isPossible: ' + phoneNumber.isPossible());

    // Check whether the number is valid based on all matching principles.
    Log.showInfo('isValid: ' + phoneNumber.isValid());

    // Parse a newly entered digit together with the previously entered digit until the clear function is called.
    asYouType.input(number);

    // Parse the country based on the entered number, for example, the US.
    Log.showInfo('country: ' + asYouType.getCountry());

    // Parse the template based on the entered number, for example, (xxx) xxx-xxxx.
    Log.showInfo('template: ' + asYouType.getTemplate());

    const phoneNumberValue = asYouType.getNumber();
    if (phoneNumberValue != undefined) {
    // Parse the number based on the entered number, for example, +12133734253.
    Log.showInfo('number: ' + JSON.stringify(asYouType.getNumber()));

    // Parse the national number format based on the entered number, for example, (213) 373-4253.
    Log.showInfo('national: ' + asYouType.getNumber().formatNational());

    // Parse the international number format based on the entered number, for example, +1 213 373 4253.
    Log.showInfo('international: ' + asYouType.getNumber().formatInternational());

    // Parse the URI format based on the entered number, for example, tel: +12133734253.
    Log.showInfo('uri: ' + asYouType.getNumber().getURI());

    // Parse the type based on the entered number, for example, fixed line or mobile.
    Log.showInfo('type: ' + asYouType.getNumber().getType());
    } else {
    Log.showInfo(TAG + "getNumber() is undefined");
    }

    // Parse the entered number to check whether it is a phone number based on the quantity of digits.
    Log.showInfo('isPossible: ' + asYouType.isPossible());

    // Parse the entered number to whether it is valid based on all matching principles.
    Log.showInfo('isValid: ' + asYouType.isValid());

    // Find a phone number from a text.
    Log.showInfo(JSON.stringify(findPhoneNumbersInText(findPhoneNumbers, 'US')));


    /**
     *
     * Use custom metadata and introduce libphonenumber-js/core.
     * Use scenarios:
     * 1. Only the phone numbers of several specified countries need to be processed.
     * 2. Custom metadata refers to the metadata that contains only specific countries, such as China and the US.
     *
     */

    const number: string[] = ['+8618717452985', '+12133734253', '+78005553535'];
    // Examples of using the custom metadata APIs are listed here. The usage of other APIs is the same as that of common metadata APIs.
    const type = new coreAsYouType('CN', customData).input(number[0]);
    Log.showInfo(TAG + ' libphonenumber-js/core AsYouType : ' + type);
    Log.showInfo(TAG + ' libphonenumber-js/core parsePhoneNumber : ' + JSON.stringify(coreParsePhoneNumber(number[0], customData)));
    Log.showInfo(TAG + ' libphonenumber-js/core parsePhoneNumber : ' + JSON.stringify(coreParsePhoneNumber(number[1], customData)));
    try {
        parsePhoneNumberWithError(number[2], customData);
    } catch (error) {
        if (error instanceof ParseError) {
            Log.showInfo(TAG + " Phone number parsing exception ,customData does not contain this country, error msg : " + error.message);
        }
    }

```

## Constraints

- DevEco Studio: 4.1 Canary (4.1.3.317)
- OpenHarmony SDK: API 11 (4.1.0.36)

## How to Contribute

If you find any problem when using the project, submit an issue or a PR.

## License

This project is licensed under [Apache License 2.0](https://github.com/catamphetamine/libphonenumber-js/blob/master/LICENSE).
