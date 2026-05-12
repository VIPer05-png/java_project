package com.travel.app.controller;

import com.travel.app.model.Destination;
import com.travel.app.model.TourPackage;
import com.travel.app.model.User;
import com.travel.app.repository.DestinationRepository;
import com.travel.app.repository.TourPackageRepository;
import com.travel.app.repository.UserRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class PublicController {

    @Autowired private DestinationRepository destinationRepository;
    @Autowired private TourPackageRepository tourPackageRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    @PostConstruct
    public void init() {
        if (userRepository.findByUsername("admin").isEmpty()) {
            User admin = new User("admin", passwordEncoder.encode("admin123"), "admin@wanderlust.com", "ROLE_ADMIN");
            userRepository.save(admin);
        }
        if (destinationRepository.count() == 0) {
            Destination d1 = new Destination("Santorini", "Greece",
                "Famous for its dramatic views, stunning sunsets, white-washed houses, and blue domed churches.",
                "https://images.unsplash.com/photo-1533105079780-92b9be482077?auto=format&fit=crop&w=800&q=80");
            Destination d2 = new Destination("Kyoto", "Japan",
                "Japan's cultural capital filled with ancient temples, traditional tea houses, and serene bamboo groves.",
                "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=800&q=80");
            Destination d3 = new Destination("Bali", "Indonesia",
                "Island paradise known for its volcanic mountains, terraced rice paddies, beaches, and coral reefs.",
                "https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=800&q=80");
            destinationRepository.saveAll(List.of(d1, d2, d3));

            tourPackageRepository.saveAll(List.of(
                new TourPackage(d1, "Santorini 5-Day Escape",   1200.0, 5, 20),
                new TourPackage(d2, "Kyoto Heritage Tour",       1500.0, 7, 15),
                new TourPackage(d3, "Bali Bliss Adventure",       950.0, 6, 25)
            ));
        }
    }

    @GetMapping("/")
    public String home(
            @RequestParam(required = false, defaultValue = "") String search,
            @RequestParam(required = false, defaultValue = "0")    double minPrice,
            @RequestParam(required = false, defaultValue = "99999") double maxPrice,
            @RequestParam(required = false, defaultValue = "0")    int maxDays,
            Model model) {

        List<TourPackage> packages;
        boolean isFiltered = !search.isBlank() || minPrice > 0 || maxPrice < 99999 || maxDays > 0;

        if (isFiltered) {
            packages = tourPackageRepository.searchPackages(search, minPrice, maxPrice, maxDays);
        } else {
            packages = tourPackageRepository.findAll();
        }

        model.addAttribute("packages",    packages);
        model.addAttribute("destinations", destinationRepository.findAll());
        model.addAttribute("search",    search);
        model.addAttribute("minPrice",  minPrice);
        model.addAttribute("maxPrice",  maxPrice < 99999 ? maxPrice : 0);
        model.addAttribute("maxDays",   maxDays);
        model.addAttribute("isFiltered", isFiltered);
        return "index";
    }
}
