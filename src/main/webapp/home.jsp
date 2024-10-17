<%@ include file="structure.jsp" %>
<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%@ page import="org.json.JSONObject" %>

<%
    // Extract access_token and id_token from session attributes
    String accessToken = (String) request.getSession().getAttribute("access_token");

    // Check if the access token is present
    if (accessToken != null && !accessToken.isEmpty()) {
        Properties props = new Properties();
        
        // Load properties from the authorization.properties file
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/authorization.properties")) {
            props.load(input);
        } catch (IOException e) {
            System.err.println("Error loading properties: " + e.getMessage());
            response.sendRedirect("index.jsp");
            return; // Exit the script
        }

        String userinfoEndpoint = props.getProperty("oauth.userinfo_endpoint");

        // Fetch user info
        try {
            // Open connection to userinfo endpoint
            URL userinfoUrl = new URL(userinfoEndpoint);
            HttpURLConnection userinfoConnection = (HttpURLConnection) userinfoUrl.openConnection();
            userinfoConnection.setRequestMethod("GET");
            userinfoConnection.setRequestProperty("Authorization", "Bearer " + accessToken);

            // Check response code
            if (userinfoConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                StringBuilder userinfoResponse = new StringBuilder();
                try (BufferedReader userinfoReader = new BufferedReader(new InputStreamReader(userinfoConnection.getInputStream()))) {
                    String userinfoInputLine;
                    while ((userinfoInputLine = userinfoReader.readLine()) != null) {
                        userinfoResponse.append(userinfoInputLine);
                    }
                }

                // Parse the JSON response
                JSONObject userinfoJson = new JSONObject(userinfoResponse.toString());
                String username = userinfoJson.optString("username");
                String name = userinfoJson.optString("given_name");
                String email = userinfoJson.optString("email");
                String contactNumber = userinfoJson.optString("phone_number");
                String country = userinfoJson.optJSONObject("address") != null ?
                                 userinfoJson.optJSONObject("address").optString("country") : "";

                // Store user info in session
                session.setAttribute("username", username);
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <style>
        .profile-info {
            max-width: 600px;
            margin: 50px auto;
            background-color: white;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
        }
        .info-pair {
            margin-bottom: 15px;
        }
        .info-label {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .info-value {
            color: #d9534f;
        }
    </style>
</head>
<body>
<div class="profile-info">
    <h2 align="center">Profile</h2>
    <div class="info-pair">
        <p class="info-label">USERNAME</p>
        <h4 class="info-value"><%= username %></h4>
    </div>
    <div class="info-pair">
        <p class="info-label">NAME</p>
        <h4 class="info-value"><%= name %></h4>
    </div>
    <div class="info-pair">
        <p class="info-label">EMAIL</p>
        <h4 class="info-value"><%= email %></h4>
    </div>
    <div class="info-pair">
        <p class="info-label">CONTACT NO</p>
        <h4 class="info-value"><%= contactNumber %></h4>
    </div>
    <div class="info-pair">
        <p class="info-label">COUNTRY</p>
        <h4 class="info-value"><%= country %></h4>
    </div>
</div>
</body>
</html>
<%
            } else {
                System.err.println("Error fetching user info: " + userinfoConnection.getResponseCode());
                response.sendRedirect("index.jsp");
            }
        } catch (IOException e) {
            System.err.println("Error during userinfo fetch: " + e.getMessage());
            response.sendRedirect("index.jsp");
        }
    } else {
        // Redirect to login if access token is not present
        response.sendRedirect("index.jsp");
    }
%>
