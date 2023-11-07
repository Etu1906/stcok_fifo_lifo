package etat_stock.storage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import connect.Connect;

public class Magasin {
    private String idMagasin;
    private String nomMagasin;

    public Magasin() {
    }

    public static List<Magasin> getAll(Connect c) throws Exception {
        boolean transact = true;
        List<Magasin> magasins = new ArrayList<>();

        if (c == null) {
            transact = false;
            c = new Connect();
            c.getConnectionPostGresql();
        }

        String sql = "SELECT * FROM magasin";
        Connection conn = c.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        try {
            while (rs.next()) {
                Magasin magasin = new Magasin();
                magasin.setIdMagasin(rs.getString("idmagasin"));
                magasin.setNomMagasin(rs.getString("nom_magasin"));
                magasins.add(magasin);
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

        return magasins;
    }

    public Magasin(String idmagasin, String nom) {
        setIdMagasin(idmagasin);
        setNomMagasin(nom);
    }

    public Magasin(String idMagasin) {
        setIdMagasin(idMagasin);
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        if (idMagasin.isEmpty() == true) {
            this.idMagasin = "%";
            return;
        }
        this.idMagasin = idMagasin;
    }

    public String getNomMagasin() {
        return nomMagasin;
    }

    public void setNomMagasin(String nomMagasin) {
        this.nomMagasin = nomMagasin;
    }

    @Override
    public String toString() {
        return "Magasin [idMagasin=" + idMagasin + ", nomMagasin=" + nomMagasin + "]";
    }
}
