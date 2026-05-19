// GeneralRule.java
package com.mediassist.rules;
import java.util.List;
public class GeneralRule implements SymptomRule {
    public boolean matches(List<String> s) {
        return s.contains("fever") || s.contains("cough") ||
                s.contains("cold") || s.contains("weakness") || s.contains("body_ache");
    }
    public String getDepartment() { return "General Medicine"; }
}