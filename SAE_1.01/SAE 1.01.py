from pprint import pprint

#Construire un tableau p_amis qui modélise ce réseau d'amitié en selon le principe qui vient d'être décrit.
p_amis = [
"Muriel", "Joel",
"Muriel", "Yasmine",
"Joel","Yasmine",

"Yasmine", "Thomas",

"Joel", "Nasssim",
"Joel", "Andrea",
"Joel", "Ali",
"Nasssim", "Andrea",
"Nasssim", "Ali",
"Andrea", "Ali",

"Thomas", "Daria",
"Thomas", "Carole",

"Thierry", "Axel",
"Thierry", "Leo",
"Axel", "Leo",

 "Valentin", "Leo",
 "Valentin", "Andrea"
 ]

#Question 1 : Nombre d'amis d'une personne

def nb_amis(amis, prenom):
    """
    Retourne le nombre d'amis de prenom à partir des données du tableau amis
    
    Parameters
    ----------
    amis : list
    prenom : string

    Returns
    -------
    somme_amis : int

    """
    somme_amis = 0

    for name in amis :
        if name == prenom :
             somme_amis += 1
    return somme_amis

def test_nb_amis():
    """Fonction test de la fonction nb_amis"""
    assert nb_amis(p_amis, "Valentin") == 2, "Personne avec 2 amis"
    assert nb_amis(p_amis, "Marya") == 0, "Personne non présente dans la liste"

    try:
        assert nb_amis(["Marya", "Marya"], "Marya") == 1, "Amis avec le même prénom"
    except AssertionError:
        print("Erreur test_nb_amis: Test Amis avec le même prénom échoué. Le test ne peux pas réussir " +
        "car la seul information que nous avons est le prénom des personnes. ")
    print("Ok")

#-------------------------------------------------------------------------------
#Question 2 : Nombre de membres d'un réseau social

def taille_reseau(amis) :
    """
    A partir d'un tableau amis, la fonction retourne le nombre de personnes 
    distinctes participant à ce réseau social.
    
    Parametres
    ----------
    amis : tableau
    
    Returns
    -------
    TYPE
        INT
    """
    nb_pers = []

    for pers in amis :
        if pers not in nb_pers :
            nb_pers.append(pers)
    return len(nb_pers)

def test_taille_reseau():
    """
    Fonction test de la fonction taille réseau
    """
    
    print("Debut Test test_taille_reseau ")

    assert taille_reseau([]) == 0
    print("test_taille_reseau : Test avec tableau vide = Réussi")

    assert taille_reseau(["Marya", "India"]) == 2
    print("test_taille_reseau : Test réseau avec 2 personnes avec des prénoms différents = Réussi")

    try:
        assert taille_reseau(["India", "India"]) == 2
    except AssertionError:
        print("Erreur test_taille_reseau: Test Amis avec le même prénom échoué. Le test ne peux pas réussir" + 
        "car la seule information que nous avons est le prénom des personnes. ")

    print("Test test_taille_reseau: Réussi \n")
#-------------------------------------------------------------------------------
#Question 3 : Lecture des données d'un réseau à partir d'un fichier

def lecture_reseau(path) :
    """
    La fonction prend en paramètre un chemin vers un fichier et retournant un
    tableau modélisant les interactions entre les personnes du fichier.

    Parameters
    ----------
    path : string

    Returns
    -------
    tab : list 

    """
    
    tab = []

    try:
        f = open(path, "r")
        for val in f :
            tab += val.strip().split(";")
        f.close()
    except IOError:
        print("lecture_reseau: Erreur lors de la lecture de fichier.")

    return tab

def test_lecture_reseau():
    assert len(lecture_reseau('')) == 0
    assert len(lecture_reseau("files\Communaute1.csv")) == 210

    print("Test test_lecture_reseau: Réussi \n")

#-------------------------------------------------------------------------------
#Question 4 : Modélisation d'un réseau par un dictionnaire

