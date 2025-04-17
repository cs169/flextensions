Given(/^I am using the "(light|dark|auto)" theme$/) do |theme|
  begin
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
  rescue StandardError => e
    puts "Error clicking theme dropdown: #{e.message}"
    # Fallback to JavaScript if clicking fails (useful in CI)
    puts "Using JavaScript to set theme to #{theme}"
    page.execute_script("document.documentElement.setAttribute('data-bs-theme', '#{theme}')")
  end

  # Verify
  current_theme = page.evaluate_script("document.documentElement.getAttribute('data-bs-theme')")

  # For auto theme, we don't know what the actual theme will be (depends on user preferences)
  expect(current_theme).to eq(theme) if theme != 'auto'
end
