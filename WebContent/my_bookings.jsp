<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travelo.dao.BookingDao" %>
<%@ page import="com.travelo.model.Booking" %>
<%@ page import="com.travelo.model.User" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if(currentUser == null) {
        response.sendRedirect("login.jsp?error=Please login to view bookings");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Bookings - TRAVELO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            --glass-bg: rgba(255, 255, 255, 0.9);
        }
        body {
            font-family: 'Outfit', sans-serif;
            background: #f8fafc;
            min-height: 100vh;
        }
        .booking-card {
            border: none;
            border-radius: 20px;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }
        .booking-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.85rem;
        }
        .status-confirmed { background: #dcfce7; color: #166534; }
        .status-cancelled { background: #fee2e2; color: #991b1b; }
        .page-title {
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 800;
        }
    </style>
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h2 class="page-title display-5">Your Adventures 🏕️</h2>
            <a href="dashboard.jsp" class="btn btn-outline-primary rounded-pill px-4">Book New</a>
        </div>

        <% if(request.getParameter("msg") != null) { %>
            <div class="alert alert-success rounded-pill px-4 shadow-sm mb-4 border-0">
                ✨ <%= request.getParameter("msg") %>
            </div>
        <% } %>
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger rounded-pill px-4 shadow-sm mb-4 border-0">
                ❌ <%= request.getParameter("error") %>
            </div>
        <% } %>

        <div class="row g-4">
            <%
                BookingDao bookingDao = new BookingDao();
                List<Booking> bookings = bookingDao.getUserBookings(currentUser.getId());
                if (bookings.isEmpty()) {
            %>
                <div class="col-12 text-center py-5">
                    <div class="card booking-card p-5 border-0">
                        <h3 class="text-muted">No bookings found yet!</h3>
                        <p class="mb-4">Your future adventures are waiting for you.</p>
                        <a href="dashboard.jsp" class="btn btn-primary rounded-pill px-5 py-3 shadow">Explore Destinations</a>
                    </div>
                </div>
            <%
                } else {
                    for(Booking b : bookings) {
            %>
                <div class="col-md-6 col-lg-4">
                    <div class="card booking-card h-100 p-4">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <span class="badge bg-soft-primary text-primary px-3 py-2 rounded-pill" style="background: #eef2ff;">
                                <%= b.getBookingType() %>
                            </span>
                            <span class="status-badge <%= "CONFIRMED".equals(b.getStatus()) ? "status-confirmed" : "status-cancelled" %>">
                                <%= b.getStatus() %>
                            </span>
                        </div>
                        <h4 class="fw-bold mb-2 text-dark"><%= b.getItemName() != null ? b.getItemName() : "N/A" %></h4>
                        <div class="text-muted small mb-3">
                            <i class="bi bi-calendar3 me-1"></i> Booked on: <%= b.getBookingDate().toLocalDateTime().toLocalDate() %>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-auto pt-3 border-top">
                            <div>
                                <span class="text-muted small d-block">Total Paid</span>
                                <span class="h5 fw-bold text-primary mb-0">₹<%= b.getTotalPrice() %></span>
                            </div>
                            <% if("CONFIRMED".equals(b.getStatus())) { %>
                                <a href="booking_action?action=cancel&id=<%= b.getId() %>" 
                                   class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                   onclick="return confirm('Are you sure you want to cancel this booking?')">Cancel</a>
                            <% } %>
                        </div>
                    </div>
                </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
