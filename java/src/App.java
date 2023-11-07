import mouvement.Mouvement;

public class App {
    public static void main(String[] args) throws Exception {
        System.out.println("Hally, World!");
        try {
            // String dt1 = "02-02-2019";
            // String dt2 = "28-02-2019";
            // String idmagasin = "";
            // String idarticle = "";

            // EtatStock etatStock = EtatStock.getEtatStock(dt1, dt2, idmagasin, idarticle);

            // // Afficher la liste des stocks
            // System.out.println("Liste des stocks :");
            // for (Stock stock : etatStock.getListeStock()) {
            // System.out.println(stock.toString());
            // }

            // // Afficher la somme du montant
            // System.out.println("Somme du montant : " + etatStock.getSommeMontant());

            Mouvement m = new Mouvement();
            m.sortie("02-02-2019", "R11", "400", "M1");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
