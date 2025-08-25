---
title: Integrating Flextensions
permalink: /integrations/
---

# Integrating Flextensions with Your Tools

Flextensions, of course, already integrates with Canvas. However, you may want to connect it with other tools you use to manage your course.

## Slack

Flextensions can be integrated with Slack to provide real-time notifications and updates. This allows instructors and students to stay informed about important events, such as assignment due dates and extension requests.

### Setting Up Slack Integration

Flextensions uses a Slack Webhook to send notifications to your Slack workspace, which are sent whenever there is a new extension request or an update to an existing request, including showing whether they are auto-approved.

**In Slack**

1. Go to your Slack workspace and navigate to **Apps**.
2. Search for and select **Incoming WebHooks**.
3. Click **Add to Slack**.
4. Choose the channel where you want to receive notifications and click **Add Incoming WebHooks integration**.
5. Copy the Webhook URL provided.

**In Flextensions**

1. Navigate to the **Settings** tab.
2. Click on **Slack Integration**.
3. Paste the Webhook URL into the provided field.
4. Click **Save** to enable Slack notifications.
