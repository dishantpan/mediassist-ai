// HistoryServlet.java
package com.mediassist.servlet;

import com.mediassist.dao.ConsultationDAO;
import com.mediassist.model.Consultation;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class HistoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("index.html");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        ConsultationDAO dao = new ConsultationDAO();
        List<Consultation> history = dao.getByUserId(userId);

        req.setAttribute("history", history);
        req.getRequestDispatcher("history.jsp").forward(req, res);
    }
}