------------------- Visualisation de toutes les competences -------------------
CREATE OR REPLACE VIEW competence AS
    SELECT competence, nom_personne, prenom_personne, intitule, UE
    FROM Module, Personne, Enseignant
        WHERE id_enseignant = id_personne;
------------------- Visualisation de tous les controles -----------------------
CREATE OR REPLACE VIEW controle AS 
    SELECT intitule, coef_eval, aFait, MAX(note), AVG(note), MIN(note)
    FROM Module JOIN Evaluation USING(id_module), aFait;
--Visualisation de toutes les moyennes dans chaque competence en fonction des groupes-------------------
CREATE VIEW moyenne_groupe_competence
AS
    SELECT comp, groupe, ROUND(AVG(moy),2)
    FROM Etudiant JOIN bulletin(groupe) ON nip = nip_
        GROUP BY comp, groupe
        ORDER BY groupe;
--------------Visualisation du bulletin de chaque élève d'un groupe------------------
CREATE OR REPLACE FUNCTION bulletin (grp varchar, out nip_ integer, out nom varchar, out prenom varchar, out groupe_ varchar, out comp varchar, out moy decimal) RETURNS SETOF record AS
$$
DECLARE 
    curseur CURSOR FOR SELECT DISTINCT nip, nom_personne, prenom_personne, groupe, nom_competence, id_competence
    FROM Etudiant JOIN Personne ON nip = id_personne 
    JOIN aFait ON id_etudiant = nip 
    JOIN Evaluation USING(id_eval)
    JOIN Possede USING(id_module)
    JOIN Competences USING(id_competence)
    ORDER BY nom_personne;
    id_comp int;
BEGIN
    OPEN curseur;
    LOOP
        FETCH curseur into nip_, nom, prenom, groupe_, comp, id_comp;
        EXIT WHEN NOT FOUND;
        IF groupe_ = grp THEN
            moy:=moyenne_competence(nip_, id_comp);
            RETURN NEXT;
        END IF;
    END LOOP;
    CLOSE curseur;
END
$$
LANGUAGE plpgsql;
-------------Visualisation des moyennes de chaques élèves d'un groupe dans chaque module--------------
CREATE OR REPLACE FUNCTION moyenne_etudiant(
    grp varchar,
    out nip_ int, 
    out nom varchar, 
    out prenom varchar, 
    out groupe_ varchar,
    out module varchar,
    out min_moyenne decimal,
    out moyenne_etudiant decimal,
    out max_moyenne decimal
    ) RETURNS setof record AS
$$
DECLARE
    curseur_etud CURSOR FOR 
        SELECT DISTINCT id_etudiant, nom_personne, prenom_personne, groupe, intitule, id_module
        FROM Personne 
        JOIN Etudiant ON id_personne = NIP
        JOIN aFait ON NIP = id_etudiant
        JOIN Evaluation USING(id_eval)
        JOIN Module USING(id_module)
        ORDER BY nom_personne;

    idModule int;
BEGIN
    OPEN curseur_etud;
    LOOP
        FETCH curseur_etud INTO nip_, nom, prenom, groupe_, module, idModule;
        EXIT WHEN NOT FOUND;
        IF groupe_ = grp THEN
            moyenne_etudiant:=moyenne(nip_, idModule);
            min_moyenne:=moyenne_min(idModule);
            max_moyenne:=moyenne_max(idModule);
            RETURN NEXT;
        END IF;
    END LOOP;
    CLOSE curseur_etud;
END
$$ LANGUAGE plpgsql;
------------Visualisation du relevé de note de l'élève entré en paramettre-------------
CREATE or replace FUNCTION releve_de_note(inout nip_ integer, out nom varchar, out prenom varchar,out module varchar,out nom_controle varchar,out meilleure_note decimal, out note_ decimal, out pire_note decimal)
RETURNS SETOF RECORD AS
$$
    DECLARE
        etud_note CURSOR(nip_ int) FOR SELECT id_etudiant, nom_personne, prenom_personne, intitule, nom_eval, note, aFait.id_eval 
        FROM Personne JOIN aFait ON id_personne = id_etudiant JOIN Evaluation USING(id_eval) JOIN Module USING(id_module)
            WHERE id_etudiant = nip_;
        idEval int;
    BEGIN
        open etud_note(nip_);
        LOOP
            FETCH etud_note INTO nip_, nom, prenom, module, nom_controle, note_, idEval;
            EXIT WHEN NOT FOUND;
            SELECT MIN(note) INTO pire_note FROM aFait WHERE id_eval = idEval;
            SELECT MAX(note) INTO meilleure_note FROM aFait WHERE id_eval = idEval;
            RETURN NEXT;
        END LOOP;
        close etud_note;
    END
$$ LANGUAGE plpgsql;
---------------------------------Visualisation du classement général------------------------------------
CREATE OR REPLACE FUNCTION classement (out nip_ int, out prenom varchar, out nom varchar, out moyenne decimal, out classement int) 
RETURNS SETOF RECORD AS
$$
    DECLARE
        curs_clsmt CURSOR FOR
        SELECT DISTINCT id_personne, prenom_personne, nom_personne, moyenne_general(id_personne) as moy
			FROM Personne
				JOIN Etudiant ON nip = id_personne
                ORDER BY moy desc;
    BEGIN
        classement :=1;
        OPEN curs_clsmt;
        LOOP
            FETCH curs_clsmt INTO nip_, prenom, nom, moyenne;
            EXIT WHEN NOT FOUND;
			RETURN NEXT;
			classement:=classement+1;
        END LOOP;
    END
$$ LANGUAGE plpgsql;
