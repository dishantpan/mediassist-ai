// OphthalmologyRule.java
package com.mediassist.rules;
import java.util.List;
public class OphthalmologyRule implements SymptomRule {
    public boolean matches(List<String> s) {
        return s.contains("eye_pain") || s.contains("blurred_vision") ||
                s.contains("eye_redness") || s.contains("watering");
    }
    public String getDepartment() { return "Ophthalmology"; }
}