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

Flextensions is designed specifically for the UC Berkeley academic environment. It integrates directly with bCourses and provides a seamless way for instructors and students to manage and track assignment extensions.


---


## Documentation
Our documentation provides detailed instructions on how to set up, use, and contribute to Flextensions.
For the full documentation, visit the public **[Flextensions Docs](https://berkeley-cdss.github.io/flextensions)**. (Or read `/docs/` in this repository.)

Below are the key resources available:
- **[Developer Resources](https://berkeley-cdss.github.io/flextensions/developers)**: Information on environment variables, database setup, and deployment.
- **[Instructor Guide](https://berkeley-cdss.github.io/flextensions/instructors)**: A comprehensive guide for instructors on how to use Flextensions.
- **[Student Guide](https://berkeley-cdss.github.io/flextensions/students)**: A comprehensive guide for students on how to use Flextensions.
- **[API Documentation](https://github.com/saasbook/esaas-swagger)**: Details on the APIs used for integration with bCourses (Canvas).

---

## Features

### For Course Staff:
- View and manage extension requests for all assignments in your course
- Grant extensions to students with a few clicks
- Monitor extension usage across your course
- Automate approving extension requests and sending email notifications

### For Students:
- View all your granted extensions in one place
- See how long your extension lasts and when the new due date is
- Stay informed and organized without checking multiple systems

---

## How It Works

Flextensions connects directly with bCourses (Canvas) and imports your assignments. The interface is intuitive and role-based—course staff can grant and manage, while students can view.

---

# Configuration

Please see `.env.example` for the environment variables that need to be set up for Flextensions to run. You can copy this file to `.env` and fill in the required values.

## Canvas Scoped Keys

This deserves brief special mention. You must keep the Canvas API configuration (in Canvas) in sync with the list of scopes defined in the CanvasFacade. If you need to add a new scope, you will need to update the Canvas API configuration in the Canvas Developer Keys section **and will need to coordinate with the bCourses team to ensure the new scope is approved and turned on before deploying it to production**.

## Citing Flextensions

Cite the software itself using the following DOI:

https://doi.org/10.5281/zenodo.17246291

References:

```
# IEEE
[1]M. Ball, “Flextensions”. Zenodo, Aug. 20, 2025. doi: 10.5281/zenodo.17246291.
# APA
Ball, M., Fox, A., Yan, L., huanger2, Yaman Tarakji, Tashrique Ahmed, Connor, Jerry, Cynthia Xinyi Li, Tianye Meng, Peter Tran, Dana Kim, andypumpkineater, Evan Kandell, dg-ucb, Sepehr Behmanesh, felder, & Zee Babar. (2025). Flextensions. Zenodo.
https://doi.org/10.5281/zenodo.17246291
```
