/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import StringUtil from '../util/StringUtil'

class DOMUtil {
    public static getAttribute(element: Element, namespace: string, attribute: string): string {
        let result = element.getAttributeNS(namespace, attribute);
        if (StringUtil.isEmpty(result)) {
            result = element.getAttribute(attribute);
        }
        return result;
    }

    /**
       * Gets all descendant elements of the given parentElement with the given namespace and tagname and returns their text child as a list of String.
       *
       * @param parentElement
       * @param namespace
       * @param tagname
       * @return
       */
    public static getElementsTextChild(parentElement: Element, namespace: string, tagname: string): Array<string> {
        let elements = parentElement.getElementsByTagNameNS(namespace, tagname);
        let result = new Array<string>();
        for (let i = 0; i < elements.length; i++) {
            result.push(DOMUtil.getTextChildrenContent(elements.item(i)));
        }
        return result;
    }

    /**
      * Finds in the current document the first element with the given namespace and elementName and with the given findAttributeName and findAttributeValue.
      * It then returns the value of the given resultAttributeName.
      *
      * @param document
      * @param namespace
      * @param elementName
      * @param findAttributeName
      * @param findAttributeValue
      * @param resultAttributeName
      * @return
      */
    public static getFindAttributeValue(document: Document, namespace: string, elementName: string, findAttributeName: string, findAttributeValue: string, resultAttributeName: string): string {
        let metaTags = document.getElementsByTagNameNS(namespace, elementName);
        for (let i = 0; i < metaTags.length; i++) {
            let metaElement = metaTags.item(i);
            if (StringUtil.equalsIgnoreCase(findAttributeValue, metaElement.getAttribute(findAttributeName))
            && StringUtil.isNotBlank(metaElement.getAttribute(resultAttributeName))) {
                return metaElement.getAttribute(resultAttributeName);
            }
        }
        return null;
    }

    /**
       * Gets the first element that is a child of the parentElement and has the given namespace and tagName
       *
       * @param parentElement
       * @param namespace
       * @param tagName
       * @return
       */
    public static getFirstElementByTagNameNS(parentElement: Element, namespace: string, tagName: string): Element {
        console.info("----DOMUtil.ets----init------getFirstElementByTagNameNS-----parma1----parentElement:" + parentElement)
        console.error("----DOMUtil.ets----init------getFirstElementByTagNameNS-----parma2--namespace:" + namespace)
        console.info("----DOMUtil.ets----init------getFirstElementByTagNameNS-----parma3--tagName:-" + tagName)
        let nodes = parentElement.getElementsByTagNameNS(namespace, tagName);
        console.info("------nodes---nodes.length--" + nodes.length)
        if (nodes.length == 0) {
            return null;
        }
        return nodes.item(0);
    }
    /**
       * The contents of all Text nodes that are children of the given parentElement.
       * The result is trim()-ed.
       *
       * The reason for this more complicated procedure instead of just returning the data of the firstChild is that
       * when the text is Chinese characters then on ohos each Characater is represented in the DOM as
       * an individual Text node.
       *
       * @param parentElement
       * @return
       */
    public static getTextChildrenContent(parentElement: Element): string {
        if (parentElement == null) {
            return null;
        }
        let result: string[] = [];
        let childNodes = parentElement.childNodes;
        for (let i = 0; i < childNodes.length; i++) {
            let node = childNodes.item(i);
            if ((node == null) ||
            (node.nodeType != 3)) { // Node.TEXT_NODE == 3
                continue;
            }
            result.push(node.textContent);
        }
        return result.join("").trim();
    }
}

export default DOMUtil