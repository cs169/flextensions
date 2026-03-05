---
title: Flextensions for Instructors
permalink: /instructors/
---

# Setting Up Flextensions for Instructors

This guide will get you started with using Flextensions as an instructor.
When you're ready, view the [integration guide](/flextensions/integrations).

## Importing a Course

After logging into Flextensions, navigate to the **Courses** page.

1. Click **Import courses from Canvas** to view the list of Canvas courses you’re associated with.

   > If you are not already listed as an instructor and need to import a course, click the blue link text under "If you are an instructor, import a course" to access the import interface.
   > [https://flextensions.berkeley.edu/courses/new](https://flextensions.berkeley.edu/courses/new)

2. On the **Import Courses** page, toggle the switch on the left for each course you'd like to import.

3. Click **Import Selected Courses** to finalize the process.
   > Courses you are enrolled in but do not have permissions to manage will appear at the bottom for reference only.

## Course Assignments

On the **Courses** page, click a blue course name (e.g., **CS 161**, **CS 168**) to access that course’s management dashboard.

### Syncing Assignments

If you have added new assignments in Canvas, you can click **Sync Assignments** to import the latest assignments from Canvas into Flextensions.

### Enabling Assignments

To allow students to request extensions for an assignment, toggle the **Enable** switch on the right side of that assignment’s row.

> 📝 If the course itself is not yet enabled, a warning banner will appear. You must first enable the course under **Course Settings** before students can access it.

## Course Extension Requests

Navigate to the **Requests** tab in the left sidebar to review and manage all extension requests.

### Viewing Extension Requests

Click **View** next to any request to access its full details.

#### Editing Extension Requests

1. Click **View** on the Requests page.
2. In the Extension Request Details page, click **Edit Request**.
3. Update the **Requested Due Date** or select a new date from the date picker.
4. Optionally revise the **Reason for Extension** field.
5. The system will auto-calculate the number of extension days.
6. Click **Update Request** to save changes.

## Approving or Denying Requests

You can respond to requests in two ways:

**Method 1: Requests Overview Page**
1. Go to the **Requests** tab.
2. Locate a pending request.
3. Click the green **Approve** or red **Reject** button in the Actions column.

**Method 2: Extension Request Details Page**
1. Click **View** next to a request.
2. Review assignment details and student’s explanation.
3. Click **Approve** or **Reject** at the bottom.
4. The request status will update in real time.

## Viewing Request History
To view all requests made in the course, click the **View all Requests** button at the top left.

# Course Enrollments

The **Enrollments** tab shows all instructors and students currently associated with the course, including their names, student IDs, email addresses, and roles.

## Syncing Enrollments

1. Navigate to the **Enrollments** tab.
2. Click **Sync Enrollments** to pull the latest enrollment data from Canvas.

The list will refresh with updated data, including new students and instructors, and will remove users no longer in the course.

> [!NOTE]
> ⚠️ If if a student is added to the course after you have already imported a course, you will need to sync the course enrollments to ensure they are able to access the Flextensions course.

## Filtering Student Requests
By clicking the name of a student in the **Enrollments** tab, you can filter the requests to only show those made by that student. This is useful for quickly reviewing all requests from a specific student.

# Course General Settings

The **Settings** tab lets you define how your course handles extension requests.

## Auto-approval Settings

Control when and how requests are automatically approved:

- **Auto-approve within days**
  Automatically approves requests made within the specified number of days before the assignment due date. Leave blank to disable.

<!-- - **Auto-approve within days (DSP)**
  Applies a similar rule specifically to students with a DSP accommodation flag. -->

- **Maximum requests to auto-approve**
  Sets a per-student limit on auto-approved requests. Use `0` for no limit.

After setting these options, click **Save Settings** to save.

### Extendate Late Due Date Automatically

_This setting is enabled by default._

When enabled, the late due date will be automatically extended by the same amount of time as the original extension when an extension is granted. This setting can be toggled on or off by instructors.

If you use "Slip Days" or otherwise accept late submissions you can enable this, so students who go beyond their extnded due date will have the option to submit late work until the late due date.

You may wish to disable this if you do not want students to have the option to submit late work, or if you set the late due date to a very distant date (e.g., end of semester) and do not want it to be extended further.

If you do not set late due dates (assignment close date in Canvas), this setting will have no effect.

## Gradescope Integration

If you use Gradescope for grading, you can integrate it with Flextensions to automatically sync extension data.

* You must invite the user `gradescope-bot@berkeley.edu` as a TA (or Reader) in your Gradescope course to enable this integration.
* Paste the URL of your Gradescope course into the **Gradescope Course URL** field in the Settings tab.
* Click **Save Settings** to enable the integration.
* Sync assignments to pull in the latest data from Gradescope.

## Course Email Settings

The **Email Settings** section (under Settings) controls how students receive notifications about their extension requests.

### Course Email Setup

Enable or disable email notifications as needed. When enabled, Flextensions sends students an email when their request is approved or denied.

You can specify a **Course Reply Email Address** for outgoing emails. This will be used as the "reply-to" address if students respond to notification emails.

💡 Ensure this address is monitored regularly by course staff.

After setting these options, click **Save Settings** to save.

### Email Template Customization

In the **Email Settings** tab, you can customize:

- Subject line
- Email body

Use provided dynamic variables to personalize each email.

**Available Variables**:

- **Student Information**
  `{{student_name}}, {{student_email}}, {{student_id}}`

- **Course Information**
  `{{course_name}}, {{course_code}}, {{assignment_name}}`

- **Extension Information**
  `{{original_due_date}}, {{new_due_date}}, {{extension_days}}, {{status}}`

Click **Reset to Default** to restore the system default template.

## Course Extension Request Form

Use the **Form** tab to customize the student request form.
> The following options are required fields and cannot be removed:
> Assignment Name, Requested Due Date, Reason for Extension.

### Writing Custom Descriptions

You can provide custom description text for:

- **Why do you need this extension?**
- **Additional Documentation**

These appear directly on the form and help guide student responses.

### Creating Custom Questions

You can add up to **two additional questions** to gather more context:

- **Title**: The main question shown to students.
- **Description**: Additional clarification or instructions.

### Setting Question Display

Each custom question as well as the **Additional Documentation** question can be configured to be:

- **Hidden**: Not shown on the form
- **Optional**: Shown but not required
- **Required**: Must be answered to submit the form

Once configured, click **Update** at the bottom of the page to save your settings.

---

## [Integration Guide](/integrations)

Flextensions supports integrations with:

* Slack Webhooks
* Google Sheets
* Gradescope (coming soon!)

---

# Deleting a Course
To delete a course, navigate to the **Settings** tab and scroll to the bottom of the page. Click **Delete Course**. This option is only available when student extension requests are not enabled for the course.

> ⚠️ Deleting a course is permanent and cannot be undone. All data associated with the course will be lost.
