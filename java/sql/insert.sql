-- Insertion des données dans la table typestock
INSERT INTO typestock (nom_type) VALUES
    ('fifo'),
    ('lifo');

-- Insertion des données dans la table unite
INSERT INTO unite (nom_unite) VALUES
    ('kg'),
    ('l'),
    ('g');

-- Insertion des données dans la table article
INSERT INTO article (idarticle, nom_article, idunite, idtypestock) VALUES
    ('R1', 'riz', 1, 1),
    ('R11', 'riz rouge', 1, 1),
    ('R12', 'riz blanc', 1, 1),
    ('R112', 'riz rose', 1, 2);

-- Insertion des données dans la table magasin
INSERT INTO magasin ( idmagasin ,  nom_magasin) VALUES
    ('M1' , 'magasin1'),   
    ('M2' , 'magasin2');
   
-- Insertion des données dans la table entree
INSERT INTO entree (idarticle, quantite_entree, pu, idmagasin, date_entree) VALUES
    ('R12', 200, 2000, 'M1', '2019-01-01 00:00:00'),
    ('R11', 100, 2000, 'M2', '2019-01-01 00:00:00'),
    ('R11', 700, 3000, 'M2', '2019-02-02 00:00:00'),
    ('R11', 430, 2000, 'M1', '2019-02-02 00:00:00'),
    ('R12', 100, 2500, 'M1', '2019-02-02 00:00:00'),
    ('R12', 200, 3000, 'M1', '2019-02-20 00:00:00'),
    ('R12', 500, 4000, 'M1', '2019-03-30 00:00:00'),
    ('R12', 100, 5000, 'M1', '2022-01-01 00:00:00');

-- Insertion des données dans la table sortie
INSERT INTO sortie (quantite_sortie, date_sortie, identree) VALUES
    (100, '2019-01-02 00:00:00', 1),
    (100, '2019-02-06 00:00:00', 5),
    (100, '2019-02-06 00:00:00', 6),
    (100, '2019-02-06 00:00:00', 7);

update sortie    
set quantite_sortie = 200
where idsortie = 1;

update sortie    
set date_sortie = '2019-03-06 00:00:00'
where idsortie = 4;