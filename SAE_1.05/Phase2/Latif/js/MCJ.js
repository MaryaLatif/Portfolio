document.addEventListener("DOMContentLoaded", function (event) {
    document.getElementById("connexion").addEventListener("click", function onclick(event) {
        event.preventDefault();
        if (document.getElementById("co-menu").className.includes("d-none")) {
            document.getElementById("co-menu").classList.remove("d-none");
        } else {
            document.getElementById("co-menu").classList.add("d-none");
        }
    });

    document.getElementById("billetterie").addEventListener("click", function onclick(event) {
        event.preventDefault();
        if (document.getElementById("bi-menu").className.includes("d-none")) {
            document.getElementById("bi-menu").classList.remove("d-none");
        } else {
            document.getElementById("bi-menu").classList.add("d-none");
        }
    });

    document.getElementById('menu').addEventListener('click', function onclick(event) {
        event.preventDefault();
        if (document.getElementById("search").className.includes("d-none")) {
            document.getElementById("search").classList.remove("d-none");
        } else {
            document.getElementById("search").classList.add("d-none");
        }
    });
    document.getElementById('logoMcj').addEventListener('click', function onclick(event) {
        event.preventDefault();
        if (document.getElementById("search").className.includes("d-none")) {
            document.getElementById("search").classList.remove("d-none");
        } else {
            document.getElementById("search").classList.add("d-none");
        }
    });
});


window.addEventListener('click', function (e) {
    if (!document.getElementById('connexion').contains(e.target)) {
        document.getElementById("co-menu").classList.add("d-none");
    }
});


window.addEventListener('click', function (e) {
    if (!document.getElementById("billetterie").contains(e.target)) {
        document.getElementById("bi-menu").classList.add("d-none");
    }
});