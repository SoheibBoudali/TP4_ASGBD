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

/* 2  Une fonction qui augmente le salaire de chaque infirmier */

CREATE OR REPLACE PROCEDURE Augmentation_salaire AS
	cursor cr is select * from infirmier;
	c_rec cr%rowtype;
	cursor cr1 is select * from employe;
	c_rec1 cr1%rowtype;
	new_s INTEGER ;
BEGIN
	FOR c_rec in cr LOOP
		if (c_rec.rotation = 'NUIT') THEN
			new_s:=c_rec.salaire+c_rec.salaire*60/100;
		else
			new_s:=c_rec.salaire+c_rec.salaire*50/100;
		end if;
		FOR c_rec1 in cr1 LOOP
			IF(c_rec1.num_emp = c_rec.num_inf) THEN
				dbms_output.put_line('Linfirmier '||c_rec1.nom_emp||' '||c_rec1.prenom_emp||' de rotation '||c_rec.rotation||' son ancien salaire est : ' ||c_rec.salaire||' DA et son nouveau salaire est '||new_s||' DA' );
			END IF;
		END LOOP;
		UPDATE infirmier i SET salaire = new_s WHERE i.num_inf =c_rec.num_inf;
	END LOOP;
END;

EXECUTE Augmentation_salaire;

/* 3 Fonction de vérification des salaires*/ 

CREATE OR REPLACE FUNCTION Verife RETURN VARCHAR AS
	cursor cr is select * from infirmier;
	c_rec cr%rowtype;
	CHAINE VARCHAR(40);
BEGIN
	CHAINE:='Vérification positive';
	FOR c_rec in cr LOOP
		IF(c_rec.salaire<10000 OR c_rec.salaire>30000) THEN
			CHAINE:='Vérification négative';
			RETURN CHAINE;
		END IF;
	END LOOP;
	RETURN CHAINE;
END Verife;

select Verife from dual;

/* 4 Une fonction qui retourne, pour chaque spécialité donnée, le nombre de médecins affectés.*/
CREATE OR REPLACE FUNCTION Med_Spec(Spec in VARCHAR) RETURN Number AS
	cursor cr is select * from medecin;
	c_rec cr%rowtype;
	nbr_med Number;
BEGIN
	nbr_med:=0;
	FOR c_rec in cr LOOP
		IF(c_rec.SPECIALITE= Spec) THEN
			nbr_med:=nbr_med+1;
		END IF;
	END LOOP;
	RETURN nbr_med;
END Med_Spec;

select Med_Spec('ORTHOPEDISTE') from dual;