See /screenshots folder for pics of Pong game. See /gosu folder for space invaders-like Gosu game, with screenshots.

This weekend (April 14, 2013), I spent hours creating this Pong game in Ruby with the Rubygame API (http://rubygame.org/) and learning about video game programming, with this tutorial: Making games with Ruby:
http://devel.manwithcode.com/making-games-with-ruby.html. Unfortunately, the sound part of Rubygame does not work: http://devel.manwithcode.com/making-games-with-ruby.html#8

I spent much blood, sweat, and tears beating my head against the wall about this and trying to figure out a multimedia library called SDL Mixer, which is unfortunately written in C: http://jcatki.no-ip.org:8080/SDL_mixer/

Finally giving up on getting sound to work with Rubygame, I switched to Ruby-SDL-FFI (https://github.com/jacius/ruby-sdl-ffi) and got some sound to work while playing the game. There are still a lot of technical problems though.  

I also created a very primitive "space invader"-like game with Gosu (http://www.libgosu.org/) a more primitive Ruby game development API than Rubygame. I went through this whole tutorial: https://sites.google.com/a/ruby4kids.com/gosu/home
Also: http://ruby4kids.com/ruby4kids/public/web_page/14

Part of the problem is these game libraries have not been updated for years, so probably something is obsolete or incompatible with my newer software and Mac. We need an updated Ruby game development API. Plus the documentation for SDL Mixer for C code and written in Sanskit for all I care. 
