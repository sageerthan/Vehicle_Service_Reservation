<%@ page import="com.services.authentication.AuthenticationUtil" %>
<%@ page import="com.services.database.DatabaseConnection" %>
<%@ page import="java.sql.*" %>
<%@ include file="structure.jsp" %>

<%
    // Check user authentication
    if (!AuthenticationUtil.isAuthenticated(request)) {
        response.sendRedirect("index.jsp"); // Redirect to the login page if not authenticated
        return; // Exit to prevent further processing
    }

    DatabaseConnection dbConnection = new DatabaseConnection();
    Connection connection = null;

    // Handle deletion of a booking
    String deleteBookingId = request.getParameter("bookingId");
    if (request.getParameter("delete") != null && deleteBookingId != null) {
        try {
            connection = dbConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement("DELETE FROM vehicle_service WHERE booking_id = ?");
            ps.setString(1, deleteBookingId);
            ps.executeUpdate();
            response.sendRedirect("delete_registration.jsp?msg=success"); // Redirect to success page
        } catch (SQLException e) {
            System.err.println("Error deleting booking: " + e.getMessage());
            response.sendRedirect("delete_registration.jsp?msg=failure"); // Redirect to failure page
        } finally {
            dbConnection.closeConnection(connection);
        }
    }

    // Fetch upcoming reservations
    try {
        connection = dbConnection.getConnection();
        String username = (String) request.getSession().getAttribute("username");
        PreparedStatement preparedStatement = connection.prepareStatement("SELECT * FROM vehicle_service WHERE username = ? AND date >= ?");
        preparedStatement.setString(1, username);
        preparedStatement.setDate(2, java.sql.Date.valueOf(java.time.LocalDate.now()));

        ResultSet resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
%>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
    }

    h4 {
        color: #333;
    }

    table {
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: #fff;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: left;
    }

    th {
        background-color: #333;
        color: #fff;
    }

    button {
        background-color: #d9534f;
        color: white;
        padding: 8px 12px;
        border: none;
        border-radius: 3px;
        cursor: pointer;
        font-size: 14px;
    }

    button:hover {
        background-color: #c9302c;
    }
</style>

    <table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Date</th>
                <th>Time</th>
                <th>Location</th>
                <th>Vehicle Number</th>
                <th>Mileage</th>
                <th>Message</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
<%
            do {
%>
            <tr>
                <td><%= resultSet.getString("booking_id") %></td>
                <td><%= resultSet.getString("date") %></td>
                <td><%= resultSet.getString("time") %></td>
                <td><%= resultSet.getString("location") %></td>
                <td><%= resultSet.getString("vehicle_no") %></td>
                <td><%= resultSet.getString("mileage") %></td>
                <td><%= resultSet.getString("message") %></td>
                <td>
                    <form action="delete_registration.jsp" method="post">
                        <input type="hidden" name="bookingId" value="<%= resultSet.getString("booking_id") %>">
                        <button type="submit" name="delete">Delete</button>
                    </form>
                </td>
            </tr>
<%
            } while (resultSet.next());
%>
        </tbody>
    </table>
<%
        } else {
%>
            <p style="color: white; text-align: center;">No Upcoming Reservations found.</p>
<%
        }
        resultSet.close();
    } catch (SQLException e) {
        System.err.println("Error fetching reservations: " + e.getMessage());
    } finally {
        dbConnection.closeConnection(connection);
    }
%>
