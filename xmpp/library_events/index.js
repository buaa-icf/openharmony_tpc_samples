"use strict";

import { timeout } from "./src/main/lib/timeout";
import { delay } from "./src/main/lib/delay";
import { TimeoutError } from "./src/main/lib/TimeoutError";
import { promise } from "./src/main/lib/promise";
import { EventEmitter } from "@ohos/node-polyfill";
import { Deferred } from "./src/main/lib/Deferred";

export { EventEmitter, timeout, delay, TimeoutError, promise, Deferred }
