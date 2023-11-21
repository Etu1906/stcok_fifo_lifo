<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>etat stock</title>
    <link rel="stylesheet" href="css/etatstock.css" />
    <style type="text/css"></style>
  </head>
  <body>
    <div class="container">
      <div class="left">
        <form action="etatStock" method="post">
          <div class="title">Formulaire Etat de Stock</div>
          <hr class="ligne" />
          <div class="form">
            <label for="">
              <div class="text">Date 1 :</div>
              <input type="date" name="dt1" id="" />
            </label>
            <label for="">
                <div class="text">Date 2 :</div>
                <input type="date" name="dt2" id="" />
              </label>
            <label for="">
              <div class="text">Magasin :</div>
              <input type="text" name="magasin" id="" />
            </label>
            <label for="">
                <div class="text">Article :</div>
                <input type="text" name="article" id="" />
              </label>
            <label for="">
              <input type="submit" value="Générer stock" />
            </label>
          </div>
        </form>
      </div>
      <div class="right"></div>
    </div>
  </body>
</html>
