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
  __routeCaptureRoutes__?: Array<CapturedRouteRegistration>
  __routeCaptureOriginal__?: RegisterNamedRoute
}

const _globalObj = new Function('return this')() as GlobalObjectLike

function getCapturedRoutes(): Array<CapturedRouteRegistration> {
  const existing = _globalObj.__routeCaptureRoutes__
  if (existing) {
    return existing
  }
  const fresh: Array<CapturedRouteRegistration> = []
  _globalObj.__routeCaptureRoutes__ = fresh
  return fresh
}

function installCapture(): void {
  const orig = _globalObj.registerNamedRoute
  if (!orig || _globalObj.__routeCaptureOriginal__) {
    return
  }
  _globalObj.__routeCaptureOriginal__ = orig
  _globalObj.registerNamedRoute = ((builder: RouteBuilder, name: string, options: RouteOptions) => {
    getCapturedRoutes().push({
      builder,
      pagePath: options.pagePath ?? '',
      pageFullPath: options.pageFullPath ?? ''
    })
    orig(builder, name, options)
  }) as RegisterNamedRoute
}

installCapture()

export function createPageInstance(pageKeyword: string): Object {
  const routes = getCapturedRoutes()
  for (let i = routes.length - 1; i >= 0; i--) {
    const r = routes[i]
    if (r.pagePath.includes(pageKeyword) || r.pageFullPath.includes(pageKeyword)) {
      return r.builder()
    }
  }
  throw new Error('No route captured for: ' + pageKeyword)
}
