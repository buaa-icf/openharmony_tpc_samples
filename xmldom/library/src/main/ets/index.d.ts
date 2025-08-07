declare module '@ohos/xmldom' {
	var DOMParser: DOMParserStatic
	var XMLSerializer: XMLSerializerStatic
	var DOMImplementation: DOMImplementationStatic
	var MIME_TYPE: MIME_TYPE

	interface DOMImplementationStatic {
		new (): ESObject
	}

	interface DOMParserStatic {
		new (): DOMParser
		new (options: DOMParserOptions): DOMParser
	}

	interface MIME_TYPE {
		HTML: string,
		XML_APPLICATION: string,
		XML_TEXT: string,
		XML_XHTML_APPLICATION: string,
		XML_SVG_IMAGE: string,
	}

	interface XMLSerializerStatic {
		new (): XMLSerializer
	}

	interface DOMParser {
		parseFromString(source: string, mimeType?: string): ESObject
	}

	interface XMLSerializer {
		serializeToString(node: ESObject): string
	}

	interface DOMParserOptions {
		errorHandler?: ErrorHandlerFunction | ErrorHandlerObject
		locator?: boolean
		normalizeLineEndings?: (source: string) => string
		xmlns?: Record<string, string | null | undefined>
	}

	interface ErrorHandlerFunction {
		(level: 'warn' | 'error' | 'fatalError', msg: string): void
	}

	interface ErrorHandlerObject {
		warning?: (msg: string) => void
		error?: (msg: string) => void
		fatalError?: (msg: string) => void
	}
}
