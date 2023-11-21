create database stock;
\c stock 
create table  typestock(
    idtypestock serial primary key, 
    nom_type varchar 
);

create table unite(
    idunite serial primary key  ,
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

ALTER TABLE entree
ALTER COLUMN date_entree TYPE date;

ALTER TABLE sortie
ALTER COLUMN date_sortie TYPE date;

create table sortie_mere(
    idsortie_mere serial primary key,
    quantite_sortie_mere numeric,
    date_sortie_mere date
);

ALTER table sortie 
drop column date_sortie;

alter table sortie 
add column idsortie_mere int references sortie_mere;

create table date_sortie_validation(
    iddate_sortie serial primary key,
    date_sortie date,
    idsortie_mere int references sortie_mere
);