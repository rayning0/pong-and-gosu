class Laser
    attr_reader :x, :y
    
    def initialize(player, window)
        @player = player
        @window = window
        @shooting = false
        @icon = Gosu::Image.new(@window, "laser.png", true)
        @x = @player.x + @player.icon.width / 2
        @y = @player.y
    end
    
    def shoot
        @shooting = true
    end
    
    def update
        if @shooting
            @y -= 10
            if @y < 0
                @shooting = false
            end
        else
            @x = @player.x + @player.icon.width / 2
            @y = @player.y
        end
    end
    
    def draw
        if @shooting
            @icon.draw(@x, @y, 4)
        else
            @icon.draw(@player.x + @player.icon.width / 2, @player.y, 4)
        end
    end
    
end