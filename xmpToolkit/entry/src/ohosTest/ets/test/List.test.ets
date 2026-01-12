import abilityTest from './Ability.test';
import xmpDateTimeTest from './XMPDateTime.test';
import xmpIteratorTest from './XMPIterator.test';
import xmpMetaTest from './XMPMeta.test';
import xmpMetaFactoryTest from './XMPMetaFactory.test';
import xmpPathFactoryTest from './XMPPathFactory.test';
import xmpSchemaRegistryTest from './XMPSchemaRegistry.test';
import xmpUtilsTest from './XMPUtils.test';
import xmpPropertyTest from './XMPProperty.test';


export default function testsuite() {
  abilityTest();

  // === XMP Library 完整测试 ===

  // 核心工厂和版本信息
  xmpMetaFactoryTest();

  // XMPMeta 属性操作
  xmpMetaTest();

  // 迭代器测试
  xmpIteratorTest();

  // 路径工厂测试
  xmpPathFactoryTest();

  // 日期时间测试
  xmpDateTimeTest();

  // Schema 注册表测试
  xmpSchemaRegistryTest();

  // 工具类测试
  xmpUtilsTest();

  //XMPProperty及XMPAliasInfo测试
  xmpPropertyTest();
}