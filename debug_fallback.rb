#!/usr/bin/env ruby

require_relative 'config/environment'

puts "🔍 Debugging fallback accounts logic"
puts "=" * 40

puts "Rails config email_mapping exists: #{Rails.application.config.respond_to?(:email_mapping)}"

if Rails.application.config.respond_to?(:email_mapping)
  puts "Rails config email_mapping: #{Rails.application.config.email_mapping.inspect}"
  puts "Valid accounts: #{Rails.application.config.email_mapping[:valid_accounts].inspect}"
else
  puts "No Rails config email_mapping found"
end

puts ""
puts "Default valid accounts: #{EmailAddressMapper.send(:default_valid_accounts).inspect}"
puts "Default sender accounts: #{EmailAddressMapper.send(:default_sender_accounts).inspect}"

puts ""
puts "Fallback calculation:"
fallback_accounts = Rails.application.config.respond_to?(:email_mapping) &&
                   Rails.application.config.email_mapping[:valid_accounts] ||
                   EmailAddressMapper.send(:default_valid_accounts)
puts "Fallback accounts result: #{fallback_accounts.inspect}"
