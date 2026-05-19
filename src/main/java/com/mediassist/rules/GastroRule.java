// GastroRule.java
package com.mediassist.rules;
import java.util.List;
public class GastroRule implements SymptomRule {
    public boolean matches(List<String> s) {
        return s.contains("stomach_pain") || s.contains("vomiting") ||
                s.contains("diarrhea") || s.contains("acidity") || s.contains("bloating");
    }
    public String getDepartment() { return "Gastroenterology"; }
}