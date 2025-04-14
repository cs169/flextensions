Given(/^I am using the "(light|dark|auto)" theme$/) do |theme|
  # Open the theme dropdown menu
  find('.testid-theme-dropdown').click
  sleep 0.5

  # Click on the appropriate theme option
  case theme
  when 'light'
    find('.testid-theme-light').click
  when 'dark'
    find('.testid-theme-dark').click
  when 'auto'
    find('.testid-theme-auto').click
  end

  sleep 0.5
  # Verify
  current_theme = page.evaluate_script("document.documentElement.getAttribute('data-bs-theme')")

  expect(current_theme).to eq(theme) if theme != 'auto'
end
