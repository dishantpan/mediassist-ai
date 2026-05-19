package com.mediassist.dao;

import com.mediassist.model.Consultation;
import com.mediassist.util.DBConnection;

import java.sql.*;
import java.util.*;

public class ConsultationDAO {

    // Naya consultation save karo
    public boolean saveConsultation(int userId, String symptoms, String department) {
        String sql = "INSERT INTO consultations (user_id, symptoms_selected, department_suggested) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, symptoms);
            ps.setString(3, department);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Ek user ki history fetch karo
    public List<Consultation> getByUserId(int userId) {
        List<Consultation> list = new ArrayList<>();
        String sql = "SELECT * FROM consultations WHERE user_id = ? ORDER BY consultation_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Consultation(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("symptoms_selected"),
                        rs.getString("department_suggested"),
                        rs.getString("consultation_date")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Admin ke liye: department wise count
    public Map<String, Integer> getDepartmentCount() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT department_suggested, COUNT(*) as cnt FROM consultations GROUP BY department_suggested";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                map.put(rs.getString("department_suggested"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    // Admin ke liye: total count
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM consultations";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}