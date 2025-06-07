# node-rules

## Introduction

Node-rules is a lightweight forward chaining rule engine.

## How to Install

1. Make sure Node.js has been installed. Then run the following command:

   ```
   ohpm install node-rules@7.2.0
   ```

OpenHarmony
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Import **node-rules** on the target page.

   ```
   import RuleEngine from "node-rules"
   ```

## How to Use

1. Define a rule.
    A rule consists of a condition and its corresponding consequence.
    
      ```
          class Rule {
            condition(R: ESObject) {
              R.when((this as ESObject).transactionTotal < 500);
            }
      
            consequence(R: ESObject) {
              (this as ESObject).result = false;
              (this as ESObject).reason = "The transaction was blocked as it was less than 500";
              R.stop();
            }
          }
      
      
          let rule = new Rule()
      ```

**priority** is an optional parameter and is used to specify the priority of a rule when compared with other rules. In the preceding example rule, **R.when** is used to specify a condition,
and **R.stop** is used to stop further processing on the facts because a consequence is returned.

<span style="color:#ff6700">R.stop</span>, <span style="color:#ff6700">R.when</span>, <span style="color:#ff6700">R.next</span>, and <span style="color:#ff6700">R.restart</span> functions are parts of the flow control API and allow users to control the rule engine flow.

2. Define a fact.
    A fact is an input JSON value that is used by the rule engine to obtain a consequence. Depending on the definition, a fact can have multiple properties.
    
      ```
          let fact: ESObject = {
            name: "user4",
            application: "MOB2",
            transactionTotal: Number.parseInt(this.setValue),
            cardType: "Credit Card"
          }
      ```
    
3. Use the rule engine.
     The following example shows how to use the rule engine to apply sample rules on specific facts. A rule can be passed to the rule engine as a rule array or a single rule object.

       ```
          let ruleEngine = new RuleEngine();
       
           class Rule {
             condition(ruleEngine: ESObject) {
               ruleEngine.when((this as ESObject).transactionTotal < 500);
             }
       
             consequence(ruleEngine: ESObject) {
               (this as ESObject).result = false;
               (this as ESObject).reason = "The transaction was blocked as it was less than 500";
               ruleEngine.stop();
             }
           }
       
       
           let rule = new Rule()
       
       
           ruleEngine.register(rule);
       
       
           let fact: ESObject = {
             name: "user4",
             application: "MOB2",
             transactionTotal: Number.parseInt(this.setValue),
             cardType: "Credit Card"
           }
       
           console.log("------" + this.setValue);
       
           ruleEngine.execute(fact, (data: ESObject) => {
             if (data.result) {
               console.log("Valid transaction: "+ data.result); // The rule is met.
               this.resultStr = "Valid transaction:" + data.result;
             } else {
               console.log("Blocked Reason: "+ data["reason"]); // The rule is not met.
               this.resultStr = "Blocked Reason:" + data["reason"];
             }
       
           })
       ```

4. Control the rules running on the rule engine.
     You can use the **priority** parameter to specify the order in which rules are applied to facts.

       ```
       "priority": 4
       ```

## Available APIs

### Flow Control API

#### R.register

Registers a rule.

#### R.When

Passes the condition expression to be evaluated. In the preceding example, the expressions are used to check whether the **transactionTotal** property of the fact in the context is lower than 500.
If the result passed to **R.when** is **true**, the condition will be executed. Otherwise, the rule engine moves to the next rule, or may terminate if no rule can be applied.

#### R.stop

Used in the result function to instruct the rule engine to stop processing facts. If this API is called, the rule to be applied should be left in time, and the rule engine does not apply other rules to the fact. This API is mainly used when we draw a conclusion on a particular fact and no further processing is required to generate the result.

As shown in the preceding example, when the property of a fact is less than 500, the rule does not need to be processed. Therefore, you can store the **false** in the **result** property and call the **stop** function immediately within the result.

#### R.next

Used in the consequence function, or used to instruct the rule engine to start applying the next rule (if any) to the fact.

