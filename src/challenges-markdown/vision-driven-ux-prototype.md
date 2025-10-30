---
Title: Vision driven UX prototype
ActivityId: 12
---

### Summary

In this rapid prototyping exercise, you will upload a photo of a hand-drawn or externally sourced wireframe into GitHub Copilot Chat Vision Preview and request Copilot to generate responsive HTML and CSS. Reserve twenty minutes for the full flow.

### What you will learn

- Adding image context to Copilot Chat Vision Preview.

- Prompting Copilot to scaffold HTML and CSS from a wireframe.

- Saving generated files in a prototype folder.

- Launching a local preview to test responsiveness.

### Before you start

Copilot Chat Vision Preview is available in **VS Code Nightly** with the Copilot extension enabled. Place a photo or scan of your wireframe in the repository for example `docs/wireframe.jpg`.

### Steps

- **Step 1.** Create a new branch called `vision-prototype` with `git checkout -b vision-prototype` or the source control panel.

- **Step 2.** Open Copilot Chat in VS Code in EDIT mode and drag the wireframe image into the chat box. Wait until the thumbnail appears. Example:

- **Step 3.** Type `Scaffold responsive HTML and CSS for this layout place files in prototype folder` then press Enter.

- **Step 4.** Copilot returns one or more files. Accept each file with **Tab** so they appear under `prototype/`.

- **Step 5.** Open `prototype/index.html` in the Live Preview extension or a local browser. Resize the window to confirm the layout adapts to mobile and desktop widths.

- **Step 6.** Adjust colours fonts or breakpoints if needed then save the files.

- **Step 7.** Commit the prototype with a clear message and push the branch for review.

### Checkpoint

1. Did Copilot generate HTML and CSS files in the `prototype/` folder

- [ ] Yes
- [ ] No

2. Does the prototype render correctly on both mobile width and desktop width

- [ ] Yes
- [ ] No

3. Did you commit the files on the `vision-prototype` branch

- [ ] Yes
- [ ] No

### Explore more

- [Vscode copilot vision](https://github.com/microsoft/vscode-copilot-vision)

- [Copilot Edits VS 2022 overview](https://learn.microsoft.com/en-us/visualstudio/ide/copilot-edits)

- [Copilot Edits VS Code overview](https://code.visualstudio.com/docs/copilot/chat/copilot-edits)

- [Copilot Edits Jetbrains overview](https://github.blog/changelog/2025-03-20-enhance-your-productivity-with-copilot-edits-in-jetbrains-ides/)
