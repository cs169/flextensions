---
title: Flextensions for Instructors
permalink: /instructors/
---

## Importing a Course
After login to the Flextensions, in courses page:

1. Click **Import courses from canvas**.
![image](https://github.com/user-attachments/assets/064c49d0-b746-4bc5-86de-805c8dc5b71d)
> If you are not already an instructor in a Course and need to import a Course, click the blue text in "If you are an instructor, import a course" to be redirected to the Import Courses page.


2. On the new page, toggle the switch on the left of any Canvas course you'd like to import.
![image](https://github.com/user-attachments/assets/ea821e4d-cde3-40e3-badb-744874774d46)

3. Click **Import Selected Courses** to complete the import.
  >⚠️ Courses you are enrolled in but cannot set up extensions for will be listed at the
  >bottom of the page for reference.
## Course Assignments
On the course page, Click on the blue course name links (e.g., CS 161, CS 168) to access the management page for each course.

![image](https://github.com/user-attachments/assets/3b0c10c8-1fdb-4188-a5b8-b1e215eb7efc)

### Syncing Assignments
Click "**Sync Assignments**" to sync all assignments from bourses
### Enabling Assignments
To make an assignment visible to students for extension requests, toggle the **Enable switch** on the right side of the assignment row.
  >📝 If the course is still disabled, you will see a warning banner. You must first
  >enable the course in **Course Settings** to allow students access.
## Course Extension Requests
Navigate to **Requests** tab in the left sidebar to manage or review your extension requests.
### Viewing Extension Requests
Click **View** next to a request to open the Extension Request Details page.
### Editing Extension Requests
1. Click **View** on the Requests page;
2. On the Extension Request Details page, click **Edit Request**.
3. In the Requested Due Date field, enter the new due date or select it from the date picker.
4. Update the Reason for Extension by editing the text in the corresponding text box.
5. Review the Number of Days field (calculated automatically based on the new due date).
6. Click **Update Request** to save your changes, or **Cancel** to discard them.
### Approving/Denying Extension Requests
As an instructor, you can approve or deny extension requests through either of the following methods:
**Method 1: From the Requests Overview Page**
1. Navigate to the Requests tab in the left sidebar.
2. Locate the request in the table.
3. In the Actions column, click Approve (green button) or Reject (red button) to respond immediately.

**Method 2: From the Request Details Page**
1.On the Requests overview page, click the View button next to the request.
2. On the Extension Request Details page, review the assignment information, requested due date, and reason.
3. Click Approve or Reject at the bottom of the page.
4. Once a decision is made, the status of the request will update accordingly.

## Course Enrollments
The Enrollments tab displays the list of all students and instructors currently associated with the course, including their names, student IDs, email addresses, and roles.
### Syncing Enrollments
To sync the enrollment list with the official course roster:

1. Navigate to the Enrollments tab in the left sidebar.

2. Click the Sync Enrollments button located at the bottom of the page.

The system will fetch the most up-to-date enrollment data and update the list accordingly.
This feature ensures that any newly added students or instructors are reflected in the course, and any removed users are no longer shown.
## Course General Settings
The Settings tab allows instructors to configure course-wide policies for extension requests, including enabling requests, setting auto-approval conditions, and managing notification preferences.
### Auto-approval Settings
Instructors can control how and when extension requests are automatically approved using the following options:
- **Auto approve within days**
  &nbsp;&nbsp;Automatically approves requests made within the specified number of days before the original due date. Leave blank to disable auto-approval.
  >Note:
- **Auto approve within days (DSP)**
  &nbsp;&nbsp;(For students with a DSP accommodation.) Similar to the setting above, but applied specifically to DSP-tagged students.
  >Note:
- **Maximum requests to auto approve**
  &nbsp;&nbsp;Sets a per-student limit on how many extension requests can be auto-approved for the course.
Enter ``0`` to allow unlimited auto-approved requests.
## Course Email Settings
   The **Email Settings** tab in **Settings** page allows instructors to configure how Flextensions sends email notifications related to extension requests. This includes specifying a reply-to address and customizing the content of email templates.

![image](https://github.com/user-attachments/assets/ce960eae-b893-48b6-abbd-d47a9f551f70)

### Course Email Setup
Instructors can choose to enable or disable email notifications.
When enabled, Flextensions will automatically send an email to students when their extension request is approved or denied.

You can also enter a Course Reply Email Address, which will be used as the "reply-to" address in outgoing emails. Students can respond to this address if they have questions about their request.

💡 Make sure the email address you provide is valid and monitored by your course staff.
### Email template Setup
Click **Email Settings** tab and you can customize both the subject line and email body of the messages sent to students. Use the dynamic variables provided to include personalized content such as student names, assignment titles, and status.

![image](https://github.com/user-attachments/assets/c9f71461-946a-4971-9263-c0e6adc7c0dc)

Available variables include:
- **Student Information**
```{{student_name}}, {{student_email}}, {{student_id}}```
- **Course Information**
```{{course_name}}, {{course_code}}, {{assignment_name}}```
- **Extension Information**
```{{original_due_date}}, {{new_due_date}}, {{extension_days}}, {{status}}```
Click **Reset to Default** to restore the original system template if needed.
## Course Extension Request Form
The **Form** tab allows instructors to customize the extension request form that students will use. You can add clarifying descriptions, request additional documentation, or define your own questions.
### Writing Custom Descriptions
You can also provide a **Custom Description** for the following sections:
- **Why do you need this extension?**
- **Additional Documentation**
The custom descriptions are shown directly on the form and help clarify what kind of response is expected. For example, you may want to include a note like:
>“Please do not include any personal health or disability related details. If you have >questions, contact the course staff before submitting.”
This helps ensure students provide appropriate and relevant information while maintaining privacy.
### Creating Custom Questions
Instructors may define up to two additional custom questions (labeled Additional Question 1 and Additional Question 2). Each question includes:
- A **Title** field, which acts as the prompt shown to students.
- A **Description** field, which provides more context or instructions for the question.
These fields are optional and allow for flexibility in gathering course-specific information (e.g., "What steps have you already taken to complete the assignment?" or "Have you communicated with your TA?").
### Setting Question Display
Each section (including the custom questions and additional documentation) can be shown or hidden using the Display dropdown. The available options are:
- *Hidden*- The section will not appear on the student form.
- *(Other options like "Required" or "Optional" may be available depending on the implementation.)*

After configuring your custom questions and visibility settings, click the **Update** button at the bottom of the page to save your changes.
