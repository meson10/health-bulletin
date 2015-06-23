require "singleton"

require_relative "./config"
require_relative "./backtrace"

begin
  require_relative "../gilmour/lib/gilmour"
  puts "Found local version of gilmour"
rescue LoadError
  require "gilmour"
end

module Subpub
  GilmourBackend = 'redis'
  # TODO: Please read this Flag from Command line or conf file.
  #
  def self.get_client
    SubpubClient.instance
  end

  class SubpubClient
    include Singleton
    include Gilmour::Base

    @@reporter = PagerDutySender.new(Config["error_reporting"])

    def activate
      enable_backend(GilmourBackend, { })
      registered_subscribers.each do |sub|
        sub.backend = 'redis'
      end

      start()
    end
  end

  class ErrorSubsciber < SubpubClient

    $stderr.puts "Listening to #{Gilmour::ErrorChannel}"
    listen_to Gilmour::ErrorChannel do
      @@reporter.send_traceback(request.body)
    end

  end
end