#### R.restart

Used inside the result function to instruct the rule engine to apply the rules to the fact from the beginning. When the fact object is modified by the result function and needs to traverse all rules again, the rule engine also uses this function internally. Using **ignoreFactChanges:true** option when a new rule engine is initialized
will disable this function.

#### R.execute

Executes and verifies the facts.

### Dynamic control

#### RuleEngine.turn(<state>,<filter>)
   This function is used to dynamically activate or deactivate a rule. The syntax for using this function is shown in below example.
```
RuleEngine.turn("OFF", {
"id": "one"
});
```
Here RuleEngine is the rule engine instance. The first parameter to turn function indicates whether we need to turn the rule ON or OFF. The second parameter passed to the function is a filter. It should be a key which can be used to uniquely distinguish the targeted rule or set of rules from the other rules running in the Rule Engine. Here the above example will deactivate all the rules where the id attribute equals "one".

#### RuleEngine.prioritize(<priority>,<filter>)
   This function is used to dynamically change the priority of a rule while rule engine is running. It works similar to the Turn function and just that instead of the ON/OFF state we will be passing a priority number value to the function. See example below
```
RuleEngine.prioritize(10, {
"id": "one"
});
```
The above prioritize call will give priority to Rule with id "one" over all the rules which are having lesser priority than 10.

#### RuleEngine.register(<rules>)
   We know that we can pass Rules as parameter into the Rule Engine constructor while we create the Rule Engine object like below.
```
var RuleEngine = new RuleEngine(rules);
```
Where rules can be either an array of rule objects or a single array. But what if we need to add some rules later to the Rule Engine. Register can be used any time to append new rules into the Rule Engine. It can be used like.
```
var RuleEngine = new RuleEngine();
RuleEngine.register(newrule);
RuleEngine.register(newrule);
```

#### RuleEngine.findRules(<filter>)
   This function is used to retrieve the Rules which are registered on the Rule engine which matches the filter we pass as its parameter. A sample usage can be like below.
```
var rules = RuleEngine.findRules({"id": "one"});
```

#### RuleEngine.init()
   This function is used to remove all the rules registered on the Rule Engine. This is mostly used for rule clean up purposes by internal functions. A sample usage can be like below.
```
var RuleEngine = new RuleEngine();
RuleEngine.register(badrule);
RuleEngine.init();//removes the bad rule and cleans up
RuleEngine.register(newrule);
```

## APIS
| Method                  | Parameter                     | Description                                                                                                          |
|-------------------------|-------------------------------|---------------------------------------------------------------------------------------------------------------|
| RuleEngine.register()   | rules: Array<Rule> : Rule     | pass Rules as parameter into the Rule Engine constructor while we create the Rule Engine object like below    |
| RuleEngine.When()       | outcome: boolean              | Passes the condition expression to be evaluated                                                               |
| RuleEngine.stop()       |                               | Used in the result function to instruct the rule engine to stop processing facts                              |
| RuleEngine.next()       |                               | Used in the consequence function                                                                              |
| RuleEngine.restart()    |                               | Used inside the result function to instruct the rule engine to apply the rules to the fact from the beginning |
| RuleEngine.execute()    | fact:Object, callback:Function| Executes and verifies the facts                                                                               |
| RuleEngine.init()       |                               | remove all the rules registered on the Rule Engine                                                            |
| RuleEngine.sync()       | fact:Object, callback:Function| sync                                                                                                          |
| RuleEngine.nextTick()   | callback:Function             | nextTick                                                                                                      |
| RuleEngine.findRules()  | filter:Object                 | retrieve the Rules which are registered on the Rule engine which matches the filter we pass as its parameter  |
| RuleEngine.turn()       | state:string, filter:Object   | dynamically activate or deactivate a rule                                                                     |
| RuleEngine.prioritize() | priority:number, filter:Object| dynamically change the priority of a rule while rule engine is running                                        |


## Constraints

This project has been verified in the following version:<br>DevEco Studio 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/nodeRulesDemo/LICENSE).

