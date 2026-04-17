<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - CyberNova</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="admin-body">

<div class="admin-login-wrapper">
    <div class="admin-login-card">
        <h1 class="admin-login-title">Admin Login</h1>

        <form action="${pageContext.request.contextPath}/admin/login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required placeholder="Enter username" autocomplete="username">
            </div>
            <div class="form-group password-group">
                <label for="password">Password</label>
                <div class="password-wrapper">
                    <input type="password" id="password" name="password" required placeholder="Enter password" autocomplete="current-password">
                    <button type="button" class="password-toggle" id="passwordToggle" aria-label="Toggle password visibility"><i class="fa-solid fa-eye"></i></button>
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-full">Login</button>
        </form>

        <c:if test="${not empty loginError}">
            <p class="login-error-text">${loginError}</p>
        </c:if>
    </div>
</div>

<script>
    var toggleBtn = document.getElementById('passwordToggle');
    var passwordField = document.getElementById('password');
    if (toggleBtn && passwordField) {
        toggleBtn.addEventListener('click', function() {
            var isPassword = passwordField.type === 'password';
            passwordField.type = isPassword ? 'text' : 'password';
            var icon = toggleBtn.querySelector('i');
            icon.className = isPassword ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
        });
    }
</script>

</body>
</html>
