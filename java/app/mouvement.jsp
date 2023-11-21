<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "etat_stock.produit.Article" %>
<%@ page import = "etat_stock.storage.Magasin" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Formulaire mouvement</title>
    <link rel="stylesheet" href="css/etatstock.css" />
    <style type="text/css"></style>
  </head>
  <body>
    <div class="container">
      <div class="left">
        <form action="ajoutmouvement" method="post">
          <div class="title">Formulaire de mouvement</div>
          <hr class="ligne" />
          <div class="form">
            <div style="color:red;" >
                <% if( request.getParameter( "erreur" ) != null ){ %>
                    <%= request.getParameter( "erreur" )  %>
                <% } %>
            </div>
            <label for="">
              <div class="text">Date :</div>
              <input type="date" name="date" id="" />
            </label>
            <label for="">
              <div class="text">Article :</div>
              <select name="idarticle" id="">
                <%
                    List<Article> articles = (List<Article>) request.getAttribute("articles");
                    for (Article article : articles) {
                %>
                    <option value="<%= article.getIdArticle() %>"><%= article.getNomArticle() %></option>
                <%
                    }
                %>
              </select>
            </label>
            <label for="">
              <div class="text">Quantité :</div>
              <input type="text" name="quantite" id="" />
            </label>
            <label for="">
              <div class="text">Magasin :</div>
              <select name="idmagasin" id="">
                <%
                    List<Magasin> magasins = (List<Magasin>) request.getAttribute("magasins");
                    for (Magasin magasin : magasins) {
                %>
                    <option value="<%= magasin.getIdMagasin() %>"><%= magasin.getNomMagasin() %></option>
                <%
                    }
                %>
              </select>
            </label>
            <label for="">
              <input type="submit" value="Valider" />
            </label>
          </div>
        </form>
      </div>
      <div class="right"></div>
    </div>
  </body>
</html>
