import * as htmlPaths from "./styles/html-paths";
import * as Html from "./html";

export function element(name) {
    return function(html) {
        return Html.elementWithTag(htmlPaths.element(name), [html]);
    };
}
