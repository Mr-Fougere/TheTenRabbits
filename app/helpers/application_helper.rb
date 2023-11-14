module ApplicationHelper

    DEFAULT_CHUNK_SIZE_NORMAL = 30
    DEFAULT_CHUNK_SIZE_RABBIT = 4

    def speech_bubble(text: ,rabbit_language: false, position: 'up')
        speech_classes = classify_speech_bubble(rabbit_language, text.size, position)
        text = converting_rabbit_language(text) if rabbit_language
        chunks = cut_text_into_chunks(text)
        render partial: 'elements/speech_bubble', locals: {chunks: chunks, classes: speech_classes}
    end

    def converting_rabbit_language(text)
        ascii_codes = text.chars.map { |char| char.ord }
        base5_representations = ascii_codes.map { |code| "0"+ code.to_s(5) }
    end

    private

    def cut_text_into_chunks(text)
        return text.each_slice(DEFAULT_CHUNK_SIZE_RABBIT).to_a if text.is_a?(Array)
        text.scan(/.{1,#{DEFAULT_CHUNK_SIZE_NORMAL}\b/)
    end

    def classify_speech_bubble(rabbit_language, text_size, position)
        speech_classes = ''
        speech_classes += 'rabbit_language ' if rabbit_language
        speech_classes += case text_size
        when 0..30
            'normal'
        when 31..60
            'faster'
        else
            'faster'
        end
        speech_classes += ' ' + position
    end

end
