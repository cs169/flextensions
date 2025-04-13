import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      const closeButton = this.element.querySelector('.btn-close')
      if (closeButton) {
        closeButton.click()
      }
    }, 3000) // 3 seconds
  }
}