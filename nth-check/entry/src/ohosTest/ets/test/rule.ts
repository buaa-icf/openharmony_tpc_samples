/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

export const valid: [string, [number, number]][] = [
  ["1", [0, 1]],
  ["2", [0, 2]],
  ["3", [0, 3]],
  ["5", [0, 5]],
  [" 1 ", [0, 1]],
  [" 5 ", [0, 5]],
  ["+2n + 1", [2, 1]],
  ["-1", [0, -1]],
  ["-1n + 3", [-1, 3]],
  ["-1n+3", [-1, 3]],
  ["-n+2", [-1, 2]],
  ["-n+3", [-1, 3]],
  ["0n+3", [0, 3]],
  ["1n", [1, 0]],
  ["1n+0", [1, 0]],
  ["2n", [2, 0]],
  ["2n + 1", [2, 1]],
  ["2n+1", [2, 1]],
  ["3n", [3, 0]],
  ["3n+0", [3, 0]],
  ["3n+1", [3, 1]],
  ["3n+2", [3, 2]],
  ["3n+3", [3, 3]],
  ["3n-1", [3, -1]],
  ["3n-2", [3, -2]],
  ["3n-3", [3, -3]],
  ["even", [2, 0]],
  ["n", [1, 0]],
  ["n+2", [1, 2]],
  ["odd", [2, 1]],

  // Surprisingly, neither sizzle, qwery or nwmatcher cover these cases
  ["-4n+13", [-4, 13]],
  ["-2n + 12", [-2, 12]],
  ["-n", [-1, 0]],
];

export const invalid = [
  "-",
  "- 1n",
  "-1 n",
  "2+0",
  "2n+-0",
  "an+b",
  "asdf",
  "b",
  "expr",
  "odd|even|x",
];