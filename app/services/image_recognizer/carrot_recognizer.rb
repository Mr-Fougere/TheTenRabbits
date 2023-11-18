module ImageRecognizer
    class CarrotRecognizer < Setup
        require 'mini_magick'
        attr_reader :verdict

        VALID_TAGS = ["carrot", "carrots"]

        THRESHOLD = 0.25
        ORANGE_RANGE = {
            r: (200..255),
            g: (50..200),
            b: (0..100)
          }

        def initialize(image_path)
            super
            @verdict = false
            @response = nil
        end
        

        def perform
            detect_main_color
            return unless @verdict
            
            send_request
            @verdict = false
            return unless @response

            confident_carrot_tag
        end

        private 

        def confident_carrot_tag
            tags = @response["result"]["tags"]
            confidence_level = 100 

            while confidence_level > 80 && tags.any?
                tag = tags.shift
                confidence_level = tag["confidence"]
                break @verdict = true if tag["tag"]["en"].in?(VALID_TAGS)
            end
        end

        def detect_main_color
            image = MiniMagick::Image.open(@image_path)
          
            pixels = image.get_pixels
          
            orange_pixel_count = 0
            pixels.each do |row|
              row.each do |pixel|
                r, g, b = pixel
                orange_pixel_count += 1 if ORANGE_RANGE[:r].include?(r) && ORANGE_RANGE[:g].include?(g) && ORANGE_RANGE[:b].include?(b)
              end
            end
           
            orange_proportion = orange_pixel_count.to_f / (image.width * image.height)
            @verdict = ( orange_proportion >= THRESHOLD )
          end
    end
end