/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import abilityTest from './Ability.test'
import caseinsensitive from './easyreplace/case-insensitive.test'
import infiniteloop from './easyreplace/infinite-loop.test'
import missingreplacement from './easyreplace/missing-replacement.test'
import missingsearchfor from './easyreplace/missing-search-for.test'
import onlystringtosearch from './easyreplace/only-string-to-search.test'
import outsideNot from './easyreplace/outsideNot.test'
import outsides from './easyreplace/outsides.test'
import readmecorrectness from './easyreplace/readme-correctness.test'
import searchForleftright from './easyreplace/searchFor-left-right.test'
import searchForleftMaybe from './easyreplace/searchFor-leftMaybe.test'
import searchFormaybesoutsides from './easyreplace/searchFor-maybes-outsides.test'
import searchFornomaybesoutsides from './easyreplace/searchFor-no-maybes-outsides.test'
import searchForoutsides from './easyreplace/searchFor-outsides.test'
import searchForrightMaybe from './easyreplace/searchFor-rightMaybe.test'
import various from './easyreplace/various.test'
import levenTest from './leven/leven2.test'

export default function testsuite() {
  abilityTest();
  caseinsensitive();
  infiniteloop();
  missingreplacement();
  missingsearchfor();
  onlystringtosearch();
  outsideNot();
  outsides();
  readmecorrectness();
  searchForleftright();
  searchForleftMaybe();
  searchFormaybesoutsides();
  searchFornomaybesoutsides();
  searchForoutsides();
  searchForrightMaybe();
  various();
  levenTest();
}