# Email Address Mapping Configuration
Rails.application.configure do
  # Email domain mapping configuration
  config.email_mapping = {
    owned_domain: 'studium.bfriars.ox.ac.uk',
    valid_accounts: [
      'vice.regent@studium.bfriars.ox.ac.uk',
      'prior@studium.bfriars.ox.ac.uk',
      'subprior@studium.bfriars.ox.ac.uk',
      'registrar@studium.bfriars.ox.ac.uk'
    ]
  }
  
  Rails.logger.info "Email Mapping Configuration: #{config.email_mapping[:valid_accounts].length} valid accounts for #{config.email_mapping[:owned_domain]}"
end
