document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("search").style.height = "290px";

    document.getElementById('menu').addEventListener('click', function onclick(event) {
        event.preventDefault();
        if (document.getElementById("search").className.includes("d-none")) {
            document.getElementById("search").classList.remove("d-none");
        } else {
            document.getElementById("search").classList.add("d-none");
        }
    });
});

