require 'mercurius/testing/base'
require 'mercurius/testing/delivery'
require 'mercurius/testing/service'

APNS::Service.send :prepend, Mercurius::Testing::Service
GCM::Service.send :prepend, Mercurius::Testing::Service
