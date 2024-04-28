"use strict";

import * as mech from "sasl-plain";

export default function saslPlain(sasl) {
  sasl.use(mech);
};
