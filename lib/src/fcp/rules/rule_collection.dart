import 'dart:collection';

import 'package:free_chat/src/fcp/rules/rule_persistent_get.dart';
import 'package:free_chat/src/fcp/rules/rules.dart';

/// Collects all [Rule]s
class RuleCollection {

  /// Point of extandability bei adding new rules which get handled in [rules]
  /// Add new rules
  static final List<Rule> rules = [RulePersistentGet(),
    RulePersistentPut(), RulePutSuccessful(), RuleGetFailed(), RuleAllDate(),
    RuleDataFound(), RuleProtocolError(), RuleSimpleProgress(),
    RuleSubscribedUSKUpdate()];
  static final Map<String, Rule> ruleMap = getRuleMap();

  /// Return the List of [rules] as a Map with name and rule
  ///
  /// eg. {"AllData": [RuleAllDate]}
  static getRuleMap() {
    Map ruleMap = HashMap<String, Rule>();
    for (Rule rule in rules) {
      ruleMap.putIfAbsent(rule.getKey(), () => rule);
    }
    return ruleMap;
  }
}