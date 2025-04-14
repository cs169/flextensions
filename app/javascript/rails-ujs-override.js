import Rails from "@rails/ujs"
Rails.start()
window.Rails = Rails

Rails.confirm = function (message, element) {
  const modalEl = document.getElementById("confirmModal")
  // Instead of using "import * as bootstrap", we rely on the global bootstrap object.
  const modal = new window.bootstrap.Modal(modalEl)

  const title = modalEl.querySelector(".modal-title")
  const body = modalEl.querySelector(".modal-body")
  const confirmBtn = modalEl.querySelector("#confirmActionBtn")
  const cancelBtn = modalEl.querySelector("#cancelConfirmBtn")

  // Populate modal dynamically from data attributes
  title.textContent = element.getAttribute("data-confirm-title") || "Are you sure?"
  body.textContent = element.getAttribute("data-confirm-body") || message || "This action cannot be undone."
  confirmBtn.textContent = element.getAttribute("data-confirm-ok") || "Yes"
  cancelBtn.textContent = element.getAttribute("data-confirm-cancel") || "Cancel"

  confirmBtn.className = element.getAttribute("data-confirm-ok-class") || "btn btn-danger"
  cancelBtn.className = element.getAttribute("data-confirm-cancel-class") || "btn btn-secondary"

  // Remove existing listeners to avoid stacking
  const newConfirmBtn = confirmBtn.cloneNode(true)
  confirmBtn.replaceWith(newConfirmBtn)

  newConfirmBtn.addEventListener("click", function () {
    newConfirmBtn.blur()  // Remove focus before closing
    modal.hide()          // Hide modal
    element.removeAttribute("data-confirm")
    element.click()       // Trigger the original action
  })

  // This is to avoid: Blocked aria-hidden on an element because its descendant retained focus.
  // Attach a listener to the modal itself to blur any focused element
  // when the modal is being hidden (e.g. when clicking outside the modal).
  modalEl.addEventListener('hide.bs.modal', function () {
    if (modalEl.contains(document.activeElement)) {
      document.activeElement.blur();
    }
  });
  // Attach listener to cancel button as well
  cancelBtn.addEventListener("click", function () {
    cancelBtn.blur()  // Remove focus from cancel button
    modal.hide()      // Hide the modal
  })

  modal.show()
  return false // Prevent default Rails confirm
}

// Optionally, you can also keep your global listener as a fallback:
document.addEventListener('hidden.bs.modal', function (event) {
  if (event.target.contains(document.activeElement)) {
    document.activeElement.blur();
  }
});