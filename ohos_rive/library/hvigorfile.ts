import fs from 'fs';
import path from 'path';
import { hvigor } from '@ohos/hvigor';
import { harTasks } from '@ohos/hvigor-ohos-plugin';
import type { HvigorPlugin } from '@ohos/hvigor';

const ON_DEVICE_TEST_TASK = 'onDeviceTest';
const GENERATE_OHOS_TEST_TEMPLATE_TASK = 'ohosTest@GenerateOhosTestTemplate';
const OHOS_TEST_COMPILE_ARK_TS_TASK = 'ohosTest@OhosTestCompileArkTS';

// The host page lives at:
//   <module>/src/ohosTest/ets/testability/pages/Index.ets               (5 ".." up to library)
// hvigor copies it to:
//   <module>/build/default/intermediates/src/ohosTest/ets/testability/pages/Index.ets   (8 ".." up to library)
// Rewrite relative imports during copy so the same source file works in both places.
const SRC_LEVEL_PREFIX = '../../../../../main/ets/';
const COPIED_LEVEL_PREFIX = '../../../../../../../../src/main/ets/';

const replaceOhosTestIndexPlugin: HvigorPlugin = {
  pluginId: 'replace_ohos_test_index',
  apply(node) {
    hvigor.nodesEvaluated(() => {
      const entryTasks = new Set(hvigor.getCommandEntryTask() ?? []);
      if (!entryTasks.has(ON_DEVICE_TEST_TASK)) {
        return;
      }
      node.registerTask({
        name: 'ReplaceOhosTestIndex',
        dependencies: [GENERATE_OHOS_TEST_TEMPLATE_TASK],
        postDependencies: [OHOS_TEST_COMPILE_ARK_TS_TASK],
        run(taskContext) {
          const sourcePath = path.resolve(
            taskContext.modulePath,
            'src/ohosTest/ets/testability/pages/Index.ets'
          );
          const targetPath = path.resolve(
            taskContext.modulePath,
            'build/default/intermediates/src/ohosTest/ets/testability/pages/Index.ets'
          );
          if (!fs.existsSync(sourcePath)) {
            return;
          }
          let content = fs.readFileSync(sourcePath, 'utf-8');
          // Adjust relative-import depth for the copy destination.
          content = content.split(SRC_LEVEL_PREFIX).join(COPIED_LEVEL_PREFIX);
          fs.mkdirSync(path.dirname(targetPath), { recursive: true });
          fs.writeFileSync(targetPath, content, 'utf-8');
        }
      });
    });
  }
};

export default {
  system: harTasks,
  plugins: [replaceOhosTestIndexPlugin]
}
