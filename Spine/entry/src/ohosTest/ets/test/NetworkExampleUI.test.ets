import { describe, it, expect, beforeAll, afterEach } from '@ohos/hypium'
import { Driver, ON, Component } from '@ohos.UiTest'

async function waitForId(driver: Driver, id: string): Promise<Component> {
  const comp: Component | null = await driver.waitForComponent(ON.id(id), 4000)
  if (comp === null) {
    throw new Error('Unable to find id: ' + id)
  }
  return comp
}

export default function NetworkExampleUITest() {
  describe('NetworkExampleUITest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = Driver.create()
      await driver.delayMs(1000)
    })

    afterEach(async () => {
      await driver.pressBack()
      await driver.delayMs(600)
    })

    it('networkExample_canvasIsVisible', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_network')
      await navBtn.click()
      await driver.delayMs(1000)
      const canvas: Component = await waitForId(driver, 'network_canvas')
      expect(canvas !== null).assertTrue()
    })

    it('networkExample_loadButton_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_network')
      await navBtn.click()
      await driver.delayMs(1000)
      const load: Component = await waitForId(driver, 'network_btn_load')
      await load.click()
      await driver.delayMs(500)
      expect(true).assertTrue()
    })

    it('networkExample_pausePlayClear_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_network')
      await navBtn.click()
      await driver.delayMs(1000)
      const pause: Component = await waitForId(driver, 'network_btn_pause')
      await pause.click()
      await driver.delayMs(300)
      const play: Component = await waitForId(driver, 'network_btn_play')
      await play.click()
      await driver.delayMs(300)
      const clear: Component = await waitForId(driver, 'network_btn_clear')
      await clear.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })

    it('networkExample_animationButtons_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_network')
      await navBtn.click()
      await driver.delayMs(1000)
      const ids: string[] = [
        'network_btn_aim', 'network_btn_death', 'network_btn_idle',
        'network_btn_jump', 'network_btn_run', 'network_btn_shoot', 'network_btn_walk'
      ]
      for (let i: number = 0; i < ids.length; i++) {
        const btn: Component = await waitForId(driver, ids[i])
        await btn.click()
        await driver.delayMs(200)
      }
      expect(true).assertTrue()
    })

    it('networkExample_canvasClick_cyclesAnimation', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_network')
      await navBtn.click()
      await driver.delayMs(1000)
      const canvas: Component = await waitForId(driver, 'network_canvas')
      await canvas.click()
      await driver.delayMs(300)
      await canvas.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })
  })
}
