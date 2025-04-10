/*!
 * Color mode toggler for Bootstrap's docs (https://getbootstrap.com/)
 * Copyright 2011-2023 The Bootstrap Authors
 * Licensed under the Creative Commons Attribution 3.0 Unported License.
 */

(() => {
  'use strict'

  const getStoredTheme = () => localStorage.getItem('theme') || 'light'
  
  const setStoredTheme = (theme) => localStorage.setItem('theme', theme)

  const getPreferredTheme = () => {
    // Always default to light mode
    const storedTheme = getStoredTheme()
    if (storedTheme) {
      return storedTheme
    }

    // Default to light
    return 'light'
  }

  const setTheme = (theme) => {
    if (theme === 'auto') {
      document.documentElement.setAttribute('data-bs-theme', 'light')
    } else {
      document.documentElement.setAttribute('data-bs-theme', theme)
    }
  }

  const showActiveTheme = (theme, focus = false) => {
    const themeSwitcher = document.querySelector('#bd-theme')
    
    if (!themeSwitcher) {
      return
    }
    
    const themeSwitcherText = document.querySelector('#bd-theme-text')
    const activeThemeIcon = document.querySelector('.theme-icon-active use')
    const btnToActive = document.querySelector(`[data-bs-theme-value="${theme}"]`)
    
    // Add null check before accessing the svg use attribute
    let svgOfActiveBtn = ''
    if (btnToActive && btnToActive.querySelector('svg use')) {
      svgOfActiveBtn = btnToActive.querySelector('svg use').getAttribute('href')
    }

    document.querySelectorAll('[data-bs-theme-value]').forEach(element => {
      element.classList.remove('active')
      element.setAttribute('aria-pressed', 'false')
    })
    
    if (btnToActive) {
      btnToActive.classList.add('active')
      btnToActive.setAttribute('aria-pressed', 'true')
    }
    
    if (activeThemeIcon) {
      activeThemeIcon.setAttribute('href', svgOfActiveBtn)
    }
    
    const themeSwitcherLabel = `${themeSwitcherText ? themeSwitcherText.textContent : 'Toggle theme'} (${btnToActive ? btnToActive.dataset.bsThemeValue : theme})`
    
    if (themeSwitcher) {
      themeSwitcher.setAttribute('aria-label', themeSwitcherLabel)
    }

    if (focus && themeSwitcher) {
      themeSwitcher.focus()
    }
  }

  // Initialize theme
  const initializeTheme = () => {
    const theme = getPreferredTheme()
    const themeSwitcherText = document.querySelector('#bd-theme-text')
    
    // Set theme on page load
    setTheme(theme)
    
    // Show active theme in UI
    showActiveTheme(theme)
    
    // Add event listeners to theme toggle buttons
    document.querySelectorAll('[data-bs-theme-value]')
      .forEach(toggle => {
        toggle.addEventListener('click', () => {
          const theme = toggle.getAttribute('data-bs-theme-value')
          setStoredTheme(theme)
          setTheme(theme)
          showActiveTheme(theme, true)
        })
      })
  }

  // Initialize theme on DOMContentLoaded
  window.addEventListener('DOMContentLoaded', () => {
    initializeTheme()
  })
  
  // For Turbo compatibility (Rails 7)
  document.addEventListener('turbo:load', () => {
    initializeTheme()
  })
  
  // Re-initialize when Turbo navigates to a new page
  document.addEventListener('turbo:render', () => {
    initializeTheme()
  })
  
  // Backup for older Turbolinks
  document.addEventListener('turbolinks:load', () => {
    initializeTheme()
  })
})()
