/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import util from '@ohos.util'
import {
  compile,
  Key,
  match,
  parse,
  pathToRegexp,
  tokensToRegexp,
  tokensToFunction,
  MyPath,
  Token,
  Match,
  ParseOptions,
  TokensToFunctionOptions,
  RegexpToFunctionOptions,
  MatchResult,
  TokensToRegexpOptions
} from 'path-to-regexp';

const BASE_COUNT = 1

type Test = [
  MyPath,
  (TokensToRegexpOptions & ParseOptions) | undefined,
  Token[],
  Array<[
    string,
    (string | undefined)[] | null,
    Match?,
    RegexpToFunctionOptions?
  ]>,
  Array<[any, string | null, TokensToFunctionOptions?]>
];

const TESTS: Test[] = [
/**
 * Simple paths.
 */
  [
    "/",
    undefined,
    ["/"],
    [
      ["/", ["/"], { path: "/", index: 0, params: {} }],
      ["/route", null, false],
    ],
    [
      [null, "/"],
      [{}, "/"],
      [{ id: 123 }, "/"],
    ],
  ],
  [
    "/test",
    undefined,
    ["/test"],
    [
      ["/test", ["/test"], { path: "/test", index: 0, params: {} }],
      ["/route", null, false],
      ["/test/route", null, false],
      ["/test/", ["/test/"], { path: "/test/", index: 0, params: {} }],
    ],
    [
      [null, "/test"],
      [{}, "/test"],
    ],
  ],
  [
    "/test/",
    undefined,
    ["/test/"],
    [
      ["/test", null],
      ["/test/", ["/test/"]],
      ["/test//", ["/test//"]],
    ],
    [[null, "/test/"]],
  ],

  /**
   * Case-sensitive paths.
   */
  [
    "/test",
    {
      sensitive: true,
    },
    ["/test"],
    [
      ["/test", ["/test"]],
      ["/TEST", null],
    ],
    [[null, "/test"]],
  ],
  [
    "/TEST",
    {
      sensitive: true,
    },
    ["/TEST"],
    [
      ["/test", null],
      ["/TEST", ["/TEST"]],
    ],
    [[null, "/TEST"]],
  ],

  /**
   * Strict mode.
   */
  [
    "/test",
    {
      strict: true,
    },
    ["/test"],
    [
      ["/test", ["/test"]],
      ["/test/", null],
      ["/TEST", ["/TEST"]],
    ],
    [[null, "/test"]],
  ],
  [
    "/test/",
    {
      strict: true,
    },
    ["/test/"],
    [
      ["/test", null],
      ["/test/", ["/test/"]],
      ["/test//", null],
    ],
    [[null, "/test/"]],
  ],

  /**
   * Non-ending mode.
   */
  [
    "/test",
    {
      end: false,
    },
    ["/test"],
    [
      ["/test", ["/test"]],
      ["/test/", ["/test/"]],
      ["/test/route", ["/test"]],
      ["/route", null],
    ],
    [[null, "/test"]],
  ],
  [
    "/test/",
    {
      end: false,
    },
    ["/test/"],
    [
      ["/test", null],
      ["/test/route", ["/test/"]],
      ["/test//", ["/test//"]],
      ["/test//route", ["/test/"]],
    ],
    [[null, "/test/"]],
  ],
  [
    "/:test",
    {
      end: false,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      [
        "/route",
        ["/route", "route"],
        { path: "/route", index: 0, params: { test: "route" } },
      ],
      [
        "/caf%C3%A9",
        ["/caf%C3%A9", "caf%C3%A9"],
        { path: "/caf%C3%A9", index: 0, params: { test: "caf%C3%A9" } },
      ],
      [
        "/caf%C3%A9",
        ["/caf%C3%A9", "caf%C3%A9"],
        { path: "/caf%C3%A9", index: 0, params: { test: "café" } },
        { decode: decodeURIComponent },
      ],
    ],
    [
      [{}, null],
      [{ test: "abc" }, "/abc"],
      [{ test: "a+b" }, "/a+b"],
      [{ test: "a+b" }, "/test", { encode: (_, token) => String(token.name) }],
      [{ test: "a+b" }, "/a%2Bb", { encode: encodeURIComponent }],
    ],
  ],
  [
    "/:test/",
    {
      end: false,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      "/",
    ],
    [
      ["/route", null],
      ["/route/", ["/route/", "route"]],
    ],
    [[{ test: "abc" }, "/abc/"]],
  ],
  [
    "",
    {
      end: false,
    },
    [],
    [
      ["", [""]],
      ["/", ["/"]],
      ["route", [""]],
      ["/route", [""]],
      ["/route/", [""]],
    ],
    [[null, ""]],
  ],

  /**
   * Non-starting mode.
   */
  [
    "/test",
    {
      start: false,
    },
    ["/test"],
    [
      ["/test", ["/test"]],
      ["/test/", ["/test/"]],
      ["/route/test", ["/test"]],
      ["/test/route", null],
      ["/route/test/deep", null],
      ["/route", null],
    ],
    [[null, "/test"]],
  ],
  [
    "/test/",
    {
      start: false,
    },
    ["/test/"],
    [
      ["/test", null],
      ["/test/route", null],
      ["/test//route", null],
      ["/test//", ["/test//"]],
      ["/route/test/", ["/test/"]],
    ],
    [[null, "/test/"]],
  ],
  [
    "/:test",
    {
      start: false,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [["/route", ["/route", "route"]]],
    [
      [{}, null],
      [{ test: "abc" }, "/abc"],
      [{ test: "a+b" }, "/a+b"],
      [{ test: "a+b" }, "/test", { encode: (_, token) => String(token.name) }],
      [{ test: "a+b" }, "/a%2Bb", { encode: encodeURIComponent }],
    ],
  ],
  [
    "/:test/",
    {
      start: false,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      "/",
    ],
    [
      ["/route", null],
      ["/route/", ["/route/", "route"]],
    ],
    [[{ test: "abc" }, "/abc/"]],
  ],
  [
    "",
    {
      start: false,
    },
    [],
    [
      ["", [""]],
      ["/", ["/"]],
      ["route", [""]],
      ["/route", [""]],
      ["/route/", ["/"]],
    ],
    [[null, ""]],
  ],

  /**
   * Combine modes.
   */
  [
    "/test",
    {
      end: false,
      strict: true,
    },
    ["/test"],
    [
      ["/test", ["/test"]],
      ["/test/", ["/test"]],
      ["/test/route", ["/test"]],
    ],
    [[null, "/test"]],
  ],
  [
    "/test/",
    {
      end: false,
      strict: true,
    },
    ["/test/"],
    [
      ["/test", null],
      ["/test/", ["/test/"]],
      ["/test//", ["/test/"]],
      ["/test/route", ["/test/"]],
    ],
    [[null, "/test/"]],
  ],
  [
    "/test.json",
    {
      end: false,
      strict: true,
    },
    ["/test.json"],
    [
      ["/test.json", ["/test.json"]],
      ["/test.json.hbs", null],
      ["/test.json/route", ["/test.json"]],
    ],
    [[null, "/test.json"]],
  ],
  [
    "/:test",
    {
      end: false,
      strict: true,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/route", ["/route", "route"]],
      ["/route/", ["/route", "route"]],
    ],
    [
      [{}, null],
      [{ test: "abc" }, "/abc"],
    ],
  ],
  [
    "/:test/",
    {
      end: false,
      strict: true,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      "/",
    ],
    [
      ["/route", null],
      ["/route/", ["/route/", "route"]],
    ],
    [[{ test: "foobar" }, "/foobar/"]],
  ],
  [
    "/test",
    {
      start: false,
      end: false,
    },
    ["/test"],
    [
      ["/test", ["/test"]],
      ["/test/", ["/test/"]],
      ["/test/route", ["/test"]],
      ["/route/test/deep", ["/test"]],
    ],
    [[null, "/test"]],
  ],
  [
    "/test/",
    {
      start: false,
      end: false,
    },
    ["/test/"],
    [
      ["/test", null],
      ["/test/", ["/test/"]],
      ["/test//", ["/test//"]],
      ["/test/route", ["/test/"]],
      ["/route/test/deep", ["/test/"]],
    ],
    [[null, "/test/"]],
  ],
  [
    "/test.json",
    {
      start: false,
      end: false,
    },
    ["/test.json"],
    [
      ["/test.json", ["/test.json"]],
      ["/test.json.hbs", null],
      ["/test.json/route", ["/test.json"]],
      ["/route/test.json/deep", ["/test.json"]],
    ],
    [[null, "/test.json"]],
  ],
  [
    "/:test",
    {
      start: false,
      end: false,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/route", ["/route", "route"]],
      ["/route/", ["/route/", "route"]],
    ],
    [
      [{}, null],
      [{ test: "abc" }, "/abc"],
    ],
  ],
  [
    "/:test/",
    {
      end: false,
      strict: true,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      "/",
    ],
    [
      ["/route", null],
      ["/route/", ["/route/", "route"]],
    ],
    [[{ test: "foobar" }, "/foobar/"]],
  ],

  /**
   * Arrays of simple paths.
   */
  [
    ["/one", "/two"],
    undefined,
    [],
    [
      ["/one", ["/one"]],
      ["/two", ["/two"]],
      ["/three", null],
      ["/one/two", null],
    ],
    [],
  ],

  /**
   * Non-ending simple path.
   */
  [
    "/test",
    {
      end: false,
    },
    ["/test"],
    [["/test/route", ["/test"]]],
    [[null, "/test"]],
  ],

  /**
   * Single named parameter.
   */
  [
    "/:test",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/route", ["/route", "route"]],
      ["/another", ["/another", "another"]],
      ["/something/else", null],
      ["/route.json", ["/route.json", "route.json"]],
      ["/something%2Felse", ["/something%2Felse", "something%2Felse"]],
      [
        "/something%2Felse%2Fmore",
        ["/something%2Felse%2Fmore", "something%2Felse%2Fmore"],
      ],
      ["/;,:@&=+$-_.!~*()", ["/;,:@&=+$-_.!~*()", ";,:@&=+$-_.!~*()"]],
    ],
    [
      [{ test: "route" }, "/route"],
      [
        { test: "something/else" },
        "/something%2Felse",
        { encode: encodeURIComponent },
      ],
      [
        { test: "something/else/more" },
        "/something%2Felse%2Fmore",
        { encode: encodeURIComponent },
      ],
    ],
  ],
  [
    "/:test",
    {
      strict: true,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/route", ["/route", "route"]],
      ["/route/", null],
    ],
    [[{ test: "route" }, "/route"]],
  ],
  [
    "/:test/",
    {
      strict: true,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      "/",
    ],
    [
      ["/route/", ["/route/", "route"]],
      ["/route//", null],
    ],
    [[{ test: "route" }, "/route/"]],
  ],
  [
    "/:test",
    {
      end: false,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/route.json", ["/route.json", "route.json"]],
      ["/route//", ["/route", "route"]],
    ],
    [[{ test: "route" }, "/route"]],
  ],

  /**
   * Optional named parameter.
   */
  [
    "/:test?",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      [
        "/route",
        ["/route", "route"],
        { path: "/route", index: 0, params: { test: "route" } },
      ],
      ["/route/nested", null, false],
      ["/", ["/", undefined], { path: "/", index: 0, params: {} }],
      ["//", null],
    ],
    [
      [null, ""],
      [{ test: "foobar" }, "/foobar"],
    ],
  ],
  [
    "/:test?",
    {
      strict: true,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/route", ["/route", "route"]],
      ["/", null], // Questionable behaviour.
      ["//", null],
    ],
    [
      [null, ""],
      [{ test: "foobar" }, "/foobar"],
    ],
  ],
  [
    "/:test?/",
    {
      strict: true,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
      "/",
    ],
    [
      ["/route", null],
      ["/route/", ["/route/", "route"]],
      ["/", ["/", undefined]],
      ["//", null],
    ],
    [
      [null, "/"],
      [{ test: "foobar" }, "/foobar/"],
    ],
  ],
  [
    "/:test?/bar",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
      "/bar",
    ],
    [
      ["/bar", ["/bar", undefined]],
      ["/foo/bar", ["/foo/bar", "foo"]],
    ],
    [
      [null, "/bar"],
      [{ test: "foo" }, "/foo/bar"],
    ],
  ],
  [
    "/:test?-bar",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
      "-bar",
    ],
    [
      ["-bar", ["-bar", undefined]],
      ["/-bar", null],
      ["/foo-bar", ["/foo-bar", "foo"]],
    ],
    [
      [undefined, "-bar"],
      [{ test: "foo" }, "/foo-bar"],
    ],
  ],
  [
    "/:test*-bar",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "*",
        pattern: "[^\\/#\\?]+?",
      },
      "-bar",
    ],
    [
      ["-bar", ["-bar", undefined]],
      ["/-bar", null],
      ["/foo-bar", ["/foo-bar", "foo"]],
      ["/foo/baz-bar", ["/foo/baz-bar", "foo/baz"]],
    ],
    [[{ test: "foo" }, "/foo-bar"]],
  ],

  /**
   * Repeated one or more times parameters.
   */
  [
    "/:test+",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "+",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/", null, false],
      [
        "/route",
        ["/route", "route"],
        { path: "/route", index: 0, params: { test: ["route"] } },
      ],
      [
        "/some/basic/route",
        ["/some/basic/route", "some/basic/route"],
        {
          path: "/some/basic/route",
          index: 0,
          params: { test: ["some", "basic", "route"] },
        },
      ],
      ["//", null, false],
    ],
    [
      [{}, null],
      [{ test: "foobar" }, "/foobar"],
      [{ test: ["a", "b", "c"] }, "/a/b/c"],
    ],
  ],
  [
    "/:test(\\d+)+",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "+",
        pattern: "\\d+",
      },
    ],
    [
      ["/abc/456/789", null],
      ["/123/456/789", ["/123/456/789", "123/456/789"]],
    ],
    [
      [{ test: "abc" }, null],
      [{ test: 123 }, "/123"],
      [{ test: [1, 2, 3] }, "/1/2/3"],
    ],
  ],
  [
    "/route.:ext(json|xml)+",
    undefined,
    [
      "/route",
      {
        name: "ext",
        prefix: ".",
        suffix: "",
        modifier: "+",
        pattern: "json|xml",
      },
    ],
    [
      ["/route", null],
      ["/route.json", ["/route.json", "json"]],
      ["/route.xml.json", ["/route.xml.json", "xml.json"]],
      ["/route.html", null],
    ],
    [
      [{ ext: "foobar" }, null],
      [{ ext: "xml" }, "/route.xml"],
      [{ ext: ["xml", "json"] }, "/route.xml.json"],
    ],
  ],
  [
    "/route.:ext(\\w+)/test",
    undefined,
    [
      "/route",
      {
        name: "ext",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: "\\w+",
      },
      "/test",
    ],
    [
      ["/route", null],
      ["/route.json", null],
      ["/route.xml/test", ["/route.xml/test", "xml"]],
      ["/route.json.gz/test", null],
    ],
    [[{ ext: "xml" }, "/route.xml/test"]],
  ],

  /**
   * Repeated zero or more times parameters.
   */
  [
    "/:test*",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "*",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/", ["/", undefined], { path: "/", index: 0, params: {} }],
      ["//", null, false],
      [
        "/route",
        ["/route", "route"],
        { path: "/route", index: 0, params: { test: ["route"] } },
      ],
      [
        "/some/basic/route",
        ["/some/basic/route", "some/basic/route"],
        {
          path: "/some/basic/route",
          index: 0,
          params: { test: ["some", "basic", "route"] },
        },
      ],
    ],
    [
      [{}, ""],
      [{ test: [] }, ""],
      [{ test: "foobar" }, "/foobar"],
      [{ test: ["foo", "bar"] }, "/foo/bar"],
    ],
  ],
  [
    "/route.:ext([a-z]+)*",
    undefined,
    [
      "/route",
      {
        name: "ext",
        prefix: ".",
        suffix: "",
        modifier: "*",
        pattern: "[a-z]+",
      },
    ],
    [
      ["/route", ["/route", undefined]],
      ["/route.json", ["/route.json", "json"]],
      ["/route.json.xml", ["/route.json.xml", "json.xml"]],
      ["/route.123", null],
    ],
    [
      [{}, "/route"],
      [{ ext: [] }, "/route"],
      [{ ext: "123" }, null],
      [{ ext: "foobar" }, "/route.foobar"],
      [{ ext: ["foo", "bar"] }, "/route.foo.bar"],
    ],
  ],

  /**
   * Custom named parameters.
   */
  [
    "/:test(\\d+)",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "\\d+",
      },
    ],
    [
      ["/123", ["/123", "123"]],
      ["/abc", null],
      ["/123/abc", null],
    ],
    [
      [{ test: "abc" }, null],
      [{ test: "abc" }, "/abc", { validate: false }],
      [{ test: "123" }, "/123"],
    ],
  ],
  [
    "/:test(\\d+)",
    {
      end: false,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "\\d+",
      },
    ],
    [
      ["/123", ["/123", "123"]],
      ["/abc", null],
      ["/123/abc", ["/123", "123"]],
    ],
    [[{ test: "123" }, "/123"]],
  ],
  [
    "/:test(.*)",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: ".*",
      },
    ],
    [
      ["/anything/goes/here", ["/anything/goes/here", "anything/goes/here"]],
      ["/;,:@&=/+$-_.!/~*()", ["/;,:@&=/+$-_.!/~*()", ";,:@&=/+$-_.!/~*()"]],
    ],
    [
      [{ test: "" }, "/"],
      [{ test: "abc" }, "/abc"],
      [{ test: "abc/123" }, "/abc%2F123", { encode: encodeURIComponent }],
      [
        { test: "abc/123/456" },
        "/abc%2F123%2F456",
        { encode: encodeURIComponent },
      ],
    ],
  ],
  [
    "/:route([a-z]+)",
    undefined,
    [
      {
        name: "route",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[a-z]+",
      },
    ],
    [
      ["/abcde", ["/abcde", "abcde"]],
      ["/12345", null],
    ],
    [
      [{ route: "" }, null],
      [{ route: "" }, "/", { validate: false }],
      [{ route: "123" }, null],
      [{ route: "123" }, "/123", { validate: false }],
      [{ route: "abc" }, "/abc"],
    ],
  ],
  [
    "/:route(this|that)",
    undefined,
    [
      {
        name: "route",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "this|that",
      },
    ],
    [
      ["/this", ["/this", "this"]],
      ["/that", ["/that", "that"]],
      ["/foo", null],
    ],
    [
      [{ route: "this" }, "/this"],
      [{ route: "foo" }, null],
      [{ route: "foo" }, "/foo", { validate: false }],
      [{ route: "that" }, "/that"],
    ],
  ],
  [
    "/:path(abc|xyz)*",
    undefined,
    [
      {
        name: "path",
        prefix: "/",
        suffix: "",
        modifier: "*",
        pattern: "abc|xyz",
      },
    ],
    [
      ["/abc", ["/abc", "abc"]],
      ["/abc/abc", ["/abc/abc", "abc/abc"]],
      ["/xyz/xyz", ["/xyz/xyz", "xyz/xyz"]],
      ["/abc/xyz", ["/abc/xyz", "abc/xyz"]],
      ["/abc/xyz/abc/xyz", ["/abc/xyz/abc/xyz", "abc/xyz/abc/xyz"]],
      ["/xyzxyz", null],
    ],
    [
      [{ path: "abc" }, "/abc"],
      [{ path: ["abc", "xyz"] }, "/abc/xyz"],
      [{ path: ["xyz", "abc", "xyz"] }, "/xyz/abc/xyz"],
      [{ path: "abc123" }, null],
      [{ path: "abc123" }, "/abc123", { validate: false }],
      [{ path: "abcxyz" }, null],
      [{ path: "abcxyz" }, "/abcxyz", { validate: false }],
    ],
  ],

  /**
   * Prefixed slashes could be omitted.
   */
  [
    "test",
    undefined,
    ["test"],
    [
      ["test", ["test"]],
      ["/test", null],
    ],
    [[null, "test"]],
  ],
  [
    ":test",
    undefined,
    [
      {
        name: "test",
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["route", ["route", "route"]],
      ["/route", null],
      ["route/", ["route/", "route"]],
    ],
    [
      [{ test: "" }, null],
      [{}, null],
      [{ test: null }, null],
      [{ test: "route" }, "route"],
    ],
  ],
  [
    ":test",
    {
      strict: true,
    },
    [
      {
        name: "test",
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["route", ["route", "route"]],
      ["/route", null],
      ["route/", null],
    ],
    [[{ test: "route" }, "route"]],
  ],
  [
    ":test",
    {
      end: false,
    },
    [
      {
        name: "test",
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["route", ["route", "route"]],
      ["/route", null],
      ["route/", ["route/", "route"]],
      ["route/foobar", ["route", "route"]],
    ],
    [[{ test: "route" }, "route"]],
  ],
  [
    ":test?",
    undefined,
    [
      {
        name: "test",
        prefix: "",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["route", ["route", "route"]],
      ["/route", null],
      ["", ["", undefined]],
      ["route/foobar", null],
    ],
    [
      [{}, ""],
      [{ test: "" }, null],
      [{ test: "route" }, "route"],
    ],
  ],
  [
    "{:test/}+",
    undefined,
    [
      {
        name: "test",
        prefix: "",
        suffix: "/",
        modifier: "+",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["route/", ["route/", "route"]],
      ["/route", null],
      ["", null],
      ["foo/bar/", ["foo/bar/", "foo/bar"]],
    ],
    [
      [{}, null],
      [{ test: "" }, null],
      [{ test: ["route"] }, "route/"],
      [{ test: ["foo", "bar"] }, "foo/bar/"],
    ],
  ],

  /**
   * Formats.
   */
  [
    "/test.json",
    undefined,
    ["/test.json"],
    [
      ["/test.json", ["/test.json"]],
      ["/route.json", null],
    ],
    [[{}, "/test.json"]],
  ],
  [
    "/:test.json",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      ".json",
    ],
    [
      ["/.json", null],
      ["/test.json", ["/test.json", "test"]],
      ["/route.json", ["/route.json", "route"]],
      ["/route.json.json", ["/route.json.json", "route.json"]],
    ],
    [
      [{ test: "" }, null],
      [{ test: "foo" }, "/foo.json"],
    ],
  ],

  /**
   * Format params.
   */
  [
    "/test.:format(\\w+)",
    undefined,
    [
      "/test",
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: "\\w+",
      },
    ],
    [
      ["/test.html", ["/test.html", "html"]],
      ["/test.hbs.html", null],
    ],
    [
      [{}, null],
      [{ format: "" }, null],
      [{ format: "foo" }, "/test.foo"],
    ],
  ],
  [
    "/test.:format(\\w+).:format(\\w+)",
    undefined,
    [
      "/test",
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: "\\w+",
      },
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: "\\w+",
      },
    ],
    [
      ["/test.html", null],
      ["/test.hbs.html", ["/test.hbs.html", "hbs", "html"]],
    ],
    [
      [{ format: "foo.bar" }, null],
      [{ format: "foo" }, "/test.foo.foo"],
    ],
  ],
  [
    "/test{.:format}+",
    undefined,
    [
      "/test",
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "+",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/test.html", ["/test.html", "html"]],
      ["/test.hbs.html", ["/test.hbs.html", "hbs.html"]],
    ],
    [
      [{ format: [] }, null],
      [{ format: "foo" }, "/test.foo"],
      [{ format: ["foo", "bar"] }, "/test.foo.bar"],
    ],
  ],
  [
    "/test.:format(\\w+)",
    {
      end: false,
    },
    [
      "/test",
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: "\\w+",
      },
    ],
    [
      ["/test.html", ["/test.html", "html"]],
      ["/test.hbs.html", null],
    ],
    [[{ format: "foo" }, "/test.foo"]],
  ],
  [
    "/test.:format.",
    undefined,
    [
      "/test",
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      ".",
    ],
    [
      ["/test.html.", ["/test.html.", "html"]],
      ["/test.hbs.html", null],
    ],
    [
      [{ format: "" }, null],
      [{ format: "foo" }, "/test.foo."],
    ],
  ],

  /**
   * Format and path params.
   */
  [
    "/:test.:format",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/route.html", ["/route.html", "route", "html"]],
      ["/route", null],
      ["/route.html.json", ["/route.html.json", "route", "html.json"]],
    ],
    [
      [{}, null],
      [{ test: "route", format: "foo" }, "/route.foo"],
    ],
  ],
  [
    "/:test{.:format}?",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/route", ["/route", "route", undefined]],
      ["/route.json", ["/route.json", "route", "json"]],
      ["/route.json.html", ["/route.json.html", "route", "json.html"]],
    ],
    [
      [{ test: "route" }, "/route"],
      [{ test: "route", format: "" }, null],
      [{ test: "route", format: "foo" }, "/route.foo"],
    ],
  ],
  [
    "/:test.:format?",
    {
      end: false,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/route", ["/route", "route", undefined]],
      ["/route.json", ["/route.json", "route", "json"]],
      ["/route.json.html", ["/route.json.html", "route", "json.html"]],
    ],
    [
      [{ test: "route" }, "/route"],
      [{ test: "route", format: undefined }, "/route"],
      [{ test: "route", format: "" }, null],
      [{ test: "route", format: "foo" }, "/route.foo"],
    ],
  ],
  [
    "/test.:format(.*)z",
    {
      end: false,
    },
    [
      "/test",
      {
        name: "format",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: ".*",
      },
      "z",
    ],
    [
      ["/test.abc", null],
      ["/test.z", ["/test.z", ""]],
      ["/test.abcz", ["/test.abcz", "abc"]],
    ],
    [
      [{}, null],
      [{ format: "" }, "/test.z"],
      [{ format: "foo" }, "/test.fooz"],
    ],
  ],

  /**
   * Unnamed params.
   */
  [
    "/(\\d+)",
    undefined,
    [
      {
        name: 0,
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "\\d+",
      },
    ],
    [
      ["/123", ["/123", "123"]],
      ["/abc", null],
      ["/123/abc", null],
    ],
    [
      [{}, null],
      [{ "0": "123" }, "/123"],
    ],
  ],
  [
    "/(\\d+)",
    {
      end: false,
    },
    [
      {
        name: 0,
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "\\d+",
      },
    ],
    [
      ["/123", ["/123", "123"]],
      ["/abc", null],
      ["/123/abc", ["/123", "123"]],
      ["/123/", ["/123/", "123"]],
    ],
    [[{ "0": "123" }, "/123"]],
  ],
  [
    "/(\\d+)?",
    undefined,
    [
      {
        name: 0,
        prefix: "/",
        suffix: "",
        modifier: "?",
        pattern: "\\d+",
      },
    ],
    [
      ["/", ["/", undefined]],
      ["/123", ["/123", "123"]],
    ],
    [
      [{}, ""],
      [{ "0": "123" }, "/123"],
    ],
  ],
  [
    "/(.*)",
    undefined,
    [
      {
        name: 0,
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: ".*",
      },
    ],
    [
      ["/", ["/", ""]],
      ["/route", ["/route", "route"]],
      ["/route/nested", ["/route/nested", "route/nested"]],
    ],
    [
      [{ "0": "" }, "/"],
      [{ "0": "123" }, "/123"],
    ],
  ],
  [
    "/route\\(\\\\(\\d+\\\\)\\)",
    undefined,
    [
      "/route(\\",
      {
        name: 0,
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "\\d+\\\\",
      },
      ")",
    ],
    [["/route(\\123\\)", ["/route(\\123\\)", "123\\"]]],
    [],
  ],
  [
    "{/login}?",
    undefined,
    [
      {
        name: "",
        prefix: "/login",
        suffix: "",
        modifier: "?",
        pattern: "",
      },
    ],
    [
      ["/", ["/"]],
      ["/login", ["/login"]],
    ],
    [
      [null, ""],
      [{ "": "" }, "/login"],
    ],
  ],
  [
    "{/login}",
    undefined,
    [
      {
        name: "",
        prefix: "/login",
        suffix: "",
        modifier: "",
        pattern: "",
      },
    ],
    [
      ["/", null],
      ["/login", ["/login"]],
    ],
    [[{ "": "" }, "/login"]],
  ],
  [
    "{/(.*)}",
    undefined,
    [
      {
        name: 0,
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: ".*",
      },
    ],
    [
      ["/", ["/", ""]],
      ["/login", ["/login", "login"]],
    ],
    [[{ 0: "test" }, "/test"]],
  ],

  /**
   * Regexps.
   */
  [/.*/, undefined, [], [["/match/anything", ["/match/anything"]]], []],
  [
    /(.*)/,
    undefined,
    [
      {
        name: 0,
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "",
      },
    ],
    [["/match/anything", ["/match/anything", "/match/anything"]]],
    [],
  ],
  [
    /\/(\d+)/,
    undefined,
    [
      {
        name: 0,
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "",
      },
    ],
    [
      ["/abc", null],
      ["/123", ["/123", "123"]],
    ],
    [],
  ],

  /**
   * Mixed arrays.
   */
  [
    ["/test", /\/(\d+)/],
    undefined,
    [
      {
        name: 0,
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "",
      },
    ],
    [["/test", ["/test", undefined]]],
    [],
  ],
  [
    ["/:test(\\d+)", /(.*)/],
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "\\d+",
      },
      {
        name: 0,
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "",
      },
    ],
    [
      ["/123", ["/123", "123", undefined]],
      ["/abc", ["/abc", undefined, "/abc"]],
    ],
    [],
  ],

  /**
   * Correct names and indexes.
   */
  [
    ["/:test", "/route/:test"],
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/test", ["/test", "test", undefined]],
      ["/route/test", ["/route/test", undefined, "test"]],
    ],
    [],
  ],
  [
    [/^\/([^/]+)$/, /^\/route\/([^/]+)$/],
    undefined,
    [
      {
        name: 0,
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "",
      },
      {
        name: 0,
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "",
      },
    ],
    [
      ["/test", ["/test", "test", undefined]],
      ["/route/test", ["/route/test", undefined, "test"]],
    ],
    [],
  ],

  /**
   * Ignore non-matching groups in regexps.
   */
  [
    /(?:.*)/,
    undefined,
    [],
    [["/anything/you/want", ["/anything/you/want"]]],
    [],
  ],

  /**
   * Respect escaped characters.
   */
  [
    "/\\(testing\\)",
    undefined,
    ["/(testing)"],
    [
      ["/testing", null],
      ["/(testing)", ["/(testing)"]],
    ],
    [[null, "/(testing)"]],
  ],
  [
    "/.\\+\\*\\?\\{\\}=^!\\:$[]|",
    undefined,
    ["/.+*?{}=^!:$[]|"],
    [["/.+*?{}=^!:$[]|", ["/.+*?{}=^!:$[]|"]]],
    [[null, "/.+*?{}=^!:$[]|"]],
  ],
  [
    "/test\\/:uid(u\\d+)?:cid(c\\d+)?",
    undefined,
    [
      "/test/",
      {
        name: "uid",
        prefix: "",
        suffix: "",
        modifier: "?",
        pattern: "u\\d+",
      },
      {
        name: "cid",
        prefix: "",
        suffix: "",
        modifier: "?",
        pattern: "c\\d+",
      },
    ],
    [
      ["/test", null],
      ["/test/", ["/test/", undefined, undefined]],
      ["/test/u123", ["/test/u123", "u123", undefined]],
      ["/test/c123", ["/test/c123", undefined, "c123"]],
    ],
    [
      [{ uid: "u123" }, "/test/u123"],
      [{ cid: "c123" }, "/test/c123"],
      [{ cid: "u123" }, null],
    ],
  ],

  /**
   * Unnamed group prefix.
   */
  [
    "/{apple-}?icon-:res(\\d+).png",
    undefined,
    [
      "/",
      {
        name: "",
        prefix: "apple-",
        suffix: "",
        modifier: "?",
        pattern: "",
      },
      "icon-",
      {
        name: "res",
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "\\d+",
      },
      ".png",
    ],
    [
      ["/icon-240.png", ["/icon-240.png", "240"]],
      ["/apple-icon-240.png", ["/apple-icon-240.png", "240"]],
    ],
    [],
  ],

  /**
   * Random examples.
   */
  [
    "/:foo/:bar",
    undefined,
    [
      {
        name: "foo",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      {
        name: "bar",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [["/match/route", ["/match/route", "match", "route"]]],
    [[{ foo: "a", bar: "b" }, "/a/b"]],
  ],
  [
    "/:foo\\(test\\)/bar",
    undefined,
    [
      {
        name: "foo",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      "(test)/bar",
    ],
    [],
    [],
  ],
  [
    "/:remote([\\w-.]+)/:user([\\w-]+)",
    undefined,
    [
      {
        name: "remote",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[\\w-.]+",
      },
      {
        name: "user",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[\\w-]+",
      },
    ],
    [
      ["/endpoint/user", ["/endpoint/user", "endpoint", "user"]],
      ["/endpoint/user-name", ["/endpoint/user-name", "endpoint", "user-name"]],
      ["/foo.bar/user-name", ["/foo.bar/user-name", "foo.bar", "user-name"]],
    ],
    [
      [{ remote: "foo", user: "bar" }, "/foo/bar"],
      [{ remote: "foo.bar", user: "uno" }, "/foo.bar/uno"],
    ],
  ],
  [
    "/:foo\\?",
    undefined,
    [
      {
        name: "foo",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      "?",
    ],
    [["/route?", ["/route?", "route"]]],
    [[{ foo: "bar" }, "/bar?"]],
  ],
  [
    "/:foo+baz",
    undefined,
    [
      {
        name: "foo",
        prefix: "/",
        suffix: "",
        modifier: "+",
        pattern: "[^\\/#\\?]+?",
      },
      "baz",
    ],
    [
      ["/foobaz", ["/foobaz", "foo"]],
      ["/foo/barbaz", ["/foo/barbaz", "foo/bar"]],
      ["/baz", null],
    ],
    [
      [{ foo: "foo" }, "/foobaz"],
      [{ foo: "foo/bar" }, "/foo%2Fbarbaz", { encode: encodeURIComponent }],
      [{ foo: ["foo", "bar"] }, "/foo/barbaz"],
    ],
  ],
  [
    "\\/:pre?baz",
    undefined,
    [
      "/",
      {
        name: "pre",
        prefix: "",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
      "baz",
    ],
    [
      ["/foobaz", ["/foobaz", "foo"]],
      ["/baz", ["/baz", undefined]],
    ],
    [
      [{}, "/baz"],
      [{ pre: "foo" }, "/foobaz"],
    ],
  ],
  [
    "/:foo\\(:bar?\\)",
    undefined,
    [
      {
        name: "foo",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      "(",
      {
        name: "bar",
        prefix: "",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
      ")",
    ],
    [
      ["/hello(world)", ["/hello(world)", "hello", "world"]],
      ["/hello()", ["/hello()", "hello", undefined]],
    ],
    [
      [{ foo: "hello", bar: "world" }, "/hello(world)"],
      [{ foo: "hello" }, "/hello()"],
    ],
  ],
  [
    "/:postType(video|audio|text)(\\+.+)?",
    undefined,
    [
      {
        name: "postType",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "video|audio|text",
      },
      {
        name: 0,
        prefix: "",
        suffix: "",
        modifier: "?",
        pattern: "\\+.+",
      },
    ],
    [
      ["/video", ["/video", "video", undefined]],
      ["/video+test", ["/video+test", "video", "+test"]],
      ["/video+", null],
    ],
    [
      [{ postType: "video" }, "/video"],
      [{ postType: "random" }, null],
    ],
  ],
  [
    "/:foo?/:bar?-ext",
    undefined,
    [
      {
        name: "foo",
        prefix: "/",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
      {
        name: "bar",
        prefix: "/",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
      "-ext",
    ],
    [
      ["/-ext", null],
      ["-ext", ["-ext", undefined, undefined]],
      ["/foo-ext", ["/foo-ext", "foo", undefined]],
      ["/foo/bar-ext", ["/foo/bar-ext", "foo", "bar"]],
      ["/foo/-ext", null],
    ],
    [
      [{}, "-ext"],
      [{ foo: "foo" }, "/foo-ext"],
      [{ bar: "bar" }, "/bar-ext"],
      [{ foo: "foo", bar: "bar" }, "/foo/bar-ext"],
    ],
  ],
  [
    "/:required/:optional?-ext",
    undefined,
    [
      {
        name: "required",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      {
        name: "optional",
        prefix: "/",
        suffix: "",
        modifier: "?",
        pattern: "[^\\/#\\?]+?",
      },
      "-ext",
    ],
    [
      ["/foo-ext", ["/foo-ext", "foo", undefined]],
      ["/foo/bar-ext", ["/foo/bar-ext", "foo", "bar"]],
      ["/foo/-ext", null],
    ],
    [[{ required: "foo" }, "/foo-ext"]],
  ],

  /**
   * Unicode characters.
   */
  [
    "/:foo",
    undefined,
    [
      {
        name: "foo",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [["/café", ["/café", "café"]]],
    [
      [{ foo: "café" }, "/café"],
      [{ foo: "café" }, "/caf%C3%A9", { encode: encodeURIComponent }],
    ],
  ],
  ["/café", undefined, ["/café"], [["/café", ["/café"]]], [[null, "/café"]]],
  [
    "/café",
    { encode: encodeURI },
    ["/café"],
    [["/caf%C3%A9", ["/caf%C3%A9"]]],
    [[null, "/café"]],
  ],
  [
    "packages/",
    undefined,
    ["packages/"],
    [
      ["packages", null],
      ["packages/", ["packages/"]],
    ],
    [[null, "packages/"]],
  ],

  /**
   * Hostnames.
   */
  [
    ":domain.com",
    {
      delimiter: ".",
    },
    [
      {
        name: "domain",
        prefix: "",
        suffix: "",
        modifier: "",
        pattern: "[^\\.]+?",
      },
      ".com",
    ],
    [
      ["example.com", ["example.com", "example"]],
      ["github.com", ["github.com", "github"]],
    ],
    [
      [{ domain: "example" }, "example.com"],
      [{ domain: "github" }, "github.com"],
    ],
  ],
  [
    "mail.:domain.com",
    {
      delimiter: ".",
    },
    [
      "mail",
      {
        name: "domain",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: "[^\\.]+?",
      },
      ".com",
    ],
    [
      ["mail.example.com", ["mail.example.com", "example"]],
      ["mail.github.com", ["mail.github.com", "github"]],
    ],
    [
      [{ domain: "example" }, "mail.example.com"],
      [{ domain: "github" }, "mail.github.com"],
    ],
  ],
  [
    "example.:ext",
    {},
    [
      "example",
      {
        name: "ext",
        prefix: ".",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["example.com", ["example.com", "com"]],
      ["example.org", ["example.org", "org"]],
    ],
    [
      [{ ext: "com" }, "example.com"],
      [{ ext: "org" }, "example.org"],
    ],
  ],
  [
    "this is",
    {
      delimiter: " ",
      end: false,
    },
    ["this is"],
    [
      ["this is a test", ["this is"]],
      ["this isn't", null],
    ],
    [[null, "this is"]],
  ],

  /**
   * Ends with.
   */
  [
    "/test",
    {
      endsWith: "?",
    },
    ["/test"],
    [
      ["/test", ["/test"]],
      ["/test?query=string", ["/test"]],
      ["/test/?query=string", ["/test/"]],
      ["/testx", null],
    ],
    [[null, "/test"]],
  ],
  [
    "/test",
    {
      endsWith: "?",
      strict: true,
    },
    ["/test"],
    [
      ["/test?query=string", ["/test"]],
      ["/test/?query=string", null],
    ],
    [[null, "/test"]],
  ],

  /**
   * Custom prefixes.
   */
  [
    "{$:foo}{$:bar}?",
    {},
    [
      {
        name: "foo",
        pattern: "[^\\/#\\?]+?",
        prefix: "$",
        suffix: "",
        modifier: "",
      },
      {
        name: "bar",
        pattern: "[^\\/#\\?]+?",
        prefix: "$",
        suffix: "",
        modifier: "?",
      },
    ],
    [
      ["$x", ["$x", "x", undefined]],
      ["$x$y", ["$x$y", "x", "y"]],
    ],
    [
      [{ foo: "foo" }, "$foo"],
      [{ foo: "foo", bar: "bar" }, "$foo$bar"],
    ],
  ],
  [
    "name/:attr1?{-:attr2}?{-:attr3}?",
    {},
    [
      "name",
      {
        name: "attr1",
        pattern: "[^\\/#\\?]+?",
        prefix: "/",
        suffix: "",
        modifier: "?",
      },
      {
        name: "attr2",
        pattern: "[^\\/#\\?]+?",
        prefix: "-",
        suffix: "",
        modifier: "?",
      },
      {
        name: "attr3",
        pattern: "[^\\/#\\?]+?",
        prefix: "-",
        suffix: "",
        modifier: "?",
      },
    ],
    [
      ["name/test", ["name/test", "test", undefined, undefined]],
      ["name/1", ["name/1", "1", undefined, undefined]],
      ["name/1-2", ["name/1-2", "1", "2", undefined]],
      ["name/1-2-3", ["name/1-2-3", "1", "2", "3"]],
      ["name/foo-bar/route", null],
      ["name/test/route", null],
    ],
    [
      [{}, "name"],
      [{ attr1: "test" }, "name/test"],
      [{ attr2: "attr" }, "name-attr"],
    ],
  ],

  /**
   * Case-sensitive compile tokensToFunction params.
   */
  [
    "/:test(abc)",
    {
      sensitive: true,
    },
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "abc",
      },
    ],
    [
      ["/abc", ["/abc", "abc"]],
      ["/ABC", null],
    ],
    [
      [{ test: "abc" }, "/abc"],
      [{ test: "ABC" }, null],
    ],
  ],
  [
    "/:test(abc)",
    {},
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "abc",
      },
    ],
    [
      ["/abc", ["/abc", "abc"]],
      ["/ABC", ["/ABC", "ABC"]],
    ],
    [
      [{ test: "abc" }, "/abc"],
      [{ test: "ABC" }, "/ABC"],
    ],
  ],

  /**
   * Nested parentheses.
   */
  [
    "/:test(\\d+(?:\\.\\d+)?)",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "\\d+(?:\\.\\d+)?",
      },
    ],
    [
      ["/123", ["/123", "123"]],
      ["/abc", null],
      ["/123/abc", null],
      ["/123.123", ["/123.123", "123.123"]],
      ["/123.abc", null],
    ],
    [
      [{ test: 123 }, "/123"],
      [{ test: 123.123 }, "/123.123"],
      [{ test: "abc" }, null],
      [{ test: "123" }, "/123"],
      [{ test: "123.123" }, "/123.123"],
      [{ test: "123.abc" }, null],
    ],
  ],
  [
    "/:test((?!login)[^/]+)",
    undefined,
    [
      {
        name: "test",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "(?!login)[^/]+",
      },
    ],
    [
      ["/route", ["/route", "route"]],
      ["/login", null],
    ],
    [
      [{ test: "route" }, "/route"],
      [{ test: "login" }, null],
    ],
  ],

  /**
   * https://github.com/pillarjs/path-to-regexp/issues/206
   */
  [
    "/user(s)?/:user",
    undefined,
    [
      "/user",
      {
        name: 0,
        prefix: "",
        suffix: "",
        modifier: "?",
        pattern: "s",
      },
      {
        name: "user",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/user/123", ["/user/123", undefined, "123"]],
      ["/users/123", ["/users/123", "s", "123"]],
    ],
    [[{ user: "123" }, "/user/123"]],
  ],

  /**
   * https://github.com/pillarjs/path-to-regexp/issues/209
   */
  [
    "/whatever/:foo\\?query=str",
    undefined,
    [
      "/whatever",
      {
        name: "foo",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
      "?query=str",
    ],
    [["/whatever/123?query=str", ["/whatever/123?query=str", "123"]]],
    [[{ foo: "123" }, "/whatever/123?query=str"]],
  ],
  [
    "/whatever/:foo",
    {
      end: false,
    },
    [
      "/whatever",
      {
        name: "foo",
        prefix: "/",
        suffix: "",
        modifier: "",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [
      ["/whatever/123", ["/whatever/123", "123"]],
      ["/whatever/123/path", ["/whatever/123", "123"]],
      ["/whatever/123#fragment", ["/whatever/123", "123"]],
      ["/whatever/123?query=str", ["/whatever/123", "123"]],
    ],
    [
      [{ foo: "123" }, "/whatever/123"],
      [{ foo: "#" }, null],
    ],
  ],
  /**
   * https://github.com/pillarjs/path-to-regexp/issues/260
   */
  [
    ":name*",
    undefined,
    [
      {
        name: "name",
        prefix: "",
        suffix: "",
        modifier: "*",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [["foobar", ["foobar", "foobar"]]],
    [[{ name: "foobar" }, "foobar"]],
  ],
  [
    ":name+",
    undefined,
    [
      {
        name: "name",
        prefix: "",
        suffix: "",
        modifier: "+",
        pattern: "[^\\/#\\?]+?",
      },
    ],
    [["foobar", ["foobar", "foobar"]]],
    [[{ name: "foobar" }, "foobar"]],
  ],
];

export default function OriginLibraryTest() {
  describe('PathToRegexpTest', function () {
    const TEST_PATH = "/user/:id";
    const TEST_PARAM = {
      name: "id",
      prefix: "/",
      suffix: "",
      modifier: "",
      pattern: "[^\\/#\\?]+?",
    };
    const tokens = parse(TEST_PATH);
    /**
     * Execute a regular expression and return a flat array for comparison.
     *
     * @param  {RegExp} re
     * @param  {String} str
     * @return {Array}
     */
    function exec(re: RegExp, str: string) {
      const match = re.exec(str);

      return match && Array.prototype.slice.call(match);
    }

    beforeAll(function () {
      TESTS.push(
        [
          /\/(?<groupname>.+)/,
          undefined,
          [
            {
              name: "groupname",
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
          ],
          [
            ["/", null],
            ["/foo", ["/foo", "foo"]],
          ],
          [],
        ],
        [
          /\/(?<test>.*).(?<format>html|json)/,
          undefined,
          [
            {
              name: "test",
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
            {
              name: "format",
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
          ],
          [
            ["/route", null],
            ["/route.txt", null],
            ["/route.html", ["/route.html", "route", "html"]],
            ["/route.json", ["/route.json", "route", "json"]],
          ],
          [],
        ],
        [
          /\/(.+)\/(?<groupname>.+)\/(.+)/,
          undefined,
          [
            {
              name: 0,
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
            {
              name: "groupname",
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
            {
              name: 1,
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
          ],
          [
            ["/test", null],
            ["/test/testData", null],
            [
              "/test/testData/extraStuff",
              ["/test/testData/extraStuff", "test", "testData", "extraStuff"],
            ],
          ],
          [],
        ]
      );
    })
    beforeEach(function () {
    })
    afterEach(function () {
    })
    afterAll(function () {
    })

    it('arguments', 0, function () {
      let startTime1 = new Date().getTime();
      let regexp1 = pathToRegexp("/test");
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime1 : " + averageTime1 + "us")

      let startTime2 = new Date().getTime();
      let regexp2 = pathToRegexp("/test", []);
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime2 : " + averageTime2 + "us")

      let startTime3 = new Date().getTime();
      let regexp3 = pathToRegexp("/test", undefined, {});
      let endTime3 = new Date().getTime();
      let averageTime3 = ((endTime3 - startTime3) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime3 : " + averageTime3 + "us")

      let startTime4 = new Date().getTime();
      let regexp4 = pathToRegexp(/^\/test/);
      let endTime4 = new Date().getTime();
      let averageTime4 = ((endTime4 - startTime4) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime4 : " + averageTime4 + "us")

      let startTime5 = new Date().getTime();
      let regexp5 = pathToRegexp(/^\/test/, []);
      let endTime5 = new Date().getTime();
      let averageTime5 = ((endTime5 - startTime5) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime5 : " + averageTime5 + "us")

      let startTime6 = new Date().getTime();
      let regexp6 = pathToRegexp(/^\/test/, undefined, {});
      let endTime6 = new Date().getTime();
      let averageTime6 = ((endTime6 - startTime6) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime6 : " + averageTime6 + "us")

      let startTime7 = new Date().getTime();
      let regexp7 = pathToRegexp(["/a", "/b"]);
      let endTime7 = new Date().getTime();
      let averageTime7 = ((endTime7 - startTime7) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime7 : " + averageTime7 + "us")

      let startTime8 = new Date().getTime();
      let regexp8 = pathToRegexp(["/a", "/b"], []);
      let endTime8 = new Date().getTime();
      let averageTime8 = ((endTime8 - startTime8) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime8 : " + averageTime8 + "us")

      let startTime9 = new Date().getTime();
      let regexp9 = pathToRegexp(["/a", "/b"], undefined, {});
      let endTime9 = new Date().getTime();
      let averageTime9 = ((endTime9 - startTime9) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime9 : " + averageTime9 + "us")

      expect((regexp1 != undefined && regexp1 != null)).assertTrue()
      expect((regexp2 != undefined && regexp2 != null)).assertTrue()
      expect((regexp3 != undefined && regexp3 != null)).assertTrue()
      expect((regexp4 != undefined && regexp4 != null)).assertTrue()
      expect((regexp5 != undefined && regexp5 != null)).assertTrue()
      expect((regexp6 != undefined && regexp6 != null)).assertTrue()
      expect((regexp7 != undefined && regexp7 != null)).assertTrue()
      expect((regexp8 != undefined && regexp8 != null)).assertTrue()
      expect((regexp9 != undefined && regexp9 != null)).assertTrue()
    })

    function diff(obj1, obj2) {
      var o1 = obj1 instanceof Object;
      var o2 = obj2 instanceof Object;
      // 判断是不是对象
      if (!o1 || !o2) {
        return obj1 === obj2;
      }
      //Object.keys() 返回一个由对象的自身可枚举属性(key值)组成的数组,
      //例如：数组返回下表：let arr = ["a", "b", "c"];console.log(Object.keys(arr))->0,1,2;
      if (Object.keys(obj1).length !== Object.keys(obj2).length) {
        return false;
      }
      for (var o in obj1) {
        var t1 = obj1[o] instanceof Object;
        var t2 = obj2[o] instanceof Object;
        if (t1 && t2) {
          if (!diff(obj1[o], obj2[o])) {
            return false
          }
        } else if (obj1[o] !== obj2[o]) {
          return false;
        }
      }
      return true;
    }

    it('ArrayKeysSecondArgument', 0, function () {
      let startTime = new Date().getTime();
      const keys: Key[] = [];
      const re = pathToRegexp(TEST_PATH, keys, {
        end: false
      });
      let excResult = exec(re, "/user/123/show")
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp  :  ArrayKeysSecondArgument : " + averageTime + "us")

      let result1 = diff(keys, [TEST_PARAM])
      let result2 = diff(excResult, ["/user/123", "123"])
      expect(result1).assertTrue();
      expect(result2).assertTrue();
    })

    it('ThrowNonCapturingPattern', 0, function () {
      let startTime = new Date().getTime();
      expect(function () {
        pathToRegexp("/:foo(?:\\d+(\\.\\d+)?)");
      }).assertThrowError(new TypeError('Pattern cannot start with "?" at 6').message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowNonCapturingPattern : " + averageTime + "us")
    })

    it('ThrowNestedCapturingGroup', 0, function () {
      let startTime = new Date().getTime();
      expect(function () {
        pathToRegexp("/:foo(\\d+(\\.\\d+)?)");
      }).assertThrowError(new TypeError("Capturing groups are not allowed at 9").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowNestedCapturingGroup : " + averageTime + "us")
    })

    it('ThrowUnbalancedPattern', 0, function () {
      let startTime = new Date().getTime();
      expect(function () {
        pathToRegexp("/:foo(abc");
      }).assertThrowError(new TypeError("Unbalanced pattern at 5").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowUnbalancedPattern : " + averageTime + "us")
    })

    it('ThrowMissingPattern', 0, function () {
      let startTime = new Date().getTime();
      expect(function () {
        pathToRegexp("/:foo()");
      }).assertThrowError(new TypeError("Missing pattern at 5").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowMissingPattern : " + averageTime + "us")
    })

    it('ThrowMissingName', 0, function () {
      let startTime = new Date().getTime();
      expect(function () {
        pathToRegexp("/:(test)");
      }).assertThrowError(new TypeError("Missing parameter name at 1").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowMissingName : " + averageTime + "us")
    })

    it('ThrowNestedGroups', 0, function () {
      let startTime = new Date().getTime();
      expect(function () {
        pathToRegexp("/{a{b:foo}}");
      }).assertThrowError(new TypeError("Unexpected OPEN at 3, expected CLOSE").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowNestedGroups : " + averageTime + "us")
    })

    it('ThrowMisplacedModifier', 0, function () {
      let startTime = new Date().getTime();
      expect(function () {
        pathToRegexp("/foo?");
      }).assertThrowError(new TypeError("Unexpected MODIFIER at 4, expected END").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowMisplacedModifier : " + averageTime + "us")
    })

    it('CompileTokensToRegexp', 0, function () {
      let startTime = new Date().getTime();
      const re = tokensToRegexp(tokens);
      let execResult = exec(re, "/user/123")
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  CompileTokensToRegexp : " + averageTime + "us")
      let result1 = diff(execResult, ["/user/123", "123"])
      expect(result1).assertTrue();

    })

    it('CompileTokensToPathFunction', 0, function () {
      let startTime = new Date().getTime();
      const fn = tokensToFunction(tokens);
      expect(fn({
        id: 123
      })).assertEqual("/user/123");
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  CompileTokensToPathFunction : " + averageTime + "us")
    })

    describe("rules", function () {
      TESTS.forEach(function (test) {
        const [path, opts, tokens, matchCases, compileCases] = test;
        const keys: Key[] = [];
        const re = pathToRegexp(path, keys, opts);
        if (typeof path === 'string') {
          it("ShouldParse", 0, function () {
            let startTime = new Date().getTime();
            let result = parse(path, opts);
            let endTime = new Date().getTime();
            let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
            console.log("pathToRegexp :  ShouldParse" + path + " : " + averageTime + "us")
            expect(result).assertEqual(tokens);
          });
          let index = 0;
          compileCases.forEach(function (io) {
            const [params, result, options] = io;
            const toPath = compile(path, {
              ...opts,
              ...options,
            });

            if (result !== null) {
              let name = "ShouldCompileUsing" + index
              it(name, 0, function () {
                let startTime = new Date().getTime();
                let result = toPath(params)
                let endTime = new Date().getTime();
                let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
                console.log("pathToRegexp :  " + name + " : " + averageTime + "us")
                expect(result).assertEqual(result);
              });
            } else {
              let name = "ShouldNotCompileUsing" + index
              it(name, 0, function () {
                let startTime = new Date().getTime();
                expect(function () {
                  toPath(params);
                }).assertThrowError('TypeError'); // TODO
                let endTime = new Date().getTime();
                let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
                console.log("pathToRegexp :  " + name + " : " + averageTime + "us")
              }
              );
            }
          });


        } else {
          it("ShouldParseKeys", 0, function () {
            let startTime = new Date().getTime();
            let result = tokens.filter(function (token) {
              return typeof token !== "string";
            })
            let endTime = new Date().getTime();
            let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
            console.log("pathToRegexp :  ShouldParseKeys : " + averageTime + "us")
            expect(keys).assertEqual(result);
          });
        }
        let matchIndex = 0;
        matchCases.forEach(function (io) {
          const [pathname, matches, params, options] = io;
          const message = `Should${matches ? "" : "Not "}Match${matchIndex}`;

          it(message, 0, function () {
            let startTime = new Date().getTime();
            let result = exec(re, pathname)
            let endTime = new Date().getTime();
            let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
            console.log("pathToRegexp :  " + message + " : " + averageTime + "us")
            expect(result).assertEqual(matches);
          });

          if (typeof path === "string" && params !== undefined) {
            const matchs = match(path, options);
            it(message + " params", 0, function () {
              let startTime = new Date().getTime();
              let result = matchs(pathname)
              let endTime = new Date().getTime();
              let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
              console.log("pathToRegexp :  " + message + " params" + " : " + averageTime + "us")
              expect(result).assertEqual(params);
            });
          }
        });

      });
    })
    describe("CompileErrors", function () {
      it('ThrowRequiredParamUndefined', 0, function () {
        let startTime = new Date().getTime();
        const toPath = compile("/a/:b/c");
        expect(function () {
          toPath();
        }).assertThrowError(new TypeError('Expected "b" to be a string').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowRequiredParamUndefined : " + averageTime + "us")
      })

      it('ThrowNotMatchPpattern', 0, function () {
        let startTime = new Date().getTime();
        const toPath = compile("/:foo(\\d+)");
        expect(function () {
          toPath({
            foo: "abc"
          });
        }).assertThrowError(new TypeError('Expected "foo" to match "\\d+", but got "abc"').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowNotMatchPpattern : " + averageTime + "us")
      })
      it('ThrowExpectingRepeatedValue', 0, function () {
        let startTime = new Date().getTime();
        const toPath = compile("/:foo+");
        expect(function () {
          toPath({
            foo: []
          });
        }).assertThrowError(new TypeError('Expected "foo" to not be empty').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowExpectingRepeatedValue : " + averageTime + "us")
      })
      it('ThrowNotExpectingRepeatedValue', 0, function () {
        let startTime = new Date().getTime();
        const toPath = compile("/:foo");
        expect(function () {
          toPath({
            foo: []
          });
        }).assertThrowError(new TypeError('Expected "foo" to not repeat, but got an array').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowNotExpectingRepeatedValue : " + averageTime + "us")
      })
      it('ThrowRepeatedValueNotMatch', 0, function () {
        let startTime = new Date().getTime();
        const toPath = compile("/:foo(\\d+)+");
        expect(function () {
          toPath({
            foo: [1, 2, 3, "a"]
          });
        }).assertThrowError(new TypeError('Expected all "foo" to match "\\d+", but got "a"').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowNotExpectingRepeatedValue : " + averageTime + "us")
      })
    })

  })
}