<!--=========================README TEMPLATE INSTRUCTIONS=============================

- ADDITIONAL EXTERNAL TEMPLATE INSTRUCTIONS:
  -  https://aka.ms/StartRight/README-Template/Instructions

==================================================================================-->


<!---------------------[  Description  ]------------------<recommended> section below------------------>

# LeaderboardApp - GitHub Copilot Adoption Challenge
## Overview
LeaderboardApp is a web application designed to track and manage scores for individual participants and teams in the GitHub Copilot Adoption Challenge. The application leverages configurable weights for different activities, allowing scores to be adjusted dynamically based on the type of activity and its importance.

The app is structured to provide real-time updates to the leaderboard, ensuring that both individual contributions and team performances are accurately reflected. Participants and teams earn scores by completing various activities, which are recorded in the system. The app is fully integrated with Docker for easy deployment and PostgreSQL for data persistence.

## Key Features
* **Participant and Team Management**: The app allows you to manage participants and teams, associating them with specific activities that contribute to their scores.
* **Activity-Based Scoring** Scores are assigned based on activities performed by participants or teams. Each activity has a configurable weight (fixed or multiplier) to reflect its importance.
* **Leaderboard**: A Leaderboard View that updates based on the activities recorded for participants and teams.
* **Daily Summaries**: Teams can submit daily github copilot summaries of their activities, which are factored into their overall score. (GitHub API integration coming soon)
* **Configurable Scoring Weights**: The app allows the configuration of scoring weights for different activities, enabling flexible and customizable scoring systems.

## Privacy and Security

📋 **[Security and Privacy Statement](./PRIVACY-STATEMENT.md)** - Please review the official Microsoft security and privacy statement before deploying this application.

-----------------------------------------------------------------


<!-----------------------[  Getting Started  ]--------------<recommended> section below------------------>
## Getting Started

<!-- 
INSTRUCTIONS:
  - Write instructions such that any new user can get the project up & running on their machine.
  - This section has subsections described further down of "Prerequisites", "Installing", and "Deployment". 

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#getting-started
-->


<!-----------------------[ Prerequisites  ]-----------------<optional> section below--------------------->
### Prerequisites

<!--------------------------------------------------------
INSTRUCTIONS:
- Describe what things a new user needs to install in order to install and use the repository. 

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#prerequisites
---------------------------------------------------------->

<!---- [TODO]  CONTENT GOES BELOW ------->
1. Install Azure Developer CLI (azd): https://aka.ms/azd-install
1. Install Azure CLI: https://aka.ms/azcli-install  
1. Have an Azure subscription

