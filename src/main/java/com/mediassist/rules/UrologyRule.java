package com.mediassist.rules;
import java.util.*;
public class UrologyRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("burning_urination", 3);
        W.put("blood_in_urine", 3);
        W.put("difficulty_urinating", 3);
        W.put("kidney_pain", 2);
        W.put("frequent_urination", 2);
        W.put("urgency", 2);
        W.put("poor_stream", 2);
        W.put("scrotal_pain", 2);
        W.put("incontinence", 2);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Urology"; }
}