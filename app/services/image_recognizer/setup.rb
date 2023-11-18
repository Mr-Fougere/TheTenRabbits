module ImageRecognizer
    class Setup
      
        API_ROOT = "https://api.imagga.com/v2/tags"
        API_KEY = ENV['IMAGGA_API_KEY']
        API_SECRET = ENV['IMAGGA_API_SECRET']

        def initialize(image_path)
            @image_path = image_path
            set_authentification
            set_file
        end

        private

        def set_authentification
            @authentification = 'Basic ' + Base64.strict_encode64( "#{API_KEY}:#{API_SECRET}" ).chomp
        end

        def set_file
            @file = File.new(@image_path, 'rb')
        end

        def send_request
            raw_response = RestClient.post API_ROOT, { :image => @file}, { :Authorization => @authentification }
            @response = JSON.parse(raw_response.body)
        end

    end
end