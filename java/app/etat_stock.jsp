<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import = "java.util.*" %>
<%@ page import = "etat_stock.etat.EtatStock" %>
<%@ page import = "etat_stock.storage.Stock" %>
<%
    EtatStock etatStock = (EtatStock) request.getAttribute("etatStock");
    String dt1 = ( String )request.getAttribute("dt1");
    String dt2 = ( String )request.getAttribute("dt2");
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tableau de l'État de Stock   </title>
    <link rel="stylesheet" href="css/table.css" />
    <style type="text/css"></style>
  </head>
  <body>
    <div class="container">
      <div class="title">État De Stock du <%= dt1 %> au <%= dt2 %></div>
      <table>
        <tr class="title_row" >
            <th>Article</th>
            <th>Unite</th>
            <th>TypeStock</th>
            <th>Magasin</th>
            <th>Quantité Initiale</th>
            <th>Sortant</th>
            <th>PU</th>
            <th>Montant</th>
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
                <td><%= stock.getPu() %></td>
                <td><%= stock.getMontant() %></td>
            </tr>
        <%
            }
        %>
        <tr>
            <td style="text-align: right; background: #000;color:#fff; font-weight:600; padding-right: 10px;" >Somme Montant</td>
            <td></td>
            <td></td>
            <td> </td>
            <td>  </td>
            <td></td>
            <td></td>
            <td><%= etatStock.getSommeMontant() %></td>
        </tr>
      </table>
        <a class="link" href="index.jsp">Retour</a>
    </div>
  </body>
</html>
