# Module contenant les fonctions de la SAE 1.O2
from time import *
p_amis = [
    "Muriel", "Joel",
    "Muriel", "Yasmine",
    "Joel", "Yasmine",

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

network = {"Alice": ["Bob", "Dominique"],
           "Bob": ["Alice", "Charlie", "Dominique"],
           "Charlie": ["Bob"],
           "Dominique": ["Alice", "Bob"]}


# Question 1
def create_network(friend):
    """
    Créer un réseau d'ami à partir d'un tableau friend
    Parametre
    ----------
    friend : list

    Returns
    -------
    dico : dict

    """
    
    dico = {}
    i = 0

    while i < len(friend):
        if friend[i] not in dico:
            dico[friend[i]] = []
        if friend[i+1] not in dico:
            dico[friend[i+1]] = []

        dico[friend[i]].append(friend[i+1])
        dico[friend[i+1]].append(friend[i])
        i += 2

    return dico


# Question 2
def liste_amis(amis, prenom):
    """
    Retourne la liste des amis de prenom en fonction du tableau amis. 
    
    Parametres
    ----------
    amis : list
    prenom : string

    Returns
    -------
    prenoms_amis : list
    """
    prenoms_amis = []
    i = 0
    while i < len(amis)//2:
        if amis[2 * i] == prenom:
            prenoms_amis.append(amis[2*i+1])
        elif amis[2*i+1] == prenom:
            prenoms_amis.append(amis[2*i])
        i += 1
    return prenoms_amis


def personnes_reseau(amis):
    """
    Retourne un tableau contenant la liste des personnes du réseau.
    
    Parametres
    ----------
    amis : list

    Returns
    -------
    people : list 
    """
    people = []
    i = 0
    while i < len(amis):
        if amis[i] not in people:
            people.append(amis[i])
        i += 1
    return people


def dico_reseau(amis):
    """
    Retourne le dictionnaire correspondant au réseau.

    Parametre
    ----------
    amis : list

    Returns
    -------
    dico : dict
        
    """
    dico = {}
    people = personnes_reseau(amis)
    i = 0
    while i < len(people):
        dico[people[i]] = liste_amis(amis, people[i])
        i += 1
    return dico


# Question 3
def get_people(network):
    """
    Retourne le tableau des personnes du réseau

    Parametres
    ----------
    network : dict

    Returns
    -------
    tab : list

    """
    
    tab = []
    for val in network:
        tab.append(val)
    return tab

# Question 4


def are_friends(network, p1, p2):
    """
    Renvoie True si p1 est ami avec p2, False sinon
    
    Parametres
    ----------
    network : dict
    p1 : string
    p2 : string
    
    Returns : bool
    """
    
    return p1 in network and p2 in network and p2 in network[p1]

# Question 5


def all_his_friends(network, person, group):
    """
    Fonction prenant en paramètre réseau, une personne et un groupe de personnes 
    et retournant `True` si la personne est amie avec toutes les personnes du 
    groupe, et False sinon.

    Parametres
    ----------
    network : dict
    person : string
    group : list

    Returns
    -------
    bool
    
    """
    
    for other_person in group:
        if not are_friends(network, person, other_person):
            return False
    return True

# Question 6


def is_a_community(network, tab):
    """
    Prenant en paramètre un dictionnaire modélisant le réseau et un groupe de 
    personnes (tableau de personnes) et retourne `True` si ce groupe est une 
    communauté, et False sinon. 

    Parametres
    ----------
    network : dict
    tab : list
    Returns
    -------
    bool

    """
    
    i = 0
    while i < len(tab):
        for val in tab:
            if val == tab[i]:
                continue
            if val not in network[tab[i]]:
                return False
        i += 1
    return True

# Question 7


def find_community(network, group):
    """
    fonction prenant en paramètre un réseau et un groupe de personnes et 
    retournant une communauté en fonction de l'heuristique décrite dans la consigne.
    L'ordre des personnes sera donné par l'ordre de celles-ci dans le tableau 
    correspondant au groupe.

    Parametres
    ----------
    network : dict
    group : list
    Returns
    -------
    community : list
    """
    
    community = []
    i = 0
    while i < len(group) and group[0] not in network.keys():
        i += 1

    if i == len(group):
        return community

    community.append(group[i])
    i += 1
    while i < len(group):
        if group[i] in network.keys() and all_his_friends(network, group[i], community):
            community.append(group[i])
        i += 1
    return community


# Question 8
def order_by_decreasing_popularity(network, tab):
    """
    fonction prenant en paramètre un réseau et un groupe de personnes et triant
    le groupe de personnes selon la popularité (nombre d'amis) décroissante.

    Parametres
    ----------
    network : dict
    tab : list

    Returns
    -------
    tab : list

    """
    
    j = 0
    while j < len(tab)-1:
        i = j
        while i < len(tab)-1:
            if len(network[tab[j]]) < len(network[tab[i]]):
                min = tab[j]
                tab[j] = tab[i]
                tab[i] = min
            i += 1
        j += 1

    return tab


# Question 9
def find_community_by_decreasing_popularity(network):
    """
    Fonction prenant en paramètre un réseau. La fonction doit trier l'ensemble 
    des personnes du réseau selon l'ordre décroissant de popularité puis
    retourner la communauté trouvée en appliquant l'heuristique de construction
    de communauté maximale expliquée plus haut"

    Parametres
    ----------
    network : dict

    Returns
    -------
    TYPE
        list

    """
    
    return find_community(network, order_by_decreasing_popularity(network, get_people(network)))


# Question 10
def find_community_from_person(network, person):
    """
    Fonction prenant en paramètre un réseau et une personne, et retournant 
    une communauté maximale contenant cette personne selon l'heuristique 
    décrite dans la consigne.

    Parametres
    ----------
    network : dict
    person : string

    Returns
    -------
    commu : list.

    """
    
    commu = [person]
    commu += find_community(network,
                            (order_by_decreasing_popularity(network, network[person])))
    return commu


# Question 12
def find_max_community(network):
    """
    fonction  prenant en paramètre un réseau et appliquant 
    l'heuristique de recherche de communauté maximale donnée par `find_community_from_person` 
    pour toutes les personnes du réseau. La fonction doit retourner la plus grande 
    communauté trouvée"

    Parametre
    ----------
    network : dict

    Returns
    -------
    max_commu : list

    """
    
    max_commu = []
    for person in network:
        person_community = find_community_from_person(network, person)
        if len(max_commu) < len(person_community):
            max_commu = person_community
    return max_commu
