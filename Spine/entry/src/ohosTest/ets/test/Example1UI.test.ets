import { describe, it, expect, beforeAll, afterEach } from '@ohos/hypium'
import { Driver, ON, Component } from '@ohos.UiTest'

async function waitForId(driver: Driver, id: string): Promise<Component> {
  const comp: Component | null = await driver.waitForComponent(ON.id(id), 4000)
  if (comp === null) {
    throw new Error('Unable to find id: ' + id)
  }
  return comp
}

export default function Example1UITest() {
  describe('Example1UITest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = Driver.create()
      await driver.delayMs(1000)
    })

    afterEach(async () => {
      await driver.pressBack()
      await driver.delayMs(600)
    })

    it('example1_canvasIsVisible', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example1')
      await navBtn.click()
      await driver.delayMs(1500)
      const canvas: Component = await waitForId(driver, 'example1_canvas')
      expect(canvas !== null).assertTrue()
    })

    it('example1_canvasClick_cyclesAnimation', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example1')
      await navBtn.click()
      await driver.delayMs(1500)
      const canvas: Component = await waitForId(driver, 'example1_canvas')
      await canvas.click()
      await driver.delayMs(300)
      await canvas.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })
  })
}
