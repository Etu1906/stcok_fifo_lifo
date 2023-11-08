package etat_stock.etat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import connect.Connect;
import etat_stock.produit.Article;
import etat_stock.produit.TypeStock;
import etat_stock.produit.Unite;
import etat_stock.storage.Magasin;
import etat_stock.storage.Stock;

public class EtatStock {
    private Stock[] listeStock;
    private String debut;
    private String fin;
    private double sommeMontant;

    public EtatStock(String debut, String fin) {
        setDebut(debut);
        setFin(fin);
    }

    public void creerVues(Connect c, String dt1, String dt2, String idmagasin, String idarticle) throws Exception {
        boolean transact = true;
        if (c == null) {
            transact = false;
            c = new Connect();
            c.getConnectionPostGresql();
        }
        if (idmagasin.isEmpty())
            idmagasin = "%";
        if (idarticle.isEmpty())
            idarticle = "%";
        System.out.println(
                "SELECT create_views('" + dt1 + "', '" + dt2 + "' , '" + idmagasin + "' , '" + idarticle + "' )");
        String sql = "SELECT create_views(?, ?, ?, ?)";
        Connection conn = c.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, dt1);
        stmt.setString(2, dt2);
        stmt.setString(3, idmagasin);
        stmt.setString(4, idarticle);

        try {
            stmt.execute();
            System.out.println("tonga eto");
            if (transact == false)
                c.commit();
            stmt.close();
        } catch (SQLException e) {
            c.rollback();
            throw e;
        } finally {
        }
    }

    public void calculerSommeMontant(Connect c) throws Exception {
        boolean transact = true;
        if (c == null) {
            transact = false;
            c = new Connect();
            c.getConnectionPostGresql();
        }

        String sql = "SELECT montant FROM v_somme_montant";
        System.out.println(sql);
        Connection conn = c.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        try {

            if (rs.next()) {
                setSommeMontant(rs.getDouble("montant"));
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
    }

    public static EtatStock getEtatStock(String dt1, String dt2, String idmagasin, String idarticle) throws Exception {
        EtatStock e = new EtatStock(dt1, dt2);
        Connect c = new Connect();
        c.getConnectionPostGresql();
        e.creerVues(c, dt1, dt2, idmagasin, idarticle);
        e.setListeStock(e.getListeStock(c));
        e.calculerSommeMontant(c);
        c.close();
        return e;
    }

    public Stock[] getListeStock(Connect c) throws Exception {
        boolean transact = true;
        List<Stock> l_Stocks = new ArrayList<Stock>();
        if (c == null) {
            transact = false;
            c = new Connect();
            c.getConnectionPostGresql();
        }
        String sql = " select * from v_etat_stock_unite_typestock order by idarticle , idmagasin , idtypestock ";
        Connection conn = c.getConnection(); // Récupère la connexion à la base de données
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        try {

            while (rs.next()) {
                Stock stock = new Stock();
                TypeStock typeStock = new TypeStock();
                typeStock.setIdTypeStock(rs.getInt("idtypestock"));
                typeStock.setNomType(rs.getString("nom_type"));

                Unite unite = new Unite();
                unite.setIdUnite(rs.getInt("idunite"));
                unite.setNomUnite(rs.getString("nom_unite"));

                stock.setArticle(
                        new Article(rs.getString("idarticle"), rs.getString(("nom_article")), unite, typeStock));
                stock.setMagasin(new Magasin(rs.getString("idmagasin"), rs.getString("nom_magasin")));
                stock.setSortant(rs.getDouble("sortant"));
                stock.setQuantiteInitiale(rs.getDouble("qte_initiale"));
                stock.setMontant(rs.getDouble("montant"));
                stock.setPu();
                l_Stocks.add(stock);
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
        return l_Stocks.toArray(new Stock[0]);
    }

    // Getters and setters
    public Stock[] getListeStock() {
        return listeStock;
    }

    public void setListeStock(Stock[] listeStock) {
        this.listeStock = listeStock;
    }

    public String getDebut() {
        return debut;
    }

    public void setDebut(String debut) {
        this.debut = debut;
    }

    public String getFin() {
        return fin;
    }

    public void setFin(String fin) {
        this.fin = fin;
    }

    public double getSommmeMontant() {
        return sommeMontant;
    }

    public void setSommmeMontant(double sommeMontant) {
        this.sommeMontant = sommeMontant;
    }

    public double getSommeMontant() {
        return sommeMontant;
    }

    public void setSommeMontant(double sommeMontant) {
        this.sommeMontant = sommeMontant;
    }

    @Override
    public String toString() {
        return "EtatStock [listeStock=" + Arrays.toString(listeStock) + ", debut=" + debut + ", fin=" + fin
                + ", sommeMontant=" + sommeMontant + "]";
    }
}
