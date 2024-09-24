# xslt-processor

## Introduction

xslt-processor can transform XML documents into multiple text formats (HTML, Text, and more) using XSLT style sheets that match XML documents.

It supports the parsing and calculation of XPath expressions.

## How to Install

```
 ohpm install xslt-processor
 ohpm install he
 ohpm install @types/he --save-dev // Install @types/he to prevent import syntax errors due to missing type declarations in the he package.
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

1. Parse XML into an operable node object.

   ```
   import { xmlParse } from 'xslt-processor'
   let originXMLStr = ""; // XML string to be transformed.
   const originXMLObj = xmlParse(originXMLStr);
   ```

2. Convert XSLT.

   ```
   import { xmlParse, xsltProcess } from 'xslt-processor'
   let originXMLStr = ""; // XML string to be converted.
   let originXSLStr = ""; // XSL template that matches the XML string to be converted.
   
   const originXMLObj = xmlParse(originXMLStr);
   const originXSLObj = xmlParse(originXSLStr);
   const text = xsltProcess(originXMLObj, originXSLObj);
   ```

3. Perform an XSLT transformation with input parameters.

   Corresponding dynamic parameter marked with **$** in the XSL template: `<span> <xsl:value-of select="$test" /> </span>`

   ```
   import { xmlParse, xsltProcess } from 'xslt-processor'
   
   const outXmlString = xsltProcess(
   xmlParse(xmlString), 
   xmlParse(this.variablesXSLTString),
   {
      test: "hugo"
   });
   ```

4. Calculate an XPath expression.

   ```
   import { ExprContext, xmlParse, xpathParse, xsltProcess } from 'xslt-processor'
   
   const xpathExpr = '/page'; // XPath expression
   const expr1 = xpathParse(xpathExpr); // Parse the XPath expression.
   const ctx = new ExprContext(xmlParse(this.xpathXML)); // Construct the expression parsing context.
   const result = expr1.evaluate(ctx); // Calculate the XPath expression to obtain the result.
   // If the result type is unknown, use nodeSetValue to obtain the corresponding result.
   const nodeSet = result.nodeSetValue();
   const nodeSetValue = nodeSet[0].nodeName + "=" + nodeSet[0].nodeValue;
   
   // If the result type is determined, obtain the value of the corresponding type.
   const value = result.numberValue();
   const value = result.stringValue();
   const value = result.booleanValue();
   ```

## Available APIs

| API                                                        | Description           |
| ------------------------------------------------------------ | ------------------- |
| xmlParse(xml:string):XDocument                               | Parses the XML into an operable object.|
| xsltProcess(xmlDoc:XDocument, stylesheet:XDocument,parameters:object):string | Uses XSLT to convert the XML.  |
| xpathParse(expr:string, xpathLog=()=>{})                     | Parses the XPath expression.    |
| new ExprContext( node: XDocument,  <br>opt_position:number,   // The default value is 0.<br>opt_nodelist:[XDocument], // Node list, which is the XPath calculation result set. The default value is the passed node array [node].<br>opt_parent: ExprContext,  // Parent context. The default value is null.<br>opt_caseInsensitive: boolean,  // Set whether the node name is case sensitive. The default value is false.<br>opt_ignoreAttributesWithoutValue:boolean,  // Set whether to ignore attributes without values. The default value is false.<br>opt_returnOnFirstMatch:boolean, // Set whether to return the first matched value. The default value is false.<br>opt_ignoreNonElementNodesForNTA:boolean // Set whether to ignore non-element nodes. The default value is false):ExprContext.| Constructs the XPath calculation context.|
| evaluate(ctx:ExprContext):NodeSetValue&#124;StringValue&#124;BooleanValue&#124;NumberValue | Calculates the XPath expression.    |

## Constraints
This project has been verified in the following version:

DevEco Studio: 4.0 Canary1 (4.0.3.512), SDK: API 10 (4.0.10.10)

For details, see [Unit Test Cases](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/xslt-processor/TEST.md).

## Directory Structure

````
/xsltprocessor-demo        # Project root
├── entry     # Sample code
│    └─ src/main/ets
│       └─ pages/index.ets // xslt-processor sample code
│       └─ pages/TestTimePage.ets // Page for testing the API duration             
├── README.md  # Readme
├── README_zh.md  # Readme                   
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xslt-processor/LICENSE).
