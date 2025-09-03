#!/usr/bin/env ruby

# Test script to directly test EmailAddressMapper functionality
# Run with: docker compose exec app ruby test_email_mapping_direct.rb

require_relative 'config/environment'

puts "🧪 Testing EmailAddressMapper directly"
puts "=" * 50

# Test the three-domain mapping
test_email = 'vice.regent@bfriars.ox.ac.uk'
puts "Testing email: #{test_email}"
puts ""

puts "🔍 Constants:"
puts "  DISPLAY_DOMAIN: #{EmailAddressMapper::DISPLAY_DOMAIN}"
puts "  OWNED_DOMAIN: #{EmailAddressMapper::OWNED_DOMAIN}"
puts "  AUTH_DOMAIN: #{EmailAddressMapper::AUTH_DOMAIN}"
puts ""

begin
  puts "📋 Listing all valid accounts..."
  accounts = EmailAddressMapper.list_all_valid_accounts
  
  puts "Source: #{accounts[:source]}"
  puts "Display domain: #{accounts[:display_domain][:domain]} - #{accounts[:display_domain][:note]}"
  puts "Owned domain: #{accounts[:owned_domain][:domain]} - #{accounts[:owned_domain][:note]}"
  puts "  Raw emails data: #{accounts[:owned_domain][:emails].inspect}"
  puts "  Emails (#{accounts[:owned_domain][:emails].length}): #{accounts[:owned_domain][:emails].first(3).join(', ')}#{accounts[:owned_domain][:emails].length > 3 ? '...' : ''}"
  puts "Auth domain: #{accounts[:auth_domain][:domain]} - #{accounts[:auth_domain][:note]}"
  puts "  Raw usernames data: #{accounts[:auth_domain][:usernames].inspect}"
  puts "  Usernames (#{accounts[:auth_domain][:usernames].length}): #{accounts[:auth_domain][:usernames].first(3).join(', ')}#{accounts[:auth_domain][:usernames].length > 3 ? '...' : ''}"
  puts ""
  
  puts "🧪 Testing email mapping..."
  result = EmailAddressMapper.test_email_mapping(test_email)
  
  puts "Input analysis:"
  puts "  Original: #{result[:input][:original_email]}"
  puts "  Cleaned: #{result[:input][:cleaned_email]}"
  puts "  Local part: #{result[:input][:local_part]}"
  puts ""
  
  puts "Mapping steps:"
  puts "  Step 1 - Studium email: #{result[:mapping_steps][:step1_studium_email]}"
  puts "  Step 1 - Exists? #{result[:mapping_steps][:step1_exists] ? '✅ Yes' : '❌ No'}"
  puts "  Step 2 - Direct auth: #{result[:mapping_steps][:step2_direct_auth]}"
  puts "  Step 2 - Direct exists? #{result[:mapping_steps][:step2_direct_exists] ? '✅ Yes' : '❌ No'}"
  puts "  Step 2 - Fallback auth: #{result[:mapping_steps][:step2_fallback_auth]}"
  puts "  Step 2 - Fallback exists? #{result[:mapping_steps][:step2_fallback_exists] ? '✅ Yes' : '❌ No'}"
  
  if result[:mapping_steps][:step2_graph_lookup]
    puts "  Step 2 - Graph lookup: #{result[:mapping_steps][:step2_graph_lookup]}"
  end
  puts ""
  
  puts "Final result:"
  if result[:result][:success]
    puts "  ✅ Mapping successful!"
    puts "  📧 Send from: #{result[:result][:send_from]}"
    puts "  ↩️  Reply to: #{result[:result][:reply_to]}"
    puts "  💬 Message: #{result[:result][:message]}"
  else
    puts "  ❌ Mapping failed!"
    puts "  🚫 Error: #{result[:result][:error]}"
  end
  
rescue => e
  puts "❌ Error testing email mapping: #{e.message}"
  puts "Backtrace:"
  puts e.backtrace.first(5).map { |line| "  #{line}" }.join("\n")
end

puts ""
puts "🏁 Test complete!"
