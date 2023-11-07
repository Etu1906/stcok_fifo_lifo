<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulaire État de Stock</title>
</head>
<body>
    <h1>Formulaire État de Stock</h1>
    <form action="etatStock" method="post">
        <label for="dt1">Date 1 :</label>
        <input type="date" id="dt1" name="dt1"><br>

        <label for="dt2">Date 2 :</label>
        <input type="date" id="dt2" name="dt2"><br>

        <label for="magasin">Magasin :</label>
        <input type="text" id="magasin" name="magasin"><br>

        <label for="article">Article :</label>
        <input type="text" id="article" name="article"><br>

        <input type="submit" value="Générer État de Stock">
    </form>
</body>
</html>
