---
Title: Custom Chat Mode
ActivityId: 12
---

### Summary

In this advanced exercise, you will create a **.chatmode.md** persona called *CI/CD Release Manager* that instructs GitHub Copilot to assist with release pipelines, tagging, and changelog generation. Estimated time: thirty minutes.

### What you will learn

- Creating a `.chatmode.md` file to define a custom Copilot persona.
- Guiding Copilot’s responses to focus on CI/CD workflows.
- Integrating and activating a chat mode in VS Code Copilot Chat.
- Applying persona-driven suggestions to automate release processes.

### Before you start

Ensure you have the latest GitHub Copilot Chat extension in VS Code, and a repository containing at least one GitHub Actions workflow for CI/CD.

### Steps

- **Step 1.** Create a folder `.github/chatmodes` in your repo.
- **Step 2.** Add a file `ci-cd-release-manager.chatmode.md` with persona instructions, limiting scope to CI/CD YAML edits, semantic versioning, and changelog automation.
- **Step 3.** Reload VS Code to load the new chat mode.
- **Step 4.** In Copilot Chat, switch to “CI/CD Release Manager” mode.
- **Step 5.** Prompt: `Prepare a GitHub Actions workflow to handle semantic version bumping based on commit messages and auto-generate a changelog.`
- **Step 6.** Review, refine, and commit the generated workflow.

### Checkpoint

1. Was the chat mode activated successfully?

- [ ] Yes
- [ ] No

2. Did Copilot suggest a workflow following persona guidelines?

- [ ] Yes
- [ ] No

### Explore more

- [Customizing Copilot](https://code.visualstudio.com/docs/copilot/copilot-customization)
- [GitHub Actions documentation](https://docs.github.com/en/actions)
