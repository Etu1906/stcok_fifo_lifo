CREATE OR REPLACE FUNCTION create_views(dt1 text, dt2 text, idmagasin text, idarticle text) RETURNS void AS $$
BEGIN
    -- Crée la vue v_entree_date1
    EXECUTE 'CREATE OR REPLACE VIEW v_entree_date1 AS ' ||
    'SELECT * FROM entree AS e ' ||
    'WHERE idarticle LIKE ' || quote_literal(idarticle) || ' ' ||
    'AND date_entree <= ' || quote_literal(dt1) || ' ' ||
    'AND idmagasin LIKE ' || quote_literal(idmagasin);

    -- Crée la vue v_sortie_date1
    EXECUTE 'CREATE OR REPLACE VIEW v_sortie_date1 AS ' ||
    'SELECT * FROM sortie AS s ' ||
    'WHERE date_sortie <= ' || quote_literal(dt1);

    -- Crée la vue v_entree_date2
    EXECUTE 'CREATE OR REPLACE VIEW v_entree_date2 AS ' ||
    'SELECT * FROM entree AS e ' ||
    'WHERE idarticle LIKE ' || quote_literal(idarticle) || ' ' ||
    'AND date_entree > ' || quote_literal(dt1) || ' ' ||
    'AND date_entree <= ' || quote_literal(dt2) || ' ' ||
    'AND idmagasin LIKE ' || quote_literal(idmagasin);

    -- Crée la vue v_sortie_date2
    EXECUTE 'CREATE OR REPLACE VIEW v_sortie_date2 AS ' ||
    'SELECT * FROM sortie AS s ' ||
    'WHERE date_sortie > ' || quote_literal(dt1) || ' ' ||
    'AND date_sortie <= ' || quote_literal(dt2);

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_entree_sortie_article(
    in_article text, 
    in_magasin text, 
    in_date text
) RETURNS void AS $$
BEGIN
    -- Crée la vue v_entree_article
    EXECUTE 'CREATE OR REPLACE VIEW v_entree_article AS ' ||
    'SELECT * FROM entree AS e ' ||
    'WHERE idarticle LIKE ' || quote_literal(in_article) || ' ' ||
    'AND date_entree <= ' || quote_literal(in_date) || ' ' ||
    'AND idmagasin LIKE ' || quote_literal(in_magasin);

    -- Crée la vue v_sortie_article
    EXECUTE 'CREATE OR REPLACE VIEW v_sortie_article AS ' ||
    'SELECT * FROM sortie AS s ' ||
    'WHERE identree IN (' ||
    'SELECT identree ' ||
    'FROM entree AS e ' ||
    'WHERE idarticle = ' || quote_literal(in_article) || ' ' ||
    'AND idmagasin LIKE ' || quote_literal(in_magasin) || ') ' ||
    'AND date_sortie <= ' || quote_literal(in_date);

END;
$$ LANGUAGE plpgsql;


select create_views( '02-02-19' , '28-02-19' , '%' , '%'  );

select get_entree_sortie_article( 'R11' , 'M1' ,  );
SELECT get_entree_sortie_article('R11', 'M1', '02-02-19');
