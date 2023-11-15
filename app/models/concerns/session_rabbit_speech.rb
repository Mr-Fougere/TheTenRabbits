module SessionRabbitSpeech

    extend ActiveSupport::Concern

    DEFAULT_CHUNK_SIZE_NORMAL = 30
    DEFAULT_CHUNK_SIZE_RABBIT = 4

    def broadcast_speech_status
        broadcast_update_to "session-#{session.uuid}", target:"#{uuid}-#{session.uuid}-speech" , partial: 'elements/speech_status', locals: {session_rabbit: self}
    end

    def broadcast_current_speech_bubble(rabbit_language: false, position: 'up')
        text = I18n.t(".#{self.rabbit.underscore_name}_#{self.current_speech.text}")
        answers = self.current_speech.speech_branches&.map(&:answer).uniq
        speech_classes = classify_speech_bubble(rabbit_language, text.size, position)
        text = converting_rabbit_language(text) if rabbit_language
        chunks = cut_text_into_chunks(text)
        broadcast_update_to "session-#{session.uuid}", target:"#{uuid}-#{session.uuid}-speech" , partial: 'elements/speech_bubble', locals: {chunks: chunks, classes: speech_classes, answers: answers}
    end

    private

    def converting_rabbit_language(text)
        ascii_codes = text.chars.map { |char| char.ord }
        base5_representations = ascii_codes.map { |code| "0"+ code.to_s(5) }
    end

    def cut_text_into_chunks(text)
        return text.each_slice(DEFAULT_CHUNK_SIZE_RABBIT).to_a if text.is_a?(Array)
        text.scan(/.{1,#{DEFAULT_CHUNK_SIZE_NORMAL}}\b/)
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