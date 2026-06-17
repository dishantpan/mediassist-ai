package com.mediassist.rules;
import java.util.*;
public class ENTRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("ear_pain", 3);
        W.put("hearing_loss", 3);
        W.put("throat_pain", 3);
        W.put("nose_bleed", 3);
        W.put("sinus_pain", 3);
        W.put("ear_discharge", 3);
        W.put("nasal_blockage", 2);
        W.put("tinnitus", 2);
        W.put("voice_change", 2);
        W.put("difficulty_swallowing", 2);
        W.put("sneezing", 1);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "ENT"; }
}