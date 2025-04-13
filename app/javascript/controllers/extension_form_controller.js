import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="extension-form"
export default class extends Controller {
  static targets = ["daysDisplay", "dueDateInput", "assignmentSelect"]

  connect() {
    // Check if we're in update-only mode (e.g. in edit view)
    if (this.assignmentSelectTarget.dataset.updateOnly === "true") {
      // Get the original due date string either from data or from the input value.
      this.originalDueDateStr = this.dueDateInputTarget.dataset.originalDueDate || document.getElementById("edit-request-requested-due-date").value;
      // Expect the value in update-only mode to be in "YYYY-MM-DD" format.
      this.originalDueDate = new Date(this.originalDueDateStr);
      
      // Set the minimum requested date to be one day after the original due date.
      const minDate = new Date(this.originalDueDate);
      minDate.setDate(minDate.getDate() + 1);
      this.dueDateInputTarget.min = this._toDateString(minDate);
      // If the current input value is older than the minDate, update it.
      let currentDueDate = new Date(this.dueDateInputTarget.value);
      if (currentDueDate < minDate) {
        this.dueDateInputTarget.value = this._toDateString(minDate);
      }
      
      // Attach event listeners.
      this.dueDateInputTarget.addEventListener("input", () => this._updateDays());
      this.assignmentSelectTarget.addEventListener("change", () => this.updateAssignment());
      this._updateDays();
      return;
    } else {
      // Normal behavior for new view.
      this.originalDueDateStr = this.dueDateInputTarget.dataset.originalDueDate;
      if (this.originalDueDateStr && this.originalDueDateStr.includes(" at ")) {
        this.originalDueDate = new Date(this.originalDueDateStr.split(" at ")[0]);
      } else {
        this.originalDueDateStr = this.dueDateInputTarget.value;
        this.originalDueDate = new Date(this.originalDueDateStr);
      }
    }
  
    if (this.originalDueDateStr) {
      // In normal mode, add one day to set the minimum requested due date.
      const minDate = new Date(this.originalDueDateStr.split(" at ")[0]);
      minDate.setDate(minDate.getDate() + 1); // add one day
      this.dueDateInputTarget.min = this._toDateString(minDate);
      this.dueDateInputTarget.value = this._toDateString(minDate);
  
      // Ensure the input value is at least the min date.
      const currentDueDate = new Date(this.dueDateInputTarget.value);
      if (currentDueDate < minDate) {
        this.dueDateInputTarget.value = this._toDateString(minDate);
      }
  
      this._updateDays();
    }
  
    // Attach listeners for any further changes.
    this.dueDateInputTarget.addEventListener("input", () => this._updateDays());
    this.assignmentSelectTarget.addEventListener("change", () => this.updateAssignment());
  }

  // Public method so that the action "input->extension-form#updateDays" works.
  updateDays() {
    this._updateDays();
  }

  _updateDays() {
    const newDueDate = new Date(this.dueDateInputTarget.value);
    const diffTime = newDueDate - this.originalDueDate;
    const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24));
    this.daysDisplayTarget.textContent = isNaN(diffDays) ? '' : Math.max(0, diffDays);
  }

  updateAssignment() {
    const selectedOption = this.assignmentSelectTarget.selectedOptions[0];
    const newOriginalDueDate = selectedOption.dataset.originalDueDate;
    const newLateDueDate = selectedOption.dataset.originalLateDueDate;
  
    if (newOriginalDueDate) {
      const minDate = new Date(newOriginalDueDate.split(" at ")[0]);
      minDate.setDate(minDate.getDate() + 1);
  
      this.dueDateInputTarget.min = this._toDateString(minDate);
      this.dueDateInputTarget.value = this._toDateString(minDate);
  
      this.dueDateInputTarget.dataset.originalDueDate = newOriginalDueDate;
      this.originalDueDate = new Date(newOriginalDueDate.split(" at ")[0]);
  
      this._updateDays();
  
      document.getElementById("due-date").textContent = newOriginalDueDate || '';
      document.getElementById("late-due-date").textContent = newLateDueDate || '';
    }
  }

  _toDateString(date) {
    return date.toISOString().split("T")[0];
  }
}