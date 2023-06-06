/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import RuleEngine from "node-rules";
//import { API, Fact } from "node-rules";
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '@ohos/hypium'
import process from '@ohos.process';

export default function NodeRulesTest() {

  function diff(obj1, obj2) {
    var o1 = obj1 instanceof Object;
    var o2 = obj2 instanceof Object;
    // 判断是不是对象
    if (!o1 || !o2) {
      return obj1 === obj2;
    }
    //Object.keys() 返回一个由对象的自身可枚举属性(key值)组成的数组,
    //例如：数组返回下表：let arr = ["a", "b", "c"];console.log(Object.keys(arr))->0,1,2;
    if (Object.keys(obj1).length !== Object.keys(obj2).length) {
      return false;
    }
    for (var o in obj1) {
      var t1 = obj1[o] instanceof Object;
      var t2 = obj2[o] instanceof Object;
      if (t1 && t2) {
        if (!diff(obj1[o], obj2[o])) {
          return false
        }
      } else if (obj1[o] !== obj2[o]) {
        return false;
      }
    }
    return true;
  }

  describe('NodeRulesTest', function () {
    _it("should empty the existing rule array", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
        },
      ];
      var R = new RuleEngine(rules);
      R.init();
      let diffResult = diff(R.rules, [])
      expect(diffResult).assertTrue();
    });
    _it("Rule should be turned on if the field  ON is absent in the rule", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
        },
      ];
      var R = new RuleEngine(rules);
      expect(R.rules[0].on).assertEqual(true);
    });
    _it("Rule can be passed to register as both arrays and individual objects", 0, function () {
      var rule = {
        condition: function (R) {
          R.when(1);
        },
        consequence: function (R) {
          R.stop();
        },
      };
      var R1 = new RuleEngine(rule);
      var R2 = new RuleEngine([rule]);
      let diffResult = diff(R1.rules, R2.rules)
      expect(diffResult).assertTrue();
    });
    _it("Rules can be appended multiple times via register after creating rule engine instance", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
        },
      ];
      var R1 = new RuleEngine(rules);
      var R2 = new RuleEngine(rules[0]);
      var R3 = new RuleEngine();
      R2.register(rules[1]);
      let diffResult1 = diff(R1.rules, R2.rules)
      expect(diffResult1).assertTrue();
      R3.register(rules);
      let diffResult2 = diff(R1.rules, R3.rules)
      expect(diffResult2).assertTrue();
    });
    _it("should only push active rules into active rules array", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
          on: true,
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
          on: false,
        },
      ];
      var R = new RuleEngine();
      R.register(rules);
      let diffResult1 = diff(R.activeRules, R.rules)
      expect(diffResult1).assertFalse();
      //          // @ts-ignore
      //                expect(R.activeRules).not().assertEqual(R.rules);
    });
    _it("should sort the rules accroding to priority, if priority is present", 0, function () {
      var rules = [
        {
          priority: 8,
          index: 1,
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
        },
        {
          priority: 6,
          index: 2,
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
        },
        {
          priority: 9,
          index: 0,
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
        },
      ];
      var R = new RuleEngine();
      R.register(rules);
      expect(R.activeRules[2].index).assertEqual(2);
    });
    _it("should run consequnce when condition matches", 0, function () {
      var rule = {
        condition: function (R, f) {
          R.when(f.transactionTotal < 500);
        },
        consequence: function (R, f) {
          f.result = false;
          R.stop();
        },
      };
      var R = new RuleEngine(rule);
      R.execute(
        {
          transactionTotal: 200,
        },
        function (result) {
          expect(result.result).assertEqual(false);
        }
      );
    });
    _it("should chain rules and find result with next", 0, function () {
      var rule = [
        {
          condition: function (R, f) {
            R.when(f.card == "VISA");
          },
          consequence: function (R, f) {
            R.stop();
            f.result = "Custom Result";
          },
          priority: 4,
        },
        {
          condition: function (R, f) {
            R.when(f.transactionTotal < 1000);
          },
          consequence: function (R, f) {
            R.next();
          },
          priority: 8,
        },
      ];
      var R = new RuleEngine(rule);
      R.execute(
        {
          transactionTotal: 200,
          card: "VISA",
        },
        function (result) {
          expect(result.result).assertEqual("Custom Result");
        }
      );
    });
    _it("should provide access to rule definition properties via rule", 0, function () {
      var rule = {
        name: "sample rule name",
        id: "xyzzy",
        condition: function (R, f) {
          R.when(f.input === true);
        },
        consequence: function (R, f) {
          f.result = true;
          f.ruleName = R.rule().name;
          f.ruleID = R.rule().id;
          R.stop();
        },
      };
      var R = new RuleEngine(rule);
      R.execute(
        {
          input: true,
        },
        function (result) {
          expect(result.ruleName).assertEqual(rule.name);
          expect(result.ruleID).assertEqual(rule.id);
        }
      );
    });


    _it("should include the matched rule path", 0, function () {
      var rules = [
        {
          name: "rule A",
          condition: function (R, f) {
            R.when(f.x === true);
          },
          consequence: function (R) {
            R.next();
          },
        },
        {
          name: "rule B",
          condition: function (R, f) {
            R.when(f.y === true);
          },
          consequence: function (R) {
            R.next();
          },
        },
        {
          id: "rule C",
          condition: function (R, f) {
            R.when(f.x === true && f.y === false);
          },
          consequence: function (R) {
            R.next();
          },
        },
        {
          id: "rule D",
          condition: function (R, f) {
            R.when(f.x === false && f.y === false);
          },
          consequence: function (R) {
            R.next();
          },
        },
        {
          condition: function (R, f) {
            R.when(f.x === true && f.y === false);
          },
          consequence: function (R) {
            R.next();
          },
        },
      ];
      var lastMatch = "index_" + (rules.length - 1).toString();
      var R = new RuleEngine(rules);
      R.execute(
        {
          x: true,
          y: false,
        },
        function (result) {
          let diffResult = diff(result.matchPath, [
          rules[0].name,
          rules[2].id,
            lastMatch,
          ])
          expect(diffResult).assertTrue();
        }
      );
    });


    _it("should support fact as optional second parameter for es6 compatibility", 0, function () {
      var rule = {
        condition: (R, f) => {
          R.when(f.transactionTotal < 500);
        },
        consequence: (R, f) => {
          f.result = false;
          R.stop();
        },
      };
      var R = new RuleEngine(rule);
      R.execute(
        {
          transactionTotal: 200,
        },
        function (result) {
          expect(result.result).assertEqual(false);
        }
      );
    });
    _it("should work even when process NextTick is unavailable", 0, function () {
      // @ts-expect-error
      process.nextTick = undefined;

      var rule = {
        condition: function (R, f) {
          R.when(f.transactionTotal < 500);
        },
        consequence: function (R, f) {
          f.result = false;
          R.stop();
        },
      };
      var R = new RuleEngine(rule);
      R.execute(
        {
          transactionTotal: 200,
        },
        function (result) {
          expect(result.result).assertEqual(false);
        }
      );
    });
    _it("find selector function for rules should exact number of matches", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "two",
        },
      ];
      var R = new RuleEngine(rules);

      expect(
      R.findRules({
        id: "one",
      }).length
      ).assertEqual(1);
    });
    _it("find selector function for rules should give the correct match as result", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "two",
        },
      ];
      var R = new RuleEngine(rules);

      expect(
      R.findRules({
        id: "one",
      })[0].id
      ).assertEqual("one");
    });
    _it("find selector function should filter off undefined entries in the query if any", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "two",
        },
      ];
      var R = new RuleEngine(rules);
      expect(
      R.findRules({
        id: "one",
        myMistake: undefined,
      })[0].id
      ).assertEqual("one");
    });
    _it("find without condition works fine", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "two",
        },
      ];
      var R = new RuleEngine(rules);
      expect(R.findRules().length).assertEqual(2);
    });
    _it("checking whether turn off rules work as expected", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "two",
          on: false,
        },
      ];
      var R = new RuleEngine(rules);
      R.turn("OFF", {
        id: "one",
      });
      expect(
      R.findRules({
        id: "one",
      })[0].on
      ).assertEqual(false);
    });
    _it("checking whether turn on rules work as expected", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "two",
          on: false,
        },
      ];
      var R = new RuleEngine(rules);
      R.turn("ON", {
        id: "two",
      });
      expect(
      R.findRules({
        id: "two",
      })[0].on
      ).assertEqual(true);
    });
    _it("checking whether prioritize work", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "two",
          priority: 1,
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "zero",
          priority: 8,
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
          priority: 4,
        },
      ];
      var R = new RuleEngine(rules);
      R.prioritize(10, {
        id: "one",
      });
      expect(
      R.findRules({
        id: "one",
      })[0].priority
      ).assertEqual(10);
    });
    _it("checking whether rules reorder after prioritize", 0, function () {
      var rules = [
        {
          condition: function (R) {
            R.when(1);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "two",
          priority: 1,
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "zero",
          priority: 8,
        },
        {
          condition: function (R) {
            R.when(0);
          },
          consequence: function (R) {
            R.stop();
          },
          id: "one",
          priority: 4,
        },
      ];
      var R = new RuleEngine(rules);
      R.prioritize(10, {
        id: "one",
      });
      expect(R.activeRules[0].id).assertEqual("one");
    });
    _it("does not rerun when a fact changes if ignoreFactChanges is true", 0, function (done) {
      var rules = [
        {
          name: "rule1",
          condition: function (R, f) {
            R.when(f.value1 > 5);
          },
          consequence: function (R, f) {
            f.result = false;
            f.errors = f.errors || [];
            f.errors.push("must be less than 5");
            R.next();
          },
        },
      ];
      var fact = {
        value1: 6,
      };
      var R = new RuleEngine(rules, {
        ignoreFactChanges: true
      });

      R.execute(fact, function (result) {
        expect(result.errors.length).assertEqual(1);
        done();
      });
    });
    _it("context switches and finishes the fact which needs least iteration first", 0, function (done) {
      var rules = [
        {
          name: "high credibility customer - avoid checks and bypass",
          priority: 4,
          on: true,
          condition: function (R, f) {
            R.when(f.userCredibility && f.userCredibility > 5);
          },
          consequence: function (R, f) {
            f.result = true;
            R.stop();
          },
        },
        {
          name: "block guest payment above 10000",
          priority: 3,
          condition: function (R, f) {
            R.when(
              f.customerType &&
              f.transactionTotal > 10000 &&
              f.customerType == "guest"
            );
          },
          consequence: function (R, f) {
            f.result = false;
            R.stop();
          },
        },
        {
          name: "is customer guest?",
          priority: 2,
          condition: function (R, f) {
            R.when(!f.userLoggedIn);
          },
          consequence: function (R, f) {
            f.customerType = "guest";
            // the fact has been altered above, so all rules will run again since ignoreFactChanges is not set.
            R.next();
          },
        },
        {
          name: "block Cashcard Payment",
          priority: 1,
          condition: function (R, f) {
            R.when(f.cardType == "Cash Card");
          },
          consequence: function (R, f) {
            f.result = false;
            R.stop();
          },
        },
      ];
      var straightFact = {
        name: "straightFact",
        userCredibility: 1,
        userLoggedIn: true,
        transactionTotal: 12000,
        cardType: "Cash Card",
      };

      /** example of a chaned up rule. will take two iterations. ****/
      var chainedFact = {
        name: "chainedFact",
        userCredibility: 2,
        userLoggedIn: false,
        transactionTotal: 100000,
        cardType: "Credit Card",
      };

      var R = new RuleEngine(rules);
      var isStraightFactFast = false;

      R.execute(chainedFact, function (result) {
        expect(isStraightFactFast).assertTrue();
        done();
      });

      R.execute(straightFact, function (result) {
        isStraightFactFast = true;
      });
    });
  })
}