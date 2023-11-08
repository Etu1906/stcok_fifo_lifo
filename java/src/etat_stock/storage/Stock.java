package etat_stock.storage;

import etat_stock.produit.Article;

public class Stock {
    private Article article;
    private Magasin magasin;
    private double quantiteInitiale;
    private double sortant;
    private double montant;
    private double pu;

    public double getPu() {
        return pu;
    }

    public void setPu() {
        if (getSortant() == 0)
            setPu(0);
        else
            setPu(getMontant() / getSortant());
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    // Getters and setters
    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public Magasin getMagasin() {
        return magasin;
    }

    public void setMagasin(Magasin magasin) {
        this.magasin = magasin;
    }

    public double getQuantiteInitiale() {
        return quantiteInitiale;
    }

    public void setQuantiteInitiale(double quantiteInitiale) {
        this.quantiteInitiale = quantiteInitiale;
    }

    public double getSortant() {
        return sortant;
    }

    public void setSortant(double sortant) {
        this.sortant = sortant;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    @Override
    public String toString() {
        return "Stock [article=" + article + ", magasin=" + magasin + ", quantiteInitiale=" + quantiteInitiale
                + ", sortant=" + sortant + ", montant=" + montant + "]";
    }
}
