document.addEventListener("DOMContentLoaded", function () {
  // Create a new scanner instance using the video element with id "preview"
  let scanner = new Instascan.Scanner({ video: document.getElementById("preview") });

  // When a QR code is scanned...
  scanner.addListener("scan", function (content) {
    // Expecting QR code format: "uid,hash"
    let [uid, hash] = content.split(",");

    // (Optional) You could validate the hash here against your own secret.

    // Send the uid via POST request using fetch API
    fetch("/admin/checkin", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ uid: uid })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert(data.message);
      } else {
        alert(data.message || "Check-in failed!");
      }
    })
    .catch(error => console.error("Error:", error));
  });

  // Get available cameras and start the scanner with the first available one
  Instascan.Camera.getCameras()
    .then(function (cameras) {
      if (cameras.length > 0) {
        scanner.start(cameras[0]);
      } else {
        console.error("No cameras found.");
      }
    })
    .catch(function (e) {
      console.error(e);
    });
});
