<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travelo.dao.ItemDao" %>
<%@ page import="com.travelo.model.Package" %>
<%@ page import="com.travelo.model.Hotel" %>
<%@ page import="java.util.List" %>
<%
    if(session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=Access Denied! Please login.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Explore Destinations - TRAVELO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background: #f8fafc; }
        .dashboard-header {
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            padding: 60px 0;
            color: white;
            border-radius: 0 0 40px 40px;
            margin-bottom: 50px;
        }
        .item-card {
            border: none;
            border-radius: 24px;
            overflow: hidden;
            background: #fff;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .item-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .item-img {
            height: 220px;
            object-fit: cover;
        }
        .price-tag {
            font-size: 1.5rem;
            font-weight: 800;
            color: #6366f1;
        }
        .btn-book {
            border-radius: 12px;
            font-weight: 700;
            padding: 10px 20px;
            transition: all 0.3s ease;
        }
        .section-badge {
            background: #eef2ff;
            color: #6366f1;
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.8rem;
            text-transform: uppercase;
        }
    </style>
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="dashboard-header text-center">
        <div class="container">
            <h1 class="display-5 fw-bold mb-2">Welcome Back, ${sessionScope.user.name} 👋</h1>
            <p class="lead opacity-75">Where do you want to go today?</p>
        </div>
    </div>

    <div class="container pb-5">
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger rounded-pill px-4 shadow-sm mb-4 border-0"><%= request.getParameter("error") %></div>
        <% } %>
        <% if(request.getParameter("msg") != null) { %>
            <div class="alert alert-success alert-dismissible fade show rounded-pill px-4 shadow-sm mb-4 border-0" role="alert">
                ✨ <%= request.getParameter("msg") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <!-- Travel Packages Section -->
        <div class="d-flex align-items-center mb-4 mt-2">
            <span class="section-badge me-3">Curated Experiences</span>
            <h3 class="fw-bold text-dark mb-0">Trending Packages</h3>
        </div>
        
        <div class="row g-4">
            <%
                ItemDao itemDao = new ItemDao();
                List<Package> packages = itemDao.getAllPackages();
                for(Package pkg : packages) {
            %>
            <div class="col-md-4">
                <div class="card item-card h-100">
                    <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&q=80&w=600" class="item-img" alt="Destination">
                    <div class="card-body p-4 d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="fw-bold mb-0"><%= pkg.getDestination() %></h5>
                            <span class="small text-muted"><i class="bi bi-clock me-1"></i><%= pkg.getDuration() %></span>
                        </div>
                        <p class="text-muted small flex-grow-1"><%= pkg.getDescription() %></p>
                        <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                            <span class="price-tag">₹<%= pkg.getPrice() %></span>
                            <form action="book" method="post" class="m-0">
                                <input type="hidden" name="type" value="PACKAGE">
                                <input type="hidden" name="referenceId" value="<%= pkg.getId() %>">
                                <input type="hidden" name="price" value="<%= pkg.getPrice() %>">
                                <button type="submit" class="btn btn-primary btn-book shadow-sm px-4">Book Trip</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <!-- Hotels Section -->
        <div class="d-flex align-items-center mb-4 mt-5 pt-4">
            <span class="section-badge me-3" style="background: #ecfdf5; color: #10b981;">Luxury Stays</span>
            <h3 class="fw-bold text-dark mb-0">Recommended Hotels</h3>
        </div>

        <div class="row g-4 mb-5">
            <%
                List<Hotel> hotels = itemDao.getAllHotels();
                for(Hotel hotel : hotels) {
            %>
            <div class="col-md-4">
                <div class="card item-card h-100">
                    <img src="<%= hotel.getImageUrl() %>" class="item-img" alt="<%= hotel.getName() %>">
                    <div class="card-body p-4 d-flex flex-column">
                        <h5 class="fw-bold mb-1"><%= hotel.getName() %></h5>
                        <p class="text-muted small mb-3"><i class="bi bi-geo-alt me-1"></i><%= hotel.getLocation() %></p>
                        <div class="d-flex justify-content-between align-items-center mt-auto pt-3 border-top">
                            <div class="d-flex flex-column">
                                <span class="price-tag mb-0">₹<%= hotel.getPricePerNight() %></span>
                                <span class="text-muted small">/ night</span>
                            </div>
                            <form action="book" method="post" class="m-0">
                                <input type="hidden" name="type" value="HOTEL">
                                <input type="hidden" name="referenceId" value="<%= hotel.getId() %>">
                                <input type="hidden" name="price" value="<%= hotel.getPricePerNight() %>">
                                <button type="submit" class="btn btn-success btn-book shadow-sm px-4" style="background: #10b981; border: none;">Reserve</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
