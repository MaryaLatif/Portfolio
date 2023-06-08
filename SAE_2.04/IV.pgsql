
------------------------------------------ Accès Données Étudiant ------------------------------------------------
-- L'étudiant peut voir que ses notes à lui
CREATE OR REPLACE FUNCTION mes_notes() RETURNS TABLE(module_ varchar, controle varchar, meilleureNote decimal, note decimal, pireNote decimal) AS
$$
    BEGIN
        IF session_user IN (SELECT nip::name FROM Etudiant) THEN
            RETURN QUERY 
                SELECT module, nom_controle, meilleure_note, note_, pire_note FROM releve_de_note(session_user::integer);
        ELSE
            RAISE EXCEPTION 'Vous n''êtes pas étudiant de cette promo';
        END IF;
    END
$$
LANGUAGE plpgsql;
-- L'étudiant peut voir que son bulletin à lui
CREATE OR REPLACE FUNCTION mon_bulletin() RETURNS TABLE(competence varchar, moyenne decimal) AS
$$
    DECLARE 
        grp varchar;
    BEGIN
        IF session_user IN (SELECT nip::name FROM Etudiant) THEN
            SELECT groupe INTO grp FROM Etudiant WHERE nip = session_user::integer;
            RETURN QUERY 
                SELECT comp, moy FROM bulletin(grp) WHERE nip_ = session_user::integer ;
        ELSE
            RAISE EXCEPTION 'Vous n''êtes pas étudiant de cette promo';
        END IF;
    END
$$
LANGUAGE plpgsql;
-- L'étudiant peut voir que ses moyennes à lui
CREATE OR REPLACE FUNCTION mes_moyennes() RETURNS TABLE(module_ varchar, meilleure_moyenne decimal, moyenne decimal, pire_moyenne decimal) AS
$$
    DECLARE 
        grp varchar;
    BEGIN
        IF session_user IN (SELECT nip::name FROM Etudiant) THEN
            SELECT groupe INTO grp FROM Etudiant WHERE nip = session_user::integer;
            RETURN QUERY 
                SELECT module, max_moyenne, moyenne_etudiant, min_moyenne FROM moyenne_etudiant(grp) WHERE nip_ = session_user::integer ;
        ELSE
            RAISE EXCEPTION 'Vous n''êtes pas étudiant de cette promo';
        END IF;
    END
$$
LANGUAGE plpgsql;
-- L'étudiant peut voir son classement avec sa moyenne générale
CREATE OR REPLACE FUNCTION mon_classement() RETURNS TABLE(moyenne_ decimal, classement_ integer) AS
$$
    BEGIN
        IF session_user IN (SELECT nip::name FROM Etudiant) THEN
            RETURN QUERY 
                SELECT moyenne, classement FROM classement() WHERE nip_ = session_user::integer ;
        ELSE
            RAISE EXCEPTION 'Vous n''êtes pas étudiant de cette promo';
        END IF;
    END
$$
LANGUAGE plpgsql;
------------------------------------------ Accès Données Enseignant/Supérieur ------------------------------------------------
-- L'enseignant/supérieur peut voir les notes de l'étudiant qu'il veut
CREATE OR REPLACE FUNCTION notes_de(nip int) RETURNS TABLE(nom_etud varchar, prenom_etud varchar, module_ varchar, controle varchar, note decimal) AS
$$
    BEGIN
        IF session_user::varchar IN (SELECT nom_personne FROM Personne JOIN Enseignant ON id_personne = id_enseignant UNION SELECT nom_personne FROM Personne JOIN Superieur ON id_personne = id_superieur) THEN
            RETURN QUERY 
                SELECT nom, prenom, module, nom_controle, note_ FROM releve_de_note(nip);
        ELSE
            RAISE EXCEPTION 'Vous n''êtes pas enseignant ou supérieur';
        END IF;
    END
$$
LANGUAGE plpgsql;
-- L'enseignant/supérieur peut voir le bulletin de l'étudiant qu'il veut
CREATE OR REPLACE FUNCTION bulletin_de(_nip int) RETURNS TABLE(nom_etud varchar, prenom_etud varchar, competence varchar, moyenne decimal) AS
$$
    DECLARE 
        grp varchar;
    BEGIN
        IF session_user::varchar IN (SELECT nom_personne FROM Personne JOIN Enseignant ON id_personne = id_enseignant UNION SELECT nom_personne FROM Personne JOIN Superieur ON id_personne = id_superieur) THEN
            SELECT groupe INTO grp FROM Etudiant WHERE nip = _nip;
            RETURN QUERY 
                SELECT nom, prenom, comp, moy FROM bulletin(grp) WHERE nip_ = _nip;
        ELSE
            RAISE EXCEPTION 'Vous n''êtes pas enseignant ou supérieur';
        END IF;
    END
$$
LANGUAGE plpgsql;
-- L'enseignant/supérieur peut voir les moyennes de l'étudiant qu'il veut
CREATE OR REPLACE FUNCTION moyenne_de(_nip int) RETURNS TABLE(nom_etud varchar, prenom_etud varchar, module_ varchar, moyenne decimal) AS
$$
    DECLARE 
        grp varchar;
    BEGIN
        IF session_user::varchar IN (SELECT nom_personne FROM Personne JOIN Enseignant ON id_personne = id_enseignant UNION SELECT nom_personne FROM Personne JOIN Superieur ON id_personne = id_superieur) THEN
            SELECT groupe INTO grp FROM Etudiant WHERE nip = _nip;
            RETURN QUERY 
                SELECT nom, prenom, module, moyenne_etudiant FROM moyenne_etudiant(grp) WHERE nip_ = _nip;
        ELSE
            RAISE EXCEPTION 'Vous n''êtes pas enseignant ou supérieur';
        END IF;
    END
$$
LANGUAGE plpgsql;
-- Trigger pour que seul l'enseignant résponsable du module puisse ajouter/modifier/supprimer des contrôles
CREATE OR REPLACE FUNCTION modif_notes()
RETURNS TRIGGER AS
$$
    DECLARE
        resp personne.nom_personne%TYPE;
    BEGIN
        SELECT nom_personne INTO resp
        FROM PERSONNE
        JOIN MODULE ON id_personne = id_enseignant
        WHERE MODULE.id_module = NEW.id_module;

        IF SESSION_USER = resp THEN 
            RAISE NOTICE 'Modification avec succès !';
            RETURN NEW;
        ELSE
            RAISE EXCEPTION 'Vous n''êtes pas résponsable du module';
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER modif_note ON EVALUATION;
CREATE TRIGGER modif_note
    BEFORE
    INSERT OR UPDATE OR DELETE ON EVALUATION
        FOR EACH ROW
        EXECUTE PROCEDURE modif_notes();
-- Trigger pour que seul l'enseignant du module et du groupe puisse ajouter/modifier/supprimer les notes d'un étudiant
CREATE OR REPLACE FUNCTION trigger_note() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT id_module, nom_personne, prenom_personne, dispense.groupe, nip 
        FROM dispense JOIN personne On id_personne = id_enseignant 
            JOIN Etudiant ON dispense.groupe = etudiant.groupe 
            JOIN Evaluation USING(id_module)
                WHERE session_user = nom_personne::name AND NEW.id_etudiant = nip 
                    AND NEW.id_eval = evaluation.id_eval) THEN
        RAISE NOTICE 'notes modifiées avec succès';
    ELSE
        RAISE EXCEPTION 'Permission non accordée';
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER modif_note
BEFORE 
INSERT OR UPDATE OR DELETE
ON aFait
FOR EACH ROW
EXECUTE PROCEDURE trigger_note();