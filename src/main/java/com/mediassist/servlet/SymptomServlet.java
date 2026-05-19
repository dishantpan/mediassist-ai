// SymptomServlet.java
package com.mediassist.servlet;

import com.mediassist.dao.ConsultationDAO;
import com.mediassist.rules.DepartmentMapper;
import com.mediassist.util.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class SymptomServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Session check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("index.html");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // Symptoms collect karo
        String[] selected = req.getParameterValues("symptoms");
        List<String> symptoms = (selected != null) ? Arrays.asList(selected) : new ArrayList<>();

        // Department suggest karo
        DepartmentMapper mapper = new DepartmentMapper();
        String department = mapper.suggest(symptoms);

        // DB mein save karo
        ConsultationDAO cDao = new ConsultationDAO();
        cDao.saveConsultation(userId, String.join(", ", symptoms), department);

        // Hospitals fetch karo
        List<Map<String, String>> hospitals = new ArrayList<>();
        String sql = "SELECT * FROM hospitals WHERE department = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, department);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> h = new HashMap<>();
                h.put("name", rs.getString("name"));
                h.put("city", rs.getString("city"));
                h.put("contact", rs.getString("contact"));
                hospitals.add(h);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Result.jsp ko data pass karo
        req.setAttribute("department", department);
        req.setAttribute("hospitals", hospitals);
        req.setAttribute("symptoms", symptoms);
        req.getRequestDispatcher("result.jsp").forward(req, res);
    }
}