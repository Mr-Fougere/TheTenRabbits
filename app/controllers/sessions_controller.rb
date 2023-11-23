class SessionsController < ActionController::Base
  include ActionCable::Channel::Broadcasting

  before_action :set_session
  skip_before_action :verify_authenticity_token

  def introduction
    @session.found_rabbit('Sparky')
  end

  def continue
    @session&.next_waiting_rabbit&.broadcast_found_speech
    return unless @session.finished?

    @session.end_session
  end

  def seek_rabbit
    return unless @session
    return unless params[:rabbit_key].present? && params[:rabbit_uuid].present?

    session_rabbit = @session.session_rabbits.hidden.find_by(key: params[:rabbit_key],
                                                             uuid: params[:rabbit_uuid])
    return unless session_rabbit

    session_rabbit.waiting_found_speech!
  end

  def switch_language
    return unless @session.present? && params[:language].present?

    update_session_ui if @session.update(language: params[:language])
  end

  def switch_colored_hint
    return unless @session.present?

    @session.update(colored_hint: !@session.colored_hint)
  end

  private

  def update_session_ui
    I18n.locale = @session.language
    current_rabbit = @session.last_rabbit_talked
    @session.session_rabbit_named(current_rabbit.name).broadcast_current_speech if current_rabbit
    @session.update_switch_colored_hint
    @session.update_title_screen
    larry = @session.session_rabbit_named('Larry')
    return unless larry
    return unless larry.hidden?
    return larry.hide! if @session.language == 'rbt'

    larry.remove_rabbit_from_hide!
  end

  def set_session
    @session = Session.find_by(uuid: params[:session_uuid] || cookies[:uuid])
  end
end
