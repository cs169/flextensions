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

## Writing Tests

> [!NOTE]
> Many of the tests do not currently follow these patterns...

**Avoid directly creating objects in your tests. Instead, use factories or fixtures to set up your test data.**

* Both Cucumber and Rspec have already seeded the database, with required models.
* Rspec specs and Cucumber features are each run within a transaction.

## Stuff Missing Tests

* We need more direct coverage for CanvasFacade, GradescopeFacade and the Gradescope API Client.

## Working with Factories

```rb
  let(:course) { create(:course, :with_staff, course_name: 'Test Course', canvas_id: '456', course_code: 'TST101') }
```

* Use `traits` or nested factories to create all necessary associations and attributes, like enrolling users in courses.
* You can then use `course.users`, `course.students`, etc. to access associated users.
   * Or, if those methods do not exist, it might be a good idea to add them to the app.
