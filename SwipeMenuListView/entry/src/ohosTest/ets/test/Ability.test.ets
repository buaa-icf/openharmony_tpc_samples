/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { describe, it, expect } from '@ohos/hypium';
import {
  SwipeMenu,
  SwipeMenuItem,
  SwipeStateController,
  SwipeMenuItemController,
  TouchConfig,
  AnimationConfig,
  SwipeMenuCreator
} from '@ohos/swipemenulistview';

const TAG = '[SwipeMenu-Perf]';
const ITERATIONS = 1000;

function runPerfTest(interfaceName: string, task: (i: number) => void) {
  const start = Date.now();
  for (let i = 0; i < ITERATIONS; i++) {
    task(i);
  }
  const end = Date.now();
  const totalMs = end - start;
  const avgUs = (totalMs * 1000) / ITERATIONS;

  console.info(`${TAG} ${interfaceName} | Total: ${totalMs}ms | Avg: ${avgUs.toFixed(3)} μs/op`);
}

class MockItemController implements SwipeMenuItemController {
  public isOpen: boolean = false;
  public position: number;
  public config: TouchConfig | null = null;
  constructor(position: number) { this.position = position; }
  openMenu() { this.isOpen = true; }
  closeMenu() { this.isOpen = false; }
  getPosition() { return this.position; }
  updateTouchConfig(config: TouchConfig) { this.config = config; }
}

