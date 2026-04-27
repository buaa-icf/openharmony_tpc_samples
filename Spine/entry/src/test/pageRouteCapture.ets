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
  __spineCapturedRoutes__?: Map<string, Array<CapturedRouteRegistration>>
  __spineOriginalRegisterNamedRoute__?: RegisterNamedRoute
}

const globalObject = (globalThis as Object) as GlobalObjectLike

function getCapturedRoutes(): Map<string, Array<CapturedRouteRegistration>> {
  const existing = globalObject.__spineCapturedRoutes__
  if (existing) {
    return existing
  }
  const map = new Map<string, Array<CapturedRouteRegistration>>()
  globalObject.__spineCapturedRoutes__ = map
  return map
}

function pushRoute(map: Map<string, Array<CapturedRouteRegistration>>, key: string,
  registration: CapturedRouteRegistration): void {
  let bucket = map.get(key)
  if (!bucket) {
    bucket = []
    map.set(key, bucket)
  }
  bucket.push(registration)
}

function installRegisterNamedRouteCapture(): void {
  const originalRegisterNamedRoute = globalObject.registerNamedRoute
  const installedRegisterNamedRoute = globalObject.__spineOriginalRegisterNamedRoute__
  if (!originalRegisterNamedRoute || installedRegisterNamedRoute) {
    return
  }

  globalObject.__spineOriginalRegisterNamedRoute__ = originalRegisterNamedRoute
  globalObject.registerNamedRoute = ((builder: RouteBuilder, name: string, options: RouteOptions) => {
    const pagePath = options.pagePath ?? ''
    const pageFullPath = options.pageFullPath ?? ''
    const registration: CapturedRouteRegistration = { builder, pagePath, pageFullPath }
    const map = getCapturedRoutes()
    if (pagePath !== '') {
      pushRoute(map, pagePath, registration)
    }
    if (pageFullPath !== '' && pageFullPath !== pagePath) {
      pushRoute(map, pageFullPath, registration)
    }
    originalRegisterNamedRoute(builder, name, options)
  }) as RegisterNamedRoute
}

installRegisterNamedRouteCapture()

export function createCapturedPage(pagePath: string): Object {
  const map = getCapturedRoutes()
  const bucket = map.get(pagePath)
  if (!bucket || bucket.length === 0) {
    throw new Error(`failed to capture route builder for page path: ${pagePath}`)
  }
  return bucket[bucket.length - 1].builder()
}
