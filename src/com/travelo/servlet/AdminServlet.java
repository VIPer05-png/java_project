package com.travelo.servlet;

import com.travelo.dao.ItemDao;
import com.travelo.model.Hotel;
import com.travelo.model.Package;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin_action")
public class AdminServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        ItemDao itemDao = new ItemDao();
        
        if ("addPackage".equals(action)) {
            Package p = new Package();
            p.setDestination(request.getParameter("destination"));
            p.setDescription(request.getParameter("description"));
            p.setPrice(Double.parseDouble(request.getParameter("price")));
            p.setDuration(request.getParameter("duration"));
            
            if (itemDao.addPackage(p)) {
                response.sendRedirect("admin_dashboard.jsp?msg=Package added successfully!");
            } else {
                response.sendRedirect("admin_dashboard.jsp?error=Failed to add package");
            }
        } else if ("addHotel".equals(action)) {
            Hotel h = new Hotel();
            h.setName(request.getParameter("name"));
            h.setLocation(request.getParameter("location"));
            h.setPricePerNight(Double.parseDouble(request.getParameter("price")));
            h.setImageUrl(request.getParameter("image_url"));
            
            if (itemDao.addHotel(h)) {
                response.sendRedirect("admin_dashboard.jsp?msg=Hotel added successfully!");
            } else {
                response.sendRedirect("admin_dashboard.jsp?error=Failed to add hotel");
            }
        }
    }
}
