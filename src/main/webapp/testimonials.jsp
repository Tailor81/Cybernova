<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Testimonials"/>
</jsp:include>

<section class="page-hero">
    <div class="container">
        <h1>Client Testimonials</h1>
        <p>What our clients say about working with CyberNova Analytics</p>
        <c:if test="${averageRating > 0}">
            <div class="average-rating-display">
                <span class="avg-stars">
                    <c:forEach begin="1" end="5" var="star">
                        <span class="${star <= averageRating ? 'star-filled' : 'star-empty'}"><i class="fa-solid fa-star"></i></span>
                    </c:forEach>
                </span>
                <span class="avg-number">${averageRating} / 5</span>
            </div>
        </c:if>
    </div>
</section>

<section class="section">
    <div class="container">

        <c:if test="${param.submitted == 'true'}">
            <div class="alert alert-success">
                Thank you for your feedback. Your testimonial has been published.
            </div>
        </c:if>

        <c:if test="${param.error == 'validation'}">
            <div class="alert alert-error">
                Please fill in all required fields and select a rating.
            </div>
        </c:if>

        <div class="testimonials-grid">
            <c:forEach items="${testimonials}" var="testimonial">
                <div class="testimonial-card">
                    <div class="testimonial-stars">
                        <c:forEach begin="1" end="5" var="star">
                            <span class="${star <= testimonial.ratingValue ? 'star-filled' : 'star-empty'}"><i class="fa-solid fa-star"></i></span>
                        </c:forEach>
                    </div>
                    <p class="testimonial-text">${testimonial.comment}</p>
                    <div class="testimonial-author">
                        <div class="author-avatar">${testimonial.customerName.substring(0, 1)}</div>
                        <span class="author-name">${testimonial.customerName}</span>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="rating-form-section">
            <h2>Leave Your Feedback</h2>
            <p>Share your experience with CyberNova Analytics</p>

            <form action="${pageContext.request.contextPath}/submit-rating" method="post" class="rating-form" id="ratingForm">
                <div class="form-group">
                    <label for="customerName">Your Name <span class="required">*</span></label>
                    <input type="text" id="customerName" name="customerName" required placeholder="Enter your name">
                </div>

                <div class="form-group">
                    <label>Your Rating <span class="required">*</span></label>
                    <div class="star-rating-input" id="starRating">
                        <input type="radio" name="ratingValue" value="5" id="star5"><label for="star5"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" name="ratingValue" value="4" id="star4"><label for="star4"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" name="ratingValue" value="3" id="star3"><label for="star3"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" name="ratingValue" value="2" id="star2"><label for="star2"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" name="ratingValue" value="1" id="star1"><label for="star1"><i class="fa-solid fa-star"></i></label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="ratingComment">Your Comment</label>
                    <textarea id="ratingComment" name="comment" rows="4" placeholder="Tell us about your experience"></textarea>
                </div>

                <button type="submit" class="btn btn-primary">Submit Feedback</button>
            </form>
        </div>

    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
