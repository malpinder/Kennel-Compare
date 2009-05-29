# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kennel_session',
  :secret      => '4073517bcc4f968fc4c2860060b9b5a9966d2c04fb8f8d507d5ba139dfacf2e1355a1a65f3e8077810e2f11b5a003435e9fb95ef5c939ae1dbebbe6248671b44'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
