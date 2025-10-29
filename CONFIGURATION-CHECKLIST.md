# Configuration Checklist - TechnicalOverview.md Requirements

This document provides a checklist to ensure all requirements from `TechnicalOverview.md` are met after deployment.

## ✅ Automated via `azd up`

These requirements are automatically configured during `azd up`:

### Infrastructure
- [x] **Azure App Service** - Deployed with .NET 8 runtime
- [x] **System-Assigned Managed Identity** - Enabled on App Service
- [x] **TLS/HTTPS** - Enforced (port 443 only, `httpsOnly: true`)
- [x] **Azure SQL Database** - Deployed with private endpoint
- [x] **Port 1433** - Default SQL Server port
- [x] **Azure AD Authentication** - SQL Server configured for Entra ID auth
- [x] **Private Endpoint (SQL)** - Inside VNet for restricted access
- [x] **Azure Key Vault** - Deployed for secrets storage
- [x] **Key Vault Access** - App Service managed identity granted "Key Vault Secrets User" role
- [x] **Virtual Network** - Created with subnets for App Service, SQL, Key Vault
- [x] **VNet Integration** - App Service integrated with VNet
- [x] **Private Endpoints** - Configured for SQL Database and Key Vault
- [x] **Private DNS Zones** - Linked for `privatelink.database.windows.net` and `privatelink.vaultcore.azure.net`
- [x] **Outbound Connectivity** - HTTPS (443) allowed to GitHub API, Microsoft Learn, login.microsoftonline.com
- [x] **Storage Account** - Deployed for diagnostics/logs

### Application Settings (Pre-configured)
- [x] **Database__Provider** - Set to "SqlServer"
- [x] **ConnectionStrings__SqlServer** - Configured with managed identity connection string
- [x] **AzureAd__CallbackPath** - Set to "/signin-oidc"
- [x] **GitHubSettings__Enabled** - Set to "false" (disabled by default)
- [x] **ChallengeSettings__MaxParticipantsPerTeam** - Set to "8"
- [x] **ChallengeSettings__ChallengeStarted** - Set to "false"
- [x] **ChallengeSettings__ChallengeStartDate** - Set to "10/04/2025"

---

## ⚠️ Manual Configuration Required

These requirements must be configured manually after deployment:

### SQL Database Permissions (Required - ~5 minutes)

**Status:** ❌ Manual setup required

**Location:** Azure Portal → SQL Server → Database Query Editor