def dico_reseau(amis) :
    """
    A partir d'un tableau amis modélisant les interactions entre personnes d'un
    réseau, la fonction retourne un dictionnaire dont les clés sont les prénoms
    des membres du réseau et les valeurs sont le tableau de leurs amis.

    Parametre
    ----------
    amis : list

    Returns
    -------
    dico : dict

    """
    dico = {}
    i = 0

    while i < len(amis):
        liste_amis = []
        if amis[i] in dico :
            liste_amis = dico[amis[i]]

        if i%2 == 0 :
            liste_amis.append(amis[i+1])
        else :
            liste_amis.append(amis[i-1])

        dico[amis[i]] = liste_amis
        i += 1

    return dico

def test_dico_reseau():
    "Fonctiont test de la fonction dico_reseau"
    assert dico_reseau(["Marya", "Daniel"]) == {"Marya":["Daniel"], "Daniel":["Marya"]}
    print("test_dico_reseau : Test sur un tableau de 2 amis = Réussi")

    assert dico_reseau([]) == {}
    print("test_dico_reseau : Test sur un tableau vide = Réussi")

    try:
        assert dico_reseau(["Marya", "Marya"]) == {"Marya" : ["Marya"]}
    except AssertionError :
        print("\nErreur test_dico_reseau : Test avec amis qui ont le même prénom échoué. Le test ne peux pas réussir " +
        "car la seul information que nous avons est le prénom des personnes.\n")

#-------------------------------------------------------------------------------
#Question 5 : Nombre d'amis des personnes les plus populaires

def nb_amis_plus_pop(dico_reseau):
    """
    A partir d'un dictionnaire entré en parametre et qui modélise les
    interactions dans un réseau d'amis, la fonction retourne le nombre d'amis
    des personnes les plus populaires du réseau.

    Parameters
    ----------
    dico_reseau : dict

    Returns
    -------
    nb_amis_max : int

    """
    nb_amis_max = 0
    for prenom, amis in dico_reseau.items() :
        if nb_amis_max < len(amis) :
            nb_amis_max = len(amis)

    return nb_amis_max

def test_nb_amis_plus_pop():
    """Fonction test de la fonction nb_amis_plus_pop"""
    assert nb_amis_plus_pop({}) == 0
    print("test_nb_amis_plus_pop : Test sur un dictionnaire vide = Réussi")

    assert nb_amis_plus_pop({"Marya" : ["Daniel","India"], "Toto": ["Samir"]}) == 2
    print("test_nb_amis_plus_pop : Test dont le tableau du dico ayant le plus d'ami est égal à 2 = Réussi")

#-------------------------------------------------------------------------------
#Question 6 : Personnes les plus populaires

def les_plus_pop(dico_reseau):
    """
    A partir d'un dictionnaire entré en parametre et qui modélise les
    interactions dans un réseau d'amis, la fonction retourne un tableau
    contenant les prénoms de toutes les personnes les plus populaires du réseau.

    Parameters
    ----------
    dico_reseau : dict

    Returns
    -------
    pop : list

    """
    pop = []
    nb = nb_amis_plus_pop(dico_reseau)
    for prenom, nb_amis in dico_reseau.items():
        if len(nb_amis) == nb :
            pop.append(prenom)
    return pop

def test_les_plus_pop():
    """Fonction test de la fonction les_plus_pop"""
    assert les_plus_pop({}) == []
    print(("test_les_plus_pop : Test sur un dico vide : Réussi"))

    assert les_plus_pop({"Marya" : ["Daniel","India"], "Toto": ["Samir"]}) == ["Marya"]
    print("test_les_plus_pop : Test sur un dico dont une seule personne est populaire (nombre d'amie = 2) : Réussi")

    assert les_plus_pop({"Marya" : ["Daniel","India"], "Toto": ["Samir"], "Paul": ["Marya", "Sam"]}) == ["Marya", "Paul"]
    print("test_les_plus_pop : Test sur un dico dont plus d'une personne est populaire (nombre d'amie = 2) : Réussi")


print(dico_reseau(p_amis))