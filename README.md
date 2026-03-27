# [Flextensions](https://flextensions.berkeley.edu)
---

[![Maintainability](https://qlty.sh/gh/berkeley-cdss/projects/flextensions/maintainability.svg)](https://qlty.sh/gh/berkeley-cdss/projects/flextensions) •
[![Code Coverage](https://qlty.sh/gh/berkeley-cdss/projects/flextensions/coverage.svg)](https://qlty.sh/gh/berkeley-cdss/projects/flextensions) •
[![RSpec Tests](https://github.com/berkeley-cdss/flextensions/actions/workflows/rspec.yml/badge.svg)](https://github.com/berkeley-cdss/flextensions/actions/workflows/rspec.yml) •
[![Cucumber Tests](https://github.com/berkeley-cdss/flextensions/actions/workflows/cucumber.yml/badge.svg)](https://github.com/berkeley-cdss/flextensions/actions/workflows/cucumber.yml) •
[![Accessibility Tests](https://github.com/berkeley-cdss/flextensions/actions/workflows/a11y.yml/badge.svg)](https://github.com/berkeley-cdss/flextensions/actions/workflows/a11y.yml) •
[![RuboCop](https://github.com/berkeley-cdss/flextensions/actions/workflows/rubocop.yml/badge.svg)](https://github.com/berkeley-cdss/flextensions/actions/workflows/rubocop.yml) • [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.17246291.svg)](https://doi.org/10.5281/zenodo.17246291)

---

## [cs169/flextensions](https://github.com/cs169/flextensions)
[![Maintainability](https://api.codeclimate.com/v1/badges/8d99ec9a1784ddba34ac/maintainability)](https://codeclimate.com/github/cs169/flextensions/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8d99ec9a1784ddba34ac/test_coverage)](https://codeclimate.com/github/cs169/flextensions/test_coverage)
[![All Specs](https://github.com/cs169/flextensions/actions/workflows/main.yml/badge.svg)](https://github.com/cs169/flextensions/actions/workflows/main.yml)
[![Accessibility Tests](https://github.com/cs169/flextensions/actions/workflows/a11y.yml/badge.svg)](https://github.com/cs169/flextensions/actions/workflows/a11y.yml)
[![RuboCop](https://github.com/cs169/flextensions/actions/workflows/rubocop.yml/badge.svg)](https://github.com/cs169/flextensions/actions/workflows/rubocop.yml)

---
### **Flextensions** is a web application built for UC Berkeley students and course staff to manage assignment extensions across all their bCourses (Canvas) courses.
#### To use Flextensions, visit [https://flextensions.berkeley.edu](https://flextensions.berkeley.edu).


---

## Made for UC Berkeley By UC Berkeley
Flextensions is a project developed by the UC Berkeley Computer Science 169L course (Software Engineering). The goal of Flextensions is to provide a user-friendly interface for managing assignment extensions, making it easier for both students and instructors to keep track of deadlines and extensions.
The project is open-source and available on GitHub, allowing for contributions and improvements from the community. The Flextensions team consists of students from the course, who have worked together to design, develop, and deploy the application.

Flextensions is designed specifically for the UC Berk

## Getting Started

1. **Clone the repository:** `git clone https://github.com/berkeley-cdss/flextensions.git`
2. **Install dependencies:** Run `bundle install` and `yarn install`.
3. **Database Setup:** Run `rails db:create db:migrate db:seed`.
4. **Environment Variables:** Create a `.env` file with your `CANVAS_API_KEY` and `CANVAS_URL`.
5. **Run the server:** Execute `rails server` and navigate to `localhost:3000`.