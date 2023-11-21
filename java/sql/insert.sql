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
    ('R101', 'riz gasy', 1, 1),
    ('R1011', 'riz gasy fotsy', 1, 2),
    ('A201', 'Ail en poudre', 1, 1),
    ('A202', 'Ail Frais', 1, 2);

-- Insertion des données dans la table magasin
INSERT INTO magasin ( idmagasin ,  nom_magasin) VALUES
    ('TNR101' , 'magasin1'),   
    ('TNR102' , 'magasin2'),
    ('TUL201' , 'magasin3')
;
   
-- Insertion des données dans la table entree
INSERT INTO entree (idarticle, quantite_entree, pu, idmagasin, date_entree) VALUES
    ('R101', 100, 4500 , 'TNR101', '2023-01-15 00:00:00'),        
    ('R101', 75, 5000 , 'TNR101', '2022-02-20 00:00:00'),        
    ('A201', 150, 3200 , 'TNR101', '2021-03-10 00:00:00'),        
    ('R1011', 50, 3050 , 'TNR102', '2020-04-05 00:00:00'),        
    ('A202', 120, 2500.5 , 'TUL201', '2020-05-12 00:00:00'),        
    ('R101', 80, 6250.5 , 'TUL201', '2021-06-18 00:00:00'),        
    ('R1011', 200, 2100 , 'TNR101', '2023-07-22 00:00:00'),        
    ('R101', 50, 5550 , 'TNR101', '2023-06-03 00:00:00')        
    ;

INSERT INTO entree (idarticle, quantite_entree, pu, idmagasin, date_entree) VALUES
    ('R1011',  200 , 5000 , 'TNR102', '2022-11-01 00:00:00'),
    ('R1011',  10 , 4500 , 'TNR102', '2021-11-01 00:00:00');

update article set idtypestock = 1 
where idarticle = 'R1011';
sele
-- Insertion des données dans la table sortie
-- INSERT INTO sortie (quantite_sortie, date_sortie, identree) VALUES
--     (200, '2019-08-08 00:00:00', 1),
--     (400, '2019-08-08 00:00:00', 2),
--     (100, '2019-12-13 00:00:00', 1),
--     (100, '2019-12-13 00:00:00', 5),
--     (500, '2020-01-02 00:00:00', 4),
--     (100, '2020-01-02 00:00:00', 7),
--     (750, '2020-07-08 00:00:00', 3)
--     ;  

-- update sortie    
-- set quantite_sortie = 200
-- where idsortie = 1;

-- update sortie    
-- set date_sortie = '2019-03-06 00:00:00'
-- where idsortie = 4;