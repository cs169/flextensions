# Testing Guide

## Running Tests Locally

| Test Type | Command | Description |
|-----------|---------|-------------|
| All RSpec Tests | `bundle exec rspec` | Run all RSpec tests |
| All Cucumber Tests | `bundle exec cucumber` | Run all Cucumber tests |
| Skip WIP/Skip Tests | `bundle exec rspec --tag "~skip" --tag "~wip"` | Run RSpec tests excluding skipped/WIP |
| Skip Cucumber Tests | `bundle exec cucumber --tags 'not @skip and not @wip'` | Run Cucumber tests excluding skipped/WIP |
| Accessibility Tests | `bundle exec rspec --tag a11y` | Run RSpec accessibility tests |
| Accessibility Features | `bundle exec cucumber --tags @a11y` | Run Cucumber accessibility features |
| Single RSpec File | `bundle exec rspec path/to/file_spec.rb` | Run specific RSpec test file |
| Single Feature | `bundle exec cucumber features/specific.feature` | Run specific Cucumber feature |
| With Coverage | `COVERAGE=true bundle exec rspec` | Run tests with SimpleCov coverage |

## Test Tags

- `@skip` or `:skip` - Skip this test
- `@wip` or `:wip` - Work in progress
- `@a11y` or `:a11y` - Accessibility test
- `@javascript` or `:js` - Requires JavaScript (uses Chrome)

## Coverage Report

After running tests with coverage, view the report at:
```
coverage/index.html
``` 