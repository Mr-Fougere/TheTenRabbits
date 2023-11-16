module SessionRabbitSpeech

    extend ActiveSupport::Concern

    DEFAULT_CHUNK_SIZE_NORMAL = 30
    DEFAULT_CHUNK_SIZE_RABBIT = 4

    def broadcast_speech_status
        broadcast_update_to "session-#{session.uuid}", target:"#{uuid}-#{session.uuid}-speech" , partial: 'elements/speech_status', locals: {session_rabbit: self}
    end

    def broadcast_current_speech_bubble()
        text = I18n.t(".#{self.rabbit.underscore_name}_#{self.current_speech.text}")
        answers = self.current_speech.speech_branches&.map(&:answer).uniq unless is_larry_enigma?
        speech_classes = classify_speech_bubble(is_larry?, text.size)
        text = converting_rabbit_language(text) if is_larry?
        chunks = cut_text_into_chunks(text)
        broadcast_update_to "session-#{session.uuid}", target:"#{uuid}-#{session.uuid}-speech" , partial: 'elements/speech_bubble', locals: {chunks: chunks, classes: speech_classes, answers: answers, is_larry_enigma: is_larry_enigma?}
    end

    def converting_rabbit_language(text)
        text.chars.map { |char| "0"+char.ord.to_s(5) }
    end

    def translate_rabbit_language(text)
        base5_representations = text.scan(/\d{1,4}/)
        base5_representations.map { |base5| p base5.to_i(5).chr }.join
    end

    private

    def cut_text_into_chunks(text)
        return text.each_slice(DEFAULT_CHUNK_SIZE_RABBIT).to_a if text.is_a?(Array)
        text.scan(/.{1,#{DEFAULT_CHUNK_SIZE_NORMAL}}\b/)
    end

    def classify_speech_bubble(is_larry, text_size)
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
    end

end