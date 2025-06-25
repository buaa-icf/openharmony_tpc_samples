import { emitter } from '@kit.BasicServicesKit';

export class CustomXComponentController extends XComponentController {
  constructor() {
    super()
  }

  onSurfaceCreated(surfaceId: string): void {
    emitter.emit('surfaceId', {
      data: {
        "id": surfaceId,
      }
    })
  }

  onSurfaceChanged(surfaceId: string, rect: SurfaceRect): void {
  }

  onSurfaceDestroyed(surfaceId: string): void {
  }
}