# Experience Cloud: Dynamic Chat Button Control

A solution for dynamically showing/hiding messaging chat buttons in Salesforce Experience Cloud based on Flow execution results.

## Table of Contents

- [Overview](#overview)
- [Why This Solution](#why-this-solution)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Testing](#testing)
- [Files Included](#files-included)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

This solution provides a REST API that executes a Salesforce Flow and uses the boolean result to control chat button visibility across all Experience Cloud pages via head markup.

The included Flow (`Messaging_Button_Availability.xml`) is an example that checks agent availability in a queue and returns 'false' (hides button) if no agents are logged in. You'll need to modify it with your specific business logic for determining when the chat button should be visible.

## Why This Solution

**Common Challenge:** Experience Cloud sites need to dynamically show/hide messaging chat buttons based on:
- Agent availability
- Business hours
- Queue capacity
- Custom business logic

**This solution** provides a simple, centralized approach using head markup that works across all pages without per-page configuration.

## Features

- 🌐 **Global Coverage** - Works on all pages via head markup
- 🔧 **Centralized Logic** - Single Flow controls all business rules
- 💾 **Client Caching** - 2-minute cache reduces API calls
- 🔒 **Guest Compatible** - Works for unauthenticated users
- 🛡️ **Error Resilient** - Graceful fallbacks and error handling
- 🔍 **Debug Friendly** - Console logging with `[CHAT-BTN]` filter
- 📱 **Responsive** - Handles multiple messaging events appropriately

## Prerequisites

- Salesforce Experience Cloud site
- Messaging for Web deployment configured
- Basic Salesforce admin/developer access

## Installation

### 1. Deploy Apex Class

Deploy `messaging_availability_check.cls` to your Salesforce org using VS Code, SFDX, or Developer Console.

### 2. Deploy and Modify Flow

1. Create or Deploy a flow called `Messaging_Button_Availability.xml`, an example is included in this project.
2. **Important:** Modify the Flow with your specific business logic
3. Ensure the Flow has a boolean output variable named `show_button`
4. Activate the Flow


### 3. Configure Guest User Permissions

1. Navigate to **Setup → Digital Experiences → All Sites**
2. Find your site and click **"Builder"**
3. Go to **Settings → General**
4. Click **"Guest User Profile"**
5. Under **"Apex Class Access"**, click **"Edit"**
6. Add **"messaging_availability_check"** to the Selected list
7. Save changes

### 4. Add Head Markup

1. Go to **Experience Builder → Settings → Advanced → Edit Head Markup**
2. Copy the contents of `headmarkup.html` from this project
3. Paste into the Head Markup editor
4. Save changes

### 5. Publish Site

Publish your Experience Cloud site to activate all changes.

## Configuration

### Customizing the Flow

The included `Messaging_Button_Availability` Flow is a basic example. Modify it to include your business logic:

- Check agent availability in your system
- Verify business hours
- Query queue status
- Apply any custom rules

**Requirements:**
- Flow Type: Autolaunched Flow
- Output Variable: `show_button` (Boolean)
- Return `true` to show chat button, `false` to hide

### Adjusting Cache Duration

Edit the head markup to change caching behavior:

```javascript
duration: 2 * 60 * 1000 // 2 minutes - adjust as needed
minInterval: 2000 // 2 seconds between checks - adjust as needed
```

## Testing

### 1. Test REST API Directly

Navigate to: `https://your-domain.my.site.com/your-site-path/services/apexrest/messaging_availability_check`

Expected response:
```json
{
  "show_button": false,
  "status": "fresh",
  "timestamp": "2025-01-24T17:30:00.000Z"
}
```

### 2. Test Integration

1. Open your Experience Cloud site in incognito window
2. Open browser console and filter by `[CHAT-BTN]`
3. Look for successful execution logs
4. Verify chat button shows/hides based on Flow result

## Files Included

| File | Purpose |
|------|---------|
| `messaging_availability_check.cls` | Main REST API class |
| `messaging_availability_check_Test.cls` | Test class for code coverage |
| `Messaging_Button_Availability.xml` | Example Flow (modify for your needs) |
| `headmarkup.html` | JavaScript for Experience Cloud head markup |
| `messaging_availability_access.permissionset-meta.xml` | Optional permission set |

## API Reference

### Endpoint
```
GET /services/apexrest/messaging_availability_check
```

### Response Format
```json
{
  "show_button": boolean,    // true = show button, false = hide button
  "status": string,          // "fresh" or "error: message"  
  "timestamp": datetime      // ISO timestamp of execution
}
```

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| 403 Forbidden | Verify guest user has access to `messaging_availability_check` class and site is published |
| 404 Not Found | Check Apex class is deployed and URL path is correct |
| Flow Errors | Confirm Flow exists, is Active, and has `show_button` output variable |
| No button response | Check console for `[CHAT-BTN]` messages and verify messaging deployment |

### Debug Console Messages

Filter browser console by `[CHAT-BTN]` to see execution flow:

| Message | Meaning |
|---------|---------|
| `🔄 Restored cache from localStorage` | Cache loaded from previous session |
| `🗄️ Using cached API result` | Cache hit - no API call made |
| `📡 Making fresh API call` | Cache miss - calling server |
| `✅ showing/hiding chat button` | Button state applied successfully |

## ⚠️ Disclaimer

> **This project is not production-ready and is intended for educational and development purposes only.**

This solution is **not officially supported by Salesforce**. It is provided "as-is" for educational and implementation purposes.

### Important Considerations

- 🚫 **Not Production Ready** - This solution requires additional hardening, testing, and customization before production use
- 🛠️ **No Official Support** - This project is not covered by Salesforce support or warranties
- 🧪 **Test Thoroughly** - Always test in a sandbox environment and validate against your specific requirements
- ⚙️ **Customization Required** - The included Flow is an example only and must be modified for your business logic
- 🔒 **Security & Compliance** - Users are responsible for ensuring the solution meets their security, privacy, and compliance requirements
- 📊 **Performance Varies** - Behavior may vary based on your org configuration, data volume, and usage patterns
- 🔧 **Ongoing Maintenance** - This solution may require updates as Salesforce releases new features or changes
