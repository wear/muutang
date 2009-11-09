# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mt_session',
  :secret      => '0764ee979a8e5274a32a9999cefa94f87d4fcddc10fe105fbaa67a25682c963fe7e30e73e0d1f9813a8f7b10465981cc6d63d8d35581bd05602c3da8382fefc3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
