module RabbitColors
    extend ActiveSupport::Concern
    
    included do

        enum color: { red: 0, orange: 1, brown: 2, green: 3, blue: 4, purple: 5, pink: 6, grey: 7, white: 8, black: 9, yellow: 10 }
        
        COLORS = {
            pink: "#FECDF6",
            grey: "#C5C5C5",
            yellow: "#E2F40C",
            orange: "#EEAB46",
            white: "#FFFFFF",
            black: "#292525",
            blue: "#1E98DC", 
            red: "#D12D2D",
            purple: "#9253AF",
            green: "#4AAA5A",
            brown: "#A0522D"
          }
    end

end