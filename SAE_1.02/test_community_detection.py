# Module contenant les test unitaires des fonctions de la SAE 1.02
from community_detection import p_amis, create_network, get_people, are_friends, all_his_friends, is_a_community, find_community, order_by_decreasing_popularity, find_community_by_decreasing_popularity, find_community_from_person, find_max_community


# Question 1
def test_create_network():
    "Fonction test de la fonction create_network"
    assert create_network(["Marya", "Daniel"]) == {
        "Marya": ["Daniel"], "Daniel": ["Marya"]}
    print("test_create_network : Test sur un tableau de 2 amis = Réussi")

    assert create_network([]) == {}
    print("test_create_network : Test sur un tableau vide = Réussi")

    try:
        assert create_network(["Marya", "Marya"]) == {"Marya": ["Marya"]}
    except AssertionError:
        print("Erreur test_create_network : Test avec amis qui ont le même prénom échoué. Le test ne peux pas réussir car la seul information que nous avons est le prénom des personnes.")


test_create_network()

# Question 3


def test_get_people():
    """
        Fonction test de la fonction get_people 
    """
    assert get_people({}) == []
    print("test_get_people : test avec un reseau vide en paramètre = Réussi")
    assert get_people({"Alice": "", "Bob": ""}) == ["Alice", "Bob"]
    print("test_get_people : test avec un réseau de 2 personnes = Réussi")
    try:
        assert get_people({"Alice": "", "Alice": ""}) == ["Alice", "Alice"]
    except AssertionError:
        print("Erreur test_get_people : test avec un réseau avec 2 personnes du même prénom ne retourne pas un tableau avec 2x le même prénom")


test_get_people()

# Question 4


def test_are_friends():
    """
        Fonction test de la fonction are_friends
    """
    assert are_friends({}, "Alice", "Bob") == False
    print("test_are_friends : test d'amitié entre deux personne qui ne sont pas dans le réseau : Réussi")
    assert are_friends(
        {"Alice": ["Bob", "Lili"], "Bob": "Alice"}, "Alice", "Bob") == True
    print("test_are_friends : test d'amitié entre deux personnes du même réseau : Réussi")
    assert are_friends({"Alice": "Alice", "Alice": [
                       "Alice", "Bob"]}, "Alice", "Alice") == True
    print("test_are_friends : test quand deux ami(e)s ont le même prénom = Réussi")


test_are_friends()

# Question 5


def test_all_his_friends():
    """
        Fonction test de la fonction all_his_friends
    """
    network = create_network(p_amis)

    assert (all_his_friends(network, "Muriel", ['Joel', 'Yasmine'])) == True
    print("test_all_his_friends : test d'amitié avec Muriel qui est bien amie avec les personnes du tableau : Réussi")
    assert (all_his_friends(network, "Muriel", ['Joel', 'Léa'])) == False
    print("test_all_his_friends : test d'amitié avec Muriel qui n'est pas amie avec Léa qui est dans le tableau : Réussi")
    assert (all_his_friends(network, "Marya", ['Joel', 'Yasmine'])) == False
    print("test_all_his_friends : test d'amitié avec Marya qui n'est pas dans le réseau d'ami : Réussi")
    assert (all_his_friends({}, "Muriel", ['Joel', 'Yasmine'])) == False
    print("test_all_his_friends : test d'amitié avec un réseau d'ami vide : Réussi")


test_all_his_friends()

# Question 6


def test_is_a_community():
    """
        Fonction test de la fonction is_a_community
    """
    network = {"Alice": ["Bob", "Dominique"],
               "Bob": ["Alice", "Charlie", "Dominique"],
               "Charlie": ["Bob"],
               "Dominique": ["Alice", "Bob"]
               }
    assert (is_a_community(network, ["Alice", "Bob", "Dominique"])) == True
    print("test_is_a_community : test de communauté avec 3 personnes de la même communauté : Réussi")
    assert (is_a_community(network, ["Alice", "Bob", "Charlie"])) == False
    print("test_is_a_community : test de communauté avec 3 personnes dont un n'est pas ami avec un membre du groupe : Réussi")
    # True car on a besoin de rien vérifier le vide est une communauté à lui tout seul constitué de rien
    assert (is_a_community(network, [])) == True
    print("test_is_a_community : test de communauté avec un tableau vide en paramètre : Réussi")


