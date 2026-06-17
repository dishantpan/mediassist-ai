package com.mediassist.rules;
import java.util.*;
public class DermatologyRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("skin_rash", 3);
        W.put("skin_lesions", 3);
        W.put("acne", 3);
        W.put("itching", 2);
        W.put("hair_loss", 2);
        W.put("nail_changes", 2);
        W.put("skin_scaling", 2);
        W.put("pigmentation_changes", 2);
        W.put("dandruff", 1);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Dermatology"; }
}