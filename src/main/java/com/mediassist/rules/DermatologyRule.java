// DermatologyRule.java
package com.mediassist.rules;
import java.util.List;
public class DermatologyRule implements SymptomRule {
    public boolean matches(List<String> s) {
        return s.contains("skin_rash") || s.contains("itching") ||
                s.contains("acne") || s.contains("hair_loss");
    }
    public String getDepartment() { return "Dermatology"; }
}