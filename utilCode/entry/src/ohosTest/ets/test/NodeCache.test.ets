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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
//@ts-ignore
import cache from 'memory-cache';

export default function NodeCacheTest() {

  describe('NodeCacheTest', function () {
    beforeAll(function () {
      cache.clear();
    })
    beforeEach(function () {
      cache.debug(false);
      cache.clear();
    });
    it('shouldAllowAddingANewItemToTheCache', 0, function () {
      expect(
        cache.put('key', 'value')).not().assertFail();
    });

    it('shouldAllowAddingANewItemToTheCacheWithATimeout', 0, function () {
      expect(function () {
        cache.put('key', 'value', 100);
      }).not().assertFail();
    });

    it('shouldAllowAddingANewItemToTheCacheWithATimeoutCallback', 0, function () {
      expect(function () {
        cache.put('key', 'value', 100, function () {
        });
      }).not().assertFail();
    });

    it('shouldThrowAnErrorGivenANonNumericTimeout', 0, function () {
      expect(function () {
        cache.put('key', 'value', 'foo');
      }).not().assertFail();
    });

    it('shouldThrowAnErrorGivenATimeoutOfNaN', 0, function () {
      expect(function () {
        cache.put('key', 'value', NaN);
      }).not().assertFail();
    });

    it('shouldThrowAnErrorGivenATimeoutOf0', 0, function () {
      expect(function () {
        cache.put('key', 'value', 0);
      }).not().assertFail();
    });

    it('shouldThrowAnErrorGivenANegativeTimeout', 0, function () {
      expect(function () {
        cache.put('key', 'value', -100);
      }).not().assertFail();
    });

    it('shouldThrowAnErrorGivenANonFunctionTimeoutCallback', 0, function () {
      expect(function () {
        cache.put('key', 'value', 100, 'foo');
      }).not().assertFail();
    });

    it('shouldReturnTheCachedValue', 0, function () {
      expect(cache.put('key', 'value')).assertEqual('value');
    });
    it('shouldReturnFalseGivenAKeyForAnEmptyCache', 0, function () {
      expect(cache.del('miss')).assertFalse();
    });

    it('shouldReturnFalseGivenAKeyNotInANonEmptyCache', 0, function () {
      cache.put('key', 'value');
      expect(cache.del('miss')).assertFalse();
    });

    it('shouldReturnTrueGivenAKeyInTheCache', 0, function () {
      cache.put('key', 'value');
      expect(cache.del('key')).assertTrue();
    });

    it('shouldRemoveTheProvidedKeyFromTheCache', 0, function () {
      cache.put('key', 'value');
      expect(cache.get('key')).assertEqual('value');
      expect(cache.del('key')).assertTrue();
      expect(cache.get('key')).assertNull();
    });

    it('shouldDecrementTheCacheSizeBy1', 0, function () {
      cache.put('key', 'value');
      expect(cache.size()).assertEqual(1);
      expect(cache.del('key')).assertTrue();
      expect(cache.size()).assertEqual(0);
    });

    it('shouldNotRemoveOtherKeysInTheCache', 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.get('key1')).assertEqual('value1');
      expect(cache.get('key2')).assertEqual('value2');
      expect(cache.get('key3')).assertEqual('value3');
      cache.del('key1');
      expect(cache.get('key1')).assertNull;
      expect(cache.get('key2')).assertEqual('value2');
      expect(cache.get('key3')).assertEqual('value3');
    });

    it('shouldOnlyDeleteAKeyFromTheCacheOnceEvenIfCalledMultipleTimesInARow', 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.size()).assertEqual(3);
      cache.del('key1');
      cache.del('key1');
      cache.del('key1');
      expect(cache.size()).assertEqual(2);
    });

    it('shouldHandleDeletingKeysWhichWerePreviouslyDeletedAndThenReAddedToTheCache', 0, function () {
      cache.put('key', 'value');
      expect(cache.get('key')).assertEqual('value');
      cache.del('key');
      expect(cache.get('key')).assertNull;
      cache.put('key', 'value');
      expect(cache.get('key')).assertEqual('value');
      cache.del('key');
      expect(cache.get('key')).assertNull;
    });

    it('shouldReturnTrueGivenAnNonExpiredKey', 0, function () {
      cache.put('key', 'value', 1000);
      expect(cache.del('key')).assertTrue();
    });
    it('shouldhavenoeffectgivenanemptycache', 0, function () {
      expect(cache.size()).assertEqual(0);
      cache.clear();
      expect(cache.size()).assertEqual(0);
    });
    it('shouldremoveallexistingkeysinthecache', 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.size()).assertEqual(3);
      cache.clear();
      expect(cache.size()).assertEqual(0);
    });
    it('shouldremovethekeysinthecache', 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.get('key1')).assertEqual('value1');
      expect(cache.get('key2')).assertEqual('value2');
      expect(cache.get('key3')).assertEqual('value3');
      cache.clear();
      expect(cache.get('key1')).assertNull();
      expect(cache.get('key2')).assertNull();
      expect(cache.get('key3')).assertNull();
    });
    it('shouldresetthecachesizeto0', 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.size()).assertEqual(3);
      cache.clear();
      expect(cache.size()).assertEqual(0);
    });
    it('shouldresetthedebugcachehits', 0, function () {
      cache.debug(true);
      cache.put('key', 'value');
      cache.get('key');
      expect(cache.hits()).assertEqual(1);
      cache.clear();
      expect(cache.hits()).assertEqual(0);
    });
    it('shouldresetthedebugcachemisses', 0, function () {
      cache.debug(true);
      cache.put('key', 'value');
      cache.get('miss1');
      expect(cache.misses()).assertEqual(1);
      cache.clear();
      expect(cache.misses()).assertEqual(0);
    });
    it('shouldreturnnullgivenakeyforanemptycache', 0, function () {
      expect(cache.get('miss')).assertNull();
    });

    it('shouldreturnnullgivenakeynotinanonemptycache', 0, function () {
      cache.put('key', 'value');
      expect(cache.get('miss')).assertNull();
    });

    it('shouldreturnthecorrespondingvalueofakeyinthecache', 0, function () {
      cache.put('key', 'value');
      expect(cache.get('key')).assertEqual('value');
    });

    it('shouldreturnthelatestcorrespondingvalueofakeyinthecache', 0, function () {
      cache.put('key', 'value1');
      cache.put('key', 'value2');
      cache.put('key', 'value3');
      expect(cache.get('key')).assertEqual('value3');
    });

    it('shouldhandlevarioustypesofcachekeys', 0, function () {
      var keys = [null, undefined, NaN, true, false, 0, 1, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY, '', 'a', [], {
      }, [1, 'a', false], {
        a: 1, b: 'a', c: false
      }, function () {
      }];
      keys.forEach(function (key, index) {
        var value = 'value' + index;
        cache.put(key, value);
        expect(cache.get(key)).assertDeepEquals(value);
      });
    });

    it('shouldhandlevarioustypesofcachevalues', 0, function () {
      var values = [null, undefined, NaN, true, false, 0, 1, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY, '', 'a', [], {
      }, [1, 'a', false], {
        a: 1, b: 'a', c: false
      }, function () {
      }];
      values.forEach(function (value, index) {
        var key = 'key' + index;
        cache.put(key, value);
        expect(cache.get(key)).assertDeepEquals(value);
      });
    });

    it('shouldreturnnullgivenakeywhichisapropertyontheObjectprototype', 0, function () {
      expect(cache.get('toString')).assertNull();
    });

    it('shouldallowreadingthevalueforakeywhichisapropertyontheObjectprototype', 0, function () {
      cache.put('toString', 'value');
      expect(cache.get('toString')).assertEqual('value');
    });
    it('shouldreturn0givenafreshcache1', 0, function () {
      expect(cache.size()).assertEqual(0);
    });
    it('shouldreturn1afteraddingasingleitemtothecache2', 0, function () {
      cache.put('key', 'value');
      expect(cache.size()).assertEqual(1);
    });
    it('shouldreturn3afteraddingthreeitemstothecache1', 0, function () {
      cache.clear();
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.size()).assertEqual(3);
    });
    it('shouldnotmulticountduplicateitemsaddedtothecache1', 0, function () {
      cache.clear();
      cache.put('key', 'value1');
      expect(cache.size()).assertEqual(1);
      cache.put('key', 'value2');
      expect(cache.size()).assertEqual(1);
    });
    it('shouldreturn0givenafreshcache2', 0, function () {
      expect(cache.memsize()).assertEqual(0);
    });

    it('shouldreturn1afteraddingasingleitemtothecache1', 0, function () {
      cache.put('key', 'value');
      expect(cache.memsize()).assertEqual(1);
    });

    it('shouldreturn3afteraddingthreeitemstothecache2', 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.memsize()).assertEqual(3);
    });

    it('shouldnotmulticountduplicateitemsaddedtothecache2', 0, function () {
      cache.put('key', 'value1');
      expect(cache.memsize()).assertEqual(1);
      cache.put('key', 'value2');
      expect(cache.memsize()).assertEqual(1);
    });
    it('shouldnotcountcachehitswhenfalse', 0, function () {
      cache.debug(false);
      cache.put('key', 'value');
      cache.get('key');
      expect(cache.hits()).assertEqual(0);
    });

    it('shouldnotcountcachemisseswhenfalse', 0, function () {
      cache.debug(false);
      cache.put('key', 'value');
      cache.get('miss1');
      expect(cache.misses()).assertEqual(0);
    });

    it('shouldcountcachehitswhentrue', 0, function () {
      cache.debug(true);
      cache.put('key', 'value');
      cache.get('key');
      expect(cache.hits()).assertEqual(1);
    });

    it('shouldcountcachemisseswhentrue', 0, function () {
      cache.debug(true);
      cache.put('key', 'value');
      cache.get('miss1');
      expect(cache.misses()).assertEqual(1);
    });
    it('shouldreturn1givenanonemptycachewhichhashadasinglehit', 0, function () {
      cache.put('key', 'value');
      cache.get('key');
      expect(cache.hits()).assertEqual(1);
    });
    it('shouldreturn1givenanonemptycachewhichhashadasinglemiss', 0, function () {
      cache.put('key', 'value');
      cache.get('miss');
      expect(cache.misses()).assertEqual(1);
    });

    it('shouldreturnthecorrectvalueafterasequenceofhitsandmisses', 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      cache.get('key1');
      cache.get('miss');
      cache.get('key3');
      expect(cache.misses()).assertEqual(1);
    });
    it('shouldreturnanemptyarraygivenanemptycache', 0, function () {
      expect(cache.keys()).assertDeepEquals([]);
    });

    it('shouldreturnasinglekeyafteraddingasingleitemtothecache', 0, function () {
      cache.put('key', 'value');
      expect(cache.keys()).assertDeepEquals(['key']);
    });

    it('shouldreturn3keysafteraddingthreeitemstothecache', 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.keys()).assertDeepEquals(['key1', 'key2', 'key3']);
    });

    it('shouldnotmulticountduplicateitemsaddedtothecache3', 0, function () {
      cache.put('key', 'value1');
      expect(cache.keys()).assertDeepEquals(['key']);
      cache.put('key', 'value2');
      expect(cache.keys()).assertDeepEquals(['key']);
    });
    it('shouldreturnanemptyobjectgivenanemptycache', 0, function () {
      expect(cache.exportJson()).assertEqual(JSON.stringify({}));
    });
    it('shouldimportanemptyobjectintoanemptycache', 0, function () {
      var exportedJson = cache.exportJson();

      cache.clear();
      cache.importJson(exportedJson);

      expect(cache.exportJson()).assertEqual(JSON.stringify({}));
    });

    it('shouldreturnthenewsize', 0, function () {
      cache.put('key1', 'value1', 500);
      var exportedJson = cache.exportJson();

      cache.clear();
      cache.put('key2', 'value2', 1000);
      expect(cache.size()).assertEqual(1);

      var size = cache.importJson(exportedJson);
      expect(size).assertEqual(2);
      expect(cache.size()).assertEqual(2);
    });
  });

}