package com.cybernova.util;

import java.util.regex.Pattern;

public class InputValidator {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    private static final Pattern PHONE_PATTERN = Pattern.compile(
            "^[+]?[0-9\\s\\-()]{7,20}$"
    );

    public static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        return !isBlank(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (isBlank(phone)) {
            return true;
        }
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean meetsMinimumLength(String value, int minimumLength) {
        return !isBlank(value) && value.trim().length() >= minimumLength;
    }

    public static String sanitize(String rawInput) {
        if (rawInput == null) {
            return "";
        }
        return rawInput.trim()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}
