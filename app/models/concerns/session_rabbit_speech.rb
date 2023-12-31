module SessionRabbitSpeech
  extend ActiveSupport::Concern

  DEFAULT_CHUNK_SIZE_NORMAL = 30
  DEFAULT_CHUNK_SIZE_RABBIT = 4

  def broadcast_speech_status
    session.update(last_rabbit_talked: nil)
    broadcast_update_to "session-#{session.uuid}", target: "#{uuid}-#{session.uuid}-speech",
                                                   partial: 'elements/speech_status', locals: { session_rabbit: self }
  end

  def broadcast_current_speech_bubble
    I18n.locale = session.language
    p I18n.locale
    rabbit_hinted if sparky_rabbit_hint?
    session.update(last_rabbit_talked: rabbit)
    text = I18n.t(".#{rabbit.underscore_name}_#{current_speech.text}")
    no_answer = is_larry_enigma? || session.finished?
    answers = possible_answers unless no_answer
    speech_classes = classify_speech_bubble(is_larry?, text.size)
    text = converting_rabbit_language(text) if is_larry?
    chunks = cut_text_into_chunks(text)
    colored_words = translated_colored_words
    broadcast_update_to "session-#{session.uuid}", target: "#{uuid}-#{session.uuid}-speech",
                                                   partial: 'elements/speech_bubble', locals: { chunks:, classes: speech_classes, answers:, no_answer:, colored_words: }
  end

  def remove_last_speech_bubble
    last_rabbit = session.last_rabbit_talked
    last_session_rabbit = session.session_rabbit_named(last_rabbit.name)
    return unless last_session_rabbit.present?

    last_session_rabbit.broadcast_speech_status
  end

  def converting_rabbit_language(text)
    text.chars.map { |char| '0' + char.ord.to_s(5) }
  end

  def translate_rabbit_language(text)
    base5_representations = text.scan(/\d{1,4}/)
    base5_representations.map { |base5| base5.to_i(5).chr }.join
  end

  private

  def translated_colored_words
    return current_speech.colored_words if I18n.locale == :en

    current_speech.colored_words.map do |colored_word|
      I18n.t(colored_word)
    end
  end

  def possible_answers
    answers = current_speech.speech_branches&.map(&:answer)&.uniq
    return answers unless rabbit.name == 'Sparky'

    remove_answers = session.session_rabbits.found.joins(:rabbit).pluck('rabbits.name')
    answers - remove_answers.map(&:underscore)
  end

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
