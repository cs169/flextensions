Given(/^I am using the "(light|dark|auto)" theme$/) do |theme|
  # Change the theme using JavaScript
  case theme
  when 'light'
    page.execute_script("document.documentElement.setAttribute('data-bs-theme', 'light'); localStorage.setItem('theme', 'light');")
  when 'dark'
    page.execute_script("document.documentElement.setAttribute('data-bs-theme', 'dark'); localStorage.setItem('theme', 'dark');")
  when 'auto'
    page.execute_script("document.documentElement.setAttribute('data-bs-theme', window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'); localStorage.setItem('theme', 'auto');")
  end
  
  # Wait a moment for the theme to apply
  sleep 0.5
  
  # Verify that the theme was applied correctly
  current_theme = page.evaluate_script("document.documentElement.getAttribute('data-bs-theme')")
  puts "Current theme set to: #{current_theme}"
  
  if theme != 'auto'
    expect(current_theme).to eq(theme)
  end
end 