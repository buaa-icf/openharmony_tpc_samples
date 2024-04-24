"use strict";

import * as mech from "sasl-scram-sha-1";

export function saslScramSha1(sasl) {
  sasl.use(mech);
};
