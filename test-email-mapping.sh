#!/bin/bash

# Email Mapping Test Script for Docker Compose
# Usage: ./test-email-mapping.sh [email_address]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default test email
TEST_EMAIL=${1:-"vice.regent@studium.bfriars.ox.ac.uk"}

echo -e "${BLUE}🚀 Starting Email Mapping Tests with Docker Compose${NC}"
echo -e "${BLUE}=================================================${NC}"
echo ""

# Check if docker compose is running
if ! docker compose ps | grep -q "Up"; then
    echo -e "${YELLOW}⚠️  Starting Docker Compose services...${NC}"
    docker compose up -d --build
    echo -e "${GREEN}✅ Services started${NC}"
    echo ""
    
    # Wait for services to be ready
    echo -e "${YELLOW}⏳ Waiting for services to be ready...${NC}"
    sleep 10
else
    echo -e "${GREEN}✅ Docker Compose services are already running${NC}"
    echo ""
fi

# Function to run commands with error handling
run_test() {
    local test_name="$1"
    local command="$2"
    
    echo -e "${BLUE}🔧 $test_name${NC}"
    echo "Command: $command"
    echo "----------------------------------------"
    
    if docker compose exec -T app $command; then
        echo -e "${GREEN}✅ $test_name - PASSED${NC}"
    else
        echo -e "${RED}❌ $test_name - FAILED${NC}"
        return 1
    fi
    echo ""
}

# Test 1: Configuration Status
run_test "Configuration Status" "rails email_mapping:config_status"

# Test 2: Microsoft Graph Connection
run_test "Microsoft Graph Connection" "rails email_mapping:test_connection"

# Test 3: List Accounts
run_test "List All Accounts" "rails email_mapping:list_accounts"

# Test 4: Test Email Mapping
run_test "Email Mapping for $TEST_EMAIL" "rails email_mapping:test_mapping[$TEST_EMAIL]"

# Test 5: Cache Refresh
run_test "Cache Refresh" "rails email_mapping:refresh_cache"

# Test 6: Rails Console Tests
echo -e "${BLUE}🔧 Rails Console Integration Tests${NC}"
echo "----------------------------------------"

# Create a temporary Ruby script for console tests
cat > /tmp/email_mapping_test.rb << 'EOF'
puts "🧪 Testing EmailAddressMapper directly..."
puts ""

# Test 1: Basic mapping
test_email = ENV['EMAIL_MAPPING_TEST_EMAIL'] || 'vice.regent@studium.bfriars.ox.ac.uk'
puts "Testing email: #{test_email}"

result = EmailAddressMapper.map_from_address(test_email)
puts "Mapping result: #{result.inspect}"
puts ""

# Test 2: Template artifact cleaning
dirty_email = "!--BEGINinlinetemplate--#{test_email}!--ENDinlinetemplate--"
puts "Testing dirty email: #{dirty_email}"

cleaned = EmailAddressMapper.send(:clean_template_artifacts, dirty_email)
puts "Cleaned email: #{cleaned}"
puts ""

# Test 3: Validation
puts "Email validation tests:"
puts "Valid email: #{EmailAddressMapper.send(:valid_email?, test_email)}"
puts "Invalid email: #{EmailAddressMapper.send(:valid_email?, 'invalid-email')}"
puts ""

# Test 4: Microsoft Graph Service
begin
  puts "Testing Microsoft Graph Service..."
  service = MicrosoftGraphService.new
  token = service.send(:get_access_token)
  puts "✅ Successfully obtained access token (length: #{token.length})"
rescue => e
  puts "❌ Microsoft Graph Service error: #{e.message}"
end
puts ""

puts "✅ Console integration tests completed!"
EOF

# Copy the test script to the container and run it
docker compose exec -T app bash -c "cat > /tmp/email_mapping_test.rb" < /tmp/email_mapping_test.rb

if docker compose exec -T app rails runner /tmp/email_mapping_test.rb; then
    echo -e "${GREEN}✅ Rails Console Integration Tests - PASSED${NC}"
else
    echo -e "${RED}❌ Rails Console Integration Tests - FAILED${NC}"
fi
echo ""

# Test 7: Performance Test
echo -e "${BLUE}🔧 Performance Tests${NC}"
echo "----------------------------------------"

cat > /tmp/performance_test.rb << 'EOF'
puts "⏱️  Testing cache performance..."

# Test uncached performance
EmailAddressMapper.refresh_valid_accounts_cache
start_time = Time.now
EmailAddressMapper.list_all_valid_accounts
uncached_time = Time.now - start_time

# Test cached performance
start_time = Time.now
EmailAddressMapper.list_all_valid_accounts
cached_time = Time.now - start_time

puts "Uncached call: #{uncached_time.round(3)} seconds"
puts "Cached call: #{cached_time.round(3)} seconds"
puts "Performance improvement: #{(uncached_time / cached_time).round(1)}x faster"
EOF

docker compose exec -T app bash -c "cat > /tmp/performance_test.rb" < /tmp/performance_test.rb

if docker compose exec -T app rails runner /tmp/performance_test.rb; then
    echo -e "${GREEN}✅ Performance Tests - PASSED${NC}"
else
    echo -e "${RED}❌ Performance Tests - FAILED${NC}"
fi
echo ""

# Clean up temporary files
rm -f /tmp/email_mapping_test.rb /tmp/performance_test.rb

# Summary
echo -e "${BLUE}📊 Test Summary${NC}"
echo -e "${BLUE}===============${NC}"
echo ""
echo -e "${GREEN}✅ All email mapping tests completed!${NC}"
echo ""
echo -e "${YELLOW}💡 Additional manual tests you can run:${NC}"
echo "1. Test with different email addresses:"
echo "   ./test-email-mapping.sh prior@studium.bfriars.ox.ac.uk"
echo ""
echo "2. Access Rails console for interactive testing:"
echo "   docker compose exec app rails console"
echo ""
echo "3. Test the web interface:"
echo "   Open http://localhost:3000 in your browser"
echo ""
echo "4. View application logs:"
echo "   docker compose logs -f app"
echo ""
echo "5. Test specific Graph API endpoints:"
echo "   docker compose exec app rails runner \"puts EmailAddressMapper.fetch_sender_domain_accounts.inspect\""
echo ""

# Check if we should keep services running
read -p "Keep Docker Compose services running? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🛑 Stopping Docker Compose services...${NC}"
    docker compose down
    echo -e "${GREEN}✅ Services stopped${NC}"
else
    echo -e "${GREEN}✅ Services are still running${NC}"
    echo "Use 'docker compose down' to stop them when finished"
fi
