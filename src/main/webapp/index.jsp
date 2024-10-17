<%@ page import="java.io.*, java.util.*" %>

<%
    // Load properties from the authorization.properties file
    Properties props = new Properties();
    try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/authorization.properties")) {
        props.load(input);
    } catch (IOException e) {
        e.printStackTrace();
        // Optionally, handle the error (e.g., redirect to an error page)
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Snap - Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-image: url('images/Car.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .login-page {
            display: flex;
            justify-content: flex-end;
            width: 100%;
            margin-right: 200px;
            align-items: center; 
        }

        .form {
            background-color: #15305c;
            padding: 10px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            min-width: 350px;
            min-height: 350px;
            display: flex; 
            flex-direction: column; 
            margin-top: 50px;
        }

        .login {
            text-align: center;
            color: #eee; 
        }

        .login-header {
            background-color: #1B1212; 
            padding: 20px;
            border-radius: 5px 5px 0 0;
            min-height: 200px;
            justify-content: center; 
            align-items: center;
        }

        .login-header h1 {
            margin: 0;
            font-size: 40px;
            margin-bottom: 50px;
        }

        .login-header p {
            font-size: 16px;
            color: #fff; 
        }

        .login-form {
            text-align: center;
            margin-top: 20px; 
        }

        .login-form button {
            background-color: #1B1212; 
            color: #eee; 
            border: none;
            padding: 15px 30px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: background-color 0.3s ease;
        }

        .login-form button a {
            color: #eee;
            text-decoration: none;
        }

        .login-form button:hover {
            background-color: #333; 
        }
    </style>
</head>

<body>
    <div class="login-page">
        <div class="form">
            <div class="login">
                <div class="login-header">
                    <h1>Service Snap</h1>
                    <p>Your Journey Begins Here</p>
                </div>
            </div>
            <div>
                <form class="login-form" action="<%= props.getProperty("oauth.auth_endpoint") %>" method="get">
                    <input type="hidden" name="scope" value="<%= props.getProperty("oauth.scope") %>">
                    <input type="hidden" name="response_type" value="<%= props.getProperty("oauth.response_type") %>">
                    <input type="hidden" name="redirect_uri" value="<%= props.getProperty("oauth.redirect_uri") %>">
                    <input type="hidden" name="client_id" value="<%= props.getProperty("oauth.client_id") %>">
                    <button type="submit">Sign In</button>
                </form>
            </div>
        </div>
    </div>
</body>

</html>
