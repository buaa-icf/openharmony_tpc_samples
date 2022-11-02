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

// @ts-ignore
import RuleEngine from "node-rules";

@Entry
@Component
struct MoreRulesAndFacts {
  @State message: string = 'Hello World'
  @State resultStr: string = "";
  controller: TextAreaController = new TextAreaController();
  @State arrayStr: Array<string> = [];

  ruleEngineExecute(): void {
    var ruleEngine = new RuleEngine();
    var rules = [
      /**** Rule 1 ****/
      {
        "name": "transaction minimum 500",
        "priority": 3,
        "on": true,
        "condition": function (R) {
          R.when(this.transactionTotal < 500);
        },
        "consequence": function (R) {
          console.log("Rule 1 matched - blocks transactions below value 500. Rejecting payment.");
          this.result = false;
          R.stop();
        }
      },

      /**** Rule 2 ****/
      {
        "name": "high credibility customer - avoid checks and bypass",
        "priority": 2,
        "on": true,
        "condition": function (R) {
          R.when(this.userCredibility && this.userCredibility > 5);
        },
        "consequence": function (R) {
          console.log("Rule 2 matched - user credibility is more, then avoid further check. Accepting payment.");
          this.result = true;
          R.stop();
        }
      },

      /**** Rule 3 ****/
      {
        "name": "block AME > 10000",
        "priority": 4,
        "on": true,
        "condition": function (R) {
          R.when(this.cardType == "Credit Card" && this.cardIssuer == "American Express" && this.transactionTotal > 1000);
        },
        "consequence": function (R) {
          console.log("Rule 3 matched - filter American Express payment above 10000. Rejecting payment.");
          this.result = false;
          R.stop();
        }
      },

      /**** Rule 4 ****/
      {
        "name": "block Cashcard Payment",
        "priority": 8,
        "on": true,
        "condition": function (R) {
          R.when(this.cardType == "Cash Card");
        },
        "consequence": function (R) {
          console.log("Rule 4 matched - reject the payment if cash card. Rejecting payment.");
          this.result = false;
          R.stop();
        }
      },

      /**** Rule 5 ****/
      {
        "name": "block guest payment above 10000",
        "priority": 6,
        "on": true,
        "condition": function (R) {
          R.when(this.customerType && this.transactionTotal > 10000 && this.customerType == "guest");
        },
        "consequence": function (R) {
          console.log("Rule 5 matched - reject if above 10000 and customer type is guest. Rejecting payment.");
          this.result = false;
          R.stop();
        }
      },

      /**** Rule 6 ****/
      {
        "name": "is customer guest?",
        "priority": 7,
        "on": true,
        "condition": function (R) {
          R.when(!this.userLoggedIn);
        },
        "consequence": function (R) {
          console.log("Rule 6 matched - support rule written for blocking payment above 10000 from guests.");
          console.log("Process left to chain with rule 5.")
          this.customerType = "guest";
          R.stop(); // this fact has been altered, so all rules will run again. No need to restart.
        }
      },

      /**** Rule 7 ****/
      {
        "name": "block payment from specific app",
        "priority": 5,
        "on": true,
        "condition": function (R) {
          R.when(this.appCode && this.appCode === "MOBI4");
        },
        "consequence": function (R) {
          console.log("Rule 7 matched - block payment from Mobile. Reject Payment");
          this.result = false;
          R.stop();
        }
      },

      /**** Rule 8 ****/
      {
        "name": "event risk score",
        "priority": 2,
        "on": true,
        "condition": function (R) {
          R.when(this.eventRiskFactor && this.eventRiskFactor < 5);
        },
        "consequence": function (R) {
          console.log("Rule 8 matched - the event is not critical, so accept.");
          this.result = true;
          R.stop();
        }
      },

      /**** Rule 9 ****/
      {
        "name": "block ip range set",
        "priority": 3,
        "on": true,
        "condition": function (R) {
          var ipList = ["10.X.X.X", "12.122.X.X", "12.211.X.X", "64.X.X.X", "64.23.X.X", "74.23.211.92"]
          var allowedRegexp = new RegExp("^(?:" + ipList.join("|").replace(/\./g, "\\.").replace(/X/g, "[^.]+") + ")$");
          R.when(this.userIP && this.userIP.match(allowedRegexp));
        },
        "consequence": function (R) {
          console.log("Rule 9 matched - ip falls in the given List, then block. Rejecting payment.");
          this.result = false;
          R.stop();
        }
      },

      /**** Rule 10 ****/
      {
        "name": "check if user's name is blacklisted",
        "priority": 1,
        "on": true,
        "condition": function (R) {
          var blacklist = ["user4"]
          R.when(this && blacklist.indexOf(this.name) > -1);
        },
        "consequence": function (R) {
          console.log("Rule 10 matched - the user is malicious, then block. Rejecting payment.");
          this.result = false;
          R.stop();
        }
      },


    ]

    ruleEngine.register(rules);

    /** example of cash card user, so payment blocked. ****/
    var user1 = {
      "userIP": "10.3.4.5",
      "name": "user1",
      "eventRiskFactor": 6,
      "userCredibility": 1,
      "appCode": "WEB1",
      "userLoggedIn": false,
      "transactionTotal": 12000,
      "cardType": "Cash Card",
      "cardIssuer": "OXI"
    }

    var user2 = {
      "userIP": "27.3.4.5",
      "name": "user2",
      "eventRiskFactor": 2,
      "userCredibility": 2,
      "appCode": "MOBI4",
      "userLoggedIn": true,
      "transactionTotal": 500,
      "cardType": "Credit Card",
      "cardIssuer": "VISA"
    }

    var user3 = {
      "userIP": "27.3.4.5",
      "name": "user3",
      "eventRiskFactor": 2,
      "userCredibility": 2,
      "appCode": "WEB1",
      "userLoggedIn": true,
      "transactionTotal": 500,
      "cardType": "Credit Card",
      "cardIssuer": "VISA"
    }

    var user4 = {
      "userIP": "27.3.4.5",
      "name": "user4",
      "eventRiskFactor": 8,
      "userCredibility": 2,
      "appCode": "WEB1",
      "userLoggedIn": true,
      "transactionTotal": 500,
      "cardType": "Credit Card",
      "cardIssuer": "VISA"
    }

    var user5 = {
      "userIP": "27.3.4.5",
      "name": "user5",
      "eventRiskFactor": 8,
      "userCredibility": 8,
      "appCode": "WEB1",
      "userLoggedIn": true,
      "transactionTotal": 500,
      "cardType": "Credit Card",
      "cardIssuer": "VISA"
    }

    var user6 = {
      "userIP": "10.3.4.5",
      "name": "user6",
      "eventRiskFactor": 8,
      "userCredibility": 2,
      "appCode": "WEB1",
      "userLoggedIn": true,
      "transactionTotal": 500,
      "cardType": "Credit Card",
      "cardIssuer": "VISA"
    }

    var user7 = {
      "userIP": "27.3.4.5",
      "name": "user7",
      "eventRiskFactor": 2,
      "userCredibility": 2,
      "appCode": "WEB1",
      "userLoggedIn": false,
      "transactionTotal": 100000,
      "cardType": "Credit Card",
      "cardIssuer": "VISA"
    }

    var user8 = {
      "userIP": "27.3.4.5",
      "name": "user8",
      "eventRiskFactor": 8,
      "userCredibility": 2,
      "appCode": "WEB1",
      "userLoggedIn": true,
      "transactionTotal": 500,
      "cardType": "Credit Card",
      "cardIssuer": "VISA"
    }


    console.log("-----------");
    console.log("start execution of rules");
    this.arrayStr.push("start execution of rules")
    console.log("-----------");

    ruleEngine.execute(user7, (result) => {
      if (result.result) {
        console.log("Completed " + "User7 Accepted");
        this.arrayStr.push("Completed " + "User7 Accepted");
      } else {
        console.log("Completed " + "User7 Rejected");
        this.arrayStr.push("Completed " + "User7 Rejected");
      }
    })

    ruleEngine.execute(user1, (result) => {
      if (result.result) {
        console.log("Completed " + "User1 Accepted");
        this.arrayStr.push("Completed " + "User1 Accepted");
      } else {
        console.log("Completed " + "User1 Rejected");
        this.arrayStr.push("Completed " + "User1 Rejected");
      }
    })

    ruleEngine.execute(user2, (result) => {
      if (result.result) {
        console.log("Completed " + "User2 Accepted");
        this.arrayStr.push("Completed " + "User2 Accepted");
      } else {
        console.log("Completed " + "User2 Rejected");
        this.arrayStr.push("Completed " + "User2 Rejected");
      }

    })

    ruleEngine.execute(user3, (result) => {
      if (result.result) {
        console.log("Completed " + "User3 Accepted");
        this.arrayStr.push("Completed " + "User3 Accepted");
      } else {
        console.log("Completed " + "User3 Rejected");
        this.arrayStr.push("Completed " + "User3 Rejected");
      }
    })

    ruleEngine.execute(user4, (result) => {
      if (result.result) {
        console.log("Completed " + "User4 Accepted");
        this.arrayStr.push("Completed " + "User4 Accepted");
      } else {
        console.log("Completed " + "User4 Rejected");
        this.arrayStr.push("Completed " + "User4 Rejected");
      }

    })

    ruleEngine.execute(user5, (result) => {
      if (result.result) {
        console.log("Completed " + " User5 Accepted");
        this.arrayStr.push("Completed " + "User5 Accepted");
      } else {
        console.log("Completed " + "User5 Rejected");
        this.arrayStr.push("Completed " + "User5 Rejected");
      }
    })

    ruleEngine.execute(user6, (result) => {
      if (result.result) {
        console.log("Completed " + "User6 Accepted");
        this.arrayStr.push("Completed " + "User6 Accepted");
      } else {
        console.log("Completed " + "User6 Rejected");
        this.arrayStr.push("Completed " + "User6 Rejected");
      }

    })

    ruleEngine.execute(user8, (result) => {
      if (result.result) {
        console.log("Completed " + "User8 Accepted");
        this.arrayStr.push("Completed " + "User8 Accepted");
      } else {
        console.log("Completed " + "User8 Rejected");
        this.arrayStr.push("Completed " + "User8 Rejected");
      }
    })


  }

  build() {
    Column() {
      Text("测试多种规则混合")
        .width("90%")
        .height(50)
        .borderRadius(15)
        .fontSize(13)
        .textAlign(TextAlign.Center)
        .margin({ top: 10 })

      Button("点击运行")
        .onClick(() => {
          this.arrayStr = [];
          this.ruleEngineExecute();
        })

      ForEach(this.arrayStr, (item, index) => {
        Text("测试结果：" + item)
          .width("90%")
          .height(30)
          .borderRadius(15)
          .fontSize(13)
          .textAlign(TextAlign.Center)
          .margin({ top: 5 });

      })

    }
    .width('100%')
    .padding({ top: 10, left: 3, right: 3 })
  }
}