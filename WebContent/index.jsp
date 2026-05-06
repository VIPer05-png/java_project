<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>TRAVELO - Discover Your Next Adventure</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #6366f1;
            --secondary: #a855f7;
            --dark: #0f172a;
        }
        body { font-family: 'Outfit', sans-serif; color: var(--dark); overflow-x: hidden; }
        
        .hero-section {
            background: linear-gradient(rgba(15, 23, 42, 0.7), rgba(15, 23, 42, 0.7)), 
                        url('https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&q=80&w=1920') no-repeat center center;
            background-size: cover;
            height: 90vh;
            display: flex;
            align-items: center;
            color: white;
            position: relative;
        }
        .hero-content { max-width: 800px; }
        .hero-badge {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .btn-premium {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 50px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.3);
        }
        .btn-premium:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(99, 102, 241, 0.4);
            color: white;
        }
        .feature-card {
            border: none;
            border-radius: 24px;
            padding: 40px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background: #fff;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
        }
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
        }
        .icon-box {
            width: 60px;
            height: 60px;
            background: #f1f5ff;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
            color: var(--primary);
            font-size: 1.5rem;
        }
        .section-title { font-weight: 800; letter-spacing: -1px; }
        .footer { background: var(--dark); padding: 80px 0 40px; }
    </style>
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="hero-section">
        <div class="container">
            <div class="hero-content" data-aos="fade-up">
                <span class="hero-badge text-uppercase small">🌎 Your Global Travel Partner</span>
                <h1 class="display-1 fw-bold mb-4">Journey Beyond <span style="color: var(--primary)">Your Limits.</span></h1>
                <p class="lead mb-5 fs-4 text-white-50">Experience the world's most breathtaking destinations and stay in curated luxury hotels with TRAVELO.</p>
                <div class="d-flex gap-3">
                    <a href="register.jsp" class="btn btn-premium btn-lg">Explore Now</a>
                    <a href="login.jsp" class="btn btn-outline-light btn-lg rounded-pill px-5">Login</a>
                </div>
            </div>
        </div>
    </div>

    <div class="container py-5 my-5">
        <div class="text-center mb-5">
            <h6 class="text-primary fw-bold text-uppercase tracking-widest mb-2">Features</h6>
            <h2 class="section-title display-4 mb-4">Why Choose TRAVELO?</h2>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-card text-center h-100">
                    <div class="icon-box mx-auto">🏕️</div>
                    <h3 class="fw-bold mb-3">All-In-One</h3>
                    <p class="text-muted">Seamlessly book both travel packages and luxury hotels in a single unified experience.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card text-center h-100">
                    <div class="icon-box mx-auto">⚡</div>
                    <h3 class="fw-bold mb-3">Fast Booking</h3>
                    <p class="text-muted">Save your time with our highly optimized booking engine designed for speed and reliability.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card text-center h-100">
                    <div class="icon-box mx-auto">🛡️</div>
                    <h3 class="fw-bold mb-3">Secure & Robust</h3>
                    <p class="text-muted">Built with Java's enterprise-grade security to ensure your data and bookings are always safe.</p>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid py-5" style="background: #f8fafc;">
        <div class="container text-center py-5">
            <h2 class="fw-bold mb-5">Trusted by 10,000+ Travelers Worldwide</h2>
            <div class="row opacity-50 grayscale d-flex justify-content-center align-items-center g-5">
                <div class="col-2 fw-bold fs-3">AIRBNB</div>
                <div class="col-2 fw-bold fs-3">BOOKING</div>
                <div class="col-2 fw-bold fs-3">EXPEDIA</div>
                <div class="col-2 fw-bold fs-3">TRIPADVISOR</div>
            </div>
        </div>
    </div>

    <footer class="footer text-white">
        <div class="container">
            <div class="row g-5">
                <div class="col-lg-4">
                    <h4 class="fw-bold mb-4">TRAVELO</h4>
                    <p class="text-white-50">Redefining the way people explore the world. Your ultimate destination for travel and luxury stays.</p>
                </div>
                <div class="col-lg-2 offset-lg-2">
                    <h6 class="fw-bold mb-4">Links</h6>
                    <ul class="list-unstyled text-white-50">
                        <li class="mb-2"><a href="#" class="text-decoration-none text-reset">Home</a></li>
                        <li class="mb-2"><a href="#" class="text-decoration-none text-reset">Packages</a></li>
                        <li class="mb-2"><a href="#" class="text-decoration-none text-reset">Hotels</a></li>
                    </ul>
                </div>
                <div class="col-lg-4">
                    <h6 class="fw-bold mb-4">Newsletter</h6>
                    <div class="input-group mb-3 rounded-pill overflow-hidden bg-white p-1">
                        <input type="text" class="form-control border-0 px-3" placeholder="Email Address">
                        <button class="btn btn-primary rounded-pill px-4" type="button">Join</button>
                    </div>
                </div>
            </div>
            <hr class="my-5 opacity-10">
            <div class="text-center text-white-50 small">
                © 2026 TRAVELO - Premium MCA Project Submission. All Rights Reserved.
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>