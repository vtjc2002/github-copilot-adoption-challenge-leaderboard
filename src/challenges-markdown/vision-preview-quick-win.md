---
Title: Vision preview quick win
ActivityId: 12
---

### Summary

In this quick win you will use **GitHub Copilot Chat Vision Preview** to turn an existing architecture diagram into C#/Java/JS code stubs. You will drag a PNG or SVG diagram from your repository into the chat panel ask Copilot to stub each service or class then save the generated files. The whole task should take fifteen to twenty minutes.

### What you will learn

- Adding image context to Copilot Chat Vision Preview.

- Prompting Copilot to create class and interface stubs from a diagram.

- Saving generated files in the correct folder of your repo.

- Using a scratch branch to keep experiments separate from main.

### Prerequisites

Copilot Chat Vision Preview currently works in **VS Code** only. Verify you have the latest VS Code and Copilot extension then enable the Vision feature in the extension settings. Make sure the diagram you want to use is already stored in your repository for example `docs/system-diagram.png`.

### Steps

- **Step 1.** Open the diagram file in the VS Code Explorer so you can see it in the file list.

- **Step 2.** Create and check out a new branch named `vision-stubs` by using `git checkout -b vision-stubs` or the source control view.

- **Step 3.** Open Copilot Chat. In VS Code select the Copilot icon in the Activity Bar.

- **Step 4.** Drag the PNG or SVG diagram from the Explorer into the chat input box. Wait until the thumbnail appears confirming the image is attached.

- **Step 5.** Type `Stub these services/classes`in a language of your choice and press Enter. Copilot will list the detected elements and generate code stubs for each one.

- **Step 6.** Review the output. Use **Tab** to accept snippets or copy each stub into new files under `/src/`.

- **Step 7.** Compile the code or your usual build task to ensure the new files compile.

- **Step 8.** Commit the stubs to the `vision-stubs` branch with a descriptive message created by you or drafted by Copilot.

### Checkpoint

1. Did Copilot identify every main component in your diagram

- [ ] Yes
- [ ] No

2. Did all generated stubs compile without errors

- [ ] Yes
- [ ] No

3. Did you commit the stubs in a separate branch for later review

- [ ] Yes
- [ ] No

### Explore more

- [Copilot Vision Preview](https://code.visualstudio.com/updates/v1_98#_copilot-vision-preview)

- [GitHub Copilot General Availability in the CLI](https://github.blog/changelog/2024-03-21-github-copilot-general-availability-in-the-cli/)
