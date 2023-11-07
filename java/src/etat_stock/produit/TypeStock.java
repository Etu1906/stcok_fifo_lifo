package etat_stock.produit;

public class TypeStock {
    private int idTypeStock;
    private String nomType;

    public TypeStock(int idTypeStock, String nomType) {
        setIdTypeStock(idTypeStock);
        setNomType(nomType);
    }

    public TypeStock() {
    }

    public int getIdTypeStock() {
        return idTypeStock;
    }

    public void setIdTypeStock(int idTypeStock) {
        this.idTypeStock = idTypeStock;
    }

    public String getNomType() {
        return nomType;
    }

    public void setNomType(String nomType) {
        this.nomType = nomType;
    }
}
