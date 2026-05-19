// AdminServlet.java
package com.mediassist.servlet;

import com.mediassist.dao.ConsultationDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

public class AdminServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        ConsultationDAO dao = new ConsultationDAO();
        Map<String, Integer> deptCount = dao.getDepartmentCount();
        int total = dao.getTotalCount();

        req.setAttribute("deptCount", deptCount);
        req.setAttribute("total", total);
        req.getRequestDispatcher("admin.jsp").forward(req, res);
    }
}