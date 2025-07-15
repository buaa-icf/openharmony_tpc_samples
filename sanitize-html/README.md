# @ohos/sanitize-html

## Introduction

@ohos/sanitize-html provides HTML sanitization APIs, with support for cleaning up HTML fragments. It allows for HTML sanitization based on default settings of built-in tags, attributes, and more. Additionally, it supports custom rules for specific sanitization requirements.

## How to Install

```
ohpm install @ohos/sanitize-html
```

For details about the OpenHarmony ohpm environment configuration, see [Installing the OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

Import sanitizeHtml HTML to obtain different cleaning results based on various configuration rules.

```
import sanitizeHtml from '@ohos/sanitize-html';
```


```
Default configuration:
sanitizeHtml.defaults = {
  allowedTags: [
    // Content sectioning
    'address', 'article', 'aside', 'footer', 'header',
    'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'hgroup',
    'main', 'nav', 'section',
    // Text content
    'blockquote', 'dd', 'div', 'dl', 'dt', 'figcaption', 'figure',
    'hr', 'li', 'main', 'ol', 'p', 'pre', 'ul',
    // Inline text semantics
    'a', 'abbr', 'b', 'bdi', 'bdo', 'br', 'cite', 'code', 'data', 'dfn',
    'em', 'i', 'kbd', 'mark', 'q',
    'rb', 'rp', 'rt', 'rtc', 'ruby',
    's', 'samp', 'small', 'span', 'strong', 'sub', 'sup', 'time', 'u', 'var', 'wbr',
    // Table content
    'caption', 'col', 'colgroup', 'table', 'tbody', 'td', 'tfoot', 'th',
    'thead', 'tr'
  ],
  disallowedTagsMode: 'discard',
  allowedAttributes: {
    a: [ 'href', 'name', 'target' ],
    img: [ 'src', 'srcset', 'alt', 'title', 'width', 'height', 'loading' ]
  },
  selfClosing: [ 'img', 'br', 'hr', 'area', 'base', 'basefont', 'input', 'link', 'meta' ],
  // URL schemes we permit
  allowedSchemes: [ 'http', 'https', 'ftp', 'mailto', 'tel' ],
  allowedSchemesByTag: {},
  allowedSchemesAppliedToAttributes: [ 'href', 'src', 'cite' ],
  allowProtocolRelative: true,
  enforceHtmlBoundary: false
};
```



### 1. Configuring Allowed Labels

1. Override the default list of allowed tags:

   ```
   sanitizeHtml.defaults.allowedTags = ['img','iframe']
   sanitizeHtml(html)
   Or
   sanitizeHtml(html,{allowedTags:['img','iframe']})
   ```

2. Add to the default allowed tags:

   ```
   sanitizeHtml.defaults.allowedTags.push('img')
   sanitizeHtml(html)
   Or
   sanitizeHtml.defaults.allowedTags.concat(['img','iframe'])
   sanitizeHtml(html)
   ```

3. Allow all tags:

   ```
   sanitizeHtml(html,{allowedTags:false})
   Or
   sanitizeHtml(html,{allowedTags:undefined})
   ```

### 2. Configuring Allowed Attributes

1. Override the default list of allowed attributes:

   ```
   sanitizeHtml.defaults.allowedAttributes = {'a':['href', 'src']}
   sanitizeHtml(html)
   Or
   sanitizeHtml(html,{allowedAttributes:{'a':['href', 'src']}})
   
   // To add attributes for all tags, use the asterisk (*) as the key
   sanitizeHtml(html,{allowedAttributes:{'*':['id','class']}})
   ```

2. Add default allowed attributes:

   ```
   // Obtain the tag for which you want to add attributes. Note: The tag must be included in allowedTags.
   let attrs = sanitizeHtml.defaults.allowedAttributes['a']
   
   attrs.push('name')
   sanitizeHtml(html)
   Or
   attrs.concat(['name','id'])
   sanitizeHtml(html)
   ```

3. Allow all attributes.

   ```
   sanitizeHtml(html,{allowedAttributes:false})
   Or
   sanitizeHtml(html,{allowedAttributes:undefined})
   ```

### 3. Configuring Allowed Schemes

1. Override the default list of allowed schemes:

   ```
   sanitizeHtml.defaults.allowedSchemes = ['http', 'https', 'sms'];
   sanitizeHtml(html)
   Or
   sanitizeHtml(html,{allowedSchemes:['http', 'https', 'sms']})
   ```

2. Add default allowed schemes:

   ```
   sanitizeHtml.defaults.allowedSchemes.push('sms')
   sanitizeHtml(html)
   Or
   sanitizeHtml.defaults.allowedSchemes.concat(['sms','data'])
   sanitizeHtml(html)
   ```

### 4. Configuring Allowed Schemes for a Specified Tag

1. Override the allowed schemes for a specific tag, which must be one in **allowedTags**.

   ```
   sanitizeHtml(html,{allowedSchemesByTag:{a:['sms','data']}})
   ```

2. Set allowed schemes for a specific tag, which must be one in **allowedTags**.

   ```
   sanitizeHtml.defaults.allowedSchemesByTag['a'] = ['sms', 'data'];
   sanitizeHtml(html)
   ```

### 5. Configuring Attributes Allowed to Use Scheme Links

1. Override the default list of attributes allowed to use scheme links.<br>Note: The attributes must be the ones allowed for tags.

   ```
   sanitizeHtml.defaults.allowedSchemesAppliedToAttributes = ['href','src'];
   sanitizeHtml(html)
   Or
   sanitizeHtml(html,{allowedSchemesAppliedToAttributes:['href','src']})
   ```

2. Add the attributes allowed to use scheme links.<br>Note: The attributes must be the ones allowed for tags.

   ```
   sanitizeHtml.defaults.allowedSchemesAppliedToAttributes.push('src')
   sanitizeHtml(html)
   Or
   sanitizeHtml.defaults.allowedSchemesAppliedToAttributes.concat(['src','href'])
   sanitizeHtml(html)
   ```

### 6. Configuring Self-Closing Tags

1. Override the default list of self-closing tags.

   ```
   sanitizeHtml.defaults.selfClosing =['img','br']
   sanitizeHtml(html) 
   Or
   sanitizeHtml(html,{selfClosing:['img','br']})
   ```

2. Add self-closing tags.

   ```
   sanitizeHtml.defaults.selfClosing.push('sms')
   sanitizeHtml(html) 
   Or
   sanitizeHtml.defaults.selfClosing.concat(['sms','data'])
   sanitizeHtml(html) 
   ```

### 7. Configuring Handling Mode for Disallowed Tags

The following modes are available:

- **discard** (default): Discard disallowed tags.
- **escape**: Escape disallowed tags. (Child tags are not escaped if they are allowed; only the disallowed tags are escaped)
- **recursiveEscape**: Escape disallowed tags and all their child tags, regardless of whether the child tags are allowed.

```
sanitizeHtml(html,{disallowedTagsMode:'discard'})
Or
sanitizeHtml(html,{disallowedTagsMode:'escape'})
Or
sanitizeHtml(html,{disallowedTagsMode:'recursiveEscape'})
```

### 8. Configuring Whether to Allow Scheme Links to Use Relative Paths

The default value is **true**, indicating that schemes links can use relative paths.

```
sanitizeHtml(html,{allowProtocolRelative:true})
Or
sanitizeHtml(html,{allowProtocolRelative:false})
```

### 9. Configuring Whether to Enforce HTML Boundary

The value **true** means to enforce HTML boundaries and discard content outside the HTML tags, and **false** (default value) means the opposite.

```
sanitizeHtml(html,{enforceHtmlBoundary:false})
Or
sanitizeHtml(html,{enforceHtmlBoundary:true})
```

### 10. Configuring Allowed Styles for Tags

```
sanitizeHtml(html,{
	allowedStyles:{
		'*':color:[/yellow/],
		'text-align': [/left/, /right/, /center/, /justify/, /initial/],
        'font-size': [/36px/]
	}})
```

### 11. Configuring Allowed Classes for Tags

```
sanitizeHtml(html,{allowedClasses:{'a':['class1','class2']}})
```

### 12. Configuring Allowed Hostnames for iframe src Attribute

```
sanitizeHtml(html,{
	allowedTags:['iframe'],
	allowedAttributes:{
		iframe:['src','href']
		},
	allowedIframeHostnames:['www.youtube.com', 'player.vimeo.com']
})
```

### 13. Configuring Allowed Domains for iframe src Attribute

```
sanitizeHtml(html,{
	allowedTags:['iframe'],
	allowedAttributes:{
		iframe:['src','href']
		},
	allowedIframeDomains:['zoom.us']
})
```

### 14. Configuring Whether Relative URLs Are Allowed for iframe src Attribute

```
sanitizeHtml(html,{
	allowedTags:['iframe'],
	allowedAttributes:{
		iframe:['src','href']
		},
	allowIframeRelativeUrls:false
})
```

### 15. Configuring Allowed Hostnames for script src Attribute

```
sanitizeHtml(html,{
	allowedTags:['script'],
	allowedAttributes:{
		script:['src','href']
		},
	allowedScriptHostnames:['www.youtube.com', 'player.vimeo.com']
})
```

### 16. Configuring Allowed Domains for script src Attribute

```
sanitizeHtml(html,{
	allowedTags:['script'],
	allowedAttributes:{
		script:['src','href']
		},
	allowedScriptDomains:['www.youtube.com', 'player.vimeo.com']
})
```

### 17. Configuring Text Filters

```
sanitizeHtml(html,{
	textFilter: function (text, tagName) {
         return text.replace(/\s/g, '_');
    }})
```

### 18. Configuring Tag Filters

```
sanitizeHtml(html, {
            exclusiveFilter: function (frame) {
              return frame.tag === 'a' && !frame.text.trim();
            }
    })
```

### 19. Configuring Disallowed Tags Not to Preserve Text

```
sanitizeHtml(html,{nonTextTags:['tagName']})
```

### 20. Configuring Tag Transformations

1. Transforming Tags Without Attributes

   ```
   sanitizeHtml(html,{transformTags:{ol:'ul'}})
   ```

2. Transforming Tags With Attributes

   ```
   sanitizeHtml(html,{
   	transformTags:{
   		ol:sanitizeHtml.simpleTransform('ul',		
   			{
   				class:'foo',
   				name:'newAttrName'
   			}),
   			allowedAttributes:{
   				ul:['class','name']
   			}
   		}})
   ```



### 21. Configuring HTML Parsing Rules

```
sanitizeHtml(html,{parser:{recognizeCDATA: true}})
```



## Available APIs

```
function sanitize(dirty: string, options?: sanitize.IOptions): string;

interface IOptions {
	// Sets allowed tags. false or undefined means no validation.
    allowedTags?: string[] | false | undefined; 
    // Sets allowed attributes. false or undefined means no validation.
    allowedAttributes?: Record<string, AllowedAttribute[]> | false | undefined;
    // Sets allowed scheme names.
    allowedSchemes?: string[];
    // Sets allowed tags that can have URLs.
    allowedSchemesByTag?: { [tagName: string]: string[] };
    // Sets allowed attributes that can have URLs.
    allowedSchemesAppliedToAttributes?: string[];
    // Sets self-closing tags.
    selfClosing?: string[];
    // Sets the mode for handling disallowed tags: discard, escape (child tags are not escaped if they are allowed),
    // recursiveEscape (the disallowed tag and all its child tags are escaped, regardless of whether the children are allowed).
    disallowedTagsMode?: DisallowedTagsModes;
    // Sets whether to allow relative URLs.
    allowProtocolRelative?: boolean;
    // Sets whether to enforce HTML boundaries.
    enforceHtmlBoundary?: boolean;
    // Sets allowed styles for tags.
    allowedStyles?: { [tagName: string]: { [styleKey: string]: RegExp[] } };
    // Sets allowed classes for tags.
    allowedClasses?: { [tagName: string]: Array<string | RegExp> };
    // Sets allowed hostnames for the iframe src attribute.
    allowedIframeHostnames?: string[];
    // Sets allowed domains for the iframe src attribute.
    allowedIframeDomains?: string[];
    // Sets whether relative URLs are allowed for the iframe src attribute.
    allowIframeRelativeUrls?: boolean;
    // Sets allowed hostnames for the script src attribute.
    allowedScriptHostnames?: string[];
    // Sets allowed domains for the script src attribute.
    allowedScriptDomains?: string[];
    // Sets a text filter.
    textFilter?: ((text: string, tagName: string) => string);
    // Sets a tag filter.
    exclusiveFilter?: ((frame: IFrame) => boolean);
    // Sets disallowed tags not to preserve text.
    nonTextTags?: string[];
    // Sets tag transformation rules.
    transformTags?: { [tagName: string]: string | Transformer };
    // Sets HTML parsing rules.
    parser?: ParserOptions;
  }
  
  
  interface Attributes { [attr: string]: string; }

  interface Tag { tagName: string; attribs: Attributes; text?: string | undefined; }
  
  type Transformer = (tagName: string, attribs: Attributes) => Tag;

  type AllowedAttribute = string | { name: string; multiple?: boolean | undefined; values: string[] };

  type DisallowedTagsModes = 'discard' | 'escape' | 'recursiveEscape';
  
  function simpleTransform(tagName: string, attribs: Attributes, merge?: boolean): Transformer;
```
## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the sanitize-html library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/sanitize-html
```
## Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure

```
/SanitizeHtml       # Root directory of the project
├── entry                  # Sample code
├── library    # Library source code
│   └── src
│       ├── index.ets      # File exposed externally
│       └──main
│          ├── js          # sanitize-html 
               ├── index.js          # Source code     
```

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/sanitize-html/LICENSE).
