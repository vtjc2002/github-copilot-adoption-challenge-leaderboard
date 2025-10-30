---
Title: CLI suggest & execute
ActivityId: 12
---

## Summary

In this exercise you will use **GitHub Copilot CLI** to suggest and run a command that cleans up local branches already merged into main. You will execute the suggestion then verify the result with `git branch`. The task should take about ten minutes.

## What you will learn

- Running `gh copilot suggest` to generate shell commands.

- Executing the generated command directly from the CLI prompt.

- Verifying local branch cleanup with `git branch`.

- Using Copilot CLI for other repository maintenance tasks.

## Prerequisites

Confirm that GitHub CLI is installed with `gh --version`. Install the Copilot extension if needed using `gh extension install github/gh-copilot`. Authenticate with `gh auth login` and open a terminal in the root of a repository that has multiple merged branches.

## Steps

- **Step 1.** In the project root run the following command and press Enter.

`gh copilot suggest "clean local merged branches"`

- **Step 2.** Review the suggestion displayed by Copilot CLI. It should resemble `git branch --merged | grep -v "main" | xargs -n 1 git branch -d`.

- **Step 3.** When prompted choose the option to execute the command. If your terminal does not prompt automatically run the suggested command manually.

- **Step 4.** After execution run `git branch` to list local branches and confirm that only active branches remain.

- **Step 5.** Explore other cleanup ideas by running `gh copilot suggest "list large files in repo"` or a command of your choice.

- **Step 6.** Commit any auxiliary changes if applicable and push to remote.

## Checkpoint

1. Did Copilot suggest a safe branch cleanup command

- [ ] Yes
- [ ] No

2. Did the command remove local branches that are already merged

- [ ] Yes
- [ ] No

3. Did you confirm the result with `git branch`

- [ ] Yes
- [ ] No

## Explore more

- [GitHub Copilot CLI project page](https://githubnext.com/projects/copilot-cli)

- [Copilot command reference](https://docs.github.com/en/copilot/using-github-copilot/copilot-chat/github-copilot-chat-cheat-sheet)
