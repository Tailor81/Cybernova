package com.cybernova.servlet;

import com.cybernova.dao.RatingDAO;
import com.cybernova.model.Rating;
import com.cybernova.util.InputValidator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/submit-rating")
public class SubmitRatingServlet extends HttpServlet {

    private final RatingDAO ratingDAO = new RatingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String customerName = request.getParameter("customerName");
        String ratingValueStr = request.getParameter("ratingValue");
        String comment = request.getParameter("comment");

        List<String> validationErrors = new ArrayList<>();

        if (InputValidator.isBlank(customerName)) {
            validationErrors.add("Your name is required");
        }

        int ratingValue = 0;
        try {
            ratingValue = Integer.parseInt(ratingValueStr);
            if (ratingValue < 1 || ratingValue > 5) {
                validationErrors.add("Rating must be between 1 and 5");
            }
        } catch (NumberFormatException invalidRating) {
            validationErrors.add("Please select a rating");
        }

        if (!validationErrors.isEmpty()) {
            request.setAttribute("ratingErrors", validationErrors);
            response.sendRedirect(request.getContextPath() + "/testimonials?error=validation");
            return;
        }

        try {
            Rating newRating = new Rating();
            newRating.setCustomerName(customerName.trim());
            newRating.setRatingValue(ratingValue);
            newRating.setComment(comment != null ? comment.trim() : "");

            ratingDAO.saveNewRating(newRating);
            response.sendRedirect(request.getContextPath() + "/testimonials?submitted=true");

        } catch (Exception saveError) {
            response.sendRedirect(request.getContextPath() + "/testimonials?error=server");
        }
    }
}
