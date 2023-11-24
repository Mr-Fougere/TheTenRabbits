class Session < ApplicationRecord
  include TimeConverter

  before_create :setup_session

  belongs_to :last_rabbit_talked, class_name: 'Rabbit', optional: true
  belongs_to :voted_rabbit, class_name: 'Rabbit', optional: true

  has_many :session_rabbits

  enum status: { initialized: 0, in_progress: 1, finished: 2 }
  enum language: { en: 0, fr: 1, rbt: 2 }

  after_update :end_sparky_introduction, if: -> { saved_change_to_status?(to: 'in_progress') }
  after_update :end_session, if: -> { saved_change_to_status?(to: 'finished') }

  BASIC_RABBITS = %w[Sparky Scotty]

  def session_rabbit_named(name)
    session_rabbits.joins(:rabbit).find_by(rabbits: { name: })
  end

  def setup_session
    self[:uuid] = SecureRandom.hex(16) while self[:uuid].blank? || Session.exists?(uuid: self[:uuid])
    self[:api_key] = SecureRandom.hex(16) while self[:api_key].blank? || Session.exists?(api_key: self[:api_key])
    hide_basic_rabbits
  end

  def found_rabbit(name)
    rabbit = Rabbit.find_by(name:)
    return unless rabbit

    session_rabbit = session_rabbits.hidden.find_by(rabbit:)
    return unless session_rabbit

    session_rabbit.waiting_found_speech!
  end

  def hide_basic_rabbits
    BASIC_RABBITS.each do |rabbit|
      session_rabbits.new(rabbit: Rabbit.find_by(name: rabbit))
    end
  end

  def scotty_introduction?
    return false unless initialized?

    scotty = session_rabbit_named('Scotty')
    return false unless scotty.present?
    return false unless scotty.hidden?

    sparky = session_rabbit_named('Sparky')
    return false unless sparky.present?
    return false if sparky.no_speech?

    sparky.current_speech.text == 'introduction-5'
  end

  def hide_remaining_rabbits
    remaining_rabbits = Rabbit.where.not(name: BASIC_RABBITS)
    remaining_rabbits.each do |rabbit|
      session_rabbit = session_rabbits.create(rabbit:)
      session_rabbit.hide!
    end
  end

  def end_sparky_introduction
    session_sparky = session_rabbit_named('Sparky')
    next_introduction_speech_id = session_sparky.current_speech.id + 1
    session_sparky.update(speech_status: 'waiting_answer',
                          current_speech: session_sparky.speeches.find(next_introduction_speech_id))
    session_sparky.broadcast_current_speech
    hide_remaining_rabbits
  end

  def update_switch_colored_hint
    broadcast_replace_to "session-#{uuid}", target: 'colored-hint-container', partial: 'elements/colored_hint',
                                            locals: { session: self }
  end

  def update_credits
    broadcast_replace_to "session-#{uuid}", target: 'credits', partial: 'elements/credits/show',
                                            locals: { session: self, animated: false}
  end

  def update_title_screen
    broadcast_replace_to "session-#{uuid}", target: 'title-screen', partial: 'elements/title_screen',
                                            locals: { session: self }
  end

  def next_waiting_rabbit
    session_rabbits.waiting_found_speech.order(updated_at: :asc).last
  end

  def end_session
    update(finished_at: Time.now)
    session_sparky = session_rabbit_named('Sparky')
    session_sparky.update(speech_type: 'found_speech', current_speech: session_sparky.speeches.found.last)
    session_rabbits.each { |rabbit| rabbit.display_rabbit(out: true) }
    session_sparky.broadcast_current_speech
    display_credits
    undisplay_configuration
  end

  def time_passed
    difference = finished_at.to_i - created_at.to_i
    convert_secondes_in_full_duration(difference)
  end

  def hint_used
    session_rabbits.hinted.size
  end

  def use_hint!
    increment!(:hint_count)
  end

  def display_credits
    broadcast_append_to "session-#{uuid}", target: "home-#{uuid}", partial: 'elements/credits/show',
                                           locals: { session: self, animated: true }
  end

  def undisplay_configuration
    broadcast_replace_to "session-#{uuid}", target: "configuration", partial: 'elements/configuration',locals: { session: self }
  end

  def secret_rabbit
    "#{false ? 'found' : 'not_found'}"
  end

  def colored_hint_use
    "#{colored_hint ? 'enabled' : 'disabled'}"
  end

  def voted?
    !voted_rabbit.nil?
  end

  def vote_for(rabbit_name)
    return if voted?

    update(voted_rabbit: Rabbit.find_by(name: rabbit_name.capitalize))
  end
end
