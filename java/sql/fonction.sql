create or replace function create_for_date1(dt1 text, dt2 text, idmagasin text, idarticle text) RETURNS void AS $$
BEGIN

    -- Crée la table temporaire temp_entree_date1
    EXECUTE 'CREATE TEMP TABLE v_entree_date1 AS ' ||
    'SELECT * FROM entree AS e ' ||
    'WHERE idarticle LIKE ' || quote_literal(idarticle) || ' ' ||
    'AND date_entree <= ' || quote_literal(dt1) || ' ' ||
    'AND idmagasin LIKE ' || quote_literal(idmagasin);

    -- Crée la table temporaire temp_sortie_date1
    EXECUTE 'CREATE TEMP TABLE v_sortie_date1 AS ' ||
    'SELECT * FROM sortie AS s ' ||
    'WHERE date_sortie <= ' || quote_literal(dt1);

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


END;
$$ LANGUAGE plpgsql;

create or replace function create_for_date2(dt1 text, dt2 text, idmagasin text, idarticle text) RETURNS void AS $$
BEGIN

    -- Crée la table temporaire temp_entree_date2
    EXECUTE 'CREATE TEMP TABLE v_entree_date2 AS ' ||
    'SELECT * FROM entree AS e ' ||
    'WHERE idarticle LIKE ' || quote_literal(idarticle) || ' ' ||
    'AND date_entree > ' || quote_literal(dt1) || ' ' ||
    'AND date_entree <= ' || quote_literal(dt2) || ' ' ||
    'AND idmagasin LIKE ' || quote_literal(idmagasin);


    -- Crée la table temporaire temp_sortie_date2
    EXECUTE 'CREATE TEMP TABLE v_sortie_date2 AS ' ||
    'SELECT * FROM sortie AS s ' ||
    'WHERE date_sortie > ' || quote_literal(dt1) || ' ' ||
    'AND date_sortie <= ' || quote_literal(dt2);

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

    
END;
$$ LANGUAGE plpgsql;


create or replace function create_for_Etat_stock(dt1 text, dt2 text, idmagasin text, idarticle text) RETURNS void AS $$
BEGIN
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
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION create_views(dt1 text, dt2 text, idmagasin text, idarticle text) RETURNS void AS $$
BEGIN
    -- Supprime les tables temporaires existantes si elles existent
    EXECUTE 'DROP TABLE IF EXISTS v_entree_date1, v_sortie_date1, v_entree_date2, v_sortie_date2 cascade';

    PERFORM  create_for_date1( dt1 , dt2 , idmagasin , idarticle );

    PERFORM  create_for_date2(dt1 , dt2 , idmagasin , idarticle );

    PERFORM  create_for_Etat_stock( dt1 , dt2 , idmagasin  , idarticle );

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_temp_article(
    in_article text, 
    in_magasin text, 
    in_date text
) RETURNS void AS $$
BEGIN

    -- Crée la table temporaire v_entree_article
    EXECUTE 'CREATE TEMP TABLE v_entree_article AS ' ||
    'SELECT * FROM entree AS e ' ||
    'WHERE idarticle LIKE ' || quote_literal(in_article) || ' ' ||
    'AND date_entree <= ' || quote_literal(in_date) || ' ' ||
    'AND idmagasin LIKE ' || quote_literal(in_magasin);

    -- Crée la table temporaire v_sortie_article
    EXECUTE 'CREATE TEMP TABLE v_sortie_article AS ' ||
    'SELECT * FROM sortie AS s ' ||
    'WHERE identree IN (' ||
    'SELECT identree ' ||
    'FROM entree AS e ' ||
    'WHERE idarticle = ' || quote_literal(in_article) || ' ' ||
    'AND idmagasin LIKE ' || quote_literal(in_magasin) || ') ' ||
    'AND date_sortie <= ' || quote_literal(in_date);

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_qte_article(
    in_article text, 
    in_magasin text, 
    in_date text
) RETURNS void AS $$
BEGIN
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
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_entree_sortie_article(
    in_article text, 
    in_magasin text, 
    in_date text
) RETURNS void AS $$
BEGIN
    EXECUTE 'DROP TABLE IF EXISTS v_entree_article, v_sortie_article cascade';

    PERFORM get_temp_article( in_article , in_magasin , in_date );

    perform get_qte_article( in_article , in_magasin , in_date );
