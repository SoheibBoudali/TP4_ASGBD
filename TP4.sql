/* 1 Afficher pour chaque chambre de chaque service le nombre de lits libres et occupés.*/
DECLARE
cursor cr is select num_chambre,code_service,nb_lits  from chambre ;
c_rec cr%rowtype;
cursor cr1 is select num_chambre,code_service,lit  from hospitalisation;
c_rec1 cr1%rowtype;

i binary_integer;
j binary_integer;
k binary_integer;
vide EXCEPTION;

BEGIN
	k:=0;
	for c_rec in cr loop 
		i:=0;
		for c_rec1 in cr1 loop 
			IF(c_rec.num_chambre=c_rec1.num_chambre AND c_rec.code_service=c_rec1.code_service) THEN 
				i:=i+1;
				k:=1;
			END IF;
		end loop;
		j:=c_rec.nb_lits - i;
		dbms_output.put_line('La chambre  '||c_rec.num_chambre||' du service '||c_rec.code_service||' contient  '||i||' lit(s) occupé(s) et '||j||' lit(s) libres(s)' );
	end loop;
	IF(k=0)THEN raise vide;END if;
	EXCEPTION when vide THEN
		dbms_output.put_line('Aucune Hospitalisation');
END;