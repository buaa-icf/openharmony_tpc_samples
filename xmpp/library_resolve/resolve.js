"use strict";

// import dns from "dns";
import http from "./src/main/lib/http";

export function resolveArgs(...args) {
  return Promise.all([
    /*dns.resolve ? dns.resolve(...args) :*/ Promise.resolve([]),
   http.resolve(...args),
  ]).then(([records, endpoints]) => [...records, ...endpoints]);
};

// if (dns.resolve) {
//   export { dns } ;
// }

export { http } ;
