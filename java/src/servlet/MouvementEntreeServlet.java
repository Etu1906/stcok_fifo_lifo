package servlet;

import java.io.IOException;
import java.util.List;

import etat_stock.produit.Article;
import etat_stock.storage.Magasin;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/mouvement")
public class MouvementEntreeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Récupérez la liste des magasins et des articles en utilisant la fonction
            // getAll
            List<Magasin> magasins = Magasin.getAll(null);
            List<Article> articles = Article.getAll(null);

            // Ajoutez les listes à la requête en tant qu'attributs
            request.setAttribute("magasins", magasins);
            request.setAttribute("articles", articles);

            // Redirigez vers le formulaire JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("mouvement.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // Gérez l'erreur et affichez un message d'erreur
        }
    }
}
