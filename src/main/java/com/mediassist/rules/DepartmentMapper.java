package com.mediassist.rules;

import java.util.List;

public class DepartmentMapper {

    private final List<SymptomRule> rules = List.of(
            new CardiologyRule(),    // High priority
            new NeurologyRule(),
            new OrthopedicRule(),
            new ENTRule(),
            new OphthalmologyRule(),
            new DermatologyRule(),
            new GastroRule(),
            new GeneralRule()        // Last — default fallback
    );

    public String suggest(List<String> symptoms) {
        for (SymptomRule rule : rules) {
            if (rule.matches(symptoms)) {
                return rule.getDepartment();
            }
        }
        return "General Medicine"; // Ultimate fallback
    }
}