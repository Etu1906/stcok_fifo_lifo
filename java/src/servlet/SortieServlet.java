package servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mouvement.Mouvement;

import java.io.IOException;

@WebServlet("/ajoutmouvement")
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
            response.sendRedirect("/stock/mouvement");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/stock/mouvement?erreur=" + e.getMessage());
        }
    }
}
