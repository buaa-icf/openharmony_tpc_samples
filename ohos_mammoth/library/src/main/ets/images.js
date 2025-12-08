import _ from 'underscore';
import * as Html from "./html";

function imgElement(func) {
    return function(element, messages) {
        return Promise.all([func(element)]).then(function(result) {
            var attributes = {};
            if (element.altText) {
                attributes.alt = element.altText;
            }
            _.extend(attributes, result[0]);

            return [Html.freshElement("img", attributes)];
        });
    };
}

const dataUri = imgElement(function(element) {
    return element.readAsBase64String().then(function(imageBuffer) {
        return {
            src: "data:" + element.contentType + ";base64," + imageBuffer
        };
    });
});

export {
    imgElement,
    imgElement as inline, // Undocumented, but retained for backwards-compatibility with 0.3.x
    dataUri
}
