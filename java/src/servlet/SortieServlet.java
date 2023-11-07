package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import mouvement.Mouvement;

import java.io.IOException;

public class SortieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String date = request.getParameter("date");
        String idarticle = request.getParameter("idarticle");
        String quantite = request.getParameter("quantite");
        String idmagasin = request.getParameter("idmagasin");

        try {
            Mouvement mouvement = new Mouvement();
            mouvement.sortie(date, idarticle, quantite, idmagasin);

            response.sendRedirect("mouvement.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
