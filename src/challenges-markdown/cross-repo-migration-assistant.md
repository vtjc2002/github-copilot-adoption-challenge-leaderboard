---
Title: Cross repo migration assistant
ActivityId: 12
---

### Summary

In this multi-repository automation task, you’ll use **GitHub Copilot (Pro/Pro+/Business)** inside VS Code to build GitHub Actions workflows that automate updates to import paths when a shared `utils` package is moved into a monorepo. You’ll create workflows for three satellite repositories—`repo-A`, `repo-B`, and `repo-C`—and validate the process with test runs and pull requests. Allocate thirty minutes.

### What you will learn

- Using GitHub Copilot to generate Actions workflows for cross-repo automation.

- Updating import paths in satellite repositories in response to monorepo changes.

- Coordinating CI triggers and jobs using reusable workflows or dispatch events.

- Reviewing Copilot-assisted PRs and verifying test results.

### Before you start

Install the latest **GitHub Copilot extension** in VS Code and ensure you have an active subscription. Confirm push rights to the monorepo and all satellite repositories. Make sure each repo has working CI pipelines configured using GitHub Actions.

### Steps

- **Step 1.** Move the `utils` package into the monorepo under `packages/utils`. Commit and push the changes.

- **Step 2.** In each satellite repository, open `.github/workflows/update-utils.yml` and use GitHub Copilot to generate a workflow that:

- Watches for new releases or changes in the monorepo’s `utils` package.
- Checks out the code.
- Replaces old import paths (e.g., `../../utils`) with `@org/utils`.
- Creates a pull request with the updated imports.

- **Step 3.** Push the workflow file and manually trigger it using the GitHub Actions UI or through a `repository_dispatch` event from the monorepo.

- **Step 4.** Review the pull request opened by the GitHub Action in each repository. Confirm the import path updates are accurate.

- **Step 5.** Wait for CI to complete in each satellite repo. If needed, prompt Copilot with follow-up requests like `Fix broken tests after utils migration` to generate patches.

- **Step 6.** Once all builds pass, merge the pull requests in `repo-A`, `repo-B`, and `repo-C`.

- **Step 7.** Clean up any obsolete `utils` folders in satellite repos and confirm that your imports rely only on the monorepo package.

### Checkpoint

1. Did you use Copilot to create a GitHub Action workflow in each satellite repo?

- [ ] Yes
- [ ] No

2. Did the workflows open pull requests with correct import path updates?

- [ ] Yes
- [ ] No

3. Did all tests pass and changes get merged?

- [ ] Yes
- [ ] No

### Explore more

- [Using GitHub Actions workflows](https://docs.github.com/en/actions/using-workflows)

- [Triggering workflows across repositories](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#repository_dispatch)

- [Copilot Agents overview](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode)
