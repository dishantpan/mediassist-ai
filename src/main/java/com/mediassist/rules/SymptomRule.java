package com.mediassist.rules;

import java.util.List;

public interface SymptomRule {
    boolean matches(List<String> symptoms);
    String getDepartment();
}
