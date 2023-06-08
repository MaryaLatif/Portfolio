CREATE ROLE enseignant;
CREATE ROLE superieur;
CREATE ROLE etudiant;

GRANT SELECT ON TABLE evaluation, aFait, Personne, module, etudiant, competences, possede TO etudiant;
GRANT SELECT ON TABLE evaluation, aFait, Personne, module, etudiant, competences, possede, superieur, dispense TO enseignant;
GRANT SELECT ON TABLE evaluation, aFait, Personne, module, etudiant, competences, possede, superieur, dispense TO superieur;
GRANT INSERT, DELETE, UPDATE ON TABLE aFait, evaluation TO enseignant;
GRANT INSERT, DELETE, UPDATE ON TABLE Etudiant, Enseignant, Superieur TO superieur;

CREATE OR REPLACE FUNCTION trigger_role() RETURNS TRIGGER AS 
$$
    DECLARE 
        user_name varchar;
    BEGIN
        IF TG_relname = 'etudiant' THEN
            EXECUTE 'CREATE USER "' || NEW.nip || '";';
            EXECUTE 'GRANT etudiant TO "' || NEW.nip || '";';
        ELSIF TG_relname = 'enseignant' THEN
            SELECT nom_personne INTO user_name FROM PERSONNE WHERE id_personne = NEW.id_enseignant;
            EXECUTE 'CREATE USER "' || user_name || '";';
            EXECUTE 'GRANT enseignant TO "' || user_name || '";';
        ELSIF TG_relname = 'superieur' THEN
            SELECT nom_personne INTO user_name FROM PERSONNE WHERE id_personne = NEW.id_superieur;
            EXECUTE 'CREATE USER "' || user_name || '";';
            EXECUTE 'GRANT superieur TO "' || user_name || '";';
        END IF;
        RETURN NEW;

    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER give_etud ON etudiant;
DROP TRIGGER give_enseign On enseignant;
DROP TRIGGER give_sup ON superieur;

CREATE TRIGGER give_etud
    AFTER INSERT ON etudiant
    FOR EACH ROW EXECUTE PROCEDURE trigger_role();

CREATE TRIGGER give_enseign
    AFTER INSERT ON enseignant
    FOR EACH ROW EXECUTE PROCEDURE trigger_role();

CREATE TRIGGER give_sup
    AFTER INSERT ON superieur
    FOR EACH ROW EXECUTE PROCEDURE trigger_role();
*/

-- Trigger qui ajoute la personne au bon ROLE 