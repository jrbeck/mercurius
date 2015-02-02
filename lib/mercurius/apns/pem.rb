module APNS
  class Pem
    include ActiveModel::Model

    attr_accessor :path, :data, :password

    def data
      @_data ||= (@data || read_file_at_path || raise(PemNotConfiguredError.new))
    end

    private

      def read_file_at_path
        if File.exist? path
          File.read path
        else
          raise PemNotFoundError.new
        end
      end

  end
end
