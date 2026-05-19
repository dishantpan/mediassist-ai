// CardiologyRule.java
package com.mediassist.rules;
import java.util.List;
public class CardiologyRule implements SymptomRule {
    public boolean matches(List<String> s) {
        return s.contains("chest_pain") || s.contains("breathlessness") ||
                s.contains("palpitations") || s.contains("dizziness");
    }
    public String getDepartment() { return "Cardiology"; }
}