export { Parser } from "./lib/parser";
export * as rules from "./lib/rules";
export * as errors from "./lib/errors"
export * as results from "./lib/parsing-results"
export * as StringSource from "./lib/StringSource";
export * as Token from "./lib/Token";
export * as bottomUp from "./lib/bottom-up";
export { RegexTokeniser } from "./lib/regex-tokeniser";
export const rule = function(ruleBuilder) {
    var rule;
    return function(input) {
        if (!rule) {
            rule = ruleBuilder();
        }
        return rule(input);
    };
};
