# Microsoft Graph Email Integration

This application has been enhanced to support sending emails through Microsoft Graph API instead of traditional SMTP. This provides better security, reliability, and integration with Microsoft 365 environments.

## Prerequisites

Before setting up Microsoft Graph integration, ensure you have:

1. An Azure AD (Entra ID) tenant
2. A registered application in Azure with appropriate permissions
3. The application configured with Mail.Send permissions

## Azure App Registration Setup

### 1. Create App Registration

1. Go to [Azure Portal](https://portal.azure.com/)
2. Navigate to **Azure Active Directory** > **App registrations**
3. Click **New registration**
4. Fill in the details:
   - **Name**: `Agatha Email Service` (or your preferred name)
   - **Supported account types**: Select appropriate option for your organization
   - **Redirect URI**: Leave empty for now
5. Click **Register**

### 2. Configure API Permissions

1. In your app registration, go to **API permissions**
2. Click **Add a permission**
3. Select **Microsoft Graph**
4. Choose **Application permissions**
5. Search for and select **Mail.Send**
6. Search for and select **User.Read.All** (needed for email address mapping)
7. Click **Add permissions**
8. Click **Grant admin consent** (requires admin privileges)

**Note**: The `User.Read.All` permission allows the application to automatically discover valid email accounts in your organization for the email address mapping feature.

### 3. Create Client Secret

1. Go to **Certificates & secrets**
2. Click **New client secret**
3. Add a description (e.g., "Agatha Email Service Secret")
4. Set expiration as appropriate for your security policy
5. Click **Add**
6. **IMPORTANT**: Copy the secret value immediately - you won't be able to see it again

### 4. Gather Required Information

From your app registration, collect:
- **Application (client) ID** (from Overview page)
- **Directory (tenant) ID** (from Overview page)  
- **Client secret** (from step 3 above)

## Rails Application Setup

### 1. Install Dependencies

The required gems have been added to your Gemfile:
```ruby
gem "microsoft_graph_mailer", "~> 1.1"
gem "oauth2", "~> 2.0"
```

Run:
```bash
bundle install
```

### 2. Configure Credentials

You have two secure options for storing your Microsoft Graph credentials:

#### Option A: Environment Variables (.env file) - Recommended for Development

Add the following to your `.env` file in the project root:

```bash
MICROSOFT_GRAPH_CLIENT_ID=your_application_client_id
MICROSOFT_GRAPH_CLIENT_SECRET=your_client_secret_value
MICROSOFT_GRAPH_TENANT_ID=your_directory_tenant_id
AGATHA_USE_MICROSOFT_GRAPH=true
```

**Benefits:**
- Simple to manage
- Easy to see what's configured
- Already ignored by git (`.env*` in `.gitignore`)
- Can be different per environment

#### Option B: Rails Encrypted Credentials - Recommended for Production

Use the Rails credentials system to securely store your Microsoft Graph configuration:

```bash
rails credentials:edit
```

Add the following structure to your credentials file:
```yaml
microsoft_graph:
  client_id: your_application_client_id
  client_secret: your_client_secret_value
  tenant_id: your_directory_tenant_id
```

**Benefits:**
- Encrypted in the repository
- Built into Rails
- Secure for production deployments

#### Interactive Setup (Supports Both Options)

Use the setup task which will guide you through either option:
```bash
rails microsoft_graph:setup
```

### 3. Enable Microsoft Graph

Microsoft Graph email sending can be enabled/disabled:

**For Production:**
Edit `config/environments/production.rb` and set:
```ruby
config.use_microsoft_graph = true
```

**For Development/Testing:**
Set environment variable:
```bash
export AGATHA_USE_MICROSOFT_GRAPH=true
```

Or in your `.env` file:
```
AGATHA_USE_MICROSOFT_GRAPH=true
```

## Usage

Once configured, the application will automatically use Microsoft Graph for email sending when enabled. The existing email functionality remains unchanged - all emails sent through `AgathaMailer` will use Microsoft Graph when enabled.

### Email Features Supported

- ✅ HTML and plain text emails
- ✅ File attachments
- ✅ Multiple recipients (semicolon-separated)
- ✅ Custom from addresses
- ✅ Fallback to SMTP if Graph fails

### Testing

You can test your Microsoft Graph configuration:

```bash
# Check configuration status
rails microsoft_graph:status

# Test connectivity and authentication
rails microsoft_graph:test
```

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Verify client ID, client secret, and tenant ID are correct
   - Ensure admin consent has been granted for Mail.Send permission
   - Check that the client secret hasn't expired

2. **Permission Errors**
   - Verify the Mail.Send application permission is granted
   - Ensure admin consent has been provided
   - Check that the from email address is valid in your tenant

3. **Email Not Sending**
   - Check Rails logs for detailed error messages
   - Verify the from email address exists in your organization
   - Ensure the application has appropriate permissions

### Debugging

Enable detailed logging by setting log level to debug in your environment:

```ruby
config.log_level = :debug
```

Microsoft Graph API calls and responses will be logged for troubleshooting.

### Fallback Behavior

If Microsoft Graph fails to send an email, the application will:
1. Log the error details
2. Attempt to fall back to traditional SMTP (if configured)
3. Mark the email as unsent for potential retry

## Security Considerations

1. **Client Secrets**: Store client secrets securely using Rails encrypted credentials
2. **Permissions**: Use the principle of least privilege - only grant Mail.Send permission
3. **Monitoring**: Monitor email sending logs for suspicious activity
4. **Secret Rotation**: Regularly rotate client secrets according to your security policy

## Benefits of Microsoft Graph

- **Better Security**: OAuth 2.0 authentication instead of SMTP credentials
- **Reliability**: Enterprise-grade email delivery infrastructure
- **Compliance**: Inherits your organization's compliance and security policies
- **Monitoring**: Email sending is logged in Microsoft 365 audit logs
- **Scalability**: No SMTP connection limits or rate limiting issues

## Migration from SMTP

The integration is designed to be seamless:
1. Set up Microsoft Graph credentials
2. Enable Microsoft Graph sending
3. Test with a few emails
4. Monitor logs to ensure successful sending
5. Gradually increase usage

To revert to SMTP at any time, simply set `config.use_microsoft_graph = false` or unset the environment variable.
