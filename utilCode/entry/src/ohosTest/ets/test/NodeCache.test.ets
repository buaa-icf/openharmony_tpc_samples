import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
// @ts-ignore
import cache from 'memory-cache';
export default function NodeCacheTest() {

  describe('NodeCacheTest', function () {
    beforeAll(function (){
      cache.clear();
    })
    beforeEach(function () {
      cache.debug(false);
      cache.clear();
    });
    it('should allow adding a new item to the cache'.split(' ').join('_'), 0, function () {
      expect(
      cache.put('key', 'value')).not().assertFail();
    });

    it('should allow adding a new item to the cache with a timeout'.split(' ').join('_'), 0, function () {
      expect(function () {
        cache.put('key', 'value', 100);
      }).not().assertFail();
    });

    it('should allow adding a new item to the cache with a timeout callback'.split(' ').join('_'), 0, function () {
      expect(function () {
        cache.put('key', 'value', 100, function () {
        });
      }).not().assertFail();
    });

    it('should throw an error given a non-numeric timeout'.split(' ').join('_'), 0, function () {
      expect(function () {
        cache.put('key', 'value', 'foo');
      }).not().assertFail();
    });

    it('should throw an error given a timeout of NaN'.split(' ').join('_'), 0, function () {
      expect(function () {
        cache.put('key', 'value', NaN);
      }).not().assertFail();
    });

    it('should throw an error given a timeout of 0'.split(' ').join('_'), 0, function () {
      expect(function () {
        cache.put('key', 'value', 0);
      }).not().assertFail();
    });

    it('should throw an error given a negative timeout'.split(' ').join('_'), 0, function () {
      expect(function () {
        cache.put('key', 'value', -100);
      }).not().assertFail();
    });

    it('should throw an error given a non-function timeout callback'.split(' ').join('_'), 0, function () {
      expect(function () {
        cache.put('key', 'value', 100, 'foo');
      }).not().assertFail();
    });

    it('should return the cached value'.split(' ').join('_'), 0, function () {
      expect(cache.put('key', 'value')).assertEqual('value');
    });
    it('should return false given a key for an empty cache'.split(' ').join('_'), 0, function () {
      expect(cache.del('miss')).assertFalse();
    });

    it('should return false given a key not in a non-empty cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.del('miss')).assertFalse();
    });

    it('should return true given a key in the cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.del('key')).assertTrue();
    });

    it('should remove the provided key from the cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.get('key')).assertEqual('value');
      expect(cache.del('key')).assertTrue();
      expect(cache.get('key')).assertNull();
    });

    it('should decrement the cache size by 1'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.size()).assertEqual(1);
      expect(cache.del('key')).assertTrue();
      expect(cache.size()).assertEqual(0);
    });

    it('should not remove other keys in the cache'.split(' ').join('_'), 0, function () {
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

    it('should only delete a key from the cache once even if called multiple times in a row'.split(' ')
      .join('_'), 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.size()).assertEqual(3);
      cache.del('key1');
      cache.del('key1');
      cache.del('key1');
      expect(cache.size()).assertEqual(2);
    });

    it('should handle deleting keys which were previously deleted and then re-added to the cache'.split(' ')
      .join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.get('key')).assertEqual('value');
      cache.del('key');
      expect(cache.get('key')).assertNull;
      cache.put('key', 'value');
      expect(cache.get('key')).assertEqual('value');
      cache.del('key');
      expect(cache.get('key')).assertNull;
    });

    it('should return true given an non-expired key'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value', 1000);
      expect(cache.del('key')).assertTrue();
    });
    it('should have no effect given an empty cache'.split(' ').join('_'), 0, function () {
      expect(cache.size()).assertEqual(0);
      cache.clear();
      expect(cache.size()).assertEqual(0);
    });
    it('should remove all existing keys in the cache'.split(' ').join('_'), 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.size()).assertEqual(3);
      cache.clear();
      expect(cache.size()).assertEqual(0);
    });
    it('should remove the keys in the cache'.split(' ').join('_'), 0, function () {
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
    it('should reset the cache size to 0'.split(' ').join('_'), 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.size()).assertEqual(3);
      cache.clear();
      expect(cache.size()).assertEqual(0);
    });
    it('should reset the debug cache hits'.split(' ').join('_'), 0, function () {
      cache.debug(true);
      cache.put('key', 'value');
      cache.get('key');
      expect(cache.hits()).assertEqual(1);
      cache.clear();
      expect(cache.hits()).assertEqual(0);
    });
    it('should reset the debug cache misses'.split(' ').join('_'), 0, function () {
      cache.debug(true);
      cache.put('key', 'value');
      cache.get('miss1');
      expect(cache.misses()).assertEqual(1);
      cache.clear();
      expect(cache.misses()).assertEqual(0);
    });
    it('should return null given a key for an empty cache'.split(' ').join('_'), 0, function () {
      expect(cache.get('miss')).assertNull();
    });

    it('should return null given a key not in a non-empty cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.get('miss')).assertNull();
    });

    it('should return the corresponding value of a key in the cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.get('key')).assertEqual('value');
    });

    it('should return the latest corresponding value of a key in the cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value1');
      cache.put('key', 'value2');
      cache.put('key', 'value3');
      expect(cache.get('key')).assertEqual('value3');
    });

    it('should handle various types of cache keys'.split(' ').join('_'), 0, function () {
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

    it('should handle various types of cache values'.split(' ').join('_'), 0, function () {
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

    it('should return null given a key which is a property on the Object prototype'.split(' ')
      .join('_'), 0, function () {
      expect(cache.get('toString')).assertNull();
    });

    it('should allow reading the value for a key which is a property on the Object prototype'.split(' ')
      .join('_'), 0, function () {
      cache.put('toString', 'value');
      expect(cache.get('toString')).assertEqual('value');
    });
    it('should return 0 given a fresh cache'.split(' ').join('_'), 0, function () {
      expect(cache.size()).assertEqual(0);
    });
    it('should return 1 after adding a single item to the cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.size()).assertEqual(1);
    });
    it('should return 3 after adding three items to the cache'.split(' ').join('_'), 0, function () {
      cache.clear();
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.size()).assertEqual(3);
    });
    it('should not multi-count duplicate items added to the cache'.split(' ').join('_'), 0, function () {
      cache.clear();
      cache.put('key', 'value1');
      expect(cache.size()).assertEqual(1);
      cache.put('key', 'value2');
      expect(cache.size()).assertEqual(1);
    });
    it('should return 0 given a fresh cache'.split(' ').join('_'), 0, function () {
      expect(cache.memsize()).assertEqual(0);
    });

    it('should return 1 after adding a single item to the cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.memsize()).assertEqual(1);
    });

    it('should return 3 after adding three items to the cache'.split(' ').join('_'), 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.memsize()).assertEqual(3);
    });

    it('should not multi-count duplicate items added to the cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value1');
      expect(cache.memsize()).assertEqual(1);
      cache.put('key', 'value2');
      expect(cache.memsize()).assertEqual(1);
    });
    it('should not count cache hits when false'.split(' ').join('_'), 0, function () {
      cache.debug(false);
      cache.put('key', 'value');
      cache.get('key');
      expect(cache.hits()).assertEqual(0);
    });

    it('should not count cache misses when false'.split(' ').join('_'), 0, function () {
      cache.debug(false);
      cache.put('key', 'value');
      cache.get('miss1');
      expect(cache.misses()).assertEqual(0);
    });

    it('should count cache hits when true'.split(' ').join('_'), 0, function () {
      cache.debug(true);
      cache.put('key', 'value');
      cache.get('key');
      expect(cache.hits()).assertEqual(1);
    });

    it('should count cache misses when true'.split(' ').join('_'), 0, function () {
      cache.debug(true);
      cache.put('key', 'value');
      cache.get('miss1');
      expect(cache.misses()).assertEqual(1);
    });
    it('should return 1 given a non-empty cache which has had a single hit'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      cache.get('key');
      expect(cache.hits()).assertEqual(1);
    });
    it('should return 1 given a non-empty cache which has had a single miss'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      cache.get('miss');
      expect(cache.misses()).assertEqual(1);
    });

    it('should return the correct value after a sequence of hits and misses'.split(' ').join('_'), 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      cache.get('key1');
      cache.get('miss');
      cache.get('key3');
      expect(cache.misses()).assertEqual(1);
    });
    it('should return an empty array given an empty cache'.split(' ').join('_'), 0, function () {
      expect(cache.keys()).assertDeepEquals([]);
    });

    it('should return a single key after adding a single item to the cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value');
      expect(cache.keys()).assertDeepEquals(['key']);
    });

    it('should return 3 keys after adding three items to the cache'.split(' ').join('_'), 0, function () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      expect(cache.keys()).assertDeepEquals(['key1', 'key2', 'key3']);
    });

    it('should not multi-count duplicate items added to the cache'.split(' ').join('_'), 0, function () {
      cache.put('key', 'value1');
      expect(cache.keys()).assertDeepEquals(['key']);
      cache.put('key', 'value2');
      expect(cache.keys()).assertDeepEquals(['key']);
    });
    it('should return an empty object given an empty cache'.split(' ').join('_'), 0, function () {
      expect(cache.exportJson()).assertEqual(JSON.stringify({}));
    });
    it('should import an empty object into an empty cache'.split(' ').join('_'), 0, function () {
      var exportedJson = cache.exportJson();

      cache.clear();
      cache.importJson(exportedJson);

      expect(cache.exportJson()).assertEqual(JSON.stringify({}));
    });

    it('should return the new size'.split(' ').join('_'), 0, function () {
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