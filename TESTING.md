# Testing Guide for Flextensions

| Test Type | Command |
|-----------|---------|
| RSpec Tests (no a11y) | `bundle exec rspec --tag '~a11y'` |
| Cucumber Tests (no a11y) | `bundle exec cucumber --tags 'not @a11y and not @skip'` |
| All Regular Tests | `bundle exec rspec --tag '~a11y' && bundle exec cucumber --tags 'not @a11y and not @skip'` |
| Accessibility Tests (RSpec) | `bundle exec rspec --tag a11y` |
| Accessibility Tests (Cucumber) | `bundle exec cucumber --tags @a11y` |
| All Tests (including a11y) | `bundle exec rspec && bundle exec cucumber --tags 'not @skip'` |
| Lint Code (RuboCop) | `bundle exec rubocop` |
| Auto-fix Lint Issues | `bundle exec rubocop -A` |
| Validate Swagger API | `npx @redocly/cli lint app/assets/swagger/swagger.json --extends=minimal` |
