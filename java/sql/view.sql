-- etat de stock 
-- pour date 1
create  temp table v_entree_date1 as  
    select *
        from entree as e 
    where idarticle like '%'  
    and date_entree <= '02-02-19'
    and idmagasin like '%';

create temp table v_sortie_date1 as 
    select * 
        from sortie as  s 
    where  date_sortie <= '02-02-19';

create or replace view v_sortie_date1_group as 
    select sum(quantite_sortie) as quantite_sortie , identree
        from v_sortie_date1 as s 
    group by identree;

create or replace view v_qte_date1 as  
    select e.identree,idarticle,quantite_entree - coalesce(quantite_sortie , 0) as quantite_entree ,pu,idmagasin,date_entree
        from v_entree_date1 as e 
    left join v_sortie_date1_group as s 
        on s.identree = e.identree;

create or replace view v_qte_initiale as
    select idarticle , idmagasin , sum( quantite_entree ) as qte  
        from v_qte_date1 as q 
    group  by idarticle , idmagasin;

-- pour date 2
create temp table v_entree_date2 as  
    select *
        from entree as e 
    where idarticle like '%'  
    and date_entree > '02-02-19'
    and date_entree <= '28-02-19'
    and idmagasin like '%';

create temp table v_sortie_date2 as 
    select * 
        from sortie as  s 
    where date_sortie > '02-02-19'
    and date_sortie <= '28-02-19';

create or replace view v_sortie_date2_group as 
    select sum(quantite_sortie) as quantite_sortie , identree
        from v_sortie_date2 as s 
    group by identree;

create or replace view v_qte_union as  
    select *
        from v_qte_date1 as q1 
    union 
    select * 
        from v_entree_date2 as e ;

create or replace view v_qte_date2 as  
    select e.identree,idarticle,quantite_entree - coalesce(quantite_sortie , 0) as quantite_entree ,pu,idmagasin,date_entree        
        from v_qte_union as e 
    left join v_sortie_date2_group as s 
        on s.identree = e.identree;

create or replace view v_sortant as  
    select idarticle , idmagasin , sum( quantite_entree ) as qte  
        from v_qte_date2 as qt2 
    group by idarticle , idmagasin ;

create or replace view v_montant as  
    select idarticle , idmagasin , sum( quantite_entree * pu ) as montant 
        from v_qte_date2 as qt2 
    group by idarticle , idmagasin;

-- véritable état de stock ( le view ampiasaina )
create or replace view v_etat_stock as  
    select  s.idarticle , s.idmagasin , s.qte as sortant , q.qte as qte_initiale  , montant
     from v_sortant as s 
    left join v_montant as m 
        on s.idarticle = m.idarticle 
        and s.idmagasin = m.idmagasin
    left join v_qte_initiale as q 
        on s.idarticle = q.idarticle 
        and s.idmagasin = q.idmagasin;

create or replace view v_etat_stock_article as 
    select * 
    from v_etat_stock as e 
        natural join article as s;

create or replace view v_etat_stock_article_magasin as 
    select * 
    from v_etat_stock_article as e 
        natural join magasin as s;

create or replace view v_etat_stock_unite_typestock as 
    select * 
        from v_etat_stock_article_magasin as e 
    natural join unite as u 
    natural join typestock as t;

create or replace view v_somme_montant as  
    select sum( montant ) as montant
        from v_etat_stock as e; 

-- mouvement de sortie
create temp table v_entree_article as  
    select *
        from entree as e 
    where idarticle like 'R11'  
    and date_entree <= '02-02-19'
    and idmagasin like 'M1';

create temp table v_sortie_article as
    select * 
        from sortie as s 
    where identree in (
        select identree 
            from entree as e 
        where idarticle =  'R11' 
        and idmagasin like 'M1'
    )
    and date_sortie <= '02-02-19';

create or replace view v_qte_article as  
    select  e.identree , idarticle , quantite_entree - coalesce(quantite_sortie , 0) as qte ,  pu  , idmagasin , date_entree
        from v_entree_article as e  
    left join v_sortie_article as s 
        on e.identree = s.identree
    ;

create or replace view v_qte_articel_type as 
    select *
        from v_qte_article as qa 
    natural join article as a
    natural join typestock;