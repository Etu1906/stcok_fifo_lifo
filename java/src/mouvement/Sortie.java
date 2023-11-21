package mouvement;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Statement;

import connect.Connect;

public class Sortie {
    private int idSortie;
    private double quantiteSortie;
    private Date dateSortie;
    private Entree entree;

    public Sortie(double quantiteSortie, String dateSortie, int entree) throws Exception {
        setQuantiteSortie(quantiteSortie);
        setDateSortie(dateSortie);
        Entree e = new Entree();
        e.setIdEntree(entree);
        setEntree(e);
    }

    public Sortie(double quantiteSortie, Date dateSortie, int entree) throws Exception {
        setQuantiteSortie(quantiteSortie);
        setDateSortie(dateSortie);
        Entree e = new Entree();
        e.setIdEntree(entree);
        setEntree(e);
    }

    public void insert(Connect c) throws Exception {
        boolean transact = true;
        if (c == null) {
            transact = false;
            c = new Connect();
            c.getConnectionPostGresql();
        }

        String sql = "INSERT INTO sortie (quantite_sortie, date_sortie, identree) " +
                "VALUES (" + quantiteSortie + ", '" + dateSortie + "', " + entree.getIdEntree() + ")";
        System.out.println(sql);
        Connection conn = c.getConnection();
        Statement stmt = conn.createStatement();

        try {
            stmt.executeUpdate(sql);
            if (transact == false) {
                c.commit();
            }
            stmt.close();
        } catch (SQLException e) {
            c.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if (transact == false) {
                conn.close();
            }
        }
    }

    // Getters and setters
    public int getIdSortie() {
        return idSortie;
    }

    public void setIdSortie(int idSortie) {
        this.idSortie = idSortie;
    }

    public Entree getEntree() {
        return entree;
    }

    public void setEntree(Entree entree) {
        this.entree = entree;
    }

    public double getQuantiteSortie() {
        return quantiteSortie;
    }

    public void setQuantiteSortie(double quantiteSortie) {
        this.quantiteSortie = quantiteSortie;
    }

    public Date getDateSortie() {
        return dateSortie;
    }

    public void setDateSortie(String dateSortie) throws Exception {
        if (dateSortie == null)
            throw new Exception("date invalide");
        setDateSortie(Date.valueOf(dateSortie));
    }

    public void setDateSortie(Date dateSortie) {
        this.dateSortie = dateSortie;
    }

    @Override
    public String toString() {
        return "Sortie [idSortie=" + idSortie + ", quantiteSortie=" + quantiteSortie + ", dateSortie=" + dateSortie
                + ", entree=" + entree + "]";
    }
}
