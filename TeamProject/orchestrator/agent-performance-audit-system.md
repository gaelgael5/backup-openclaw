# AGENT PERFORMANCE AUDIT SYSTEM

## 📊 MÉTRIQUES DE PERFORMANCE

### Tracking Automatique
```yaml
Performance Metrics per Agent:
  success_rate:
    - completed_tasks / total_tasks (rolling 7 days)
    - target: >85%
    - critical_threshold: <70%
  
  resolution_time:
    - average_minutes_to_completion
    - baseline_per_task_complexity
    - alert_threshold: >200% baseline
  
  quality_metrics:
    - rework_required_percentage
    - user_satisfaction_feedback
    - deliverable_completeness_score
  
  expertise_indicators:
    - first_time_success_rate
    - research_depth_before_action
    - methodology_systematic_vs_adhoc
```

### Baseline Standards par Agent
```yaml
Baselines:
  dev-flutter:
    success_rate_target: 90%
    avg_resolution_time: 45 minutes
    rework_threshold: 10%
    
  dev-python:  
    success_rate_target: 85%
    avg_resolution_time: 60 minutes
    rework_threshold: 15%
    
  strategist:
    success_rate_target: 95%
    avg_resolution_time: 120 minutes
    rework_threshold: 5%
```

## 🔍 PATTERN DETECTION ENGINE

### Automatic Trigger Conditions
```yaml
Audit Triggers:
  mission_critical_failure:
    - priority: MAXIMUM + status: FAILED
    - impact: blocks pipeline progression
    - automatic_audit: immediate
    
  repeated_failure_pattern:
    - same_agent + same_error_type >= 3x
    - timeframe: 30 days
    - automatic_audit: after 3rd occurrence
    
  performance_degradation:
    - success_rate drops >15% vs baseline
    - resolution_time increases >100%
    - automatic_audit: weekly check
    
  user_frustration_signals:
    - explicit_negative_feedback
    - multiple_agent_relaunches
    - escalation_requests
```

### Gap Analysis Framework
```yaml
Skills Gap Categories:
  technical_expertise:
    indicators:
      - solutions_surface_level_vs_root_cause
      - unfamiliarity_with_domain_tools
      - outdated_approaches_vs_modern_practices
    examples:
      - "flutter pub get fails" → dependency_overrides band-aid
      - vs systematic dependency conflict resolution
      
  methodology_gaps:
    indicators:
      - no_research_before_action
      - trial_error_vs_systematic_approach
      - missing_local_testing_validation
    examples:
      - commits code without local build testing
      - doesn't search Stack Overflow for known issues
      
  quality_standards:
    indicators:
      - incomplete_deliverables
      - missing_documentation
      - no_verification_before_reporting_complete
    examples:
      - reports "mission complete" but files not in workspace
      - no commit messages explaining technical decisions
```

## 📋 AUDIT REPORT TEMPLATES

### Standard Performance Audit
```markdown
# AGENT PERFORMANCE AUDIT REPORT

**Agent:** {agent_id}
**Audit Date:** {timestamp}  
**Trigger:** {mission_failure | pattern_detected | performance_decline}
**Auditor:** orchestrator

## PERFORMANCE METRICS ANALYSIS

### Current Performance (30-day window)
- **Success Rate:** {current_rate}% (baseline: {baseline}%, target: >85%)
- **Avg Resolution Time:** {current_time} min (baseline: {baseline_time} min)
- **Rework Required:** {rework_rate}% (target: <10%)
- **User Satisfaction:** {satisfaction_score}/5

### Performance Trends
- **Week 1:** {week1_metrics}
- **Week 2:** {week2_metrics}  
- **Week 3:** {week3_metrics}
- **Week 4:** {week4_metrics}
- **Trend Direction:** {improving | stable | declining}

## FAILURE PATTERN ANALYSIS

### Repeated Issues Identified
1. **{error_category_1}:** {frequency} occurrences
   - Examples: {specific_mission_examples}
   - Root Cause: {technical | methodological | knowledge_gap}
   
2. **{error_category_2}:** {frequency} occurrences
   - Examples: {specific_mission_examples}
   - Root Cause: {technical | methodological | knowledge_gap}

### Missing Competencies Detected
**Technical Skills:**
- {missing_technical_skill_1}: Evidence: {specific_examples}
- {missing_technical_skill_2}: Evidence: {specific_examples}

**Methodology:**
- {missing_methodology_1}: Evidence: {specific_examples}
- {missing_methodology_2}: Evidence: {specific_examples}

**Research & Learning:**
- {missing_research_skill_1}: Evidence: {specific_examples}

## RECOMMENDATIONS

### Profile Enhancement Required
**Current Assessed Level:** {junior | intermediate | senior}
**Recommended Target Level:** {intermediate | senior | expert}

### Specific Competency Additions
```yaml
Enhanced Profile Requirements:
  technical_expertise:
    - {specific_domain_knowledge}
    - {specific_tools_mastery}
    - {specific_troubleshooting_skills}
    
  methodology_improvements:
    - {systematic_approach_definition}
    - {quality_gate_requirements}
    - {documentation_standards}
    
  research_protocol:
    - {information_sources_integration}
    - {validation_requirements}
    - {continuous_learning_approach}
