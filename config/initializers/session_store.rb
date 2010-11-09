# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cocktail_session',
  :secret      => '35bb6eca211326b0fe74475f4e264ecb29c1bdfd665aade9b828c27a1b101129c2e78948ccdfaad0cbaed2b072203f401fdc1e375ba9ab24c208f9f5929c4fb9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
