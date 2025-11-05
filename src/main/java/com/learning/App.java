package com.learning;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;

@WebServlet("/api/health")
public class App extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        
        String healthStatus = "{"
            + "\"status\": \"UP\","
            + "\"application\": \"Learning Platform\","
            + "\"version\": \"1.0.0\","
            + "\"timestamp\": \"" + LocalDateTime.now() + "\""
            + "}";
        
        out.println(healthStatus);
        out.close();
    }
}