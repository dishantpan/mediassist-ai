package com.mediassist.rules;
import java.util.*;
public class CardiologyRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("chest_pain", 3);
        W.put("palpitations", 3);
        W.put("breathlessness", 2);
        W.put("leg_swelling", 2);
        W.put("fainting", 2);
        W.put("dizziness", 1);
        W.put("orthopnea", 3);
        W.put("exertional_chest_pain", 3);
        W.put("exertional_breathlessness", 2);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Cardiology"; }
}