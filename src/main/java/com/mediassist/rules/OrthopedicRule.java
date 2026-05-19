// OrthopedicRule.java
package com.mediassist.rules;
import java.util.List;
public class OrthopedicRule implements SymptomRule {
    public boolean matches(List<String> s) {
        return s.contains("joint_pain") || s.contains("swelling") ||
                s.contains("fracture") || s.contains("back_pain") || s.contains("stiffness");
    }
    public String getDepartment() { return "Orthopedic"; }
}