package com.cybernova.servlet;

import com.cybernova.dao.RatingDAO;
import com.cybernova.model.Rating;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/testimonials")
public class TestimonialsServlet extends HttpServlet {

    private final RatingDAO ratingDAO = new RatingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Rating> allTestimonials = ratingDAO.findAllRatings();
            double averageRating = ratingDAO.calculateAverageRating();

            request.setAttribute("testimonials", allTestimonials);
            request.setAttribute("averageRating", averageRating);

        } catch (Exception loadError) {
            request.setAttribute("testimonialError", "Could not load testimonials");
        }

        request.getRequestDispatcher("/testimonials.jsp").forward(request, response);
    }
}
