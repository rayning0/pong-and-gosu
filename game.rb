require 'rubygame'
require 'ruby-sdl-ffi'
require './lib/shared.rb'
require './lib/pause.rb'
require './lib/about.rb'
require './lib/title.rb'
require './lib/ingame.rb'

Rubygame::TTF.setup

class Game
    attr_accessor :screen, :queue, :clock, :state
    def initialize
        @screen = Rubygame::Screen.new [640, 480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
        @screen.title = "Pong"
        
        @queue = Rubygame::EventQueue.new
        @clock = Rubygame::Clock.new
        @clock.target_framerate = 60
        
        # The state has to be changed by the developer
        # using the game class, or else the game won't
        # start successfully
        @state = nil
        @state_buffer = nil
    end
    
    def run!
        loop do
            update
            draw
            @clock.tick
        end
    end
    
    def update
        @queue.peek_each do |ev|
            case ev
                when Rubygame::QuitEvent
                    Rubygame.quit
                    exit
                when Rubygame::KeyDownEvent
                    # This is somewhat of a hack since EventQueue#push seems to
                    # add on events while your still looping over the queue, meaning
                    # that if we handle this in the Title state, the QuitEvent will
                    # be processed before the Game class can see it
                    if ev.key == Rubygame::K_ESCAPE and @state.class == Title
                        @queue.push Rubygame::QuitEvent.new
                    end
            end
        end
        @state.update
        if @state_buffer != nil
            @state = @state_buffer
            @state_buffer = nil
        end
    end
    
    def draw
        @state.draw
    end
    
    def switch_state state
        if @state != nil
            @state.state_change(:going_out)
            @state_buffer = state
        else
            @state = state
        end
        state.state_change(:going_in)
    end
end

g = Game.new
g.switch_state Title.new(g)
g.run!