<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import = "java.util.*" %>
<%@ page import = "etat_stock.etat.EtatStock" %>
<%@ page import = "etat_stock.storage.Stock" %>
<%
    EtatStock etatStock = (EtatStock) request.getAttribute("etatStock");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de l'État de Stock</title>
</head>
<body>
    <h1>État de Stock</h1>

    <table border="1">
        <tr>
            <th>Article</th>
            <th>Unite</th>
            <th>TypeStock</th>
            <th>Magasin</th>
            <th>Quantité Initiale</th>
            <th>Sortant</th>
            <th>Montant</th>
            <th>PU</th>
        </tr>

        <%
            for (Stock stock : etatStock.getListeStock()) {
        %>
            <tr>
                <td><%= stock.getArticle().getNomArticle() %></td>
                <td><%= stock.getArticle().getUnite().getNomUnite() %></td>
                <td><%= stock.getArticle().getTypeStock().getNomType() %></td>
                <td><%= stock.getMagasin().getNomMagasin() %></td>
                <td><%= stock.getQuantiteInitiale() %></td>
                <td><%= stock.getSortant() %></td>
                <td><%= stock.getMontant() %></td>
                <td><%= stock.getPu() %></td>
            </tr>
        <%
            }
        %>
    </table>

    <p>Somme du Montant : <%= etatStock.getSommeMontant() %></p>
    <a href="index.jsp" > Retour </a>
</body>
</html>
