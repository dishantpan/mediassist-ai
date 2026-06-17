package com.mediassist.rules;

import java.util.List;
import java.util.Map;

public interface SymptomRule {
    int score(List<String> symptoms);
    String getDepartment();
}