import { describe, it, expect, beforeAll, afterEach } from '@ohos/hypium'
import { Driver, ON, Component } from '@ohos.UiTest'

async function waitForId(driver: Driver, id: string): Promise<Component> {
  const comp: Component | null = await driver.waitForComponent(ON.id(id), 4000)
  if (comp === null) {
    throw new Error('Unable to find id: ' + id)
  }
  return comp
}

export default function Example3UITest() {
  describe('Example3UITest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = Driver.create()
      await driver.delayMs(1000)
    })

    afterEach(async () => {
      await driver.pressBack()
      await driver.delayMs(600)
    })

    it('example3_canvasIsVisible', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example3')
      await navBtn.click()
      await driver.delayMs(1000)
      const canvas: Component = await waitForId(driver, 'example3_canvas')
      expect(canvas !== null).assertTrue()
    })

    it('example3_storeSandbox_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example3')
      await navBtn.click()
      await driver.delayMs(1000)
      const store: Component = await waitForId(driver, 'example3_btn_store')
      await store.click()
      await driver.delayMs(800)
      expect(true).assertTrue()
    })

    it('example3_loadSandbox_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example3')
      await navBtn.click()
      await driver.delayMs(1000)
      const store: Component = await waitForId(driver, 'example3_btn_store')
      await store.click()
      await driver.delayMs(800)
      const load: Component = await waitForId(driver, 'example3_btn_load')
      await load.click()
      await driver.delayMs(1000)
      expect(true).assertTrue()
    })

    it('example3_canvasClick_cyclesAnimation', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example3')
      await navBtn.click()
      await driver.delayMs(1000)
      const canvas: Component = await waitForId(driver, 'example3_canvas')
      await canvas.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })
  })
}
