import { createBodyReader } from "@ohos/mammoth/src/main/ets/docx/body-reader";
import { defaultNumbering } from "@ohos/mammoth/src/main/ets/docx/numbering-xml";
import { Styles } from "@ohos/mammoth/src/main/ets/docx/styles-reader";

function createBodyReaderForTests(options) {
    options = Object.create(options || {});
    options.styles = options.styles || new Styles({}, {});
    options.numbering = options.numbering || defaultNumbering;
    return createBodyReader(options);
}

export { createBodyReaderForTests }
