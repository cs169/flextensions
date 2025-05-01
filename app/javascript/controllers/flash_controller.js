import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { }    // no values needed here

  connect() {
    const match = document.cookie.match(/(?:^|;\s*)js_flash=([^;]*)/)
    if (match) {
      try {
        const decoded = decodeURIComponent(match[1])
        const { type, message } = JSON.parse(decoded)
        this.show(type, message)
      } catch (e) {
        console.error("Invalid flash cookie:", e)
      }
      // Clear the cookie
      document.cookie = "js_flash=; Max-Age=0; path=/"
    }

    window.addEventListener("flash", (e) => {
      this.show(e.detail.type, e.detail.message)
    })
  }

  show(type, message) {
    const container = this.element
    const bsClass =
      type === "notice" ? "alert-success"
      : type === "alert"  ? "alert-danger"
      :                     "alert-info"

    // wrap in a full-width row if you want
    const wrapper = document.createElement("div")
    wrapper.className = "col-12"
    wrapper.innerHTML = `
      <div class="alert ${bsClass} alert-dismissible fade show" role="alert">
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    `
    container.appendChild(wrapper)
  }
}

// Global helper to shortcut firing the flash controller:
window.flash = (type, message) => {
  const payload = encodeURIComponent(JSON.stringify({ type, message }))
  document.cookie = `js_flash=${payload}; path=/`
}