/*
CREATE OR REPLACE VIEW competence AS
    SELECT competence, nom_personne, prenom_personne, intitule, UE
    FROM Module, Personne, Enseignant
        WHERE id_enseignant = id_personne;

CREATE OR REPLACE VIEW controle AS 
    SELECT intitule, coef_eval, aFait, MAX(note), AVG(note), MIN(note)
    FROM Module JOIN Evaluation USING(id_module), aFait;
*/

CREATE OR REPLACE FUNCTION bulletin (out nip_ integer, out nom varchar, out prenom varchar, out comp varchar, out moy decimal) RETURNS SETOF record AS
$$
DECLARE 
    curseur CURSOR FOR SELECT DISTINCT nip, nom_personne, prenom_personne, competence FROM Etudiant, Personne, Module, aFait, Evaluation 
        WHERE nip = id_personne AND nip = id_etudiant;
BEGIN
    OPEN curseur;
    IF (SELECT 1 FROM Etudiant WHERE SESSION_USER = nip::name) THEN
        LOOP
            FETCH curseur into nip_, nom, prenom, comp;
            IF SESSION_USER = nip_::name THEN
                SELECT ROUND(AVG(note),2) INTO moy FROM aFait WHERE id_etudiant::name = SESSION_USER;
                RETURN NEXT;
            END IF;
            EXIT WHEN NOT FOUND;
        END LOOP;
    ELSE
        LOOP
            FETCH curseur into nip_, nom, prenom, comp;
            SELECT ROUND(AVG(note),2) INTO moy FROM aFait WHERE id_etudiant = nip_ GROUP BY id_etudiant;
            EXIT WHEN NOT FOUND;
            RETURN NEXT;
        END LOOP;
    END IF;
END
$$
LANGUAGE plpgsql;

-- NIP | nom | prénom | module | moyenne plus haute | moyenne | moyenne plus basse
/*
CREATE OR REPLACE FUNCTION moyenne_etudiant(
    out nip_ int, 
    out nom varchar, 
    out prenom varchar, 
    out module varchar,
    out moyenne decimal,
    out max_moyenne decimal,
    out min_moyenne decimal
    ) RETURNS setof record AS
$$
DECLARE
    curseur CURSOR FOR 
        SELECT id_etudiant, nom_personne, prenom_personne, intitule, id_module
        FROM Personne, Module, aFait 
            WHERE id_etudiant = id_personne AND id_eval = id_module;
    idModule int;
BEGIN
    OPEN curseur;
    IF (SELECT 1 FROM Etudiant WHERE SESSION_USER = nip::name) THEN
        LOOP
            FETCH curseur INTO nip_, nom, prenom, module, idModule;
            EXIT WHEN NOT FOUND;
            IF SESSION_USER = nip_::name THEN
                SELECT ROUND(AVG(note),2) INTO moyenne FROM aFait WHERE id_eval = idModule AND id_etudiant = nip_;
                SELECT ROUND(MAX(note), 2) INTO max_moyenne FROM aFait WHERE id_eval = idModule;
                SELECT ROUND(MIN(note), 2) INTO min_moyenne FROM aFait WHERE id_eval = idModule;
                RETURN NEXT;
            END IF;
        END LOOP;
    ELSE
        LOOP
            FETCH curseur INTO nip_, nom, prenom, module, idModule;
            EXIT WHEN NOT FOUND;
            SELECT ROUND(AVG(note),2) INTO moyenne FROM aFait WHERE id_eval = idModule AND id_etudiant = nip_;
            SELECT ROUND(MAX(note), 2) INTO max_moyenne FROM aFait WHERE id_eval = idModule;
            SELECT ROUND(MIN(note), 2) INTO min_moyenne FROM aFait WHERE id_eval = idModule;
            RETURN NEXT;
    END LOOP;
    END IF;
    CLOSE curseur;
END
$$ LANGUAGE plpgsql;
*/
/*
CREATE or replace FUNCTION rdn(out nip_ integer, out nom varchar, out prenom varchar,out module varchar,out nom_controle varchar,out note_ decimal, out best_note decimal, out pire_note decimal)
RETURNS SETOF RECORD AS
$$
    DECLARE
        etud_note CURSOR FOR SELECT id_etudiant, nom_personne, prenom_personne, intitule, nom_eval, note, aFait.id_eval FROM Personne JOIN aFait ON id_personne = id_etudiant JOIN Evaluation USING(id_eval) JOIN Module USING(id_module);
        idEval int;
    BEGIN
        open etud_note;
        IF (SELECT 1 FROM Etudiant WHERE SESSION_USER = nip::name) THEN
            LOOP
                FETCH etud_note INTO nip_, nom, prenom, module, nom_controle, note_, idEval;
                EXIT WHEN NOT FOUND;
                IF SESSION_USER = nip_::name THEN
                    SELECT MIN(note) INTO pire_note FROM aFait WHERE id_eval = idEval;
                    SELECT MAX(note) INTO best_note FROM aFait WHERE id_eval = idEval;
                    RETURN NEXT;
                END IF;
            END LOOP;
        ELSE
            LOOP
                FETCH etud_note INTO nip_, nom, prenom, module, nom_controle, note_, idEval;
                EXIT WHEN NOT FOUND;
                SELECT MIN(note) INTO pire_note FROM aFait WHERE id_eval = idEval;
                SELECT MAX(note) INTO best_note FROM aFait WHERE id_eval = idEval;
                RETURN NEXT;
            END LOOP;
        END IF;
        close etud_note;
    END
$$ LANGUAGE plpgsql;
*/
CREATE OR REPLACE FUNCTION classement (out nip_ int, out prenom varchar, out nom varchar, out moyenne decimal, out classement int) 
RETURNS SETOF RECORD AS
$$
    DECLARE
        curs_clsmt CURSOR FOR
        SELECT id_personne, prenom_personne, nom_personne, ROUND(AVG(note),2) as moy
			FROM Personne
				JOIN AFAIT ON id_personne = id_etudiant
				GROUP BY id_personne, prenom_personne, nom_personne
				ORDER BY moy DESC;
    BEGIN
        classement :=1;
        OPEN curs_clsmt;
        IF (SELECT DISTINCT 1 FROM Etudiant WHERE SESSION_USER = nip::name) THEN
            LOOP
                FETCH curs_clsmt INTO nip_, prenom, nom, moyenne;
                EXIT WHEN NOT FOUND;
                IF SESSION_USER = nip_::name THEN
                    RETURN NEXT;
                ELSE
                    classement:=classement+1;
                END IF;
            END LOOP;
        ELSE
            LOOP
                FETCH curs_clsmt INTO nip_, prenom, nom, moyenne;
                EXIT WHEN NOT FOUND;
				RETURN NEXT;
				classement:=classement+1;
            END LOOP;
        END IF;
    END
$$ LANGUAGE plpgsql;

/*
CREATE or replace FUNCTION insert_note(id_contr integer, id_eleve integer, note decimal) RETURNS VOID AS
$$
    BEGIN
        IF(SELECT 1 FROM Personne WHERE current_user = nom_personne) THEN 
            GRANT INSERT ON aFait TO current_user ;
            INSERT INTO aFait values(id_contr,id_eleve,note);
            REVOKE INSERT ON aFait FROM current_user RESTRICT;
        END IF;
    END

$$
LANGUAGE plpgsql
SECURITY DEFINER;
*/