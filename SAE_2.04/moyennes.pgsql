------------------- Moyenne de l'étudiant sur le module ---------------------
CREATE OR REPLACE FUNCTION moyenne(nip_ int, module_ int) RETURNS decimal AS
$$
DECLARE
    curseur_moy CURSOR(nip int, id_mod int) FOR 
        SELECT coef_eval, note FROM aFait 
        JOIN Evaluation USING(id_eval)
        JOIN Module USING(id_module)
            WHERE id_etudiant = nip AND id_module = id_mod;

    coef decimal;
    note decimal;
    sum_note decimal;
    sum_coef decimal;
BEGIN
    OPEN curseur_moy(nip_, module_);
    sum_note:=0;
    sum_coef:=0;
    LOOP
        FETCH curseur_moy INTO coef, note;
        EXIT WHEN NOT FOUND;
        sum_note:= sum_note + (coef*note);
        sum_coef:= sum_coef + coef;
    END LOOP;
    CLOSE curseur_moy;
    IF sum_coef!=0 THEN 
        RETURN ROUND(sum_note/sum_coef,2);
    END IF;
    RETURN ROUND(0,2); -- Si l'élève n'a pas de note il a 0
END
$$
LANGUAGE plpgsql;
--------------------- Moyenne la plus haute sur le module -----------------
CREATE OR REPLACE FUNCTION moyenne_max (module_ integer) RETURNS decimal AS
$$
DECLARE 
    curseur CURSOR FOR SELECT nip FROM Etudiant;
    nip_ int;
    max decimal:=0;
BEGIN
    OPEN curseur;
    LOOP
        FETCH curseur INTO nip_;
        EXIT WHEN NOT FOUND;
        IF max < moyenne(nip_, module_) THEN
            max:= moyenne(nip_, module_);
        END IF;
    END LOOP;
    CLOSE curseur;
    RETURN max;
END
$$
LANGUAGE plpgsql;
-------------------- Moyenne la plus basse sur le module -----------------
CREATE OR REPLACE FUNCTION moyenne_min (module_ integer) RETURNS decimal AS
$$
DECLARE 
    curseur CURSOR FOR SELECT nip FROM Etudiant;
    nip_ int;
    min decimal;
BEGIN
    OPEN curseur;
    min:= moyenne(12200955, module_);
    LOOP
        FETCH curseur INTO nip_;
        EXIT WHEN NOT FOUND;
        IF min > moyenne(nip_, module_) THEN
            min:= moyenne(nip_, module_);
        END IF;
    END LOOP;
    CLOSE curseur;
    RETURN min;
END
$$
LANGUAGE plpgsql;
-------------------------- Moyenne sur la competence -------------------------------
CREATE OR REPLACE FUNCTION moyenne_competence(nip_ int, comp int) RETURNS DECIMAL AS
$$
DECLARE
    curseur_comp CURSOR(compe int) FOR SELECT * FROM Possede
        WHERE id_competence = compe;

    competence int;
    module int;
    coef decimal;
    sum_coef decimal:=0;
    sum_moy decimal:=0;
BEGIN
    OPEN curseur_comp(comp);
    LOOP
        FETCH curseur_comp INTO competence, module, coef;
        EXIT WHEN NOT FOUND;
        sum_moy:=sum_moy+moyenne(nip_, module)*coef;
        sum_coef:=sum_coef+coef;
    END LOOP;
    CLOSE curseur_comp;

    IF sum_coef!=0 THEN
        RETURN ROUND(sum_moy/sum_coef,2);
    END IF;
    RETURN 0;
END
$$
LANGUAGE plpgsql;
-------------------------- Moyenne générale ---------------------------
CREATE OR REPLACE FUNCTION moyenne_general(nip int) RETURNS DECIMAL AS 
$$
DECLARE
    curseur_moyG CURSOR FOR SELECT id_competence FROM Competences;
    comp int;
    sum_comp decimal:=0;
    nb int;
BEGIN
    SELECT COUNT(id_competence) INTO nb FROM Competences;
    OPEN curseur_moyG;
    LOOP
        FETCH curseur_moyG INTO comp;
        EXIT WHEN NOT FOUND;
        sum_comp:= sum_comp+moyenne_competence(nip, comp);
    END LOOP;
    CLOSE curseur_moyG;
    RETURN ROUND(sum_comp/nb,2);
END
$$
LANGUAGE plpgsql;
