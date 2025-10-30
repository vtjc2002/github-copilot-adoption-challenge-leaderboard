---
Title: Workspace autopilot
ActivityId: 12
---

### Summary

In this activity you will use **GitHub Copilot Workspace in GitHub Enterprise** to fix a real issue in your repository. Copilot Workspace will create a plan generate a new branch apply the changes and open a pull request for review. Expect to spend twenty to twenty five minutes.

### What you will learn

- Enabling Copilot Workspace on a GitHub Issue.

- Reviewing an AI generated implementation plan.

- Letting Copilot create code commits and a pull request automatically.

- Verifying the pull request fixes the bug before merging.

### Before you start

Copilot Workspace is currently available in **VS Code** with the Copilot Nightly extension. Confirm you have the Nightly build installed and signed in to GitHub. Ensure there is a GitHub Issue in your repository that describes a reproducible bug.

### Steps

- **Step 1.** Open the Issue you want to fix in your browser and click **Open in Copilot Workspace**.

- **Step 2.** VS Code launches a workspace panel showing the Issue description. Click **Generate plan** and wait for Copilot to list tasks.

- **Step 3.** Review the task list. If it looks correct click **Run** to let Copilot apply the changes on a new branch named `workspace_fix`.

- **Step 4.** Watch Copilot create commits. When finished it opens a pull request in the repository.

- **Step 5.** Open the pull request in your browser. Review the diff run tests locally or via continuous integration and confirm the bug is resolved.

- **Step 6.** Merge the pull request using the standard Merge button.

- **Step 7.** Close the original Issue if it did not close automatically.

### Checkpoint

1. Did Copilot Workspace generate a clear task plan for the Issue

- [ ] Yes
- [ ] No

2. Did the automated branch and pull request compile and pass tests

- [ ] Yes
- [ ] No

3. Did you merge the pull request and close the Issue

- [ ] Yes
- [ ] No

### Explore more

- [Copilot Workspace project overview](https://githubnext.com/projects/copilot-workspace)

- [Working with GitHub Issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/about-issues)
