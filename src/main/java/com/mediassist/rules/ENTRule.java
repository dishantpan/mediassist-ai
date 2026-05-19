// ENTRule.java
package com.mediassist.rules;
import java.util.List;
public class ENTRule implements SymptomRule {
    public boolean matches(List<String> s) {
        return s.contains("ear_pain") || s.contains("hearing_loss") ||
                s.contains("throat_pain") || s.contains("nose_bleed");
    }
    public String getDepartment() { return "ENT"; }
}