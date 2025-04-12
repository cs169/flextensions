document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".toggle-enabled-switch").forEach((switchElement) => {
    switchElement.addEventListener("change", function () {
      const assignmentId = this.getAttribute("data-assignment-id");
      const isChecked = this.checked;

      fetch(`/assignments/${assignmentId}/toggle_enabled`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
        body: JSON.stringify({ enabled: isChecked }),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error("Failed to update assignment status.");
          }
          return response.json();
        })
        .then((data) => {
          if (data.success) {
            alert(`Assignment ${isChecked ? "enabled" : "disabled"} successfully.`);
          } else {
            alert("An error occurred: " + data.error);
          }
        })
        .catch((error) => {
          alert(error.message || "An error occurred while updating the assignment.");
          this.checked = !isChecked; // Revert the toggle if the request fails
        });
    });
  });
});