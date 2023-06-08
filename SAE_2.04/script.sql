DROP TABLE IF EXISTS aFait;

DROP TABLE IF EXISTS Evaluation;

DROP TABLE IF EXISTS Possede;

DROP TABLE IF EXISTS Competences;

DROP TABLE IF EXISTS Dispense;

DROP TABLE IF EXISTS Module;

DROP TABLE IF EXISTS Etudiant;

DROP TABLE IF EXISTS Enseignant;

DROP TABLE IF EXISTS Superieur;

DROP TABLE IF EXISTS Personne;


-- Création des tables 
CREATE TABLE Personne(
    id_personne INTEGER PRIMARY KEY,
    nom_personne VARCHAR,
    prenom_personne VARCHAR
);

CREATE TABLE Enseignant(
    id_enseignant INTEGER PRIMARY KEY REFERENCES Personne(id_personne)
);

CREATE TABLE Superieur(
    id_superieur INTEGER PRIMARY KEY REFERENCES Personne(id_personne),
    grade VARCHAR
);

CREATE TABLE Etudiant(
    NIP INTEGER PRIMARY KEY REFERENCES Personne(id_personne),
    groupe VARCHAR
);

CREATE TABLE Module(
    id_module INTEGER PRIMARY KEY,
    intitule VARCHAR,
    UE VARCHAR,
    id_enseignant INTEGER REFERENCES Enseignant(id_enseignant)
);

CREATE TABLE Competences(
    id_competence INTEGER PRIMARY KEY,
    nom_competence VARCHAR
);

CREATE TABLE Dispense(
    id_enseignant INTEGER REFERENCES Enseignant(id_enseignant),
    id_module INTEGER REFERENCES Module(id_module),
    groupe VARCHAR,
    PRIMARY KEY(id_enseignant, id_module, groupe)
);

CREATE TABLE Possede(
    id_competence INTEGER REFERENCES Competences(id_competence),
    id_module INTEGER REFERENCES Module(id_module),
    coef DECIMAL(4,2),
    PRIMARY KEY(id_competence, id_module)
);

CREATE TABLE Evaluation(
    id_eval SERIAL PRIMARY KEY,
    nom_eval VARCHAR,
    coef_eval DECIMAL(4,2),
    date_eval DATE,
    id_module INTEGER REFERENCES MODULE(id_module)
);

CREATE TABLE aFait(
    id_eval INTEGER REFERENCES Evaluation(id_eval),
    id_etudiant INTEGER REFERENCES Etudiant(NIP),
    PRIMARY KEY(id_eval, id_etudiant),
    note DECIMAL(4,2)
);



--peuplement :

INSERT INTO Personne VALUES
(12200955, 'Latif', 'Marya'),
(12200844, 'Cabo', 'India'), 
(12200789, 'Baouchi', 'Aboubakar'),
(12240000, 'Alejandro', 'Poquito'),
(1, 'Kris', 'Evaggelos'),
(2, 'Hebert', 'David');

INSERT INTO Etudiant VALUES
(12200955, 'SHANGO'),
(12200844, 'SHANGO'), 
(12200789, 'SHANGO'),
(12240000, 'ZEUS');

INSERT INTO Enseignant VALUES
(1),(2);

INSERT INTO Competences VALUES
(1, 'Optimisation'),
(2, 'Autres');

INSERT INTO Module VALUES
(1, 'java', 'UE12', 1),
(2, 'python', 'UE12', 1);

INSERT INTO Possede VALUES
(1, 1, 2.0),
(2, 2, 4.0);

INSERT INTO Evaluation VALUES
(1, 'controle1', 1, '12/12/12', 1),
(2, 'controle 1', 1, '10/12/34', 2),
(3, 'controle 2', 3, '19/05/2023', 2);

INSERT INTO aFait VALUES
(1, 12200955, 15.77),
(1, 12200844, 19),
(1, 12200789, 19.5),
(1, 12240000, 9.0),
(3, 12200955, 17.33),
(2, 12200955, 18),
(2, 12240000, 12.98);

INSERT INTO Superieur VALUES
(2, 'Directeur');

INSERT INTO Dispense VALUES
(1, 2, 'SHANGO');