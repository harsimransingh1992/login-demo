package com.example.logindemo.service.dto;

public class EmailAttachment {
    private String filename;
    private byte[] content;
    private String contentType;

    public EmailAttachment() {}

    public EmailAttachment(String filename, byte[] content, String contentType) {
        this.filename = filename;
        this.content = content;
        this.contentType = contentType;
    }

    public String getFilename() { return filename; }
    public void setFilename(String filename) { this.filename = filename; }

    public byte[] getContent() { return content; }
    public void setContent(byte[] content) { this.content = content; }

    public String getContentType() { return contentType; }
    public void setContentType(String contentType) { this.contentType = contentType; }
}