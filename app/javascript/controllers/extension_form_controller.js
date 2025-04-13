import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="extension-form"
export default class extends Controller {
  static targets = ["daysDisplay", "dueDateInput", "assignmentSelect"]

  connect() {
    this.originalDueDateStr = this.dueDateInputTarget.dataset.originalDueDate
    this.originalDueDate = new Date(this.originalDueDateStr?.split(" at ")[0])

    if (this.originalDueDateStr) {
      const minDate = new Date(this.originalDueDateStr.split(" at ")[0])
      minDate.setDate(minDate.getDate() + 1)
      this.dueDateInputTarget.min = this._toDateString(minDate)
      this.dueDateInputTarget.value = this._toDateString(minDate)

      const currentDueDate = new Date(this.dueDateInputTarget.value)
      if (currentDueDate < minDate) {
        this.dueDateInputTarget.value = this._toDateString(minDate)
      }

      this._updateDays()
    }

    this.dueDateInputTarget.addEventListener("input", () => this._updateDays())
    this.assignmentSelectTarget.addEventListener("change", () => this.updateAssignment())
  }

  _updateDays() {
    const newDueDate = new Date(this.dueDateInputTarget.value)
    const diffTime = newDueDate - this.originalDueDate
    const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24))
    this.daysDisplayTarget.textContent = isNaN(diffDays) ? '' : Math.max(0, diffDays)
  }

  updateAssignment() {
    const selectedOption = this.assignmentSelectTarget.selectedOptions[0]
    const newOriginalDueDate = selectedOption.dataset.originalDueDate
    const newLateDueDate = selectedOption.dataset.originalLateDueDate
  
    if (newOriginalDueDate) {
      const minDate = new Date(newOriginalDueDate.split(" at ")[0])
      minDate.setDate(minDate.getDate() + 1)
  
      this.dueDateInputTarget.min = this._toDateString(minDate)
      this.dueDateInputTarget.value = this._toDateString(minDate)
  
      this.dueDateInputTarget.dataset.originalDueDate = newOriginalDueDate
      this.originalDueDate = new Date(newOriginalDueDate.split(" at ")[0])
  
      this._updateDays()
  
      document.getElementById("due-date").textContent = newOriginalDueDate || ''
      document.getElementById("late-due-date").textContent = newLateDueDate || ''
    }
  }

  _toDateString(date) {
    return date.toISOString().split("T")[0]
  }
}