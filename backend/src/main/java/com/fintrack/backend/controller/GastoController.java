package com.fintrack.backend.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fintrack.backend.model.Gasto;
import com.fintrack.backend.repository.GastoRepository;

@RestController
@RequestMapping("/api/gastos")
@CrossOrigin
public class GastoController {

    @Autowired
    private GastoRepository gastoRepository;
    
    @GetMapping
    public List<Gasto> obtenerTodos(){
        return gastoRepository.findAll();
    }

    @PostMapping
    public Gasto guardarGasto(@RequestBody Gasto gasto) {
        return gastoRepository.save(gasto);
    }
}
