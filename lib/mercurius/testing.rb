require 'testing/service'

APNS::Service.send :prepend, TestService
GCM::Service.send :prepend, TestService
