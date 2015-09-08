# Mercurius

### Send push messages to Android, iOS devices.

This gem is designed to be easy to configure for simple operation when your needs are simple, but also allow more complicated cases such as when you need to send to multiple applications with different configurations. The interface is designed to be as similar as possible for GCM and APNS.

## Installation

    $ gem install mercurius

or add to your ``Gemfile``

    gem 'mercurius'

and install it with

    $ bundle install

## GCM

Set up the default GCM configuration. (All GCM::Services will be created with this configuration, but the configuration can be overridden per-service if you need to.)

    GCM.key = 'your_gcm_key'

Create the service with:

    gcm_service = GCM::Service.new

Now create the notification that you wish to send:

    gcm_notification = GCM::Notification.new(data: { alert: 'Hey' })

You can deliver the gcm_notification in the following manners:

    gcm_service.deliver gcm_notification, 'token123'               # single recipient
    gcm_service.deliver gcm_notification, 'token123', 'token456'   # multiple recipients
    gcm_service.deliver gcm_notification, ['token123', 'token456'] # multiple recipients
    gcm_service.deliver gcm_notification, topic: 'topic123'        # topic delivery

## APNS

The typical APNS configuration is set automatically, but you need to set the host with with either:

    APNS.mode = :development  # gateway.sandbox.push.apple.com

or

    APNS.mode = :production   # gateway.push.apple.com

Next, you'll need to set your PEM information. This can either be with a file or with a text buffer:

    pem = APNS::Pem.new(path: 'sandbox.pem', password: 'test123')
    pem = APNS::Pem.new(data: pem_data_buffer, password: 'test123')

Set the default configuration:

    APNS.pem = pem

Now you are ready to create the APNS::Service, which will allow you to send notifications:

    apns_service = APNS::Service.new

The APNS::Service object is created with the settings from earlier, but any of them can be overridden if you need more control (for instance if you need to send with multiple PEMs)

    apns_notification = APNS::Notification.new(alert: 'Hey')

The deliver method can be called in the following ways:

    apns_service.deliver apns_notification, 'token123'              # single recipient
    apns_service.deliver apns_notification, 'token123', 'token456'  # multiple recipients
    token_array = ['token123', 'token456']
    apns_service.deliver apns_notification, token_array             # multiple recipients

## Testing

`GCM::Service` and `APNS::Service` can accept which type of connection to use. Mercurius provides several mock connections
for convenient testing. You can create a custom fake connection if you require a special use case.

```ruby
# Tokens passed will return successfully from GCM
GCM::Service.new connection: GCM::SuccessfulConnection.new

# Tokens passed will return a NotRegistered error from the fake GCM
GCM::Service.new connection: GCM::UnregisteredDeviceTokenConnection.new('token123')`

# Tokens passed as keys will return their mapped value as the canonical ID
GCM::Service.new connection: GCM::CanonicalIdConnection.new('token123' => 'canonical123')`
```

## Contributing

Please fork, modify, and send a pull request if you want to help improve this gem.

## License

Mercurius is released under the MIT license:

http://www.opensource.org/licenses/MIT
