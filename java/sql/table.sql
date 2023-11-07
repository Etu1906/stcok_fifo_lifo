create database stock;
\c stock 
create table  typestock(
    idtypestock serial primary key, 
    nom_type varchar 
);

create table unite(
    idunite serial primary key,
    nom_unite varchar
);

create table article( 
    idarticle varchar primary key,
    nom_article varchar,
    idunite int references unite,
    idtypestock int references typestock(idtypestock)
);

create table magasin(
    idmagasin varchar  primary key,
    nom_magasin varchar
);
create table entree(
    identree serial primary key,
    idarticle varchar references article,
    quantite_entree numeric,
    pu numeric,
    idmagasin varchar references magasin,
    date_entree timestamp
);

create table sortie(
    idsortie serial primary key,
    quantite_sortie numeric,
    date_sortie timestamp,
    identree int references entree
);