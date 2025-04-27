import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assignment"
export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    this.checkboxTargets.forEach((checkbox) => {
      checkbox.addEventListener("change", (event) => this.toggleAssignment(event, checkbox))
    })
  }

  async toggleAssignment(event, checkbox) {
    const assignmentId = checkbox.dataset.assignmentId;
    const url = checkbox.dataset.url;
    const enabled = checkbox.checked;

    try {
      const token = document.querySelector('meta[name="csrf-token"]').content;

      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token,
        },
        body: JSON.stringify({ enabled: enabled }),
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
}