**Steps:** See [DEPLOYMENT.md - Configure SQL Database Permissions](./DEPLOYMENT.md#configure-sql-database-permissions-required)

**Requirements:**
- [ ] Enable public access temporarily
- [ ] Set yourself as Entra ID Admin
- [ ] Grant App Service managed identity database roles:
  - [ ] `db_datareader` - Read data (SELECT queries)
  - [ ] `db_datawriter` - Write data (INSERT, UPDATE, DELETE)
  - [ ] `db_ddladmin` - Schema modifications (CREATE TABLE, ALTER, DROP)
- [ ] Disable public access (re-enable private endpoint only)

**How to verify this is needed:**

Check App Service logs. If you see this error, permissions setup is required:
```
DB Init failed: Reason: Connection was denied because Deny Public Network Access is set to Yes
Login failed for user '<token-identified principal>'
```

**SQL Commands:**
```sql
CREATE USER [<app-service-name>] FROM EXTERNAL PROVIDER;
GO

ALTER ROLE db_datareader ADD MEMBER [<app-service-name>];
ALTER ROLE db_datawriter ADD MEMBER [<app-service-name>];
ALTER ROLE db_ddladmin ADD MEMBER [<app-service-name>];
GO
```

**After completing:**
- [ ] Restart App Service
- [ ] Verify database connection works (check logs for "Tables created or validated successfully")

---

### Azure AD App Registration (Required - ~10 minutes)

**Status:** ❌ Manual setup required

**Location:** Azure Portal → App registrations

**Steps:** See [DEPLOYMENT.md - Configure Azure AD Authentication](./DEPLOYMENT.md#configure-azure-ad-authentication-required)

**Requirements:**
- [ ] Create App Registration
  - [ ] **Name:** LeaderboardApp (or preferred name)
  - [ ] **Account type:** Single tenant
  - [ ] **Redirect URI:** `https://<app-service-name>.azurewebsites.net/signin-oidc`
- [ ] Create Client Secret
  - [ ] Store secret value in Key Vault (recommended) or App Service env vars
  - [ ] Set expiration period (180 days, 1 year, or 2 years)
- [ ] Configure API Permissions (Delegated):
  - [ ] `User.Read` (Microsoft Graph)
  - [ ] `openid` (Microsoft Graph)
  - [ ] `profile` (Microsoft Graph)
  - [ ] Grant admin consent (if required by organization)
- [ ] Enable ID tokens (OpenID Connect)

**App Service Environment Variables:**
- [ ] `AzureAd__Domain` - Primary domain (e.g., `yourcompany.onmicrosoft.com`)
- [ ] `AzureAd__TenantId` - Directory (tenant) ID
- [ ] `AzureAd__ClientId` - Application (client) ID
- [ ] `AzureAd__ClientSecret` - Client secret value OR Key Vault reference (recommended)

**Recommended: Use Key Vault Reference for Client Secret**
```bash
# Store in Key Vault
az keyvault secret set --vault-name <keyvault-name> --name "AzureAd-ClientSecret" --value "<your-client-secret>"

# Set in App Service (use Key Vault reference format)
AzureAd__ClientSecret = @Microsoft.KeyVault(SecretUri=https://<keyvault-name>.vault.azure.net/secrets/AzureAd-ClientSecret/)
```

---

## 🔧 Optional Configuration

These requirements are optional based on your use case:

### GitHub Integration (Optional)

**Status:** ⬜ Optional (disabled by default)

**When needed:** 
- Track GitHub Copilot usage metrics
- Validate challenge completions via GitHub activity
- Sync team creation with GitHub organizations

**Location:** App Service → Environment variables

**Requirements:**
- [ ] GitHub organization with Copilot enabled
- [ ] Personal Access Token (PAT) with scopes:
  - [ ] `repo` (if accessing private repos)
  - [ ] `admin:org` (for team management)
  - [ ] `user` (for user information)
- [ ] PAT authorized for the organization
- [ ] PAT stored in Key Vault (recommended)

**App Service Environment Variables:**
- [ ] `GitHubSettings__Enabled` - Set to `true`
- [ ] `GitHubSettings__Org` - GitHub organization name
- [ ] `GitHubSettings__PAT` - Key Vault reference: `@Microsoft.KeyVault(SecretUri=https://<keyvault-name>.vault.azure.net/secrets/GitHub-PAT/)`

**Steps:** See [DEPLOYMENT.md - GitHub Integration](./DEPLOYMENT.md#github-integration-optional)

---

### SMTP Configuration (Optional)

**Status:** ⬜ Optional

**When needed:**
- Send passcode emails to participants
- Send team invitations
- Send challenge notifications

**Location:** App Service → Environment variables

**Requirements:**
- [ ] SMTP server credentials
- [ ] SMTP password stored in Key Vault (recommended)

**App Service Environment Variables:**
- [ ] `SmtpSettings__Server` - SMTP server (e.g., `smtp.office365.com`)
- [ ] `SmtpSettings__Port` - SMTP port (typically `587` for TLS)
- [ ] `SmtpSettings__SenderName` - Display name for emails
- [ ] `SmtpSettings__SenderEmail` - Email address to send from
- [ ] `SmtpSettings__Username` - SMTP username
- [ ] `SmtpSettings__Password` - Key Vault reference (recommended)
- [ ] `SmtpSettings__EnableSsl` - Set to `true`

**Recommended: Use Key Vault Reference for SMTP Password**
```bash
# Store in Key Vault
az keyvault secret set --vault-name <keyvault-name> --name "SMTP-Password" --value "<your-smtp-password>"

# Set in App Service
SmtpSettings__Password = @Microsoft.KeyVault(SecretUri=https://<keyvault-name>.vault.azure.net/secrets/SMTP-Password/)
```

**Steps:** See [DEPLOYMENT.md - SMTP Configuration](./DEPLOYMENT.md#smtp-configuration-optional)

---

## 📋 Verification Steps

After completing required manual configuration:

### 1. Verify SQL Connection
- [ ] Check App Service logs for successful database connection
- [ ] Confirm tables are created (Teams, Participants, Challenges, etc.)
- [ ] No errors like "Cannot open database" or "Login failed"

### 2. Verify Azure AD Authentication
- [ ] Navigate to app URL: `https://<app-service-name>.azurewebsites.net`
- [ ] Redirected to Microsoft sign-in page
- [ ] Can sign in with Azure AD credentials
- [ ] Redirected back to app after authentication
- [ ] No errors like "IDW10106: The 'ClientId' option must be provided"

### 3. Verify Network Security
- [ ] Public access to SQL Server is disabled
- [ ] App Service can access SQL via private endpoint
- [ ] Key Vault accessible via private endpoint
- [ ] IP restrictions configured correctly on App Service

### 4. Verify Key Vault Access
- [ ] App Service managed identity has "Key Vault Secrets User" role
- [ ] Key Vault references resolve correctly in App Service
- [ ] No errors like "The remote server returned an error: (403) Forbidden"

---

## 🔐 Security Best Practices Checklist

From TechnicalOverview.md Section: "Security Best Practices"

- [x] **Enforce HTTPS only** - Configured in Bicep (`httpsOnly: true`)
- [x] **Use Managed Identity** - SQL connection uses managed identity (no passwords)
- [ ] **Store secrets in Key Vault** - Manual: Store client secrets, PAT, SMTP password
- [ ] **Use Key Vault references** - Manual: Configure env vars with Key Vault references
- [x] **Limit outbound network access** - VNet integration with private endpoints
- [x] **Apply least-privilege SQL roles** - Manual: Grant only required roles (reader, writer, ddladmin)
- [ ] **Monitor logs** - Set up Application Insights / Azure Monitor (recommended)

---

## 📚 Reference Documentation

- **Primary Deployment Guide:** [DEPLOYMENT.md](./DEPLOYMENT.md)
- **Technical Requirements:** [TechnicalOverview.md](./src/app/docs/TechnicalOverview.md)
- **Quick Setup Summary:** [AZURE-AD-SETUP.md](./AZURE-AD-SETUP.md)
- **SQL Setup Overview:** [SQL-SETUP-SUMMARY.md](./SQL-SETUP-SUMMARY.md)

---

## 🎯 Quick Start Summary

For someone deploying for the first time:

1. **Deploy Infrastructure (1 command, ~5 minutes):**
   ```bash
   azd auth login
   azd up
   ```

2. **Configure SQL Permissions (Manual, ~5 minutes):**
   - Follow: [DEPLOYMENT.md - SQL Database Permissions](./DEPLOYMENT.md#configure-sql-database-permissions-required)

3. **Configure Azure AD (Manual, ~10 minutes):**
   - Follow: [DEPLOYMENT.md - Azure AD Authentication](./DEPLOYMENT.md#configure-azure-ad-authentication-required)

4. **Verify Application:**
   - Navigate to app URL
   - Sign in with Azure AD
   - Confirm app loads successfully

**Total Time:** ~20 minutes (5 min automated + 15 min manual configuration)

---

**Status Legend:**
- ✅ = Automated / Complete
- ❌ = Manual configuration required
- ⬜ = Optional configuration
