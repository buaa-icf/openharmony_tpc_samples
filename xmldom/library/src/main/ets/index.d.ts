declare module '@ohos/xmldom' {
	var DOMParser: DOMParserStatic
	var XMLSerializer: XMLSerializerStatic
	var DOMImplementation: DOMImplementationStatic

	interface DOMImplementationStatic {
		new (): ESObject
	}

	interface DOMParserStatic {
		new (): DOMParser
		new (options: DOMParserOptions): DOMParser
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