export default function abilityTest() {
  describe('SwipeLibraryFullCoverageTest', () => {

    // =========================================================================
    // 1. 状态控制器 (SwipeStateController) - 4个接口
    // =========================================================================

    it('test_smoothOpenMenu', 0, () => {
      const controller = new SwipeStateController();
      controller.registerItemController(0, new MockItemController(0));
      controller.smoothOpenMenu(0);
      expect(controller.isMenuOpen(0)).assertTrue();
      runPerfTest('smoothOpenMenu', () => controller.smoothOpenMenu(0));
    });

    it('test_smoothCloseMenu', 0, () => {
      const controller = new SwipeStateController();
      controller.registerItemController(0, new MockItemController(0));
      controller.smoothOpenMenu(0);
      controller.smoothCloseMenu();
      expect(controller.isMenuOpen(0)).assertFalse();
      runPerfTest('smoothCloseMenu', () => controller.smoothCloseMenu());
    });

    it('test_isMenuOpen', 0, () => {
      const controller = new SwipeStateController();
      controller.registerItemController(0, new MockItemController(0));
      controller.smoothOpenMenu(0);
      expect(controller.isMenuOpen(0)).assertTrue();
      runPerfTest('isMenuOpen', () => controller.isMenuOpen(0));
    });

    it('test_updateTouchConfig', 0, () => {
      const controller = new SwipeStateController();
      const mockItem = new MockItemController(0);
      controller.registerItemController(0, mockItem);
      const config = TouchConfig.sensitive();
      controller.updateTouchConfig(config);
      expect(mockItem.config?.minSwipeDistance).assertEqual(3);
      runPerfTest('updateTouchConfig', () => controller.updateTouchConfig(config));
    });

    // =========================================================================
    // 2. 菜单项管理 (SwipeMenu) - 4个接口
    // =========================================================================

    it('test_addMenuItem', 0, () => {
      const menu = new SwipeMenu();
      const item = new SwipeMenuItem({ id: 'test', background: 'red' });
      menu.addMenuItem(item);
      expect(menu.getMenuItems().length).assertEqual(1);
      runPerfTest('addMenuItem', () => {
        const m = new SwipeMenu();
        m.addMenuItem(item);
      });
    });

    it('test_removeMenuItem', 0, () => {
      const menu = new SwipeMenu();
      const item = new SwipeMenuItem({ id: 'test', background: 'red' });
      menu.addMenuItem(item);
      menu.removeMenuItem(item);
      expect(menu.getMenuItems().length).assertEqual(0);
      const benchMenu = new SwipeMenu();
      runPerfTest('removeMenuItem', () => {
        benchMenu.addMenuItem(item);
        benchMenu.removeMenuItem(item);
      });
    });

    it('test_getMenuItem', 0, () => {
      const menu = new SwipeMenu();
      const item = new SwipeMenuItem({ id: 'test', background: 'red' });
      menu.addMenuItem(item);
      expect(menu.getMenuItem(0)?.getId()).assertEqual('test');
      runPerfTest('getMenuItem', () => menu.getMenuItem(0));
    });

    it('test_getMenuItems', 0, () => {
      const menu = new SwipeMenu();
      menu.addMenuItem(new SwipeMenuItem({ id: 1, background: 'red' }));
      menu.addMenuItem(new SwipeMenuItem({ id: 2, background: 'blue' }));
      expect(menu.getMenuItems().length).assertEqual(2);
      runPerfTest('getMenuItems', () => menu.getMenuItems());
    });

    // =========================================================================
    // 3. 菜单项配置 (SwipeMenuItem) - 5个接口
    // =========================================================================

    it('test_new_SwipeMenuItem', 0, () => {
      const item = new SwipeMenuItem({ id: 'test', background: 'red' });
      expect(item).not().assertUndefined();
      runPerfTest('new SwipeMenuItem', () => {
        new SwipeMenuItem({ id: 'bench', title: 'Test', background: 'red', width: 100 });
      });
    });

    it('test_setTitle', 0, () => {
      const item = new SwipeMenuItem({ id: 'test', background: 'red' });
      item.setTitle('A');
      expect(item.getTitle()).assertEqual('A');
      runPerfTest('setTitle', () => item.setTitle('Title'));
    });

    it('test_setBackground', 0, () => {
      const item = new SwipeMenuItem({ id: 'test', background: 'red' });
      item.setBackground('blue');
      expect(item.getBackground()).assertEqual('blue');
      runPerfTest('setBackground', () => item.setBackground('#FFFFFF'));
    });

    it('test_setWidth', 0, () => {
      const item = new SwipeMenuItem({ id: 'test', background: 'red' });
      item.setWidth(200);
      expect(item.getWidth()).assertEqual(200);
      runPerfTest('setWidth', () => item.setWidth(100));
    });

    it('test_getId', 0, () => {
      const item = new SwipeMenuItem({ id: 999, background: 'red' });
      expect(item.getId()).assertEqual(999);
      runPerfTest('getId', () => item.getId());
    });

    // =========================================================================
    // 4. 自定义菜单 (Creator) - 1个接口
    // =========================================================================

    it('test_create', 0, () => {
      class TestCreator implements SwipeMenuCreator {
        create(menu: SwipeMenu, item?: Object, position?: number): void {
          menu.addMenuItem(new SwipeMenuItem({ id: 1, background: 'red' }));
        }
      }
      const creator = new TestCreator();
      const menu = new SwipeMenu();
      const dummy = new Object();
      creator.create(menu, dummy, 0);
      expect(menu.getMenuItems().length).assertEqual(1);
      const benchMenu = new SwipeMenu();
      runPerfTest('create', () => creator.create(benchMenu, dummy, 0));
    });

    // =========================================================================
    // 5. 触摸控制 (TouchConfig) - 3个接口
    // =========================================================================

    it('test_TouchConfig_default', 0, () => {
      expect(TouchConfig.default().minSwipeDistance).assertEqual(10);
      runPerfTest('TouchConfig.default', () => TouchConfig.default());
    });

    it('test_TouchConfig_sensitive', 0, () => {
      expect(TouchConfig.sensitive().minSwipeDistance).assertEqual(3);
      runPerfTest('TouchConfig.sensitive', () => TouchConfig.sensitive());
    });

    it('test_TouchConfig_strict', 0, () => {
      expect(TouchConfig.strict().minSwipeDistance).assertEqual(30);
      runPerfTest('TouchConfig.strict', () => TouchConfig.strict());
    });

    // =========================================================================
    // 6. 动画效果配置 (AnimationConfig) - 8个接口
    // =========================================================================

    it('test_AnimationConfig_default', 0, () => {
      expect(AnimationConfig.default()).not().assertUndefined();
      runPerfTest('AnimationConfig.default', () => AnimationConfig.default());
    });

    it('test_AnimationConfig_fast', 0, () => {
      expect(AnimationConfig.fast().duration).assertEqual(150);
      runPerfTest('AnimationConfig.fast', () => AnimationConfig.fast());
    });

    it('test_AnimationConfig_slow', 0, () => {
      expect(AnimationConfig.slow().duration).assertEqual(400);
      runPerfTest('AnimationConfig.slow', () => AnimationConfig.slow());
    });

    it('test_AnimationConfig_spring', 0, () => {
      expect(AnimationConfig.spring().springConfig).not().assertUndefined();
      runPerfTest('AnimationConfig.spring', () => AnimationConfig.spring());
    });

    it('test_AnimationConfig_bounce', 0, () => {
      expect(AnimationConfig.bounce().interpolator).not().assertUndefined();
      runPerfTest('AnimationConfig.bounce', () => AnimationConfig.bounce());
    });

    it('test_AnimationConfig_overshoot', 0, () => {
      expect(AnimationConfig.overshoot().overshootTension).not().assertUndefined();
      runPerfTest('AnimationConfig.overshoot', () => AnimationConfig.overshoot());
    });

    it('test_AnimationConfig_anticipate', 0, () => {
      expect(AnimationConfig.anticipate().anticipateTension).not().assertUndefined();
      runPerfTest('AnimationConfig.anticipate', () => AnimationConfig.anticipate());
    });

    it('test_AnimationConfig_none', 0, () => {
      expect(AnimationConfig.none().enabled).assertFalse();
      runPerfTest('AnimationConfig.none', () => AnimationConfig.none());
    });

  });
}