<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travelo.util.DBConnection" %>
<%@ page import="com.travelo.model.User" %>
<%@ page import="java.sql.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Admin Access Required");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - TRAVELO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background: #f4f7fe; }
        .admin-card { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .nav-tabs { border: none; }
        .nav-link { border: none; color: #64748b; font-weight: 600; padding: 12px 25px; border-radius: 10px !important; }
        .nav-link.active { background: #fff !important; color: #6366f1 !important; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.1); }
        .btn-primary { background: #6366f1; border: none; border-radius: 10px; padding: 10px 20px; }
        .table thead { background: #f8fafc; }
        .status-badge { padding: 5px 12px; border-radius: 50px; font-size: 0.75rem; font-weight: 700; }
    </style>
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-dark mb-0">🛡️ Admin Control Panel</h2>
            <div class="text-muted">Logged in as: <span class="fw-bold text-primary"><%= user.getName() %></span></div>
        </div>

        <% if(request.getParameter("msg") != null) { %>
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-3 mb-4" role="alert">
                <strong>Success!</strong> <%= request.getParameter("msg") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-3 mb-4" role="alert">
                <strong>Error!</strong> <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <ul class="nav nav-tabs mb-4" id="adminTabs" role="tablist">
            <li class="nav-item me-2">
                <button class="nav-link active" id="bookings-tab" data-bs-toggle="tab" data-bs-target="#bookings" type="button">Recent Bookings</button>
            </li>
            <li class="nav-item me-2">
                <button class="nav-link" id="add-package-tab" data-bs-toggle="tab" data-bs-target="#add-package" type="button">Add Package</button>
            </li>
            <li class="nav-item">
                <button class="nav-link" id="add-hotel-tab" data-bs-toggle="tab" data-bs-target="#add-hotel" type="button">Add Hotel</button>
            </li>
        </ul>

        <div class="tab-content" id="adminTabsContent">
            <!-- Bookings Tab -->
            <div class="tab-pane fade show active" id="bookings" role="tabpanel">
                <div class="card admin-card p-4">
                    <h5 class="fw-bold mb-4">Latest Transactions</h5>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>User ID</th>
                                    <th>Service Type</th>
                                    <th>Total Price</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try (Connection conn = DBConnection.getConnection()) {
                                        if (conn == null) {
                                            out.println("<tr><td colspan='6' class='text-center text-danger'>Database connection failed. Please check your MySQL settings.</td></tr>");
                                        } else {
                                            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM bookings ORDER BY id DESC LIMIT 20");
                                                 ResultSet rs = ps.executeQuery()) {
                                                while(rs.next()) {
                                %>
                                <tr>
                                    <td class="fw-bold text-muted">#<%= rs.getInt("id") %></td>
                                    <td>User <%= rs.getInt("user_id") %></td>
                                    <td>
                                        <span class="badge" style="background: <%= "PACKAGE".equals(rs.getString("booking_type")) ? "#e0e7ff; color: #4338ca;" : "#dcfce7; color: #15803d;" %>">
                                            <%= rs.getString("booking_type") %>
                                        </span>
                                    </td>
                                    <td class="fw-bold">₹<%= rs.getDouble("total_price") %></td>
                                    <td>
                                        <span class="status-badge <%= "CONFIRMED".equals(rs.getString("status")) ? "bg-success text-white" : "bg-danger text-white" %>">
                                            <%= rs.getString("status") %>
                                        </span>
                                    </td>
                                    <td class="text-muted"><%= rs.getTimestamp("booking_date") %></td>
                                </tr>
                                <% } } } } catch(Exception e) { out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>"); } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Add Package Tab -->
            <div class="tab-pane fade" id="add-package" role="tabpanel">
                <div class="card admin-card p-4">
                    <h5 class="fw-bold mb-4">Create New Travel Package</h5>
                    <form action="admin_action" method="POST">
                        <input type="hidden" name="action" value="addPackage">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted small fw-bold">DESTINATION</label>
                                <input type="text" name="destination" class="form-control rounded-3 p-2" required placeholder="e.g. Maldives Island">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small fw-bold">DURATION</label>
                                <input type="text" name="duration" class="form-control rounded-3 p-2" required placeholder="e.g. 5 Days 4 Nights">
                            </div>
                            <div class="col-12">
                                <label class="form-label text-muted small fw-bold">DESCRIPTION</label>
                                <textarea name="description" class="form-control rounded-3 p-2" rows="3" required placeholder="Describe the trip highlights..."></textarea>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small fw-bold">PRICE (₹)</label>
                                <input type="number" name="price" class="form-control rounded-3 p-2" required placeholder="0.00">
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary px-5 py-2 fw-bold shadow-sm">Publish Package</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Add Hotel Tab -->
            <div class="tab-pane fade" id="add-hotel" role="tabpanel">
                <div class="card admin-card p-4">
                    <h5 class="fw-bold mb-4">Register New Luxury Hotel</h5>
                    <form action="admin_action" method="POST">
                        <input type="hidden" name="action" value="addHotel">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted small fw-bold">HOTEL NAME</label>
                                <input type="text" name="name" class="form-control rounded-3 p-2" required placeholder="e.g. Grand Hyatt">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small fw-bold">LOCATION</label>
                                <input type="text" name="location" class="form-control rounded-3 p-2" required placeholder="e.g. Mumbai">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small fw-bold">PRICE PER NIGHT (₹)</label>
                                <input type="number" name="price" class="form-control rounded-3 p-2" required placeholder="0.00">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small fw-bold">IMAGE URL</label>
                                <input type="url" name="image_url" class="form-control rounded-3 p-2" required placeholder="https://unsplash.com/...">
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary px-5 py-2 fw-bold shadow-sm">Add Hotel</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
