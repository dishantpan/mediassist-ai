package com.mediassist.rules;
import java.util.*;
public class NeurologyRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("seizures", 3);
        W.put("blurred_speech", 3);
        W.put("tremors", 3);
        W.put("facial_droop", 3);
        W.put("one_sided_weakness", 3);
        W.put("severe_headache", 2);
        W.put("numbness", 2);
        W.put("memory_loss", 2);
        W.put("loss_of_balance", 2);
        W.put("gait_disturbance", 2);
        W.put("dizziness", 1);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Neurology"; }
}