import abilityTest from './Ability.test'
import tempUtilsTest from './TempUtil.test'
import countryUtilsTest from './CountryUtils.test'
import nodeCacheTest from './NodeCache.test'
import gcoordTest from  './Gcoord.test'
import colorTest from  './Color.test'
import timeTest from  './Time.test'
import picture from  './Picture.test'
export default function testsuite() {
  abilityTest()
  tempUtilsTest()
  countryUtilsTest()
  nodeCacheTest()
  gcoordTest()
  colorTest()
  timeTest()
  picture()
}