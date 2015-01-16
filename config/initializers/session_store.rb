# Be sure to restart your server when you modify this file.

Trainerjim::Application.config.session_store :active_record_store, key: '_trainerjim_session', expire_after: 15.days

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Trainerjim::Application.config.session_store :active_record_store
