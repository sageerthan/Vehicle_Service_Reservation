package com.services.authentication;

import javax.servlet.http.HttpServletRequest;

public class AuthenticationUtil {

    private AuthenticationUtil() {
        // Private constructor to prevent instantiation
    }

    public static boolean isAuthenticated(HttpServletRequest request) {
        // Retrieve the session from the request, and check if the "username" attribute is present
        return getSessionAttribute(request, "username") != null;
    }

    private static Object getSessionAttribute(HttpServletRequest request, String attributeName) {
        // Helper method to get a session attribute by its name
        return request.getSession().getAttribute(attributeName);
    }
}

