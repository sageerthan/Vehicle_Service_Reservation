<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONObject" %>

<%
String authorizationCode = request.getParameter("code");
String sessionState = request.getParameter("session_state");
session.setAttribute("sessionState", sessionState);

if (authorizationCode == null || authorizationCode.isEmpty()) {
    out.println("Authorization code is missing.");
    return;
}

Properties props = new Properties();
try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/authorization.properties")) {
    if (input == null) {
        out.println("Authorization properties file not found.");
        return;
    }
    props.load(input);
} catch (IOException e) {
    out.println("Failed to load authorization properties: " + e.getMessage());
    e.printStackTrace();
    return;
}

String clientId = props.getProperty("oauth.client_id");
String clientSecret = props.getProperty("oauth.client_secret");
String tokenEndpoint = props.getProperty("oauth.token_endpoint");
String redirectUri = props.getProperty("oauth.redirect_uri");

String requestData = String.format(
    "code=%s&grant_type=authorization_code&client_id=%s&client_secret=%s&redirect_uri=%s",
    URLEncoder.encode(authorizationCode, "UTF-8"),
    URLEncoder.encode(clientId, "UTF-8"),
    URLEncoder.encode(clientSecret, "UTF-8"),
    URLEncoder.encode(redirectUri, "UTF-8")
);

HttpURLConnection tokenConnection = null;
try {
    URL tokenUrl = new URL(tokenEndpoint);
    tokenConnection = (HttpURLConnection) tokenUrl.openConnection();
    tokenConnection.setRequestMethod("POST");
    tokenConnection.setDoOutput(true);

    try (OutputStream outputStream = tokenConnection.getOutputStream()) {
        outputStream.write(requestData.getBytes(StandardCharsets.UTF_8));
        outputStream.flush();
    }

    int responseCode = tokenConnection.getResponseCode();
    if (responseCode != HttpURLConnection.HTTP_OK) {
        out.println("Failed to exchange token, response code: " + responseCode);
        return;
    }

    StringBuilder tokenResponse = new StringBuilder();
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(tokenConnection.getInputStream(), StandardCharsets.UTF_8))) {
        String line;
        while ((line = reader.readLine()) != null) {
            tokenResponse.append(line);
        }
    }

    JSONObject jsonResponse = new JSONObject(tokenResponse.toString());
    String accessToken = jsonResponse.optString("access_token", null);
    String idToken = jsonResponse.optString("id_token", null);

    if (accessToken == null || idToken == null) {
        out.println("Token response is missing required fields.");
        return;
    }

    session.setAttribute("access_token", accessToken);
    session.setAttribute("id_token", idToken);
    response.sendRedirect("home.jsp");

} catch (IOException e) {
    out.println("An error occurred during token exchange: " + e.getMessage());
    e.printStackTrace();
} finally {
    if (tokenConnection != null) {
        tokenConnection.disconnect();
    }
}
%>
