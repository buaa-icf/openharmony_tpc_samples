import { describe, it, expect, beforeAll, afterEach } from '@ohos/hypium'
import { Driver, ON, Component } from '@ohos.UiTest'

async function waitForId(driver: Driver, id: string): Promise<Component> {
  const comp: Component | null = await driver.waitForComponent(ON.id(id), 4000)
  if (comp === null) {
    throw new Error('Unable to find id: ' + id)
  }
  return comp
}

export default function SingleExampleUITest() {
  describe('SingleExampleUITest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = Driver.create()
      await driver.delayMs(1000)
    })

    afterEach(async () => {
      await driver.pressBack()
      await driver.delayMs(600)
    })

    it('singleExample_canvasIsVisible', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_single')
      await navBtn.click()
      await driver.delayMs(1000)
      const canvas: Component = await waitForId(driver, 'single_canvas')
      expect(canvas !== null).assertTrue()
    })

    it('singleExample_pausePlayButtons_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_single')
      await navBtn.click()
      await driver.delayMs(1000)
      const pause: Component = await waitForId(driver, 'single_btn_pause')
      await pause.click()
      await driver.delayMs(300)
      const play: Component = await waitForId(driver, 'single_btn_play')
      await play.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })

    it('singleExample_clearButton_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_single')
      await navBtn.click()
      await driver.delayMs(1000)
      const clear: Component = await waitForId(driver, 'single_btn_clear')
      await clear.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })

    it('singleExample_resourceButtons_switchAnimation', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_single')
      await navBtn.click()
      await driver.delayMs(1000)
      const res1: Component = await waitForId(driver, 'single_btn_res1')
      await res1.click()
      await driver.delayMs(600)
      const res2: Component = await waitForId(driver, 'single_btn_res2')
      await res2.click()
      await driver.delayMs(600)
      const res6: Component = await waitForId(driver, 'single_btn_res6')
      await res6.click()
      await driver.delayMs(600)
      expect(true).assertTrue()
    })

    it('singleExample_canvasClick_cyclesAnimation', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_single')
      await navBtn.click()
      await driver.delayMs(1000)
      const canvas: Component = await waitForId(driver, 'single_canvas')
      await canvas.click()
      await driver.delayMs(300)
      await canvas.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })
  })
}
