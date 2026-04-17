package com.cybernova.model;

import java.sql.Timestamp;

public class WebinarRegistration {

    private int registrationId;
    private int webinarId;
    private String fullName;
    private String email;
    private String organisation;
    private String phone;
    private Timestamp registrationDate;

    public WebinarRegistration() {}

    public int getRegistrationId() { return registrationId; }
    public void setRegistrationId(int registrationId) { this.registrationId = registrationId; }

    public int getWebinarId() { return webinarId; }
    public void setWebinarId(int webinarId) { this.webinarId = webinarId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getOrganisation() { return organisation; }
    public void setOrganisation(String organisation) { this.organisation = organisation; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Timestamp getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Timestamp registrationDate) { this.registrationDate = registrationDate; }
}
