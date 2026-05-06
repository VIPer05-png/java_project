package com.travelo.servlet;

import com.travelo.dao.BookingDao;
import com.travelo.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/booking_action")
public class BookingActionServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Unauthorized access");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        if ("cancel".equals(action)) {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            BookingDao bookingDao = new BookingDao();
            
            if (bookingDao.cancelBooking(bookingId, user.getId())) {
                response.sendRedirect("my_bookings.jsp?msg=Booking cancelled successfully");
            } else {
                response.sendRedirect("my_bookings.jsp?error=Cancellation failed");
            }
        }
    }
}