END;
$$ LANGUAGE plpgsql;




select create_views( '02-02-19' , '28-02-19' , '%' , '%'  );

select get_entree_sortie_article( 'R11' , 'M1' ,  );
SELECT get_entree_sortie_article('R11', 'M1', '02-02-19');


-- CREATE OR REPLACE FUNCTION creer_et_mettre_a_jour_table()
-- RETURNS void AS $$
-- BEGIN
--   -- Supprimez la table temporaire si elle existe
--   DROP TABLE IF EXISTS temp_result;
  
--   -- Recréez la table temporaire et insérez les données
--   CREATE TEMP TABLE temp_result AS
--   SELECT *
--   FROM sortie
--   WHERE idsortie =  1 ;
  
--   -- Vous pouvez effectuer d'autres opérations si nécessaire
-- END;
-- $$ LANGUAGE plpgsql;


-- create  MATERIALIZED view  v_temp AS
--   SELECT *
--   FROM sortie
--   WHERE idsortie =  1 ;

--   DROP MATERIALIZED VIEW IF EXISTS v_temp;


-- CREATE OR REPLACE FUNCTION create_views(dt1 text, dt2 text, idmagasin text, idarticle text) RETURNS void AS $$
-- BEGIN
--     -- Crée la vue v_entree_date1
--     EXECUTE 'CREATE OR REPLACE VIEW v_entree_date1 AS ' ||
--     'SELECT * FROM entree AS e ' ||
--     'WHERE idarticle LIKE ' || quote_literal(idarticle) || ' ' ||
--     'AND date_entree <= ' || quote_literal(dt1) || ' ' ||
--     'AND idmagasin LIKE ' || quote_literal(idmagasin);

--     -- Crée la vue v_sortie_date1
--     EXECUTE 'CREATE OR REPLACE VIEW v_sortie_date1 AS ' ||
--     'SELECT * FROM sortie AS s ' ||
--     'WHERE date_sortie <= ' || quote_literal(dt1);

--     -- Crée la vue v_entree_date2
--     EXECUTE 'CREATE OR REPLACE VIEW v_entree_date2 AS ' ||
--     'SELECT * FROM entree AS e ' ||
--     'WHERE idarticle LIKE ' || quote_literal(idarticle) || ' ' ||
--     'AND date_entree > ' || quote_literal(dt1) || ' ' ||
--     'AND date_entree <= ' || quote_literal(dt2) || ' ' ||
--     'AND idmagasin LIKE ' || quote_literal(idmagasin);

--     -- Crée la vue v_sortie_date2
--     EXECUTE 'CREATE OR REPLACE VIEW v_sortie_date2 AS ' ||
--     'SELECT * FROM sortie AS s ' ||
--     'WHERE date_sortie > ' || quote_literal(dt1) || ' ' ||
--     'AND date_sortie <= ' || quote_literal(dt2);

-- END;
-- $$ LANGUAGE plpgsql;


-- CREATE OR REPLACE FUNCTION get_entree_sortie_article(
--     in_article text, 
--     in_magasin text, 
--     in_date text
-- ) RETURNS void AS $$
-- BEGIN
--     -- Crée la vue v_entree_article
--     EXECUTE 'CREATE OR REPLACE VIEW v_entree_article AS ' ||
--     'SELECT * FROM entree AS e ' ||
--     'WHERE idarticle LIKE ' || quote_literal(in_article) || ' ' ||
--     'AND date_entree <= ' || quote_literal(in_date) || ' ' ||
--     'AND idmagasin LIKE ' || quote_literal(in_magasin);

--     -- Crée la vue v_sortie_article
--     EXECUTE 'CREATE OR REPLACE VIEW v_sortie_article AS ' ||
--     'SELECT * FROM sortie AS s ' ||
--     'WHERE identree IN (' ||
--     'SELECT identree ' ||
--     'FROM entree AS e ' ||
--     'WHERE idarticle = ' || quote_literal(in_article) || ' ' ||
--     'AND idmagasin LIKE ' || quote_literal(in_magasin) || ') ' ||
--     'AND date_sortie <= ' || quote_literal(in_date);

-- END;
-- $$ LANGUAGE plpgsql;
