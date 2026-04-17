document.addEventListener('DOMContentLoaded', function () {

    var navToggle = document.getElementById('navToggle');
    var navMenu = document.getElementById('navMenu');

    if (navToggle && navMenu) {
        navToggle.addEventListener('click', function () {
            navMenu.classList.toggle('active');
        });

        document.addEventListener('click', function (event) {
            if (!navToggle.contains(event.target) && !navMenu.contains(event.target)) {
                navMenu.classList.remove('active');
            }
        });
    }

    var contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function (event) {
            var isValid = validateContactForm();
            if (!isValid) {
                event.preventDefault();
            }
        });
    }

    var ratingForm = document.getElementById('ratingForm');
    if (ratingForm) {
        ratingForm.addEventListener('submit', function (event) {
            var isValid = validateRatingForm();
            if (!isValid) {
                event.preventDefault();
            }
        });
    }

    highlightActiveNavLink();
});

function validateContactForm() {
    var allFieldsValid = true;

    allFieldsValid = validateRequiredField('fullName', 'Full name is required') && allFieldsValid;
    allFieldsValid = validateEmailField('email', 'A valid email address is required') && allFieldsValid;
    allFieldsValid = validateRequiredField('country', 'Country is required') && allFieldsValid;
    allFieldsValid = validateRequiredField('serviceType', 'Type of security issue is required') && allFieldsValid;
    allFieldsValid = validateMinLength('description', 10, 'Description must be at least 10 characters') && allFieldsValid;

    var phoneField = document.getElementById('phoneNumber');
    if (phoneField && phoneField.value.trim() !== '') {
        var phonePattern = /^[+]?[0-9\s\-()]{7,20}$/;
        if (!phonePattern.test(phoneField.value.trim())) {
            showFieldError('phoneNumber', 'Phone number format is not valid');
            allFieldsValid = false;
        } else {
            clearFieldError('phoneNumber');
        }
    } else {
        clearFieldError('phoneNumber');
    }

    return allFieldsValid;
}

function validateRatingForm() {
    var nameField = document.getElementById('customerName');
    var ratingSelected = document.querySelector('input[name="ratingValue"]:checked');

    if (!nameField || nameField.value.trim() === '') {
        alert('Please enter your name');
        return false;
    }

    if (!ratingSelected) {
        alert('Please select a star rating');
        return false;
    }

    return true;
}

function validateRequiredField(fieldId, errorMessage) {
    var field = document.getElementById(fieldId);
    if (!field) return true;

    if (field.value.trim() === '') {
        showFieldError(fieldId, errorMessage);
        return false;
    }

    clearFieldError(fieldId);
    return true;
}

function validateEmailField(fieldId, errorMessage) {
    var field = document.getElementById(fieldId);
    if (!field) return true;

    var emailPattern = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    if (field.value.trim() === '' || !emailPattern.test(field.value.trim())) {
        showFieldError(fieldId, errorMessage);
        return false;
    }

    clearFieldError(fieldId);
    return true;
}

function validateMinLength(fieldId, minimumLength, errorMessage) {
    var field = document.getElementById(fieldId);
    if (!field) return true;

    if (field.value.trim().length < minimumLength) {
        showFieldError(fieldId, errorMessage);
        return false;
    }

    clearFieldError(fieldId);
    return true;
}

function showFieldError(fieldId, message) {
    var field = document.getElementById(fieldId);
    var errorSpan = document.getElementById(fieldId + 'Error');

    if (field) field.classList.add('error');
    if (errorSpan) errorSpan.textContent = message;
}

function clearFieldError(fieldId) {
    var field = document.getElementById(fieldId);
    var errorSpan = document.getElementById(fieldId + 'Error');

    if (field) field.classList.remove('error');
    if (errorSpan) errorSpan.textContent = '';
}

function highlightActiveNavLink() {
    var currentPath = window.location.pathname;
    var navLinks = document.querySelectorAll('.nav-menu a');

    navLinks.forEach(function (link) {
        var linkPath = link.getAttribute('href');
        if (linkPath && currentPath.endsWith(linkPath.split('/').pop())) {
            link.style.color = '#00B4D8';
        }
    });
}

// Admin sidebar mobile toggle
(function () {
    var toggle = document.getElementById('adminMenuToggle');
    var sidebar = document.getElementById('adminSidebar');
    var overlay = document.getElementById('adminOverlay');

    if (toggle && sidebar && overlay) {
        toggle.addEventListener('click', function () {
            sidebar.classList.toggle('mobile-open');
            overlay.classList.toggle('active');
        });

        overlay.addEventListener('click', function () {
            sidebar.classList.remove('mobile-open');
            overlay.classList.remove('active');
        });

        sidebar.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                sidebar.classList.remove('mobile-open');
                overlay.classList.remove('active');
            });
        });
    }
})();
