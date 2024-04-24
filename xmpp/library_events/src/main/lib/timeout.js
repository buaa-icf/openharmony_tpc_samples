"use strict";

import { TimeoutError } from "./TimeoutError";
import { delay } from "./delay";

export function timeout(promise, ms) {
  const promiseDelay = delay(ms);

  function cancelDelay() {
    clearTimeout(promiseDelay.timeout);
  }

  return Promise.race([
    promise.finally(cancelDelay),
    promiseDelay.then(() => {
      throw new TimeoutError();
    }),
  ]);
};
