package com.mediassist.model;

public class Consultation {
    private int id;
    private int userId;
    private String symptomsSelected;
    private String departmentSuggested;
    private String consultationDate;

    public Consultation() {}

    public Consultation(int id, int userId, String symptomsSelected,
                        String departmentSuggested, String consultationDate) {
        this.id = id;
        this.userId = userId;
        this.symptomsSelected = symptomsSelected;
        this.departmentSuggested = departmentSuggested;
        this.consultationDate = consultationDate;
    }

    public int getId()                     { return id; }
    public int getUserId()                 { return userId; }
    public String getSymptomsSelected()    { return symptomsSelected; }
    public String getDepartmentSuggested() { return departmentSuggested; }
    public String getConsultationDate()    { return consultationDate; }

    public void setId(int id)                          { this.id = id; }
    public void setUserId(int userId)                  { this.userId = userId; }
    public void setSymptomsSelected(String s)          { this.symptomsSelected = s; }
    public void setDepartmentSuggested(String d)       { this.departmentSuggested = d; }
    public void setConsultationDate(String date)       { this.consultationDate = date; }
}