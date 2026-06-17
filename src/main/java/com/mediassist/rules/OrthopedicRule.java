package com.mediassist.rules;
import java.util.*;
public class OrthopedicRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("joint_pain", 3);
        W.put("fracture", 3);
        W.put("back_pain", 3);
        W.put("neck_pain", 3);
        W.put("stiffness", 2);
        W.put("limb_pain", 2);
        W.put("inability_to_bear_weight", 2);
        W.put("muscle_weakness", 1);
        W.put("swelling", 1);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Orthopedic"; }
}