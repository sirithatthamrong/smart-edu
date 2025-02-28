document.addEventListener("DOMContentLoaded", function () {
    window.confirmDelete = function(teacherId, teacherEmail) {
        console.log("Opening delete modal for", teacherEmail); // Debugging
        document.getElementById("teacherEmail").innerText = teacherEmail;
        document.getElementById("deleteForm").action = `/teachers/${teacherId}`;
        document.getElementById("deleteModal").style.display = "flex"; // Fix hidden issue
    };

    window.closeModal = function() {
        document.getElementById("deleteModal").style.display = "none";
    };
});
