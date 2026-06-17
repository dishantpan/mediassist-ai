package com.mediassist.rules;
import java.util.*;
public class EndocrinologyRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("excessive_thirst", 3);
        W.put("thyroid_swelling", 3);
        W.put("heat_cold_intolerance", 3);
        W.put("excessive_hunger", 2);
        W.put("unexplained_weight_change", 2);
        W.put("excessive_sweating", 2);
        W.put("frequent_urination", 2);
        W.put("neck_swelling", 2);
        W.put("fatigue", 1);
        W.put("weakness", 1);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Endocrinology"; }
}