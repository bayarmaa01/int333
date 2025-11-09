package com.learning;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.management.ManagementFactory;

@WebServlet("/metrics")
public class MetricsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        resp.setContentType("text/plain; version=0.0.4");
        PrintWriter out = resp.getWriter();
        
        Runtime runtime = Runtime.getRuntime();
        long uptime = ManagementFactory.getRuntimeMXBean().getUptime() / 1000;
        long usedMemory = (runtime.totalMemory() - runtime.freeMemory()) / (1024 * 1024);
        long maxMemory = runtime.maxMemory() / (1024 * 1024);
        
        // Prometheus format metrics
        out.println("# HELP app_status Application status (1 = UP, 0 = DOWN)");
        out.println("# TYPE app_status gauge");
        out.println("app_status 1");
        
        out.println("# HELP app_uptime_seconds Application uptime in seconds");
        out.println("# TYPE app_uptime_seconds counter");
        out.println("app_uptime_seconds " + uptime);
        
        out.println("# HELP jvm_memory_used_mb JVM memory used in MB");
        out.println("# TYPE jvm_memory_used_mb gauge");
        out.println("jvm_memory_used_mb " + usedMemory);
        
        out.println("# HELP jvm_memory_max_mb JVM max memory in MB");
        out.println("# TYPE jvm_memory_max_mb gauge");
        out.println("jvm_memory_max_mb " + maxMemory);
        
        out.close();
    }
}