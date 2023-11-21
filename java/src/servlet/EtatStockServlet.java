package servlet;

import java.io.IOException;

import etat_stock.etat.EtatStock;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/etatStock")
public class EtatStockServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dt1 = request.getParameter("dt1");
        String dt2 = request.getParameter("dt2");
        String magasin = request.getParameter("magasin");
        String article = request.getParameter("article");

        // Créez un objet EtatStock en utilisant les données du formulaire (à
        // implémenter)
        try {
            EtatStock etatStock = EtatStock.getEtatStock(dt1, dt2, magasin, article);
            
            request.setAttribute("dt1", dt1);
            request.setAttribute("dt2", dt2);
            // Placez l'objet EtatStock dans le request
            request.setAttribute("etatStock", etatStock);

            // Dispatch vers une page JSP pour afficher l'état de stock
            request.getRequestDispatcher("etat_stock.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
