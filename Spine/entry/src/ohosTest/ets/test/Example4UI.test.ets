import { describe, it, expect, beforeAll, afterEach } from '@ohos/hypium'
import { Driver, ON, Component } from '@ohos.UiTest'

async function waitForId(driver: Driver, id: string): Promise<Component> {
  const comp: Component | null = await driver.waitForComponent(ON.id(id), 4000)
  if (comp === null) {
    throw new Error('Unable to find id: ' + id)
  }
  return comp
}

export default function Example4UITest() {
  describe('Example4UITest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = Driver.create()
      await driver.delayMs(1000)
    })

    afterEach(async () => {
      await driver.pressBack()
      await driver.delayMs(600)
    })

    it('example4_canvasIsVisible', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example4')
      await navBtn.click()
      await driver.delayMs(1000)
      const canvas: Component = await waitForId(driver, 'example4_canvas')
      expect(canvas !== null).assertTrue()
    })

    it('example4_loadPausePlay_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example4')
      await navBtn.click()
      await driver.delayMs(1000)
      const load: Component = await waitForId(driver, 'example4_btn_load')
      await load.click()
      await driver.delayMs(1500)
      const pause: Component = await waitForId(driver, 'example4_btn_pause')
      await pause.click()
      await driver.delayMs(300)
      const play: Component = await waitForId(driver, 'example4_btn_play')
      await play.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })

    it('example4_clearButton_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example4')
      await navBtn.click()
      await driver.delayMs(1000)
      const clear: Component = await waitForId(driver, 'example4_btn_clear')
      await clear.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })

    it('example4_listenerButtons_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example4')
      await navBtn.click()
      await driver.delayMs(1000)
      const load: Component = await waitForId(driver, 'example4_btn_load')
      await load.click()
      await driver.delayMs(1500)
      const add: Component = await waitForId(driver, 'example4_btn_add_listener')
      await add.click()
      await driver.delayMs(300)
      const remove: Component = await waitForId(driver, 'example4_btn_remove_listener')
      await remove.click()
      await driver.delayMs(300)
      const clearAll: Component = await waitForId(driver, 'example4_btn_clear_listeners')
      await clearAll.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })

    it('example4_animationStateButtons_nocrash', 0, async () => {
      const navBtn: Component = await waitForId(driver, 'nav_example4')
      await navBtn.click()
      await driver.delayMs(1000)
      const load: Component = await waitForId(driver, 'example4_btn_load')
      await load.click()
      await driver.delayMs(1500)
      const getCurrent: Component = await waitForId(driver, 'example4_btn_get_current')
      await getCurrent.click()
      await driver.delayMs(300)
      const setAnimWith: Component = await waitForId(driver, 'example4_btn_set_anim_with')
      await setAnimWith.click()
      await driver.delayMs(300)
      const clearTrack: Component = await waitForId(driver, 'example4_btn_clear_track')
      await clearTrack.click()
      await driver.delayMs(300)
      const addAnim: Component = await waitForId(driver, 'example4_btn_add_anim')
      await addAnim.click()
      await driver.delayMs(300)
      expect(true).assertTrue()
    })
  })
}
