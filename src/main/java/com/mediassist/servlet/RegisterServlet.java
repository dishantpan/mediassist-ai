// RegisterServlet.java
package com.mediassist.servlet;

import com.mediassist.dao.UserDAO;
import com.mediassist.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        UserDAO dao = new UserDAO();

        if (dao.emailExists(email)) {
            res.sendRedirect("register.html?error=exists");
            return;
        }

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);

        boolean success = dao.registerUser(user);
        if (success) {
            res.sendRedirect("index.html?success=registered");
        } else {
            res.sendRedirect("register.html?error=failed");
        }
    }
}