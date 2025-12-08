import * as htmlWriter from "./html-writer";
import * as markdownWriter from "./markdown-writer";

export function writer(options) {
    options = options || {};
    if (options.outputFormat === "markdown") {
        return markdownWriter.writer();
    } else {
        return htmlWriter.writer(options);
    }
}
