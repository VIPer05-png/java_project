<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travelo.model.User" %>
<style>
    .navbar {
        background: rgba(255, 255, 255, 0.95) !important;
        backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(0,0,0,0.05);
    }
    .navbar-brand {
        font-weight: 800;
        letter-spacing: -0.5px;
        background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }
    .nav-link {
        color: #475569 !important;
        font-weight: 600;
        font-size: 0.95rem;
        transition: color 0.3s ease;
    }
    .nav-link:hover {
        color: #6366f1 !important;
    }
    .btn-nav-primary {
        background: #6366f1;
        color: white !important;
        border-radius: 50px;
        padding: 8px 24px !important;
        box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2);
    }
    .btn-nav-primary:hover {
        background: #4f46e5;
        transform: translateY(-1px);
    }
</style>
<nav class="navbar navbar-expand-lg navbar-light sticky-top py-3">
  <div class="container">
    <a class="navbar-brand fs-4" href="index.jsp">🌎 TRAVELO</a>
    <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto align-items-center">
        <li class="nav-item">
          <a class="nav-link px-3" href="index.jsp">Home</a>
        </li>
        <%
            User navUser = (User) session.getAttribute("user");
            if (navUser != null) {
                if ("ADMIN".equals(navUser.getRole())) {
        %>
                    <li class="nav-item"><a class="nav-link px-3" href="admin_dashboard.jsp">Admin Panel</a></li>
        <%      } else { %>
                    <li class="nav-item"><a class="nav-link px-3" href="dashboard.jsp">Explore</a></li>
                    <li class="nav-item"><a class="nav-link px-3" href="my_bookings.jsp">My Bookings</a></li>
        <%      } %>
                <li class="nav-item ms-lg-3">
                    <div class="dropdown">
                        <a class="nav-link dropdown-toggle fw-bold text-primary" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            Hi, <%= navUser.getName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg rounded-3 mt-2">
                            <li><a class="dropdown-item py-2 text-danger" href="auth?action=logout">Logout</a></li>
                        </ul>
                    </div>
                </li>
        <%  } else { %>
                <li class="nav-item">
                  <a class="nav-link px-3" href="login.jsp">Login</a>
                </li>
                <li class="nav-item ms-lg-2">
                  <a class="nav-link btn-nav-primary" href="register.jsp">Get Started</a>
                </li>
        <%  } %>
      </ul>
    </div>
  </div>
</nav>
