---
Title: Context augmented agent
ActivityId: 12
---

## Summary

In this advanced workflow, you’ll configure a **GitHub Copilot knowledge base** so that the Copilot Agent can reference your organization’s internal documentation. You’ll then ask the Agent to draft an ADR proposing a migration from a monolith to microservices. This task takes about thirty minutes.

## What you will learn

- Creating and managing a GitHub Copilot knowledge base.

- Adding document sources to the knowledge base.

- Connecting a Copilot Agent in VS Code to your knowledge base.

- Prompting the Agent to draft an ADR using contextual knowledge.

## Before you start

Ensure your organization has **GitHub Copilot Enterprise** enabled. You must be an organization owner or have appropriate permissions to manage Copilot settings. Prepare your documentation (Markdown, text, or supported formats) and ensure it is stored in a GitHub repository or external location that can be added to a knowledge base.

## Steps

- **Step 1.** Navigate to your organization settings on GitHub.com. Under **Copilot**, click **Knowledge bases**, then click **New knowledge base**.

- **Step 2.** Give your knowledge base a name (e.g., `Architecture Docs`) and add sources. You can include repositories, folders, or external links as needed.

- **Step 3.** Save the knowledge base and ensure it's accessible to Copilot Agents in your organization.

- **Step 4.** In VS Code, switch to Copilot **Agent** mode and confirm your organization’s knowledge base appears in the sidebar.

- **Step 5.** Create a new branch with `git checkout -b adr-microservices`. Then in the Agent chat, type:
`Draft an Architecture Decision Record for migrating our monolith to microservices using our current architecture documents as context.`

- **Step 6.** Review the generated ADR, which should include: *Context*, *Decision*, *Status*, and *Consequences*.

- **Step 7.** Save the draft to `docs/adr/0005-microservices-migration.md`, make any organization-specific edits, commit the file, and push the branch for review.

## Checkpoint

1. Did you successfully configure a Copilot knowledge base?

- [ ] Yes
- [ ] No

2. Did the Agent cite information from your documentation in the ADR draft?

- [ ] Yes
- [ ] No

3. Did you commit and push the ADR for review?

- [ ] Yes
- [ ] No

## Explore more

- [Managing Copilot knowledge bases](https://docs.github.com/en/enterprise-cloud@latest/copilot/customizing-copilot/managing-copilot-knowledge-bases)

- [Copilot Agents and Workspace overview](https://githubnext.com/projects/copilot-workspace)

- [Markdown ADR template](https://adr.github.io/madr/)
