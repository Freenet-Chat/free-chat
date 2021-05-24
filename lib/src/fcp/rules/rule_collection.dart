import 'dart:collection';

import 'package:free_chat/src/fcp/rules/rule_persistent_get.dart';
import 'package:free_chat/src/fcp/rules/rules.dart';

class RuleCollection {
  // Add rules
  static final List<Rule> rules = [RulePersistentGet(),
    RulePersistentPut(), RulePutSuccessful(), RuleGetFailed(), RuleAllDate(),
    RuleDataFound(), RuleProtocolError(), RuleSimpleProgress(),
    RuleSubscribedUSKUpdate()];
  static final Map<String, Rule> ruleMap = getRuleMap();

  static getRuleMap() {
    Map ruleMap = HashMap<String, Rule>();
    for (Rule rule in rules) {
      ruleMap.putIfAbsent(rule.getKey(), () => rule);
    }
    return ruleMap;
  }
}