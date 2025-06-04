# dayjs

## Introduction

dayjs is a lightweight JavaScript library for handling dates and times, workable in both Node.js and browsers. It is verified against [dayjs](https://github.com/iamkun/dayjs) v1.11.7.

## How to Install

```node
ohpm install dayjs
```

## How to Use

```javascript
import dayjs from "dayjs";
```

## Example

### 1. API

```javascript
dayjs("2018-08-08"); // Parse

dayjs().format("{YYYY} MM-DDTHH:mm:ss SSS [Z] A"); // Display

dayjs().set("month", 3).month(); // Obtain and set

dayjs().add(1, "year"); // Process

dayjs().isBefore(dayjs()); // Query
```

### 2. Internationalization

Day.js supports internationalization, but additional languages are not included in your build unless manually imported.

```javascript
import "dayjs/locale/es"; // Load on demand.

dayjs.locale("es"); // Use Spanish locale globally.

dayjs("2018-05-05").locale("zh-cn").format(); // Use Simplified Chinese locale for this instance.
```

### 3. Plug-in

A plug-in is standalone program that can enhance Day.js by adding new features or extending existing functionalities.

```javascript
import advancedFormat from "dayjs/plugin/advancedFormat"; // Load on demand.

dayjs.extend(advancedFormat); // Use the plug-in.

dayjs().format("Q Do k kk X x"); // Use the API enhanced with the plug-in.
```

For details about unit test cases, see [TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/dayjs/TEST.md).

## Time Format Specifications

Due to restrictions of the runtime environment, pay attention to the following when using the time format:

Supported: 2021-1-4 0:0:0.000

Not supported: 2021-1-4 0:0:0:000

---

Supported: 2021-1-4 0:0:0.000-05:00

Not supported: 2021-1-4 0:0:0.000-0500

## Constraints

This project has been verified in the following versions:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.2 Release (3.1.3.400), OpenHarmony SDK: API 9 Release (3.2.11.5)

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/dayjs/LICENSE).
