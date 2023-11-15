module ApplicationCable
  class Channel < ActionCable::Channel::Base


    def connect
      p "ici"
    end

    def disconnect
      p "la"
    end
  end
end
