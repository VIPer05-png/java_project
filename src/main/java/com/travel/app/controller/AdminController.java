package com.travel.app.controller;

import com.travel.app.model.Destination;
import com.travel.app.model.TourPackage;
import com.travel.app.repository.BookingRepository;
import com.travel.app.repository.DestinationRepository;
import com.travel.app.repository.TourPackageRepository;
import com.travel.app.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private UserRepository userRepository;
    @Autowired private DestinationRepository destinationRepository;
    @Autowired private TourPackageRepository tourPackageRepository;
    @Autowired private BookingRepository bookingRepository;

    @GetMapping("/dashboard")
    public String adminDashboard(Model model) {
        model.addAttribute("totalUsers",    userRepository.count());
        model.addAttribute("totalBookings", bookingRepository.count());
        model.addAttribute("destinations",  destinationRepository.findAll());
        model.addAttribute("packages",      tourPackageRepository.findAll());
        model.addAttribute("bookings",      bookingRepository.findAll());
        return "admin/dashboard";
    }

    /* ── Add Destination ── */
    @PostMapping("/add-destination")
    public String addDestination(Destination destination) {
        destinationRepository.save(destination);
        return "redirect:/admin/dashboard?destAdded=true";
    }

    /* ── Add Package ── */
    @PostMapping("/add-package")
    public String addPackage(TourPackage tourPackage) {
        tourPackageRepository.save(tourPackage);
        return "redirect:/admin/dashboard?pkgAdded=true";
    }

    /* ── Delete Package ── */
    @PostMapping("/delete-package/{id}")
    public String deletePackage(@PathVariable Long id) {
        tourPackageRepository.deleteById(id);
        return "redirect:/admin/dashboard?pkgDeleted=true";
    }

    /* ── Delete Destination ── */
    @PostMapping("/delete-destination/{id}")
    public String deleteDestination(@PathVariable Long id) {
        destinationRepository.deleteById(id);
        return "redirect:/admin/dashboard?destDeleted=true";
    }

    /* ── Update Booking Status ── */
    @PostMapping("/update-booking/{id}")
    public String updateBookingStatus(@PathVariable Long id, @RequestParam String status) {
        bookingRepository.findById(id).ifPresent(booking -> {
            String prev = booking.getStatus();
            booking.setStatus(status);
            // Restore seats on cancel, deduct on re-confirm
            if ("CANCELLED".equals(status) && !"CANCELLED".equals(prev)) {
                booking.getTourPackage().setAvailableSeats(
                    booking.getTourPackage().getAvailableSeats() + booking.getNumberOfTravelers()
                );
                tourPackageRepository.save(booking.getTourPackage());
            } else if ("CONFIRMED".equals(status) && "CANCELLED".equals(prev)) {
                booking.getTourPackage().setAvailableSeats(
                    booking.getTourPackage().getAvailableSeats() - booking.getNumberOfTravelers()
                );
                tourPackageRepository.save(booking.getTourPackage());
            }
            bookingRepository.save(booking);
        });
        return "redirect:/admin/dashboard";
    }
}
