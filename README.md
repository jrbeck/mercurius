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

    gcm_notification = GCM::Notification.new(alert: 'Hey')

You can deliver the gcm_notification in the following manners:

    gcm_service.deliver gcm_notification, 'token123'              # single recipient
    gcm_service.deliver gcm_notification, 'token123', 'token456'  # multiple recipients
    token_array = ['token123', 'token456']
    gcm_service.deliver gcm_notification, token_array             # multiple recipients

## APNS

The typical APNS configuration is set automatically, but you need to set the host with with either:

    APNS.set_mode(:develop) # gateway.sandbox.push.apple.com

or

    APNS.set_mode(:production) # gateway.push.apple.com

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

## Contributing

Please fork, modify, and send a pull request if you want to help improve this gem.

## License

Mercurius is released under the MIT license:

http://www.opensource.org/licenses/MIT
