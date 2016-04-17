# WWPass-ruby-sdk

The WWPass connection web application SDK for Ruby allows a service provider to provide authentication using the WWPass system. The WWPass Authentication Service is an alternative to, or replacement for, other authentication methods such as user name/password.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wwpass-ruby-sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wwpass-ruby-sdk

## Usage

WWPass requires access to the certificates that were installed as part of your WWPass installation as described [here](https://developers.wwpass.com/documentation/get-started). We recommend creating a configuration file like `config/wwpass.yml` with contents like
```ruby
default: &default
  :sp_name: 'your_sp_name'
  :cert_file: '/etc/ssl/certs/your_sp_name.crt'
  :key_file: '/etc/ssl/certs/your_sp_name.key'
  :cert_ca: '/etc/ssl/certs/wwpass.ca.cer'
development:
  <<: *default
test: 
  <<: *default
production: 
  <<: *default
```

You can then create code (typically in a controller class) that connects to the WWPass Service Provider Front End (spfe) and, for example, fetches a ticket:

```ruby
@connection = WWPassRubySDK::WWPassConnection.new(WWPASS_CONFIG[:cert_file], WWPASS_CONFIG[:key_file], WWPASS_CONFIG[:cert_ca])
begin
  @ticket = @connection.get_ticket(':p')    # Requires access code entry
rescue WWPassException => e
  # Handle exception
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wwpass/wwpass-ruby-sdk.

