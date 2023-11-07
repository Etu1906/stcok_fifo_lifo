package connect;

import java.sql.*;

public class Connect {
    Connection con;
    Statement stat;

    public Statement getStat() {
        return stat;
    }

    public void getConnectionPostGresql() throws Exception {
        try {
            Class dbDriver = Class.forName("org.postgresql.Driver");
            String jdbcURL = "jdbc:postgresql://localhost:5432/stock";
            con = DriverManager.getConnection(jdbcURL, "postgres", "root");
            // stat = con.createStatement();
            this.getConnection().setAutoCommit(false);
            // return con;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Connexion interrompue");
        }
    }

    public void rollback() throws Exception {
        getConnection().rollback();
    }

    public void commit() throws Exception {
        getConnection().commit();
    }

    public void close()throws Exception{
        getConnection().close();
    }

    public Connection getConnection() {
        return this.con;
    }

}
