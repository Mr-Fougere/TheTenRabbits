module TimeConverter
    
    extend ActiveSupport::Concern
    
    def convert_secondes_in_full_duration(secondes)
        hours = secondes / 3600
        minutes = (secondes % 3600) / 60
        secondes = secondes % 60
        hours_time = "#{hours}h" if hours > 0
        minutes_time = "#{minutes}m" if minutes > 0
        secondes_time = "#{secondes}s"
        
        "#{hours_time} #{minutes_time} #{secondes_time}".strip
    end
end