import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assignment"
export default class extends Controller {
  static targets = ["checkbox"]
  static values = { courseId: Number }

  connect() {
    this.checkboxTargets.forEach((checkbox) => {
      checkbox.addEventListener("change", (event) => this.toggleAssignment(event, checkbox))
    })
  }

  async toggleAssignment(event, checkbox) {
    const assignmentId = checkbox.dataset.assignmentId;
    const url = checkbox.dataset.url;
    const enabled = checkbox.checked;
    const role = checkbox.dataset.role; // Get the role
    const userId = checkbox.dataset.userId; // Get the user ID

    try {
      const token = document.querySelector('meta[name="csrf-token"]').content;

      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token,
        },
        body: JSON.stringify({
          enabled: enabled,
          role: role, // Pass the role
          user_id: userId, // Pass the user ID
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        if (data.redirect_to) {
          window.location.href = data.redirect_to;
          return;
        }
        throw new Error(data.error || 'Error updating assignment');
      }

      console.log(`Assignment ${assignmentId} enabled: ${enabled}`);
    } catch (error) {
      console.error("Error updating assignment:", error);
      checkbox.checked = !enabled; // rollback checkbox if error
    }
  }

  sync() {
    const courseId = this.courseIdValue;
    const token = document.querySelector('meta[name="csrf-token"]').content;
    fetch(`/courses/${courseId}/sync_assignments`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Failed to sync assignments.");
        }
        return response.json();
      })
      .then((data) => {
        alert(data.message || "Assignments synced successfully.");
        location.reload();
      })
      .catch((error) => {
        alert(error.message || "An error occurred while syncing assignments.");
      });
  }
}