package com.mediassist.rules;
import java.util.*;
public class PsychiatryRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("hallucinations", 3);
        W.put("depression", 3);
        W.put("panic_attacks", 3);
        W.put("suicidal_thoughts", 3);
        W.put("anxiety", 2);
        W.put("insomnia", 2);
        W.put("mood_swings", 2);
        W.put("irritability", 2);
        W.put("poor_concentration", 2);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Psychiatry"; }
}