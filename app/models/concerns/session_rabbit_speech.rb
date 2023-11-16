module SessionRabbitSpeech

    extend ActiveSupport::Concern

    DEFAULT_CHUNK_SIZE_NORMAL = 30
    DEFAULT_CHUNK_SIZE_RABBIT = 4

    def broadcast_speech_status
        broadcast_update_to "session-#{session.uuid}", target:"#{uuid}-#{session.uuid}-speech" , partial: 'elements/speech_status', locals: {session_rabbit: self}
    end

    def broadcast_current_speech_bubble(position: 'up')
        is_larry = self.rabbit.name == 'Larry'
        text = I18n.t(".#{self.rabbit.underscore_name}_#{self.current_speech.text}")
        answers = self.current_speech.speech_branches&.map(&:answer).uniq unless is_larry
        speech_classes = classify_speech_bubble(is_larry, text.size, position)
        text = converting_rabbit_language(text) if is_larry
        chunks = cut_text_into_chunks(text)
        broadcast_update_to "session-#{session.uuid}", target:"#{uuid}-#{session.uuid}-speech" , partial: 'elements/speech_bubble', locals: {chunks: chunks, classes: speech_classes, answers: answers, is_larry: is_larry}
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

    def classify_speech_bubble(is_larry, text_size, position)
        speech_classes = ''
        speech_classes += 'rabbit_language ' if is_larry
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