For local development, you will also need:
* [Docker or orchestration engine like Kubernetes to run the LeaderboardApp container](https://www.docker.com/)
* [PostgresSQL running as a container](https://hub.docker.com/_/postgres)
<!------====-- CONTENT GOES ABOVE ------->


<!-----------------------[  Installing  ]-------------------<optional> section below------------------>
### Installing - Quick Deployment to Azure

<!--
INSTRUCTIONS:
- A step by step series of examples that tell you how to get a development environment and your code running. 
- Best practice is to include examples that can be copy and pasted directly from the README into a terminal.

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#installing

<!---- [TODO]  CONTENT GOES BELOW ------->
Deploy the entire application with a single command using Azure Developer CLI:

```bash
## set the necessary environment variables first.  Make sure to replace the placeholders with your actual values.
pwsh ./setup-azd.ps1 -TenantId <tenant-id> -SubscriptionId <subscription-id> -Location <azure-region> -EnvironmentName <env-name>
## run azd up to deploy the infra and app
azd up
## execute sql script to grant web app the db roles
pwsh ./src/infra/scripts/grant-sql-managed-identity-roles.ps1 
## execute sql script to add seed data
pwsh ./src/infra/scripts/seed-database.ps1
## create app registration name LeaderboardApp-<env-name> in azure and update web app settings
pwsh ./src/infra/scripts/app-reg-setup.ps1 -passwordDaysToExpiration <number of days before password expires>

```

This will provision all Azure infrastructure (App Service, SQL Database, VNet, Key Vault) and deploy your application in one step.

_the script adds the ip address of your current machine to the sql server firewall rules so that the sql scripts can be executed successfully.  It also adds the ip address to the web app firewall rules.  Make sure to update your firewall rules accordingly after the deployment/setup._

Use below command to get the web app URL after deployment:
```bash
azd env get-value APP_SERVICE_HOST
```

💻**Technical Overview**: See [TechnicalOverview.md](./TechnicalOverview.md) for architecture and component details.  Also app configuration settings.

📖 **Detailed Step-by-Step Guide**: See [DEPLOYMENT.md](./DEPLOYMENT.md) for comprehensive instructions as well as optional features such as SMTP email or GitHub connection.  Troubleshooting tips are also included.  Note that the deployment scripts above does all the non-optional steps for you already when you deploy.



**Alternative deployment options:**
- **Step-by-step**: Use `azd provision` then `azd deploy` for more control
- **Local development**: Use Docker and PostgreSQL (see prerequisites section)
<!------====-- CONTENT GOES ABOVE ------->

### Understanding the Scoring System

The Activities table defines how different GitHub Copilot activities contribute to team scores:

**Weight Types:**
- **Multiplier**: Score = Activity count × Weight (e.g., 10 chats × 10.00 = 100 points)
- **Fixed**: Score = Weight regardless of count (e.g., completing certification = 1000 points)

**Scopes:**
- **User**: Individual participant activity
- **Team**: Aggregated team activity

**Frequencies:**
- **Daily**: Activity tracked and scored every day
- **Once**: One-time achievement (e.g., certifications)

**Default Weights (Customizable):**

| Activity | Weight | Type | Why It Matters |
|----------|--------|------|----------------|
| ActiveUsersPerDay | 50.00 | Multiplier | Encourages daily engagement |
| EngagedUsersPerDay | 75.00 | Multiplier | Rewards active participation |
| TotalCodeSuggestions | 1.00 | Multiplier | Tracks basic usage |
| TotalLinesAccepted | 1.50 | Multiplier | Rewards accepting suggestions |
| TotalChats | 10.00 | Multiplier | Encourages using Chat features |
| TotalChatInsertions | 50.00 | Multiplier | Rewards code insertions from Chat |
| TotalChatCopyEvents | 30.00 | Multiplier | Tracks code copying from Chat |
| TotalPRSummariesCreated | 100.00 | Multiplier | Encourages PR documentation |
| TotalDotComChats | 20.00 | Multiplier | Rewards using GitHub.com Chat |
| CompletedLearningModule | 250.00 | Fixed | Recognizes training completion |
| GitHubCopilotCertificationExam | 1000.00 | Fixed | Highest reward for certification |
| CopilotDailyChallengeCompleted | 200.00 | Fixed | Daily challenge incentive |
| LinkClicked | 50.00 | Fixed | Engagement tracking |
| TeamBonus | 50.00 | Fixed | Team collaboration bonus |

> **💡 Customization Tip:** You can adjust these weights based on what's most important to your organization. For example:
> - Increase `GitHubCopilotCertificationExam` to 2000 to emphasize certification
> - Increase `TotalPRSummariesCreated` to encourage better documentation
> - Adjust `TotalChats` vs `TotalCodeSuggestions` to prioritize different features

<!-----------------------[  Deployment (CI/CD)  ]-----------<optional> section below--------------------->
### Deployment (CI/CD)

<!-- 
INSTRUCTIONS:
- Describe how to deploy if applicable. Deployment includes website deployment, packages, or artifacts.
- Avoid potential new contributor frustrations by making it easy to know about all compliance and continuous integration 
    that will be run before pull request approval.
- NOTE: Setting up an Azure DevOps pipeline gets you all 1ES compliance and build tooling such as component governance. 
  - More info: https://aka.ms/StartRight/README-Template/integrate-ado

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#deployment-and-continuous-integration
-->

<!---- [TODO]  CONTENT GOES BELOW ------->
_At this time, the repository does not use continuous integration. Use `azd up` for deployment._
<!------====-- CONTENT GOES ABOVE ------->


<!-----------------------[  Versioning and Changelog  ]-----<optional> section below--------------------->

<!-- ### Versioning and Changelog -->

<!-- 
INSTRUCTIONS:
- If there is any information on a changelog, history, versioning style, roadmap or any related content tied to the 
  history and/or future of your project, this is a section for it.

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#versioning-and-changelog
-->

<!---- [TODO]  CONTENT GOES BELOW ------->
<!-- We use [SemVer](https://aka.ms/StartRight/README-Template/semver) for versioning. -->
<!------====-- CONTENT GOES ABOVE ------->


-----------------------------------------------


<!-----------------------[  Contributing  ]-----------------<recommended> section below------------------>
## Contributing

<!--
INSTRUCTIONS: 
- Establish expectations and processes for existing & new developers to contribute to the repository.
  - Describe whether first step should be email, teams message, issue, or direct to pull request.
  - Express whether fork or branch preferred.
- CONTRIBUTING content Location:
  - You can tell users how to contribute in the README directly or link to a separate CONTRIBUTING.md file.
  - The README sections "Contacts" and "Reuse Expectations" can be seen as subsections to CONTRIBUTING.
  
How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#contributing
-->

<!---- [TODO]  CONTENT GOES BELOW ------->
_This repository prefers outside contributors start forks rather than branches. For pull requests more complicated 
than typos, it is often best to submit an issue first._

<!------====-- CONTENT GOES ABOVE ------->


<!-----------------------[  Limitations  ]----------------------<optional> section below----------------->


### Limitations 


<!-- 
INSTRUCTIONS:
- Use this section to make readers aware of any complications or limitations that they need to be made aware of.
  - State:
    - Export restrictions
    - If telemetry is collected
    - Dependencies with non-typical license requirements or limitations that need to not be missed. 
    - trademark limitations
 
How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#limitations
-->

<!---- [TODO]  CONTENT GOES BELOW ------->
1. Supports only Microsoft Entra Id for authentication
1. Supports only single Microsoft Entra Id tenant for SSO
1. Supports only single GitHub organization
 

<!------====-- CONTENT GOES ABOVE ------->

--------------------------------------------


<!-----------------------[  Links to Platform Policies  ]-------<recommended> section below-------------->
## How to Accomplish Common User Actions
<!-- 
INSTRUCTIONS: 
- This section links to information useful to any user of this repository new to internal GitHub policies & workflows.
-->

 <!-- If you have trouble doing something related to this repository, please keep in mind that the following actions require 
 using [GitHub inside Microsoft (GiM) tooling](https://aka.ms/gim/docs) and not the normal GitHub visible user interface!
- [Switching between EMU GitHub and normal GitHub without logging out and back in constantly](https://aka.ms/StartRight/README-Template/maintainingMultipleAccount)
- [Creating a repository](https://aka.ms/StartRight)
- [Changing repository visibility](https://aka.ms/StartRight/README-Template/policies/jit) 
- [Gaining repository permissions, access, and roles](https://aka.ms/StartRight/README-TEmplates/gim/policies/access)
- [Enabling easy access to your low sensitivity and widely applicable repository by setting it to Internal Visibility and having any FTE who wants to see it join the 1ES Enterprise Visibility MyAccess Group](https://aka.ms/StartRight/README-Template/gim/innersource-access)
- [Migrating repositories](https://aka.ms/StartRight/README-Template/troubleshoot/migration)
- [Setting branch protection](https://aka.ms/StartRight/README-Template/gim/policies/branch-protection)
- [Setting up GitHubActions](https://aka.ms/StartRight/README-Template/policies/actions)
- [and other actions](https://aka.ms/StartRight/README-Template/gim/policies)

This README started as a template provided as part of the 
[StartRight](https://aka.ms/gim/docs/startright) tool that is used to create new repositories safely. Feedback on the
[README template](https://aka.ms/StartRight/README-Template) used in this repository is requested as an issue.  -->

<!-- version: 2023-04-07 [Do not delete this line, it is used for analytics that drive template improvements] -->
