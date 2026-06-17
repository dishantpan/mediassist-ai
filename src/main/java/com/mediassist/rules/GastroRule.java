package com.mediassist.rules;
import java.util.*;
public class GastroRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("blood_in_stool", 3);
        W.put("jaundice", 3);
        W.put("vomiting_blood", 3);
        W.put("black_stools", 3);
        W.put("stomach_pain", 2);
        W.put("vomiting", 2);
        W.put("diarrhea", 2);
        W.put("acidity", 2);
        W.put("bloating", 2);
        W.put("constipation", 2);
        W.put("loss_of_appetite", 1);
        W.put("nausea", 1);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Gastroenterology"; }
}