package com.mediassist.rules;
import java.util.*;
public class DentistryRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("tooth_pain", 3);
        W.put("gum_bleeding", 3);
        W.put("swollen_gums", 3);
        W.put("tooth_sensitivity", 3);
        W.put("jaw_pain", 2);
        W.put("mouth_ulcer", 2);
        W.put("loose_tooth", 2);
        W.put("difficulty_chewing", 2);
        W.put("bad_breath", 2);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Dentistry"; }
}