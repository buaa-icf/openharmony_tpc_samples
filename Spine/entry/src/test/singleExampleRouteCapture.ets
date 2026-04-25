type RouteBuilder = () => Object

interface CapturedRouteRegistration {
  builder: RouteBuilder
  pagePath: string
  pageFullPath: string
}

interface RouteOptions {
  pagePath?: string
  pageFullPath?: string
}

type RegisterNamedRoute = (builder: RouteBuilder, name: string, options: RouteOptions) => void

interface GlobalObjectLike {
  registerNamedRoute?: RegisterNamedRoute
  __singleExampleCapturedRoutes__?: Array<CapturedRouteRegistration>
  __singleExampleOriginalRegisterNamedRoute__?: RegisterNamedRoute
}

const SINGLE_EXAMPLE_PAGE_PATH = 'pages/SingleExample'
const SINGLE_EXAMPLE_PAGE_FULL_PATH = 'entry/src/main/ets/pages/SingleExample'

const globalObject = new Function('return this')() as GlobalObjectLike

function getCapturedRoutes(): Array<CapturedRouteRegistration> {
  const capturedRoutes = globalObject.__singleExampleCapturedRoutes__
  if (capturedRoutes) {
    return capturedRoutes
  }

  const newCapturedRoutes: Array<CapturedRouteRegistration> = []
  globalObject.__singleExampleCapturedRoutes__ = newCapturedRoutes
  return newCapturedRoutes
}

function installRegisterNamedRouteCapture(): void {
  const originalRegisterNamedRoute = globalObject.registerNamedRoute
  const installedRegisterNamedRoute = globalObject.__singleExampleOriginalRegisterNamedRoute__
  if (!originalRegisterNamedRoute || installedRegisterNamedRoute) {
    return
  }

  globalObject.__singleExampleOriginalRegisterNamedRoute__ = originalRegisterNamedRoute
  globalObject.registerNamedRoute = ((builder: RouteBuilder, name: string, options: RouteOptions) => {
    if (options.pagePath === SINGLE_EXAMPLE_PAGE_PATH ||
      options.pageFullPath === SINGLE_EXAMPLE_PAGE_FULL_PATH) {
      getCapturedRoutes().push({
        builder,
        pagePath: options.pagePath ?? '',
        pageFullPath: options.pageFullPath ?? ''
      })
    }

    originalRegisterNamedRoute(builder, name, options)
  }) as RegisterNamedRoute
}

installRegisterNamedRouteCapture()

export function createSingleExamplePage(): Object {
  const capturedRoutes = getCapturedRoutes()
  if (capturedRoutes.length === 0) {
    throw new Error('failed to capture SingleExample route builder')
  }

  return capturedRoutes[capturedRoutes.length - 1].builder()
}
