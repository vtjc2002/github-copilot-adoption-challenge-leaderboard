---
Title: Enterprise policy testing
ActivityId: 12
---

### Summary

In this governance exercise you will run the **/policy** slash command in GitHub Copilot Chat to generate a `.github/copilot-policy.yml` file that blocks model usage on files containing secrets. You will commit the policy file on a new branch and open a pull request for organisational review. Plan about fifteen minutes.

### What you will learn

- Invoking the `/policy` command in Copilot Chat.

- Configuring a policy to restrict AI suggestions on secret-related paths.

- Committing the policy file and opening a pull request for review.

- Understanding responsible AI controls in GitHub Copilot Enterprise.

### Before you start

Copilot policy management requires **GitHub Copilot Enterprise**. Confirm you have write access to an organisation repository and that Copilot Chat is enabled in your IDE (VS Code JetBrains or Visual Studio). The Copilot policy management feature is available only with GitHub Copilot Enterprise.

### Steps

- **Step 1.** Create a branch named `copilot-policy-secrets` with `git checkout -b copilot-policy-secrets` or your IDE branch UI.

- **Step 2.** Open Copilot Chat in your IDE and type `/policy` then press Enter.

- **Step 3.** In the policy prompt choose to *Disallow model usage* on files matching patterns such as `**/*secrets*.yml` and `**/.env`. Accept the generated `.github/copilot-policy.yml`.

- **Step 4.** Review the YAML in the editor to ensure the `blocked_paths` section includes the desired globs.

- **Step 5.** Stage the file with `git add .github/copilot-policy.yml` then commit with a message such as `chore: add Copilot policy to block secrets files`. You may let Copilot draft the commit message.

- **Step 6.** Push the branch and open a pull request. Request at least one teammate to review the new policy.

- **Step 7.** Once approved merge the pull request to enforce the policy on the default branch.

### Checkpoint

1. Did `.github/copilot-policy.yml` include blocked paths for secret files

- [ ] Yes
- [ ] No

2. Did you open a pull request for team review of the new policy

- [ ] Yes
- [ ] No

3. Was the branch merged so the policy is active on the default branch

- [ ] Yes
- [ ] No

### Explore more

- [Organisation policies for Copilot](https://docs.github.com/en/copilot/managing-copilot/managing-github-copilot-in-your-organization/managing-policies-for-copilot-in-your-organization)

- [Best practices for managing secrets in repos](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#using-secrets-in-github-actions)
