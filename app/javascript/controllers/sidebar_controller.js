import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.updateMobileSidebarToggle()
    window.addEventListener('resize', this.updateMobileSidebarToggle.bind(this))
    document.addEventListener('click', this.handleOutsideClick.bind(this))
  }

  updateMobileSidebarToggle() {
    const sidebar = document.getElementById("sidebar")
    const btn = document.getElementById('mobileSidebarToggle')
    const closeBtn = document.getElementById('mobileSidebarClose')
    if (!btn || !closeBtn) return

    if (window.innerWidth < 768) {
      btn.style.display = 'inline-flex'
    } else {
      btn.style.display = 'none'
      closeBtn.style.display = 'none'
      sidebar?.classList.remove('expanded')
      document.body.classList.remove('sidebar-open')
    }
  }

  toggleSidebar() {
    const sidebar = document.getElementById("sidebar")
    const sidebarCloseBtn = document.getElementById("mobileSidebarClose")
    const mobileSidebarToggle = document.getElementById("mobileSidebarToggle")
    sidebar.classList.toggle('expanded')
    if (sidebar.classList.contains('expanded')) {
      document.body.classList.add('sidebar-open')
      mobileSidebarToggle.style.display = 'none'
      sidebarCloseBtn.style.display = 'inline-flex'
    } else {
      document.body.classList.remove('sidebar-open')
      sidebarCloseBtn.style.display = 'none'
      mobileSidebarToggle.style.display = 'inline-flex'
    }
  }

  closeSidebar() {
    const sidebar = document.getElementById("sidebar")
    const sidebarCloseBtn = document.getElementById("mobileSidebarClose")
    const sidebarToggleBtn = document.getElementById("mobileSidebarToggle")
    sidebar.classList.remove('expanded')
    document.body.classList.remove('sidebar-open')
    sidebarCloseBtn.style.display = 'none'
    sidebarToggleBtn.style.display = 'inline-flex'
  }

  handleOutsideClick(e) {
    const sidebar = document.getElementById("sidebar")
    const sidebarCloseBtn = document.getElementById("mobileSidebarClose")
    const sidebarToggleBtn = document.getElementById("mobileSidebarToggle")
    if (window.innerWidth >= 768) return
    if (!sidebar.classList.contains('expanded')) return

    if (
      !sidebar.contains(e.target) &&
      e.target !== sidebarToggleBtn && !sidebarToggleBtn.contains(e.target) &&
      e.target !== sidebarCloseBtn && !sidebarCloseBtn.contains(e.target)
    ) {
      this.closeSidebar()
    }
  }
}