package com.cybernova.util;

import com.cybernova.dao.AdminDAO;

public class SetupDatabase {

    public static void main(String[] arguments) {
        try {
            String adminUsername = "admin";
            String adminPassword = "CyberNova2024";

            if (arguments.length >= 2) {
                adminUsername = arguments[0];
                adminPassword = arguments[1];
            }

            String hashedPassword = PasswordHasher.hashPassword(adminPassword);

            AdminDAO adminDAO = new AdminDAO();
            adminDAO.createAdmin(adminUsername, hashedPassword);

            System.out.println("Admin account created successfully");
            System.out.println("Username: " + adminUsername);
            System.out.println("Password: " + adminPassword);
        } catch (Exception setupFailure) {
            System.err.println("Setup failed: " + setupFailure.getMessage());
            setupFailure.printStackTrace();
        }
    }
}
