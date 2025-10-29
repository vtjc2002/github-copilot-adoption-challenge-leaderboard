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

⚠️ **Before You Begin**: Please read the [Security and Privacy Statement](./PRIVACY-STATEMENT.md) before deploying this application.

### Quick Deployment to Azure

Deploy the entire application with a single command using Azure Developer CLI:

```bash
## set the necessary environment variables first.  Make sure to replace the placeholders with your actual values.
pwsh ./setup-azd.ps1 -TenantId <tenant-id> -SubscriptionId <subscription-id> -Location <azure-region> -EnvironmentName <env-name>
## run azd up
azd up
## execute sql script to grant web app the db roles
pwsh ./src/infra/scripts/grant-sql-managed-identity-roles.ps1 
## execute sql script to add seed data
pwsh ./src/infra/scripts/seed-database.ps1
## create app registration name LeaderboardApp-<env-name> in azure and update web app settings
pwsh ./src/infra/scripts/app-reg-setup.ps1 -passwordDaysToExpiration <number of days before password expires>

```

This will provision all Azure infrastructure (App Service, SQL Database, VNet, Key Vault) and deploy your application in one step.

**Post-deployment configuration required (one-time, ~15 minutes):**
1. **SQL Database Permissions**: Grant the App Service managed identity database access via Azure Portal (~5 min)
2. **Azure AD Authentication**: Create an App Registration and configure ClientId/TenantId/ClientSecret (~10 min)

� **Configuration Checklist**: See [CONFIGURATION-CHECKLIST.md](./CONFIGURATION-CHECKLIST.md) for complete requirements validation

📖 **Detailed Step-by-Step Guide**: See [DEPLOYMENT.md](./DEPLOYMENT.md) for comprehensive instructions

**Alternative deployment options:**
- **Step-by-step**: Use `azd provision` then `azd deploy` for more control
- **Local development**: Use Docker and PostgreSQL (see prerequisites below)

<!-----------------------[ Prerequisites  ]-----------------<optional> section below--------------------->
### Prerequisites

<!--------------------------------------------------------
INSTRUCTIONS:
- Describe what things a new user needs to install in order to install and use the repository. 

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#prerequisites
---------------------------------------------------------->

<!---- [TODO]  CONTENT GOES BELOW ------->
* [Docker or orchestration engine like Kubernetes to run the LeaderboardApp container](https://www.docker.com/)
* [PostgresSQL running as a container](https://hub.docker.com/_/postgres)
<!------====-- CONTENT GOES ABOVE ------->


<!-----------------------[  Installing  ]-------------------<optional> section below------------------>
### Installing

<!--
INSTRUCTIONS:
- A step by step series of examples that tell you how to get a development environment and your code running. 
- Best practice is to include examples that can be copy and pasted directly from the README into a terminal.

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#installing

<!---- [TODO]  CONTENT GOES BELOW ------->
This repository does not hold installable content.
<!------====-- CONTENT GOES ABOVE ------->


<!-----------------------[  Tests  ]------------------------<optional> section below--------------------->
<!-- 
## Tests
 -->

<!--
INSTRUCTIONS:
- Explain how to run the tests for this project. You may want to link here from Deployment (CI/CD) or Contributing sections.

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#tests
-->

<!---- [TODO]  CONTENT GOES BELOW ------->
<!--

*Explain what these tests test and why* 

```
Give an example
``` 

-->
<!------====-- CONTENT GOES ABOVE ------->


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
_At this time, the repository does not use continuous integration or produce a website, artifact, or anything deployed._
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

<!-----------------------[  Access  ]-----------------------<recommended> section below------------------>
## Access

<!-- 
INSTRUCTIONS:
- Please use this section to reduce the all-too-common friction & pain of getting read access and role-based permissions 
  to repos inside Microsoft. Please cover (a) Gaining a role with read, write, other permissions. (b) sharing a link to 
  this repository such that people who are not members of the organization can access it.
- If the repository is set to internalVisibility, you may also want to refer to the "Sharing a Link to this Repository" sub-section 
of the [README-Template instructions](https://aka.ms/StartRight/README-Template/Instructions#sharing-a-link-to-this-repository) so new GitHub EMU users know to get 1ES-Enterprise-Visibility MyAccess group access and therefore will have read rights to any repo set to internalVisibility.

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#how-to-share-an-accessible-link-to-this-repository
-->


<!---- [TODO]  CONTENT GOES BELOW ------->

<!------====-- CONTENT GOES ABOVE ------->


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

If you are a new potential collaborator who finds reaching out or contributing to another project awkward, you may find 
it useful to read these [tips & tricks](https://aka.ms/StartRight/README-Template/innerSource/2021_02_TipsAndTricksForCollaboration) 
on InnerSource Communication.
<!------====-- CONTENT GOES ABOVE ------->


<!-----------------------[  Contacts  ]---------------------<recommended> section below------------------>
<!-- 
#### Contacts  
-->
<!--
INSTRUCTIONS: 
- To lower friction for new users and contributors, provide a preferred contact(s) and method (email, TEAMS, issue, etc.)

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#contacts
-->

<!---- [TODO]  CONTENT GOES BELOW ------->

<!------====-- CONTENT GOES ABOVE ------->


<!-----------------------[  Support & Reuse Expectations  ]-----<recommended> section below-------------->
 
### Support & Reuse Expectations

 
<!-- 
INSTRUCTIONS:
- To avoid misalignments use this section to set expectations in regards to current and future state of:
  - The level of support the owning team provides new users/contributors and 
  - The owning team's expectations in terms of incoming InnerSource requests and contributions.

How to Evaluate & Examples:
  - https://aka.ms/StartRight/README-Template/Instructions#support-and-reuse-expectations
-->

<!---- [TODO]  CONTENT GOES BELOW ------->

_The creators of this repository **DO NOT EXPECT REUSE**._

If you do use it, please let us know via an email or 
leave a note in an issue, so we can best understand the value of this repository.
<!------====-- CONTENT GOES ABOVE ------->


<!-----------------------[  Limitations  ]----------------------<optional> section below----------------->

<!-- 
### Limitations 
--> 

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

<!------====-- CONTENT GOES ABOVE ------->

--------------------------------------------


<!-----------------------[  Links to Platform Policies  ]-------<recommended> section below-------------->
## How to Accomplish Common User Actions
<!-- 
INSTRUCTIONS: 
- This section links to information useful to any user of this repository new to internal GitHub policies & workflows.
-->

 If you have trouble doing something related to this repository, please keep in mind that the following actions require 
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
[README template](https://aka.ms/StartRight/README-Template) used in this repository is requested as an issue. 

<!-- version: 2023-04-07 [Do not delete this line, it is used for analytics that drive template improvements] -->
