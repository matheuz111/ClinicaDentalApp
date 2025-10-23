/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dental.app.clinicadentalapp.controller;

import com.dental.app.clinicadentalapp.dao.CitaDAO;
import com.dental.app.clinicadentalapp.dao.CitaDAO.EstadoRegistroCita; // CAMBIO 1: Importar el enum
import com.dental.app.clinicadentalapp.model.Cita;
import com.dental.app.clinicadentalapp.model.Odontologo;
import com.dental.app.clinicadentalapp.model.Paciente;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Matheus
 */
@WebServlet(name = "CitaController", urlPatterns = {"/cita"})
public class CitaController extends HttpServlet {

    private CitaDAO citaDAO = new CitaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            int pacienteId = Integer.parseInt(request.getParameter("pacienteId"));
            int odontologoId = Integer.parseInt(request.getParameter("odontologoId"));
            LocalDate fecha = LocalDate.parse(request.getParameter("fecha"));
            LocalTime hora = LocalTime.parse(request.getParameter("hora"));
            String motivo = request.getParameter("motivo");
            String estado = "Programada"; // O puedes añadir un campo para el estado si quieres

            Paciente p = new Paciente();
            p.setPacienteId(pacienteId);

            Odontologo o = new Odontologo();
            o.setOdontologoId(odontologoId);
            
            Cita cita = new Cita();
            cita.setPaciente(p);
            cita.setOdontologo(o);
            cita.setFechaCita(fecha);
            cita.setHoraCita(hora);
            cita.setMotivo(motivo);
            cita.setEstado(estado);

            boolean exito = false;
            String redirectParam = "";

            if ("agendar".equals(action)) {
                // CAMBIO 2: Ya no usamos boolean, usamos el enum
                EstadoRegistroCita resultado = citaDAO.registrarCita(cita);
                
                // CAMBIO 3: Manejamos los 3 posibles casos
                switch (resultado) {
                    case EXITO:
                        redirectParam = "registro=exito";
                        break;
                    case ERROR_HORARIO_OCUPADO:
                        redirectParam = "registro=error_horario"; // Nuevo error
                        break;
                    case ERROR_BD:
                        redirectParam = "registro=error"; // Error genérico
                        break;
                }
            } else if ("editar".equals(action)) {
                int citaId = Integer.parseInt(request.getParameter("citaId"));
                cita.setCitaId(citaId);
                // Nota: La edición no verifica duplicados por ahora, solo el registro.
                exito = citaDAO.actualizarCita(cita);
                redirectParam = exito ? "update=exito" : "update=error";
            }
            
            response.sendRedirect("dashboard/dashboard.jsp?page=citas&" + redirectParam);

        } catch (NumberFormatException | DateTimeParseException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard/dashboard.jsp?page=citas&registro=error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("eliminar".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (citaDAO.eliminarCita(id)) {
                    response.sendRedirect("dashboard/dashboard.jsp?page=citas&delete=exito");
                } else {
                    response.sendRedirect("dashboard/dashboard.jsp?page=citas&delete=error");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("dashboard/dashboard.jsp?page=citas&delete=error");
            }
        }
    }
}