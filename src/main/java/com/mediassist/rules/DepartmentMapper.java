package com.mediassist.rules;

import java.util.List;

public class DepartmentMapper {

    private final List<SymptomRule> rules = List.of(
            new CardiologyRule(),
            new NeurologyRule(),
            new OrthopedicRule(),
            new ENTRule(),
            new OphthalmologyRule(),
            new DermatologyRule(),
            new GastroRule(),
            new PsychiatryRule(),
            new UrologyRule(),
            new EndocrinologyRule(),
            new DentistryRule(),
            new GeneralRule()
    );

    public String suggest(List<String> symptoms) {

        // ============================================
        // TIER 0 — EMERGENCY RED FLAGS
        // Yeh combinations OPD ke liye nahi hain
        // Emergency department jaana chahiye
        // ============================================

        // Heart Attack
        if (symptoms.contains("chest_pain")
                && symptoms.contains("breathlessness")
                && symptoms.contains("fainting"))
            return "⚠️ EMERGENCY — Possible Heart Attack. Go to Casualty immediately!";

        // Stroke
        if ((symptoms.contains("blurred_speech")
                || symptoms.contains("one_sided_weakness")
                || symptoms.contains("facial_droop"))
                && symptoms.contains("severe_headache"))
            return "⚠️ EMERGENCY — Possible Stroke. Go to Casualty immediately!";

        // Meningitis
        if (symptoms.contains("severe_headache")
                && symptoms.contains("neck_stiffness")
                && symptoms.contains("fever"))
            return "⚠️ EMERGENCY — Possible Meningitis. Go to Casualty immediately!";

        // Active Seizure
        if (symptoms.contains("seizures")
                && symptoms.contains("loss_of_consciousness"))
            return "⚠️ EMERGENCY — Active Seizure. Go to Casualty immediately!";

        // GI Bleed with shock
        if ((symptoms.contains("blood_in_stool")
                || symptoms.contains("vomiting_blood"))
                && symptoms.contains("fainting"))
            return "⚠️ EMERGENCY — Possible GI Bleed. Go to Casualty immediately!";

        // ============================================
        // TIER 1 — PATHOGNOMONIC SYMPTOMS
        // Ek symptom = 100% ek department
        // All 3 AI research agree on these
        // ============================================

        // Neurology — stroke signs
        if (symptoms.contains("blurred_speech"))
            return "Neurology";

        if (symptoms.contains("seizures"))
            return "Neurology";

        if (symptoms.contains("facial_droop"))
            return "Neurology";

        if (symptoms.contains("one_sided_weakness"))
            return "Neurology";

        // Gastroenterology
        if (symptoms.contains("jaundice"))
            return "Gastroenterology";

        // Endocrinology
        if (symptoms.contains("thyroid_swelling"))
            return "Endocrinology";

        // Psychiatry
        if (symptoms.contains("hallucinations"))
            return "Psychiatry";

        if (symptoms.contains("suicidal_thoughts"))
            return "Psychiatry";

        // Orthopedic
        if (symptoms.contains("fracture"))
            return "Orthopedic";

        // Urology
        if (symptoms.contains("blood_in_urine"))
            return "Urology";

        // Dentistry — only if no major systemic symptoms
        boolean hasMajorSystemic = symptoms.contains("chest_pain")
                || symptoms.contains("severe_headache")
                || symptoms.contains("breathlessness")
                || symptoms.contains("fever");

        if (!hasMajorSystemic
                && (symptoms.contains("tooth_pain")
                || symptoms.contains("swollen_gums")))
            return "Dentistry";

        // ============================================
        // TIER 2 — DIAGNOSTIC COMBINATIONS
        // Research validated clinical combinations
        // All 3 researches support these
        // ============================================

        // --- CARDIOLOGY ---
        // Classic ACS combination
        if (symptoms.contains("chest_pain")
                && symptoms.contains("palpitations"))
            return "Cardiology";

        if (symptoms.contains("chest_pain")
                && symptoms.contains("breathlessness"))
            return "Cardiology";

        if (symptoms.contains("chest_pain")
                && symptoms.contains("fainting"))
            return "Cardiology";

        if (symptoms.contains("chest_pain")
                && symptoms.contains("leg_swelling"))
            return "Cardiology";

        // Heart failure combination
        if (symptoms.contains("breathlessness")
                && symptoms.contains("leg_swelling"))
            return "Cardiology";

        // --- NEUROLOGY ---
        // Stroke cluster (without facial droop already caught above)
        if (symptoms.contains("severe_headache")
                && symptoms.contains("numbness"))
            return "Neurology";

        if (symptoms.contains("severe_headache")
                && symptoms.contains("blurred_vision")
                && symptoms.contains("vomiting"))
            return "Neurology";

        if (symptoms.contains("tremors")
                && symptoms.contains("memory_loss"))
            return "Neurology";

        if (symptoms.contains("numbness")
                && symptoms.contains("loss_of_balance"))
            return "Neurology";

        // --- ENDOCRINOLOGY ---
        // Diabetes Triad — all 3 researches confirm this
        if (symptoms.contains("excessive_thirst")
                && symptoms.contains("excessive_hunger")
                && symptoms.contains("frequent_urination"))
            return "Endocrinology";

        if (symptoms.contains("excessive_thirst")
                && symptoms.contains("unexplained_weight_change"))
            return "Endocrinology";

        // Hypothyroidism combination
        if (symptoms.contains("heat_cold_intolerance")
                && symptoms.contains("unexplained_weight_change"))
            return "Endocrinology";

        if (symptoms.contains("excessive_sweating")
                && symptoms.contains("unexplained_weight_change")
                && symptoms.contains("palpitations"))
            return "Endocrinology";

        // --- UROLOGY ---
        // UTI combination
        if (symptoms.contains("burning_urination")
                && symptoms.contains("frequent_urination"))
            return "Urology";

        // Kidney stone combination
        if (symptoms.contains("kidney_pain")
                && symptoms.contains("burning_urination"))
            return "Urology";

        if (symptoms.contains("kidney_pain")
                && symptoms.contains("difficulty_urinating"))
            return "Urology";

        // --- PSYCHIATRY ---
        // Anxiety disorder combination
        if (symptoms.contains("panic_attacks")
                && symptoms.contains("anxiety"))
            return "Psychiatry";

        if (symptoms.contains("anxiety")
                && symptoms.contains("insomnia")
                && symptoms.contains("depression"))
            return "Psychiatry";

        if (symptoms.contains("depression")
                && symptoms.contains("mood_swings"))
            return "Psychiatry";

        // --- OPHTHALMOLOGY ---
        // Acute glaucoma combination
        if (symptoms.contains("eye_pain")
                && symptoms.contains("blurred_vision"))
            return "Ophthalmology";

        if (symptoms.contains("eye_pain")
                && symptoms.contains("eye_redness"))
            return "Ophthalmology";

        if (symptoms.contains("eye_redness")
                && symptoms.contains("eye_discharge"))
            return "Ophthalmology";

        if (symptoms.contains("sudden_vision_loss"))
            return "Ophthalmology";

        // --- ENT ---
        // Otitis media combination
        if (symptoms.contains("ear_pain")
                && symptoms.contains("hearing_loss"))
            return "ENT";

        if (symptoms.contains("ear_pain")
                && symptoms.contains("ear_discharge"))
            return "ENT";

        // Meniere's disease
        if (symptoms.contains("hearing_loss")
                && symptoms.contains("tinnitus"))
            return "ENT";

        if (symptoms.contains("throat_pain")
                && symptoms.contains("difficulty_swallowing"))
            return "ENT";

        if (symptoms.contains("nasal_blockage")
                && symptoms.contains("sinus_pain"))
            return "ENT";

        // --- DERMATOLOGY ---
        if (symptoms.contains("skin_rash")
                && symptoms.contains("itching"))
            return "Dermatology";

        if (symptoms.contains("skin_lesions")
                && symptoms.contains("itching"))
            return "Dermatology";

        if (symptoms.contains("hair_loss")
                && symptoms.contains("nail_changes"))
            return "Dermatology";

        // --- GASTROENTEROLOGY ---
        if (symptoms.contains("stomach_pain")
                && symptoms.contains("vomiting")
                && symptoms.contains("diarrhea"))
            return "Gastroenterology";

        if (symptoms.contains("blood_in_stool")
                && symptoms.contains("stomach_pain"))
            return "Gastroenterology";

        if (symptoms.contains("stomach_pain")
                && symptoms.contains("bloating")
                && symptoms.contains("acidity"))
            return "Gastroenterology";

        // --- ORTHOPEDIC ---
        if (symptoms.contains("joint_pain")
                && symptoms.contains("stiffness"))
            return "Orthopedic";

        if (symptoms.contains("joint_pain")
                && symptoms.contains("swelling"))
            return "Orthopedic";

        if (symptoms.contains("back_pain")
                && symptoms.contains("numbness"))
            return "Orthopedic";

        if (symptoms.contains("neck_pain")
                && symptoms.contains("stiffness"))
            return "Orthopedic";

        // --- DENTISTRY ---
        if (symptoms.contains("tooth_pain")
                && symptoms.contains("gum_bleeding"))
            return "Dentistry";

        if (symptoms.contains("jaw_pain")
                && symptoms.contains("tooth_sensitivity"))
            return "Dentistry";

        // ============================================
        // TIER 3 — WEIGHTED SCORING
        // Fallback — jab koi Tier 0/1/2 match nahi hua
        // Weights based on all 3 research sources
        // ============================================

        String bestDept = "General Medicine";
        int highestScore = 0;

        for (SymptomRule rule : rules) {
            int score = rule.score(symptoms);
            if (score > highestScore) {
                highestScore = score;
                bestDept = rule.getDepartment();
            }
        }

        return bestDept;
    }
}