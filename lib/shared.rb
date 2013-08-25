class GameObject
    attr_accessor :x, :y, :width, :height, :surface
    
    def initialize x, y, surface
        @x = x
        @y = y
        @surface = surface
        @width = surface.width
        @height = surface.height
    end
    
    def update
    end
    
    def draw screen
        @surface.blit screen, [@x, @y]
    end
    
    def handle_event event
    end
    
    def center_x w
        @x = w/2-@width/2
    end
    
    def center_y h
        @y = h/2-@height/2
    end
end

class Text < GameObject
    def initialize x=0, y=0, text="Hello, World!", size=48
        @font = Rubygame::TTF.new "media/font.ttf", size
        @text = text
        super x, y, rerender_text()
    end
    
    def rerender_text
        @width,@height = @font.size_text(@text)
        @surface = @font.render(@text, true, [255, 255, 255])
    end
    
    def text
        @text
    end
    
    def text= string
        @text = string
        rerender_text
    end
end

class State
    def update
    end
    
    def draw
    end

    def state_change way
    end
end