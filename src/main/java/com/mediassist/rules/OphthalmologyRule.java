package com.mediassist.rules;
import java.util.*;
public class OphthalmologyRule implements SymptomRule {
    private static final Map<String, Integer> W = new HashMap<>();
    static {
        W.put("eye_pain", 3);
        W.put("eye_redness", 3);
        W.put("eye_discharge", 3);
        W.put("sudden_vision_loss", 3);
        W.put("blurred_vision", 3);
        W.put("double_vision", 2);
        W.put("photophobia", 2);
        W.put("itching_eyes", 2);
        W.put("watering", 2);
    }
    public int score(List<String> s) {
        int t = 0;
        for (String x : s) t += W.getOrDefault(x, 0);
        return t;
    }
    public String getDepartment() { return "Ophthalmology"; }
}