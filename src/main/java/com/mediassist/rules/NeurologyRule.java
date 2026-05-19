// NeurologyRule.java
package com.mediassist.rules;
import java.util.List;
public class NeurologyRule implements SymptomRule {
    public boolean matches(List<String> s) {
        return s.contains("severe_headache") || s.contains("seizures") ||
                s.contains("numbness") || s.contains("blurred_speech");
    }
    public String getDepartment() { return "Neurology"; }
}