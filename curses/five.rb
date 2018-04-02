require 'curses'
require 'open3'

Curses.init_screen
Curses.curs_set(0) #invisible cursor

begin
  # build static window
  window1 = Curses::Window.new(Curses.lines - 1, Curses.cols / 2 - 1, 0, 0)
  #window1.box("|", "-")
  cur_x = 1
  cur_y = 1 
  File.foreach('test_list.txt') { |line|
    window1.setpos(cur_y, 1)
    window1.addstr(line)
    cur_y = cur_y + 1
  }
  window1.box("|", "-")
  window1.refresh
  
  # next window
  window2 = Curses::Window.new(Curses.lines - 1, Curses.cols / 2 - 1, 0, Curses.cols / 2 - 1)
  window2.nodelay = true
  window2.keypad = true
  window2.box("|", "-")
  window2.refresh

  current_ypos = window2.maxy / 2
  2.upto(window2.maxx - 3) do |i|
    window2.setpos(current_ypos, i)
    Curses.noecho
    input = window2.getch
    if input == Curses::Key::UP then
      current_ypos = current_ypos - 1
    elsif input == Curses::Key::DOWN then
      current_ypos = current_ypos + 1
    elsif input == "\t".ord then
      window1.setpos(cur_y, cur_x)
      window1.addstr("Tab Pressed!")
      window1.refresh
      cur_y = cur_y + 1
    elsif input == "l" then
      window1.clear
      cur_y = 1
      cur_x = 1
      o, s = Open3.capture2("ls -l")
      output = o.split("\n")
      output.each { |data|
        window1.setpos(cur_y, cur_x)
        window1.addstr(data)
        cur_y = cur_y + 1
      }
      window1.box("|", "-")
      window1.refresh
    end
    window2 << "*"
    window2.refresh
    sleep 0.15

  end

  sleep 0.5
  window1.clear
  window1.refresh
  window1.close
  sleep 0.5
  window2.clear
  window2.refresh
  window2.close
  sleep 0.5
rescue => ex
  Curses.close_screen
end
