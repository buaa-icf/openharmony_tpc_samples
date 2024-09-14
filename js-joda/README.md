# js-joda

## Introduction

js-joda is a utility library for processing time and date. It provides simple APIs for date and time classes to support the time zone, duration, and date and time formatting and parsing. It is an immutable date and time library for OpenHarmony.

## How to Install

```
 ohpm install @js-joda/core
 ohpm install @js-joda/timezone
 ohpm install @ohos/localeenus
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```
import { LocalDate } from '@js-joda/core'

console.info(LocalDate.now().toString());
// Parse 2022-07-21.
var mDate = LocalDate.parse('2022-07-21');
console.info(mDate.toString());
// Day of the month: 21
console.info(mDate.dayOfMonth().toString());
// Month: JULY
console.info(mDate.month().toString());
// Value of the month: 7
console.info(mDate.monthValue().toString());
// Year: 2022
console.info(mDate.year().toString());
// Day of the week: THURSDAY
console.info(mDate.dayOfWeek().toString());
// Value of the day of the week: 4
console.info(mDate.dayOfWeek().value().toString());
// Day of the year: 202
console.info(mDate.dayOfYear().toString());
// Leap year: false
console.info(mDate.isLeapYear().toString());
// Number of days in the month: 31
console.info(mDate.lengthOfMonth().toString());
// Number of days in the year: 365
console.info(mDate.lengthOfYear().toString());
// Week of the year: 29
console.info(mDate.get(ChronoField.ALIGNED_WEEK_OF_YEAR).toString());
```

## Available APIs
* `parse()`: parses a given date.
* `dayOfMonth()`: obtains the day of the month of a given date.
* `month()`: obtains the month of a given date.
* `year()`: obtains the year of a given date.
* `dayOfWeek()`: obtains the day of the week of a given date.
* `dayOfYear()`: obtains the day of the year of a given date.
* `isLeapYear()`: checks whether the year of a given date is a leap year.
* `lengthOfYear()`: obtains the number of days in the year of a given date.
* `plusDays()`: adds the number of specified days to a given date.
* `minusDays()`: subtracts the number of specified days from a given date.

## Constraints
This project has been verified in the following version:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

````
|---- js-joda # Root directory 
|     |---- entry  # Sample code
|     |---- library  # localeenus library
|     |---- README.md  # Readme                
````

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-joda/LICENSE).
