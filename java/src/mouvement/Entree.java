package mouvement;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import connect.Connect;
import etat_stock.produit.Article;
import etat_stock.produit.TypeStock;
import etat_stock.storage.Magasin;

public class Entree {
    private int idEntree;
    private Article article;
    private double quantiteEntree;
    private double pu;
    private Magasin magasin;
    private Date dateEntree;

    public static List<Entree> getEntreeArticle(Connect c) throws Exception {
        boolean transact = true;
        List<Entree> entrees = new ArrayList<>();

        if (c == null) {
            transact = false;
            c = new Connect();
            c.getConnectionPostGresql();
        }

        String sql = "SELECT *  FROM v_qte_articel_type order by date_entree asc";
        Connection conn = c.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        try {
            while (rs.next()) {
                Entree entree = new Entree();
                entree.setIdEntree(rs.getInt("identree"));

                Article article = new Article();
                article.setIdArticle(rs.getString("idarticle"));
                article.setTypeStock(new TypeStock(rs.getInt("idtypestock"), rs.getString("nom_type")));
                entree.setArticle(article);
                entree.setQuantiteEntree(rs.getDouble("qte"));
                entree.setPu(rs.getDouble("pu"));

                Magasin magasin = new Magasin();
                magasin.setIdMagasin(rs.getString("idmagasin"));
                entree.setMagasin(magasin);
                entree.setDateEntree(rs.getString("date_entree"));

                entrees.add(entree);
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

        return entrees;
    }

    public int getIdEntree() {
        return idEntree;
    }

    public void setIdEntree(int idEntree) {
        this.idEntree = idEntree;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public double getQuantiteEntree() {
        return quantiteEntree;
    }

    public void setQuantiteEntree(double quantiteEntree) {
        this.quantiteEntree = quantiteEntree;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public Magasin getMagasin() {
        return magasin;
    }

    public void setMagasin(Magasin magasin) {
        this.magasin = magasin;
    }

    public Date getDateEntree() {
        return dateEntree;
    }

    public void setDateEntree(String dateEntree) throws Exception {
        if (dateEntree == null) {
            throw new Exception("date invalide");
        }
        setDateEntree(Date.valueOf(dateEntree));
    }

    @Override
    public String toString() {
        return "Entree [idEntree=" + idEntree + ", article=" + article + ", quantiteEntree=" + quantiteEntree + ", pu="
                + pu + ", magasin=" + magasin + ", dateEntree=" + dateEntree + "]";
    }

    public void setDateEntree(Date dateEntree) {
        this.dateEntree = dateEntree;
    }
}
