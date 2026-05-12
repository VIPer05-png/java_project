package com.travel.app.controller;

import com.travel.app.model.Booking;
import com.travel.app.model.TourPackage;
import com.travel.app.model.User;
import com.travel.app.repository.BookingRepository;
import com.travel.app.repository.TourPackageRepository;
import com.travel.app.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired private BookingRepository bookingRepository;
    @Autowired private TourPackageRepository tourPackageRepository;
    @Autowired private UserRepository userRepository;

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        User user = userRepository.findByUsername(authentication.getName()).orElse(null);
        if (user != null) {
            model.addAttribute("bookings", bookingRepository.findByUserId(user.getId()));
        }
        return "user/dashboard";
    }

    /* ── Book a Package ── */
    @PostMapping("/book")
    public String bookPackage(@RequestParam Long packageId,
                              @RequestParam String travelDate,
                              @RequestParam int travelers,
                              Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElse(null);
        TourPackage tour = tourPackageRepository.findById(packageId).orElse(null);

        if (user != null && tour != null && tour.getAvailableSeats() >= travelers) {
            Booking booking = new Booking(user, tour,
                    LocalDate.now(), LocalDate.parse(travelDate), travelers, "CONFIRMED");
            bookingRepository.save(booking);
            tour.setAvailableSeats(tour.getAvailableSeats() - travelers);
            tourPackageRepository.save(tour);
        }
        return "redirect:/user/dashboard?booked=true";
    }

    /* ── Cancel a Booking ── */
    @PostMapping("/cancel/{id}")
    public String cancelBooking(@PathVariable Long id, Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElse(null);
        bookingRepository.findById(id).ifPresent(booking -> {
            // Only allow cancellation of own CONFIRMED booking
            if (user != null && booking.getUser().getId().equals(user.getId())
                    && "CONFIRMED".equals(booking.getStatus())) {
                booking.setStatus("CANCELLED");
                // Restore seats
                TourPackage tour = booking.getTourPackage();
                tour.setAvailableSeats(tour.getAvailableSeats() + booking.getNumberOfTravelers());
                tourPackageRepository.save(tour);
                bookingRepository.save(booking);
            }
        });
        return "redirect:/user/dashboard?cancelled=true";
    }
}
