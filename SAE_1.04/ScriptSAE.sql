DROP TABLE IF EXISTS aFait;

DROP TABLE IF EXISTS Evaluation;

DROP TABLE IF EXISTS Participe;

DROP TABLE IF EXISTS Module;

DROP TABLE IF EXISTS Etudiant;

DROP TABLE IF EXISTS Enseignant;

DROP TABLE IF EXISTS Personne;

DROP TABLE IF EXISTS data;

-- Création des tables 
CREATE TABLE Personne(
    id_personne INTEGER PRIMARY KEY,
    nom_personne VARCHAR,
    prenom_personne VARCHAR
);

CREATE TABLE Enseignant(
    id_enseignant INTEGER PRIMARY KEY REFERENCES Personne(id_personne)
);

CREATE TABLE Etudiant(
    NIP INTEGER PRIMARY KEY REFERENCES Personne(id_personne)
);

CREATE TABLE Module(
    id_module INTEGER PRIMARY KEY,
    intitule VARCHAR,
    code VARCHAR,
    UE VARCHAR,
    id_enseignant INTEGER REFERENCES Enseignant(id_enseignant)
);

CREATE TABLE Evaluation(
    id_eval SERIAL PRIMARY KEY,
    nom_eval VARCHAR,
    date_eval VARCHAR,
    id_module INTEGER REFERENCES MODULE(id_module)
);

CREATE TABLE aFait(
    id_eval INTEGER REFERENCES Evaluation(id_eval),
    id_etudiant INTEGER REFERENCES Etudiant(NIP),
    PRIMARY KEY(id_eval, id_etudiant),
    note VARCHAR
);

CREATE TABLE Data (
    id_enseignant INTEGER,
    nom_enseignant VARCHAR,
    prenom_enseignant VARCHAR,
    id_module INTEGER,
    code VARCHAR,
    ue VARCHAR,
    intitule_module VARCHAR,
    nom_evaluation VARCHAR,
    date_evaluation VARCHAR,
    note VARCHAR,
    id_etudiant INTEGER,
    nom_etudiant VARCHAR,
    prenom_etudiant VARCHAR
);

\copy data FROM 'Documents/SAE/SAE_1.03/data.csv' WITH (FORMAT CSV, HEADER, DELIMITER ';');

-- Insertion des tables :
INSERT INTO
    personne (id_personne, nom_personne, prenom_personne)
SELECT
    DISTINCT id_enseignant,
    nom_enseignant,
    prenom_enseignant
FROM
    data;

INSERT INTO
    personne (id_personne, nom_personne, prenom_personne)
SELECT
    DISTINCT id_etudiant,
    nom_etudiant,
    prenom_etudiant
FROM
    data;

INSERT INTO
    enseignant (id_enseignant)
SELECT
    DISTINCT id_enseignant
FROM
    data;

INSERT INTO
    etudiant (nip)
SELECT
    DISTINCT id_etudiant
FROM
    data;

INSERT INTO
    module (id_module, intitule, code, ue, id_enseignant)
SELECT
    DISTINCT id_module,
    intitule_module,
    code,
    ue,
    id_enseignant
FROM
    data;

INSERT INTO
    evaluation (nom_eval, date_eval, id_module)
SELECT
    DISTINCT nom_evaluation,
    date_evaluation,
    id_module
FROM
    data;

INSERT INTO
    participe (id_module, id_etudiant)
SELECT
    DISTINCT id_module,
    id_etudiant
FROM
    data;

INSERT INTO
    aFait (id_eval, id_etudiant, note)
SELECT
    id_eval,
    id_etudiant,
    note
from
    data
    JOIN evaluation ON data.nom_evaluation = evaluation.nom_eval
    and data.date_evaluation = evaluation.date_eval;

-- Reqêtes intéressantes :
SELECT
    nom_personne,
    prenom_personne,
    COUNT(*)
FROM
    aFait
    JOIN personne ON id_etudiant = id_personne
GROUP BY
    nom_personne,
    prenom_personne
ORDER BY
    nom_personne;

SELECT
    nom_evaluation,
    nom_etudiant,
    prenom_etudiant
FROM
    data
WHERE
    nom_etudiant = 'Point'
    and prenom_etudiant = 'Yvon';

ALTER TABLE
    afait
ALTER COLUMN
    note TYPE FLOAT USING (note :: double precision);

SELECT
    nom_personne,
    prenom_personne,
    AVG(note)
FROM
    aFait
    JOIN personne ON id_etudiant = id_personne
GROUP BY
    nom_personne,
    prenom_personne
HAVING
    AVG(note) >= 10;