
    <%String sessionState = (String) session.getAttribute("sessionState"); 
    String client_id="Yb0SLskZKAQHsgNs2ffFQ84evf0a" ;
    
  %>  
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  
   <style>
    body {
        font-family: Arial;
        background-color: #333;
        margin: 0;
        padding: 0;
    }

    .navbar {
        background-color: #000;
        display: flex;
        justify-content: space-around;
        align-items: center;
        padding: 10px 0;
    }

    .nav-link {
        text-decoration: none;
        color: #fff;
        font-size: 16px;
        margin: 0 20px;
    }

    .nav-link.active {
        background-color: #555;
        border-radius: 3px;
        padding: 5px 10px;
    }

    #logout-btn {
        background-color: #d9534f;
        color: white;
        padding: 8px 12px;
        border: none;
        border-radius: 3px;
        cursor: pointer;
        font-size: 14px;
    }

    #logout-btn:hover {
        background-color: #c9302c;
    }
</style>

</head>

<body>

<div class="navbar">
    <a class="nav-link" href="home.jsp">Profile</a>
    <a class="nav-link" href="service_registration.jsp">Add Reservation</a>
    <a class="nav-link" href="delete_registration.jsp">Upcoming Reservations</a>
    <a class="nav-link" href="view_registration.jsp">View All</a>
   <form id="logout-form" action="https://api.asgardeo.io/t/sageerthan/oidc/logout" method="POST">
    <input type="hidden" id="client-id" name="client_id" value="<%=client_id %>">
    <input type="hidden" id="post-logout-redirect-uri" name="post_logout_redirect_uri" value="http://localhost:8082/Service_Snap/index.jsp">
    <input type="hidden" id="state" name="state" value="<%= sessionState %>">
    <button id="logout-btn" type="submit">Logout</button>
</form>
   
   
</div>

<!-- Rest of your content here -->
</body>

</html>
