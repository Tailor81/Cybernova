package com.cybernova.listener;

import com.cybernova.dao.DatabaseConnection;
import com.cybernova.util.PasswordHasher;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebListener
public class DatabaseInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        try (Connection database = DatabaseConnection.openConnection();
             Statement statement = database.createStatement()) {

            statement.execute(
                "CREATE TABLE IF NOT EXISTS service_request ("
                + "request_id SERIAL PRIMARY KEY, "
                + "full_name VARCHAR(100) NOT NULL, "
                + "email VARCHAR(150) NOT NULL, "
                + "phone_number VARCHAR(20), "
                + "organisation_name VARCHAR(150), "
                + "country VARCHAR(100) NOT NULL, "
                + "job_title VARCHAR(100), "
                + "industry_sector VARCHAR(100), "
                + "service_type VARCHAR(100) NOT NULL, "
                + "description TEXT NOT NULL, "
                + "status VARCHAR(20) DEFAULT 'pending', "
                + "submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            statement.execute(
                "CREATE TABLE IF NOT EXISTS admin ("
                + "admin_id SERIAL PRIMARY KEY, "
                + "username VARCHAR(50) UNIQUE NOT NULL, "
                + "password_hash VARCHAR(256) NOT NULL)"
            );

            statement.execute(
                "CREATE TABLE IF NOT EXISTS rating ("
                + "rating_id SERIAL PRIMARY KEY, "
                + "request_id INT, "
                + "customer_name VARCHAR(100) NOT NULL, "
                + "rating_value INT NOT NULL CHECK (rating_value >= 1 AND rating_value <= 5), "
                + "comment TEXT, "
                + "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                + "FOREIGN KEY (request_id) REFERENCES service_request(request_id) ON DELETE SET NULL)"
            );

            statement.execute(
                "CREATE TABLE IF NOT EXISTS webinar ("
                + "webinar_id SERIAL PRIMARY KEY, "
                + "title VARCHAR(200) NOT NULL, "
                + "description TEXT, "
                + "webinar_date DATE NOT NULL, "
                + "webinar_time VARCHAR(20) NOT NULL, "
                + "platform VARCHAR(20) DEFAULT 'Online', "
                + "speaker VARCHAR(150), "
                + "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            statement.execute(
                "CREATE TABLE IF NOT EXISTS webinar_registration ("
                + "registration_id SERIAL PRIMARY KEY, "
                + "webinar_id INT NOT NULL, "
                + "full_name VARCHAR(100) NOT NULL, "
                + "email VARCHAR(150) NOT NULL, "
                + "organisation VARCHAR(150), "
                + "phone VARCHAR(20), "
                + "registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                + "FOREIGN KEY (webinar_id) REFERENCES webinar(webinar_id) ON DELETE CASCADE)"
            );

            ResultSet adminCheck = statement.executeQuery("SELECT COUNT(*) AS total FROM admin");
            adminCheck.next();
            if (adminCheck.getInt("total") == 0) {
                String hashedPassword = PasswordHasher.hashPassword("admin123");
                statement.execute(
                    "INSERT INTO admin (username, password_hash) VALUES ('admin', '"
                    + hashedPassword + "')"
                );
            }

            ResultSet requestCheck = statement.executeQuery("SELECT COUNT(*) AS total FROM service_request");
            requestCheck.next();
            if (requestCheck.getInt("total") == 0) {
                seedServiceRequests(database);
            }

            ResultSet ratingCheck = statement.executeQuery("SELECT COUNT(*) AS total FROM rating");
            ratingCheck.next();
            if (ratingCheck.getInt("total") == 0) {
                seedRatings(database);
            }

            ResultSet webinarCheck = statement.executeQuery("SELECT COUNT(*) AS total FROM webinar");
            webinarCheck.next();
            if (webinarCheck.getInt("total") == 0) {
                seedWebinars(database);
            }

            event.getServletContext().log("CyberNova database initialized successfully");

        } catch (Exception initFailure) {
            event.getServletContext().log("Database initialization failed: " + initFailure.getMessage()
                + " — check DB_URL, DB_USER, DB_PASSWORD environment variables");
        }
    }

    private void seedServiceRequests(Connection database) throws Exception {
        String insertQuery = "INSERT INTO service_request "
            + "(full_name, email, phone_number, organisation_name, country, "
            + "job_title, industry_sector, service_type, description, status, submission_date) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Object[][] requests = {
            {"Thabo Modise", "thabo.modise@bbs.co.bw", "+267 310 2200", "Botswana Building Society", "Botswana",
             "IT Director", "Financial Services", "AI Cyber Assistant",
             "We need continuous network monitoring for our core banking systems and branch network across 15 locations.", "resolved",
             daysAgo(92)},

            {"Lindiwe Dlamini", "lindiwe@fnb.co.za", "+27 11 350 4000", "First National Bank SA", "South Africa",
             "Chief Information Security Officer", "Financial Services", "Network Security Audit",
             "Require a comprehensive audit of our payment processing infrastructure following recent PCI DSS updates.", "resolved",
             daysAgo(85)},

            {"Emmanuel Okafor", "e.okafor@lagosstate.gov.ng", "+234 812 300 4500", "Lagos State Government", "Nigeria",
             "Head of ICT", "Government", "Penetration Testing",
             "Need external and internal penetration testing for our citizen portal and internal systems before the new fiscal year launch.", "resolved",
             daysAgo(78)},

            {"Amina Juma", "amina.juma@tz-health.go.tz", "+255 22 215 0000", "Tanzania Ministry of Health", "Tanzania",
             "Systems Administrator", "Healthcare", "Network Security Audit",
             "Patient record systems need a full security audit to comply with new health data regulations.", "in_progress",
             daysAgo(65)},

            {"Pieter van der Merwe", "pieter@naspers.com", "+27 21 406 2121", "Naspers Technologies", "South Africa",
             "VP Engineering", "Technology", "AI Cyber Assistant",
             "Looking for AI-powered threat detection to integrate with our existing SIEM platform across our media properties.", "in_progress",
             daysAgo(58)},

            {"Grace Nyambe", "grace@znbs.co.zm", "+260 211 231 385", "Zambia National Building Society", "Zambia",
             "Risk Manager", "Financial Services", "Security Consultation",
             "Need strategic advice on building an internal cybersecurity programme aligned with banking regulations.", "resolved",
             daysAgo(52)},

            {"Kwame Asante", "kwame@ashesi.edu.gh", "+233 302 610 330", "Ashesi University", "Ghana",
             "Network Administrator", "Education", "Cyber Awareness Training",
             "Want to run phishing simulation campaigns and security awareness workshops for all staff and students.", "resolved",
             daysAgo(45)},

            {"Fatou Diallo", "fatou@orange-sonatel.sn", "+221 33 839 1234", "Sonatel Group", "Other",
             "Cybersecurity Analyst", "Telecommunications", "Penetration Testing",
             "Require web application penetration testing for our customer self-service portal and mobile API endpoints.", "in_progress",
             daysAgo(40)},

            {"Robert Kachali", "robert@malawi-rbs.mw", "+265 1 820 244", "Reserve Bank of Malawi", "Other",
             "IT Security Manager", "Financial Services", "AI Cyber Assistant",
             "Interested in deploying AI-based anomaly detection for monitoring SWIFT transactions and interbank communication channels.", "pending",
             daysAgo(35)},

            {"Nomsa Ndlovu", "nomsa@debswana.bw", "+267 290 4000", "Debswana Diamond Company", "Botswana",
             "IT Manager", "Manufacturing", "Network Security Audit",
             "Need a thorough security assessment of our mining operations network infrastructure at Jwaneng and Orapa.", "resolved",
             daysAgo(30)},

            {"Ahmed Hassan", "ahmed@co-opbank.co.ke", "+254 20 327 6000", "Co-operative Bank of Kenya", "Kenya",
             "Digital Banking Manager", "Financial Services", "Penetration Testing",
             "Our mobile banking application needs comprehensive security testing before the next release cycle.", "in_progress",
             daysAgo(28)},

            {"Julia Fernandes", "julia@bancabc.co.mz", "+258 21 344 400", "BancABC Mozambique", "Mozambique",
             "Compliance Officer", "Financial Services", "Security Consultation",
             "Need guidance on aligning our security practices with Mozambique Central Bank cybersecurity directive.", "pending",
             daysAgo(22)},

            {"Tendai Moyo", "tendai@econet.co.zw", "+263 4 486 2000", "Econet Wireless Zimbabwe", "Zimbabwe",
             "Infrastructure Lead", "Telecommunications", "AI Cyber Assistant",
             "Looking for real-time network traffic analysis solution for detecting DDoS attacks and SIM swap fraud.", "pending",
             daysAgo(18)},

            {"Sarah Banda", "sarah@ub.ac.bw", "+267 355 0000", "University of Botswana", "Botswana",
             "IT Security Officer", "Education", "Cyber Awareness Training",
             "Need a campus-wide cybersecurity awareness programme covering phishing, social engineering, and safe browsing.", "in_progress",
             daysAgo(14)},

            {"Michael Osei", "michael@ghana-health.gov.gh", "+233 302 665 421", "Ghana Health Service", "Ghana",
             "Director of IT", "Healthcare", "Network Security Audit",
             "Require security audit of our electronic health management information system that handles patient data across 300 facilities.", "pending",
             daysAgo(12)},

            {"Chipo Mwanza", "chipo@stanbic.co.zm", "+260 211 370 700", "Stanbic Bank Zambia", "Zambia",
             "Head of Digital Channels", "Financial Services", "Penetration Testing",
             "Need to test our internet banking platform and ATM network against current threat vectors.", "pending",
             daysAgo(10)},

            {"Blessing Mutasa", "blessing@steward.co.zw", "+263 4 751 631", "Steward Bank Zimbabwe", "Zimbabwe",
             "Information Security Analyst", "Financial Services", "AI Cyber Assistant",
             "Evaluating AI monitoring solutions for our branch network and online banking fraud detection.", "pending",
             daysAgo(7)},

            {"David Kimani", "david@safaricom.co.ke", "+254 722 000 000", "Safaricom PLC", "Kenya",
             "Senior Security Engineer", "Telecommunications", "Incident Response",
             "Experienced a suspected breach in our M-Pesa partner API gateway and need immediate forensic investigation.", "in_progress",
             daysAgo(5)},

            {"Palesa Molefe", "palesa@bpc.bw", "+267 360 0500", "Botswana Power Corporation", "Botswana",
             "SCADA Engineer", "Manufacturing", "Security Consultation",
             "Need assessment of our industrial control systems and SCADA network security posture for critical infrastructure protection.", "pending",
             daysAgo(3)},

            {"Wanjiku Muthoni", "wanjiku@nairobi.go.ke", "+254 20 222 1111", "Nairobi County Government", "Kenya",
             "Chief Digital Officer", "Government", "Cyber Awareness Training",
             "Planning a county-wide digital literacy and cybersecurity awareness campaign for government employees across all departments.", "pending",
             daysAgo(1)}
        };

        try (PreparedStatement prepared = database.prepareStatement(insertQuery)) {
            for (Object[] row : requests) {
                prepared.setString(1, (String) row[0]);
                prepared.setString(2, (String) row[1]);
                prepared.setString(3, (String) row[2]);
                prepared.setString(4, (String) row[3]);
                prepared.setString(5, (String) row[4]);
                prepared.setString(6, (String) row[5]);
                prepared.setString(7, (String) row[6]);
                prepared.setString(8, (String) row[7]);
                prepared.setString(9, (String) row[8]);
                prepared.setString(10, (String) row[9]);
                prepared.setTimestamp(11, (Timestamp) row[10]);
                prepared.executeUpdate();
            }
        }
    }

    private void seedRatings(Connection database) throws Exception {
        String insertQuery = "INSERT INTO rating (request_id, customer_name, rating_value, comment) VALUES (?, ?, ?, ?)";

        Object[][] ratings = {
            {1, "Thabo Modise", 5, "CyberNova transformed our security infrastructure. Their AI-driven approach detected threats we did not know existed."},
            {2, "Lindiwe Dlamini", 4, "Excellent penetration testing service. The team was thorough and professional throughout the engagement."},
            {3, "Emmanuel Okafor", 5, "The network security audit revealed critical vulnerabilities. Their recommendations were practical and effective."},
            {6, "Grace Nyambe", 5, "Outstanding strategic consultation. They helped us build a security programme from the ground up in record time."},
            {7, "Kwame Asante", 4, "The cyber awareness training workshops were engaging and transformed how our staff handles security threats."},
            {10, "Nomsa Ndlovu", 5, "Thorough audit of our mining network. They identified risks we had overlooked for years and provided a clear remediation path."},
            {11, "Ahmed Hassan", 4, "Professional mobile app security testing. They found several critical issues before our release went live."},
            {1, "BBS IT Team", 5, "Second engagement with CyberNova. Their AI monitoring has reduced our incident response time by over 80 percent."}
        };

        try (PreparedStatement prepared = database.prepareStatement(insertQuery)) {
            for (Object[] row : ratings) {
                prepared.setInt(1, (Integer) row[0]);
                prepared.setString(2, (String) row[1]);
                prepared.setInt(3, (Integer) row[2]);
                prepared.setString(4, (String) row[3]);
                prepared.executeUpdate();
            }
        }
    }

    private Timestamp daysAgo(int days) {
        return Timestamp.valueOf(LocalDateTime.now().minusDays(days));
    }

    private void seedWebinars(Connection database) throws Exception {
        String insertQuery = "INSERT INTO webinar (title, description, webinar_date, webinar_time, platform, speaker) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

        Object[][] webinars = {
            {"AI Threat Detection Using Machine Learning",
             "Learn how AI detects and responds to modern cyber threats in real time. This session covers anomaly detection algorithms, SIEM integration, and practical deployment strategies.",
             "2026-05-20", "10:00 AM", "Online", "Dr. Kefilwe Motlhabane"},
            {"Network Security Basics for Businesses",
             "Essential network security practices every business should implement today. Topics include firewall configuration, network segmentation, VPN setup, and access control best practices.",
             "2026-05-25", "10:00 AM", "Online", "Eng. Sipho Dlamini"},
            {"Incident Response: A Practical Guide",
             "Walk through a real-world incident response scenario from detection to recovery. Understand containment strategies, evidence collection, and post-incident hardening.",
             "2026-06-05", "02:00 PM", "Online", "Amina Osei"},
            {"Phishing Awareness and Social Engineering Defence",
             "Understand how attackers manipulate people rather than systems. This session includes live phishing simulation breakdowns and how to build a human firewall in your organisation.",
             "2026-06-18", "11:00 AM", "Online", "James Kariuki"}
        };

        try (PreparedStatement prepared = database.prepareStatement(insertQuery)) {
            for (Object[] row : webinars) {
                prepared.setString(1, (String) row[0]);
                prepared.setString(2, (String) row[1]);
                prepared.setObject(3, java.sql.Date.valueOf((String) row[2]));
                prepared.setString(4, (String) row[3]);
                prepared.setString(5, (String) row[4]);
                prepared.setString(6, (String) row[5]);
                prepared.executeUpdate();
            }
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
    }
}
