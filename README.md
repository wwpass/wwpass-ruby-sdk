# WWPass-ruby-sdk

## OVERVIEW
### Introduction
The *WWPass Ruby SDK* allows a service provider to provide authentication using WWPass. WWPass's Authentication Service is an alternative to or replacement for other authentication methods such as username and password.  The Authentication Service works with the WWPass PassKey or WWPass PassKey Lite application on your smart phone.

The **WWPass PassKey** or **WWPass PassKey Lite** is a requirement for user authentication. 
**PassKey** is a hardware device that enables authentication and access for a given user.  A major component of the WWPass authentication capability is the software that supports the PassKey itself. Without this software, requests to an end user to authenticate their identity will fail since this software is used to directly access information stored on the PassKey and communicate with WWPass. To allow Administrator testing of the authentication infrastructure, this client software and an accompanying PassKey is required. 
**PassKey Lite** is an application for Android and iOS smartphones and tablets. The application is used to scan QR codes to authenticate into WWPass-enabled sites. Alternatively, when browsing with these mobile devices, you can tap the QR code image to authenticate into the site to access protected information directly on your phone or tablet. 
For more information about how to obtain a PassKey and register it, please refer to the WWPass web site (<http://www.wwpass.com>)  

### Licensing
The *WWPass Python SDK* is licensed under the Apache 2.0 license.  This license applies to all source code, code examples and accompanying documentation contained herein.  You can modify and re-distribute the code with the appropriate attribution.  This software is subject to change without notice and should not be construed as a commitment by WWPass.

You may obtain a copy of the License at <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, the software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

### Customer Assistance
If you encounter a problem or have a question, you can contact the WWPass Service Desk as follows:
Phone - 1-888-WWPASS1 (+1-888-997-2771)
Email - <support@wwpass.com>
Online - [Support form](https://www.wwpass.com/support/)


## Quick Start
### Installation

Add this line to your application's Gemfile:

```ruby
gem 'wwpass-ruby-sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wwpass-ruby-sdk

### Usage

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
begin
  @connection = WWPassRubySDK::WWPassConnection.new(WWPASS_CONFIG[:cert_file], WWPASS_CONFIG[:key_file], WWPASS_CONFIG[:cert_ca])
rescue WWPassException => e
  # Handle exception
end
@ticket = @connection.get_ticket(':p')    # Requires access code entry
```


### Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wwpass/wwpass-ruby-sdk.

## Ruby API
### WWPassConnection Constructor
#### Signature
    WWPASSConnection(cert_file, key_file, cafile, timeout, spfe_addr)
#### Purpose
*WWPassConnection* is the class for a WWPass SPFE connection, and a new connection is initiated every time a connection request is made.  The WWPass CA certificate is required for validating the SPFE certificate and can be downloaded at <https://developers.wwpass.com/downloads/wwpass.ca>
#### Parameters
| Name | Description |
| --------- | ---------------- | 
| cert_file | The path to the Service Provider's certificate file. |
| key_file | The path to the Service Provider's private key file. |
| cafile |The path to the WWPass Service Provider CA certificate. |
| timeout | Timeout of requests to SPFE measured in seconds. It is used in all operations. The default is 10 seconds. |
| spfe_addr | The hostname or base URL of the SPFE. The default name is <https://spfe.wwpass.com>. |
 
### getName
#### Signature
    getName()
#### Purpose
Gets the service provider name on the certificate which was used initiate this *WWPassConnection* instance.

#### Returns
The service provider name
#### Exception (Throw)
*WWPassException* is thrown if there is an internal formatting error

### getTicket
#### Signature
    getTicket(auth_type, ttl)
#### Purpose
Gets a newly-issued ticket from SPFE. This ticket is required in all other functions.
#### Parameters
| Name | Description |
| ------- | -------------- |
| auth_type | Defines which credentials will be asked of the user to authenticate this ticket. The values may be any combination of following letters: ‘p’ — to ask for PassKey and access code; ‘s’ — to generate cryptographically secure random number that would be available both to client and Service Provider; or empty string to ask for PassKey only (default). |
| ttl |The period in seconds for the ticket to remain valid since issuance. The default is 120 seconds. |

#### Returns
Ticket string

### getPUID
#### Signature
    getPUID(ticket, auth_type)
#### Purpose
Gets the id of the user from the Service Provider Front End. This ID is unique for each Service Provider.
#### Parameters
| Name | Description |
| ------- | -------------- |
| ticket | The authenticated ticket. |
| auth_type | Defines which credentials will be asked of the user to authenticate this ticket. The values may be any combination of following letters: ‘p’ — to ask for PassKey and access code; ‘s’ — to generate cryptographically secure random number that would be available both to client and Service Provider; or empty string to ask for PassKey only (default). |

#### Returns
User ID

### putTicket
#### Signature
    putTicket(ticket, ttl, auth_type)
#### Purpose
Checks the authentication of the ticket and may issue a new ticket from SPFE.  All subsequent operations should use a returned ticket instead of one provided to *putTicket*.
#### Parameters
| Name | Description |
| ------- | -------------- |
| ticket | The ticket to validate. |
| ttl | The period in seconds for the ticket to remain valid since issuance. The default is 120 seconds. |
| auth_type | Defines which credentials will be asked of the user to authenticate this ticket. The values may be any combination of following letters: ‘p’ — to ask for PassKey and access code; ‘s’ — to generate cryptographically secure random number that would be available both to client and Service Provider; or empty string to ask for PassKey only (default). |

#### Returns
Possibly new ticket

The new ticket should be used in further operations with the SPFE.  

### readData()
#### Signature
    readData(ticket, container)
#### Purpose
Requests data stored in the user’s data container.
#### Parameters
| Name | Description |
| ------- | -------------- |
| ticket | The authenticated ticket issued by the SPFE. |
| container | Arbitrary string (only the first 32 bytes are significant) identifying the user’s data container. |

#### Returns
Data string
 
### readDataAndLock()
#### Signature
    readDataAndLock(ticket, lock_timeout, container)
#### Purpose
Requests data stored in the user’s data container and tries to atomically lock an associated lock.
#### Parameters
| Name | Description |
| ------- | -------------- |
| ticket | The authenticated ticket issued by the SPFE. |
| lock_timeout | The period in seconds for the data container to remain protected from the new data being accessed. |
| container | Arbitrary string (only the first 32 bytes are significant) identifying the user’s data container. |

#### Returns
Data string

### writeData()
#### Signature
    writeData(ticket, data, container)
#### Purpose
Write data into the user’s data container.
#### Parameters
| Name | Description |
| ------- | -------------- |
| ticket | The authenticated ticket issued by the SPFE. |
| data | The string to write into the container. |
| container | Arbitrary string (only the first 32 bytes are significant) identifying the user’s data container. |

#### Returns
`(True, None)` or
`(False, <error message>)` 

### writeDataAndUnlock
#### Signature
    writeDataAndUnlock(ticket, data, container)
#### Purpose
Writes data into the user's data container and unlocks an associated lock. If the lock is already unlocked, the write will succeed, but the function will return an appropriate error.
#### Parameters
| Name | Description |
| ------- | -------------- |
| ticket | The authenticated ticket issued by the SPFE. |
| data | The string to write into the container. |
| container | Arbitrary string (only the first 32 bytes are significant) identifying the user’s data container. |

### lock
#### Signature
    lock(ticket, lockTimeout, lockid)
#### Purpose
Tries to lock a lock identified by the user (by authenticated ticket) and lock ID.
#### Parameters
| Name | Description |
| ------- | -------------- |
| ticket | The authenticated ticket issued by the SPFE. |
| lockTimeout | The period in seconds for the data container to remain protected from the new data being accessed. |
| lockid | The arbitrary string (only the first 32 bytes are significant) identifying the lock. |
 
### unlock
#### Signature
    unlock(ticket, lockid)
#### Purpose
Tries to unlock a lock identified by the user (by authenticated ticket) and lock ID.
##### Parameters
| Name | Description |
| ------- | -------------- |
| ticket | The authenticated ticket issued by the SPFE. |
| lockid | The arbitrary string (only the first 32 bytes are significant) identifying the lock. |
