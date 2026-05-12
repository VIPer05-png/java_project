package com.travel.app.repository;

import com.travel.app.model.TourPackage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TourPackageRepository extends JpaRepository<TourPackage, Long> {

    @Query("SELECT p FROM TourPackage p WHERE " +
           "(:search IS NULL OR LOWER(p.title) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "   OR LOWER(p.destination.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "   OR LOWER(p.destination.country) LIKE LOWER(CONCAT('%', :search, '%'))) " +
           "AND p.price >= :minPrice " +
           "AND p.price <= :maxPrice " +
           "AND (:maxDays = 0 OR p.durationDays <= :maxDays)")
    List<TourPackage> searchPackages(
            @Param("search") String search,
            @Param("minPrice") double minPrice,
            @Param("maxPrice") double maxPrice,
            @Param("maxDays") int maxDays
    );
}
