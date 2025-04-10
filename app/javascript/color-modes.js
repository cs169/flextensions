/*!
 * Color mode toggler for Bootstrap's docs (https://getbootstrap.com/)
 * Copyright 2011-2023 The Bootstrap Authors
 * Licensed under the Creative Commons Attribution 3.0 Unported License.
 */

(() => {
  'use strict'

  const getStoredTheme = () => localStorage.getItem('theme')
  
  const setStoredTheme = (theme) => localStorage.setItem('theme', theme)

  const getPreferredTheme = () => {
    const storedTheme = getStoredTheme()
    if (storedTheme) {
      return storedTheme
    }

    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  }

  const setTheme = (theme) => {
    if (theme === 'auto') {
      document.documentElement.setAttribute('data-bs-theme', 
        window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    } else {
      document.documentElement.setAttribute('data-bs-theme', theme)
    }
  }

  // Set theme on page load
  setTheme(getPreferredTheme())

  const showActiveTheme = (theme, focus = false) => {
    const themeSwitcher = document.querySelector('#bd-theme')
    const themeSwitcherText = document.querySelector('#bd-theme-text')
    
    if (!themeSwitcher) {
      return
    }
    
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

  // Update the active theme indicator based on the current theme
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
    const storedTheme = getStoredTheme()
    if (storedTheme !== 'light' && storedTheme !== 'dark') {
      setTheme(getPreferredTheme())
    }
  })

  // Initialize theme and handle theme toggle button click
  const initializeTheme = () => {
    // Show the active theme in UI
    showActiveTheme(getPreferredTheme())
    
    // Add event handlers for theme toggle buttons
    document.querySelectorAll('[data-bs-theme-value]').forEach(toggle => {
      toggle.addEventListener('click', (event) => {
        event.preventDefault()
        const theme = toggle.getAttribute('data-bs-theme-value')
        setStoredTheme(theme)
        setTheme(theme)
        showActiveTheme(theme, true)
      })
    })
    
    // Handle dropdown open without changing the theme
    const dropdown = document.querySelector('#bd-theme')
    if (dropdown) {
      dropdown.addEventListener('click', (event) => {
        if (!event.target.closest('[data-bs-theme-value]')) {
          // Only show current theme, don't change it
          event.preventDefault()
          event.stopPropagation()
          showActiveTheme(getPreferredTheme(), false)
        }
      })
    }
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
