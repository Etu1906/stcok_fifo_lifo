delete from sortie;

delete from entree;

alter sequence entree_identree_seq restart with 1;
alter sequence sortie_idsortie_seq restart with 1;