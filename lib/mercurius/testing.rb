require File.expand_path('testing/service', __FILE__)

APNS::Service.send :prepend, TestService
GCM::Service.send :prepend, TestService
