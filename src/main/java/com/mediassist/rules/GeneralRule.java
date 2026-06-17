package com.mediassist.rules;
import java.util.*;
public class GeneralRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("fever", 3);
        W.put("cough", 2);
        W.put("cold", 2);
        W.put("body_ache", 2);
        W.put("weakness", 1);
        W.put("fatigue", 1);
        W.put("loss_of_appetite", 2);
        W.put("chills", 2);
        W.put("runny_nose", 2);
        W.put("sneezing", 1);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "General Medicine"; }
}