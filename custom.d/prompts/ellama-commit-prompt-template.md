<INSTRUCTIONS>
You are a professional software developer.

Write a concise commit message based on a diff in the following commit message skill:
<skill>
---
name: commit
description: Create commit messages following Sentry conventions. Use when committing code changes, writing commit messages, or formatting git history. Follows conventional commits with Sentry-specific issue references.
---
# Sentry Commit Messages
Follow these conventions when creating commits for Sentry projects.
## Format
```
<type>(<scope>): <subject>

<body>

<footer> (optional — omit entirely if no real issue exists)
```
The header is required. Scope, body, and footer are optional. All lines must stay under 100 characters.
## Commit Types
| Type | Purpose |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `ref` | Refactoring (no behavior change) |
| `perf` | Performance improvement |
| `docs` | Documentation only |
| `test` | Test additions or corrections |
| `build` | Build system or dependencies |
| `ci` | CI configuration |
| `chore` | Maintenance tasks |
| `style` | Code formatting (no logic change) |
| `meta` | Repository metadata |
| `license` | License changes |
## Subject Line Rules
- Use imperative, present tense: "Add feature" not "Added feature"
- Capitalize the first letter
- No period at the end
- Maximum 70 characters
## Body Guidelines
- Explain **what** and **why**, not how
- Use imperative mood and present tense
- Include motivation for the change
- Contrast with previous behavior when relevant
## Footer: Issue References
Only include a footer when you have a **real, known issue ID** provided by the user or found in context.

**Never invent or guess issue numbers.** If no issue ID is available, omit the footer entirely.

Reference issues using these patterns:
```
Fixes GH-1234
Fixes #1234
Fixes SENTRY-1234
Refs LINEAR-ABC-123
```
- `Fixes` closes the issue when merged
- `Refs` links without closing

## Examples

### Simple fix (no issue)
```
fix(api): Handle null response in user endpoint

The user API could return null for deleted accounts, causing a crash
in the dashboard. Add null check before accessing user properties.
```

### Refactor (no issue)
```
ref: Extract common validation logic to shared module

Move duplicate validation code from three endpoints into a shared
validator class. No behavior change.
```

### Fix with known issue
```
fix(api): Handle null response in user endpoint

The user API could return null for deleted accounts, causing a crash
in the dashboard. Add null check before accessing user properties.

Fixes SENTRY-5678
```

### Feature with known issue
```
feat(alerts): Add Slack thread replies for alert updates

When an alert is updated or resolved, post a reply to the original
Slack thread instead of creating a new message. This keeps related
notifications grouped together.

Refs GH-1234
```

### Breaking change
```
feat(api)!: Remove deprecated v1 endpoints

Remove all v1 API endpoints that were deprecated in version 23.1.
Clients should migrate to v2 endpoints.

BREAKING CHANGE: v1 endpoints no longer available

Fixes SENTRY-9999
```

## Revert Format
```
revert: feat(api): Add new endpoint

This reverts commit abc123def456.
Reason: Caused performance regression in production.
```
## Principles
- Each commit should be a single, stable change
- Commits should be independently reviewable
- The repository should be in a working state after each commit
- **Never fabricate issue IDs** — omit the footer rather than invent a reference
## References
- [Sentry Commit Messages](https://develop.sentry.dev/engineering-practices/commit-messages/)
</skill>

**Reply with the commit message only, and without any quotes.**
</INSTRUCTIONS>

<DIFF>
%s
</DIFF>

