package mouvement;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import connect.Connect;
import etat_stock.produit.Article;
import etat_stock.storage.Magasin;

public class Mouvement {
    private Date date;
    private Article article;
    private double quantite;
    private Magasin magasin;
    private List<Sortie> l_Sorties;

    public void creerVues(Connect c, String dt, String idmagasin, String idarticle) throws Exception {
        boolean transact = true;
        if (c == null) {
            transact = false;
            c = new Connect();
            c.getConnectionPostGresql();
        }
        String sql = "SELECT get_entree_sortie_article(?, ?, ?)";
        System.out
                .println("SELECT get_entree_sortie_article('" + idarticle + "' , '" + idmagasin + "',' " + dt + "' )");
        Connection conn = c.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, idarticle);
        stmt.setString(2, idmagasin);
        stmt.setString(3, dt);

        try {
            stmt.execute();
            System.out.println("Les vues ont été créées avec succès. oui oui");
            if (transact == false)
                c.commit();
            stmt.close();
        } catch (SQLException e) {
            c.rollback();
            throw e;
        }
    }

    public List<Sortie> addSortie(List<Entree> lEntrees) throws Exception {
        List<Sortie> lSorties = new ArrayList<Sortie>();
        double quantite = getQuantite();
        String type_stock = lEntrees.get(0).getArticle().getTypeStock().getNomType();
        double qteEntree = 0;
        boolean stock_ok = false;
        double qte_sortie = 0;
        if (type_stock.compareToIgnoreCase("lifo") == 0) {
            Collections.reverse(lEntrees);
        }
        for (Entree entree : lEntrees) {
            System.out.println(entree);
            qteEntree = entree.getQuantiteEntree();
            if (stock_ok == true)
                break;
            // raha misy le anaty entrée ka mbola misy le qté nasorina
            if (qteEntree > 0 && quantite != 0) {
                System.out.println(qteEntree + " eto <-> " + quantite);
                if (qteEntree >= quantite) {
                    stock_ok = true;
                    qte_sortie = quantite;
                } else {
                    quantite = quantite - qteEntree;
                    qte_sortie = qteEntree;
                }
                if (quantite == 0)
                    stock_ok = true;
                Sortie sortie = new Sortie(qte_sortie, getDate(), entree.getIdEntree());
                lSorties.add(sortie);
            }
        }
        // tsy nisy intsony tanaty stock
        if (stock_ok != true) {
            throw new Exception(" stock insuffisant ");
        }

        return lSorties;
    }

    public void sortie(String date, String idarticle, String qte, String idmagasin) throws Exception {
        System.out.println("qté : " + quantite);
        setQuantite(qte);
        setDate(date);
        Connect c = new Connect();
        c.getConnectionPostGresql();
        try {
            creerVues(c, date, idmagasin, idarticle);
            List<Entree> lEntrees = Entree.getEntreeArticle(c);
            if (lEntrees.size() == 0) {
                throw new Exception("stock insuffisant");
            }
            System.out.println(" tonga teto ");
            setL_Sorties(addSortie(lEntrees));
            for (Sortie sortie : getL_Sorties()) {
                System.out.println(sortie.toString());
                sortie.insert(c);
            }
            c.commit();
        } catch (Exception e) {
            c.rollback();
            throw e;
        } finally {
            c.close();
        }

    }

    // Getters and setters
    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public void setDate(String date) throws Exception {
        if (date == null || date.isEmpty() == true)
            throw new Exception(" date invalide ");
        setDate(Date.valueOf(date));
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(String quantite) throws Exception {
        if (quantite == null || quantite.isEmpty())
            throw new Exception(" qualiite invalide ");
        setQuantite(Double.parseDouble(quantite));
    }

    public void setQuantite(double quantite) {
        this.quantite = quantite;
    }

    public Magasin getMagasin() {
        return magasin;
    }

    public void setMagasin(Magasin magasin) {
        this.magasin = magasin;
    }

    public List<Sortie> getL_Sorties() {
        return l_Sorties;
    }

    public void setL_Sorties(List<Sortie> l_Sorties) {
        this.l_Sorties = l_Sorties;
    }
}
