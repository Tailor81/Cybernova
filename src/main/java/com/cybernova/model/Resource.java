package com.cybernova.model;

import java.sql.Timestamp;

public class Resource {

    private int resourceId;
    private String title;
    private String description;
    private String category;
    private String fileName;
    private String fileType;
    private long fileSize;
    private Timestamp uploadedDate;

    public Resource() {
    }

    public int getResourceId() { return resourceId; }
    public void setResourceId(int resourceId) { this.resourceId = resourceId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public long getFileSize() { return fileSize; }
    public void setFileSize(long fileSize) { this.fileSize = fileSize; }

    public Timestamp getUploadedDate() { return uploadedDate; }
    public void setUploadedDate(Timestamp uploadedDate) { this.uploadedDate = uploadedDate; }

    public String getFileSizeLabel() {
        if (fileSize < 1024) return fileSize + " B";
        if (fileSize < 1024 * 1024) return String.format("%.1f KB", fileSize / 1024.0);
        return String.format("%.1f MB", fileSize / (1024.0 * 1024));
    }

    public String getFileIcon() {
        if (fileType == null) return "fa-file";
        if (fileType.contains("pdf")) return "fa-file-pdf";
        if (fileType.contains("word") || fileType.contains("docx") || fileType.contains("doc")) return "fa-file-word";
        if (fileType.contains("excel") || fileType.contains("xlsx") || fileType.contains("xls")) return "fa-file-excel";
        if (fileType.contains("powerpoint") || fileType.contains("pptx")) return "fa-file-powerpoint";
        if (fileType.contains("zip") || fileType.contains("rar")) return "fa-file-zipper";
        if (fileType.contains("image") || fileType.contains("png") || fileType.contains("jpg")) return "fa-file-image";
        return "fa-file-lines";
    }
}
