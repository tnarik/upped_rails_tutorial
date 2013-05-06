# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Upped::Application.config.secret_token = APP_CONFIG['secret_token'] || ENV['SECRET_TOKEN'] || 'b0fae6df36d382dae84837d524646029dfe337b010db1b8df7dc371858adee9b408f8fc7eee22c95e75c56b5f3dd972bf254fc8750bf78f227e3b1c4173157f2'
