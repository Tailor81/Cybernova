package com.cybernova.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordHasher {

    private static final int ITERATION_COUNT = 65536;
    private static final int KEY_LENGTH = 256;
    private static final String HASHING_ALGORITHM = "PBKDF2WithHmacSHA256";

    public static String hashPassword(String plainPassword) {
        try {
            byte[] salt = generateSalt();
            byte[] hashedBytes = performHashing(plainPassword, salt);
            String saltEncoded = Base64.getEncoder().encodeToString(salt);
            String hashEncoded = Base64.getEncoder().encodeToString(hashedBytes);
            return saltEncoded + ":" + hashEncoded;
        } catch (Exception hashingFailure) {
            throw new RuntimeException("Password hashing failed", hashingFailure);
        }
    }

    public static boolean verifyPassword(String plainPassword, String storedHash) {
        try {
            String[] hashParts = storedHash.split(":");
            byte[] salt = Base64.getDecoder().decode(hashParts[0]);
            byte[] expectedHash = Base64.getDecoder().decode(hashParts[1]);
            byte[] actualHash = performHashing(plainPassword, salt);

            if (expectedHash.length != actualHash.length) {
                return false;
            }

            int comparisonResult = 0;
            for (int i = 0; i < expectedHash.length; i++) {
                comparisonResult |= expectedHash[i] ^ actualHash[i];
            }
            return comparisonResult == 0;
        } catch (Exception verificationFailure) {
            return false;
        }
    }

    private static byte[] generateSalt() {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    private static byte[] performHashing(String password, byte[] salt) throws Exception {
        PBEKeySpec keySpec = new PBEKeySpec(
                password.toCharArray(), salt, ITERATION_COUNT, KEY_LENGTH
        );
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(HASHING_ALGORITHM);
        return keyFactory.generateSecret(keySpec).getEncoded();
    }
}