test_is_a_community()

# Question 7


def test_find_community():
    """ 
        Fonction test de la fonction find_community
    """
    network = {"Alice": ["Bob", "Dominique"],
               "Bob": ["Alice", "Charlie", "Dominique"],
               "Charlie": ["Bob"],
               "Dominique": ["Alice", "Bob"]
               }
    assert (find_community(network, ["Alice", "Bob", "Charlie", "Dominique"])) == [
        "Alice", "Bob", "Dominique"]
    print("test_find_community : test avec un groupe dont une personne n'est pas amie avec toute les personne du groupe d'amis de la première personne du tableau en paramètre : Réussi")
    assert (find_community(network, ["Charlie", "Alice", "Bob", "Dominique"])) == [
        "Charlie", "Bob"]
    print("test_find_community : test avec un groupe dont une personne est amie avec la première personne du tableau en paramètre : Réussi")
    assert (find_community(network, ["Charlie", "Alice", "Dominique"])) == [
        "Charlie"]
    print("test_find_community : test avec un groupe dont personne n'est amie avec la première personne du tableau en paramètre : Réussi")
    assert (find_community(network, [])) == []
    print("test_find_community : test avec un tableau vide en paramètre : Réussi")


test_find_community()

# Question 8


def test_order_by_decreasing_popularity():
    """
        Fonction test de la fonction order_by_decreasing_popularity
    """
    network = {
        "Alice": ["Bob", "Dominique"],
        "Bob": ["Alice", "Charlie", "Dominique"],
        "Charlie": ["Bob"],
        "Dominique": ["Alice", "Bob"]
    }
    assert (order_by_decreasing_popularity(
        network, ["Alice", "Bob", "Charlie"])) == ['Bob', 'Alice', 'Charlie']
    print("test_test_order_by_decreasing_popularity : test avec un groupe personne d'un réseau :  Réussi")
    assert (order_by_decreasing_popularity(network, [])) == []
    print("test_test_order_by_decreasing_popularity : test avec un tableau vide en paramètre :  Réussi")


test_order_by_decreasing_popularity()

# Question 9


def test_find_community_by_decreasing_popularity():
    """
        Fonction test de la fonction find_community_by_decreasing_popularity
    """
    network = {
        "Alice": ["Bob", "Dominique"],
        "Bob": ["Alice", "Charlie", "Dominique"],
        "Charlie": ["Bob"],
        "Dominique": ["Alice", "Bob"]
    }
    assert (find_community_by_decreasing_popularity(
        network)) == ["Bob", "Alice", "Dominique"]
    print("test_find_community_by_decreasing_popularity : test avec un réseau : Réussi")
    assert (find_community_by_decreasing_popularity({})) == []
    print("test_find_community_by_decreasing_popularity : test avec un réseau vide : Réussi")


test_find_community_by_decreasing_popularity()

# Question 10


def test_find_community_from_person():
    """ 
        Fonction test de la fonction find_community_from_person
    """
    network = {"Alice": ["Bob", "Dominique"],
               "Bob": ["Alice", "Charlie", "Dominique"],
               "Charlie": ["Bob"],
               "Dominique": ["Alice", "Bob"]
               }
    assert (find_community_from_person(network, "Alice")) == [
        "Alice", "Bob", "Dominique"]
    print("test_find_community_from_person : test avec Alice : Réussi")
    assert (find_community_from_person(
        network, "Charlie")) == ["Charlie", "Bob"]
    print("test_find_community_from_person : test avec Charlie : Réussi")


test_find_community_from_person()

# Question 12


def test_find_max_community():
    """ 
        Fonction test de la fonction find_max_community
    """
    network = {"Alice": ["Bob", "Dominique"],
               "Bob": ["Alice", "Charlie", "Dominique"],
               "Charlie": ["Bob"],
               "Dominique": ["Alice", "Bob"]
               }
    assert (find_max_community(network)) == ["Alice", "Bob", "Dominique"]
    print("test_find_max_community : test avec un réseau d'ami : Réussi")
    assert (find_max_community({})) == []
    print("test_find_max_community : test avec un réseau d'ami vide : Réussi")


test_find_max_community()
