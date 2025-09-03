# Email Mapping Testing with Docker Compose

This guide helps you test the email mapping functionality in a Docker environment.

## Prerequisites

1. **Microsoft Graph Credentials**: You need valid Azure app registration credentials
2. **Domain Access**: Access to both `studium.bfriars.ox.ac.uk` and `english.op.org` domains
3. **Docker and Docker Compose**: Installed and running

## Setup Environment Variables

Create a `.env` file in your project root with your Microsoft Graph credentials:

```bash
# Database Configuration
ENV_POSTGRES_HOST=db
ENV_POSTGRES_DEV_DB=agatha_development
ENV_POSTGRES_USER=postgres
ENV_POSTGRES_PASSWORD=your_secure_password

# Microsoft Graph Configuration
MICROSOFT_GRAPH_CLIENT_ID=your_application_client_id
MICROSOFT_GRAPH_CLIENT_SECRET=your_client_secret
MICROSOFT_GRAPH_TENANT_ID=your_tenant_id
AGATHA_USE_MICROSOFT_GRAPH=true

# Email Mapping Test Configuration (optional)
EMAIL_MAPPING_TEST_EMAIL=vice.regent@studium.bfriars.ox.ac.uk
EMAIL_MAPPING_EXPECTED_SENDER=robert.vice.regent@english.op.org
```

## Starting the Environment

```bash
# Build and start the containers
docker-compose up --build

# Or run in detached mode
docker-compose up -d --build
```

## Testing Email Mapping

### 1. Basic Configuration Test

```bash
# Check if Microsoft Graph credentials are properly configured
docker-compose exec app rails email_mapping:config_status
```

### 2. Test Microsoft Graph Connection

```bash
# Test connection and authentication
docker-compose exec app rails email_mapping:test_connection
```

### 3. List Available Accounts

```bash
# List all accounts from both domains
docker-compose exec app rails email_mapping:list_accounts
```

### 4. Test Email Address Mapping

```bash
# Test with a specific email address
docker-compose exec app rails email_mapping:test_mapping[vice.regent@studium.bfriars.ox.ac.uk]

# Test with another email
docker-compose exec app rails email_mapping:test_mapping[prior@studium.bfriars.ox.ac.uk]
```

### 5. Refresh Account Caches

```bash
# Clear and refresh all caches
docker-compose exec app rails email_mapping:refresh_cache
```

## Testing End-to-End Email Sending

### 1. Rails Console Testing

```bash
# Access Rails console
docker-compose exec app rails console

# Test email mapping in console
> mapper_result = EmailAddressMapper.map_from_address('vice.regent@studium.bfriars.ox.ac.uk')
> puts mapper_result.inspect

# Test Microsoft Graph service
> service = MicrosoftGraphService.new
> access_token = service.send(:get_access_token)
> puts "Token length: #{access_token.length}"

# Create a test email (replace with actual IDs from your database)
> person = Person.first
> template = EmailTemplate.first
> test_email = AgathaEmail.new(
    from_email: 'vice.regent@studium.bfriars.ox.ac.uk',
    to_email: 'test@example.com',
    subject: 'Test Email',
    body: 'This is a test email.',
    person: person
  )

# Test the mapping
> mapping = EmailAddressMapper.map_from_address(test_email.from_email)
> puts mapping.inspect
```

### 2. HTTP API Testing

If your app has web interfaces, you can test through the browser:

```bash
# The app will be available at:
# http://localhost:3000

# Or get the container's IP
docker-compose exec app hostname -I
```

## Debugging Common Issues

### Issue 1: Authentication Errors

```bash
# Check credentials are loaded
docker-compose exec app rails runner "
puts 'Client ID: ' + (ENV['MICROSOFT_GRAPH_CLIENT_ID'] || 'NOT SET')
puts 'Tenant ID: ' + (ENV['MICROSOFT_GRAPH_TENANT_ID'] || 'NOT SET')
puts 'Secret: ' + (ENV['MICROSOFT_GRAPH_CLIENT_SECRET'] ? 'SET' : 'NOT SET')
"
```

### Issue 2: Permission Errors

```bash
# Test specific Graph API calls
docker-compose exec app rails runner "
service = MicrosoftGraphService.new
begin
  token = service.send(:get_access_token)
  puts 'Token obtained successfully'
rescue => e
  puts 'Error: ' + e.message
end
"
```

### Issue 3: User Not Found

```bash
# Check if user exists in Graph
docker-compose exec app rails runner "
email = 'vice.regent@studium.bfriars.ox.ac.uk'
result = EmailAddressMapper.find_sender_email_for_address(email)
puts result || 'User not found'
"
```

### Issue 4: Domain Configuration

```bash
# Verify domain configuration
docker-compose exec app rails runner "
puts 'Owned Domain: ' + EmailAddressMapper::OWNED_DOMAIN
puts 'Sender Domain: ' + EmailAddressMapper::SENDER_DOMAIN
"
```

## Performance Testing

### Test Cache Performance

```bash
# Time the first call (no cache)
docker-compose exec app rails runner "
start_time = Time.now
EmailAddressMapper.list_all_valid_accounts
puts 'First call: ' + (Time.now - start_time).to_s + ' seconds'
"

# Time the second call (with cache)
docker-compose exec app rails runner "
start_time = Time.now
EmailAddressMapper.list_all_valid_accounts
puts 'Cached call: ' + (Time.now - start_time).to_s + ' seconds'
"
```

## Automated Testing

Create a test script to run all tests:

```bash
# Run all email mapping tests
docker-compose exec app bash -c "
echo '🔧 Testing Email Mapping Configuration...'
rails email_mapping:config_status
echo ''

echo '🔌 Testing Microsoft Graph Connection...'
rails email_mapping:test_connection
echo ''

echo '📧 Listing Available Accounts...'
rails email_mapping:list_accounts
echo ''

echo '🧪 Testing Email Mapping...'
rails email_mapping:test_mapping[vice.regent@studium.bfriars.ox.ac.uk]
echo ''

echo '✅ All tests completed!'
"
```

## Cleanup

```bash
# Stop containers
docker-compose down

# Remove containers and volumes (careful - this deletes data!)
docker-compose down -v

# Remove images (optional)
docker-compose down --rmi all
```

## Troubleshooting Tips

1. **Check logs**: `docker-compose logs app`
2. **Check database**: `docker-compose exec db psql -U postgres -d agatha_development`
3. **Rebuild if needed**: `docker-compose build --no-cache app`
4. **Check environment**: `docker-compose exec app env | grep MICROSOFT`

## Security Notes

- Never commit your `.env` file with real credentials
- Use different credentials for development vs production
- Regularly rotate your client secrets
- Monitor Microsoft Graph API usage in Azure portal
