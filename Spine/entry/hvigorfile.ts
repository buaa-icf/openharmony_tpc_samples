import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { HvigorPlugin, HvigorNode } from '@ohos/hvigor';
import * as path from 'path';
import * as fs from 'fs';
function copyTestIndexPlugin(): HvigorPlugin {
  return {
    pluginId: 'CopyTestIndex',
    apply(node: HvigorNode): void {
      // 直接执行文件复制操作，不依赖任务钩子
      try {
        const src = path.join(__dirname, 'src/ohosTest/ets/testability/pages/Index.ets');
        const dest = path.join(
          __dirname,
          'build/default/intermediates/src/ohosTest/ets/testability/pages/Index.ets'
        );
        fs.mkdirSync(path.dirname(dest), { recursive: true });
        fs.copyFileSync(src, dest);
        console.log('[CopyTestIndex] custom Index.ets -> ' + dest);
      } catch (error) {
        console.log('[CopyTestIndex] copy failed:', error.message);
      }
    }
  };
}

export default {
  system: hapTasks,
  plugins: [copyTestIndexPlugin()]
}
