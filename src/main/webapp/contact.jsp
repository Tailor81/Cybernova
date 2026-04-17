<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Request Assessment"/>
</jsp:include>

<section class="section">
    <div class="container">
        <div class="assessment-layout">

            <div class="assessment-info">
                <h1>Request Cyber Risk Assessment</h1>
                <p>Fill in the form and our team will get back to you shortly.</p>
                <div class="assessment-icon"><i class="fa-solid fa-shield-halved"></i></div>
            </div>

            <div class="assessment-form">

                <c:if test="${not empty errors}">
                    <div class="alert alert-error">
                        <ul>
                            <c:forEach items="${errors}" var="errorMessage">
                                <li>${errorMessage}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/submit-request" method="post" id="contactForm" novalidate>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" value="${fullName}" required
                                   placeholder="Enter your full name">
                            <span class="field-error" id="fullNameError"></span>
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" value="${email}" required
                                   placeholder="Enter your email">
                            <span class="field-error" id="emailError"></span>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="phoneNumber">Phone Number</label>
                            <input type="tel" id="phoneNumber" name="phoneNumber" value="${phoneNumber}"
                                   placeholder="Enter phone number">
                            <span class="field-error" id="phoneNumberError"></span>
                        </div>
                        <div class="form-group">
                            <label for="organisationName">Organisation</label>
                            <input type="text" id="organisationName" name="organisationName" value="${organisationName}"
                                   placeholder="Enter organisation">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="country">Country</label>
                            <select id="country" name="country" required>
                                <option value="">Select country</option>
                                <option value="Botswana" ${country == 'Botswana' ? 'selected' : ''}>Botswana</option>
                                <option value="South Africa" ${country == 'South Africa' ? 'selected' : ''}>South Africa</option>
                                <option value="Namibia" ${country == 'Namibia' ? 'selected' : ''}>Namibia</option>
                                <option value="Zimbabwe" ${country == 'Zimbabwe' ? 'selected' : ''}>Zimbabwe</option>
                                <option value="Zambia" ${country == 'Zambia' ? 'selected' : ''}>Zambia</option>
                                <option value="Mozambique" ${country == 'Mozambique' ? 'selected' : ''}>Mozambique</option>
                                <option value="Tanzania" ${country == 'Tanzania' ? 'selected' : ''}>Tanzania</option>
                                <option value="Kenya" ${country == 'Kenya' ? 'selected' : ''}>Kenya</option>
                                <option value="Nigeria" ${country == 'Nigeria' ? 'selected' : ''}>Nigeria</option>
                                <option value="Ghana" ${country == 'Ghana' ? 'selected' : ''}>Ghana</option>
                                <option value="United Kingdom" ${country == 'United Kingdom' ? 'selected' : ''}>United Kingdom</option>
                                <option value="Other" ${country == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                            <span class="field-error" id="countryError"></span>
                        </div>
                        <div class="form-group">
                            <label for="industrySector">Industry Sector</label>
                            <select id="industrySector" name="industrySector">
                                <option value="">Select industry</option>
                                <option value="Financial Services" ${industrySector == 'Financial Services' ? 'selected' : ''}>Financial Services</option>
                                <option value="Government" ${industrySector == 'Government' ? 'selected' : ''}>Government</option>
                                <option value="Healthcare" ${industrySector == 'Healthcare' ? 'selected' : ''}>Healthcare</option>
                                <option value="Education" ${industrySector == 'Education' ? 'selected' : ''}>Education</option>
                                <option value="Technology" ${industrySector == 'Technology' ? 'selected' : ''}>Technology</option>
                                <option value="Retail" ${industrySector == 'Retail' ? 'selected' : ''}>Retail</option>
                                <option value="Manufacturing" ${industrySector == 'Manufacturing' ? 'selected' : ''}>Manufacturing</option>
                                <option value="Telecommunications" ${industrySector == 'Telecommunications' ? 'selected' : ''}>Telecommunications</option>
                                <option value="Other" ${industrySector == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label for="serviceType">Service Type</label>
                        <select id="serviceType" name="serviceType" required>
                            <option value="">Select a service type</option>
                            <option value="AI Cyber Assistant" ${serviceType == 'AI Cyber Assistant' ? 'selected' : ''}>AI Cyber Assistant</option>
                            <option value="Network Security Audit" ${serviceType == 'Network Security Audit' ? 'selected' : ''}>Network Security Audit</option>
                            <option value="Penetration Testing" ${serviceType == 'Penetration Testing' ? 'selected' : ''}>Penetration Testing</option>
                            <option value="Incident Response" ${serviceType == 'Incident Response' ? 'selected' : ''}>Incident Response</option>
                            <option value="Security Consultation" ${serviceType == 'Security Consultation' ? 'selected' : ''}>Security Consultation</option>
                            <option value="Cyber Awareness Training" ${serviceType == 'Cyber Awareness Training' ? 'selected' : ''}>Cyber Awareness Training</option>
                        </select>
                        <span class="field-error" id="serviceTypeError"></span>
                    </div>

                    <div class="form-group full-width">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="5" required
                                  placeholder="Describe your security needs or what you'd like assessed (min 10 characters)">${description}</textarea>
                        <span class="field-error" id="descriptionError"></span>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary btn-full">Submit Request</button>
                    </div>

                </form>
            </div>

        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
