package etat_stock.produit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import connect.Connect;

public class Article {
    private String idArticle;
    private String nomArticle;
    private Unite unite;
    private TypeStock typeStock;

    public Article() {
    }

    public Article(String idArticle, String nomArticle, Unite unite, TypeStock typeStock) {
        setIdArticle(idArticle);
        setNomArticle(nomArticle);
        setUnite(unite);
        setTypeStock(typeStock);
    }

    public Article(String idarticle) {
        setIdArticle(idarticle);
    }

    public static List<Article> getAll(Connect c) throws Exception {
        boolean transact = true;
        List<Article> articles = new ArrayList<>();

        if (c == null) {
            transact = false;
            c = new Connect();
            c.getConnectionPostGresql();
        }

        String sql = "SELECT * FROM article";
        Connection conn = c.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        try {
            while (rs.next()) {
                Article article = new Article();
                article.setIdArticle(rs.getString("idarticle"));
                article.setNomArticle(rs.getString("nom_article"));

                Unite unite = new Unite();
                unite.setIdUnite(rs.getInt("idunite"));
                article.setUnite(unite);

                TypeStock typeStock = new TypeStock();
                typeStock.setIdTypeStock(rs.getInt("idtypestock"));
                article.setTypeStock(typeStock);

                articles.add(article);
            }
            stmt.close();
        } catch (Exception e) {
            c.rollback();
            throw e;
        } finally {
            if (transact == false) {
                rs.close();
            }
        }

        return articles;
    }

    public String getIdArticle() {
        return idArticle;
    }

    public void setIdArticle(String idArticle) {
        if (idArticle.isEmpty() == true) {
            this.idArticle = "%";
            return;
        }
        this.idArticle = idArticle;
    }

    public String getNomArticle() {
        return nomArticle;
    }

    public void setNomArticle(String nomArticle) {
        this.nomArticle = nomArticle;
    }

    public Unite getUnite() {
        return unite;
    }

    public void setUnite(Unite unite) {
        this.unite = unite;
    }

    public TypeStock getTypeStock() {
        return typeStock;
    }

    public void setTypeStock(TypeStock typeStock) {
        this.typeStock = typeStock;
    }

    @Override
    public String toString() {
        return "Article [idArticle=" + idArticle + ", nomArticle=" + nomArticle + ", unite=" + unite + ", typeStock="
                + typeStock + "]";
    }
}
