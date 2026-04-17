package com.cybernova.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Webinar {

    private int webinarId;
    private String title;
    private String description;
    private Date webinarDate;
    private String webinarTime;
    private String platform;
    private String speaker;
    private Timestamp createdDate;

    public Webinar() {}

    public int getWebinarId() { return webinarId; }
    public void setWebinarId(int webinarId) { this.webinarId = webinarId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getWebinarDate() { return webinarDate; }
    public void setWebinarDate(Date webinarDate) { this.webinarDate = webinarDate; }

    public String getWebinarTime() { return webinarTime; }
    public void setWebinarTime(String webinarTime) { this.webinarTime = webinarTime; }

    public String getPlatform() { return platform; }
    public void setPlatform(String platform) { this.platform = platform; }

    public String getSpeaker() { return speaker; }
    public void setSpeaker(String speaker) { this.speaker = speaker; }

    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }
}
