package com.fintrack.backend.repository;

import com.fintrack.backend.model.*;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GastoRepository extends JpaRepository<Gasto, Long> {
    /*  Esto esta vacio porque ya hereda todo lo que necesita como findAll(), save(),
    deleteById() etc .. */
}