```

### Implementation Priority Matrix
**HIGH PRIORITY (Critical for mission success):**
- {critical_skill_1}: Blocks {percentage}% of current mission types
- {critical_skill_2}: Causes {percentage}% of current failures

**MEDIUM PRIORITY (Efficiency improvement):**
- {important_skill_1}: Reduces resolution time by ~{percentage}%
- {important_skill_2}: Improves quality by ~{percentage}%

**LOW PRIORITY (Future enhancement):**
- {nice_to_have_1}: Enables advanced mission types
- {nice_to_have_2}: Improves user experience

### Success Metrics Definition
Post-implementation targets:
- **Success Rate:** ≥95%
- **Resolution Time:** ≤{target_time} minutes  
- **Rework Required:** ≤5%
- **User Satisfaction:** ≥4.5/5

### Implementation Confidence
- **Evidence Strength:** {strong | moderate | weak}
- **Solution Certainty:** {high | medium | low}
- **Implementation Effort:** {low | medium | high}
- **Expected Timeline:** {immediate | 1-week | 1-month}

## FOLLOW-UP PLAN

### Monitoring Schedule
- **Week 1:** Daily performance check
- **Week 2-4:** Bi-daily performance check  
- **Month 2:** Weekly performance review
- **Quarter 1:** Full re-audit

### Success Validation Criteria
✅ Zero repeated failures of same issue type
✅ Success rate consistently >95% 
✅ Resolution time within target range
✅ Positive user feedback on deliverable quality

---

**Recommendation Status:** {draft | proposed | approved | implemented}
**Next Action:** {propose_to_user | implement_changes | monitor_current}
```

### Quick Assessment Template
```markdown
# QUICK AGENT ASSESSMENT

**Agent:** {agent_id} | **Date:** {date} | **Issue:** {brief_description}

## PROBLEM
{1-sentence_problem_description}

## EVIDENCE  
- Performance: {metric} vs {baseline}
- Pattern: {error_type} occurred {frequency}x
- Impact: {mission_type} blocked for {duration}

## ROOT CAUSE
{technical_gap | methodology_gap | research_gap}

## RECOMMENDATION
{current_level} → {target_level}
+{key_competency_1} +{key_competency_2}

## EXPECTED IMPACT
Success rate: {current}% → {target}%
Resolution time: {current}min → {target}min

**Confidence:** {high | medium | low}
**Priority:** {critical | high | medium | low}
```

## 🔄 CONTINUOUS IMPROVEMENT CYCLE

### Weekly Performance Review
```yaml
Automated Weekly Tasks:
  1. collect_performance_metrics_all_agents()
  2. identify_declining_performance_trends()
  3. detect_new_failure_patterns()
  4. generate_improvement_recommendations()
  5. update_agent_skill_matrices()
  6. report_team_optimization_opportunities()
```

### Monthly Strategic Assessment
```yaml
Monthly Deep Dive:
  1. analyze_mission_complexity_vs_agent_capabilities()
  2. identify_emerging_technology_skill_gaps()
  3. assess_cross_agent_collaboration_effectiveness()
  4. recommend_team_composition_optimizations()
  5. plan_proactive_skill_development_roadmap()
```

### Quarterly Skill Evolution Planning
```yaml
Quarterly Planning:
  1. benchmark_against_industry_best_practices()
  2. identify_future_mission_complexity_trends()
  3. plan_strategic_agent_specializations()
  4. design_cross_training_opportunities()
  5. set_team_performance_improvement_targets()
```

---

**System Status:** Active and Monitoring
**Last Updated:** 2026-03-04
**Version:** 2.0 (Agent Performance Auditor Integration)