require 'curses'
require 'open3'

Curses.init_screen
Curses.curs_set(0) #invisible cursor
Curses.noecho

# 1)  Create 2 windows
# 2)  Tab changes which window has input/focus
# 3)  "l" lists directory
# 4)  "s" displays a test_list.txt in the correct window

def handle_footer(window3,window_name)
  footer_msg = "[#{window_name}] Press CTRL-C to quit.  \"l\" to list the current directory.  \"s\" to show the contents of the file.  <Tab> switches between active windows."
  window3.setpos(0,window3.maxx / 2- footer_msg.length / 2)
  window3.addstr(footer_msg)
end

begin
  # build static window 1
  #window1 = Curses::Window.new(Curses.lines - 1, Curses.cols / 2 - 1, 0, 0)
  window1 = Curses::Window.new(Curses.lines / 2, Curses.cols - 1, 0, 0)
  win1_cur_x = 1
  win1_cur_y = 1 
  window1.box("|", "-")
  window1.refresh
  # build static window 2
  #window2 = Curses::Window.new(Curses.lines - 1 , Curses.cols / 2 - 1, 0, Curses.cols / 2)
  window2 = Curses::Window.new(Curses.lines / 2 - 1, Curses.cols - 1, Curses.lines / 2, 0)
  win2_cur_x = 1
  win2_cur_y = 1
  window2.box("|", "-")
  window2.refresh
  # build window 3
  window3 = Curses::Window.new(0, Curses.cols - 1, Curses.lines - 1,0)
  window3.attrset(Curses::A_STANDOUT)

  
  window1.nodelay = true
  window1.keypad = true
  window2.nodelay = true
  window2.keypad = true
  window1.setpos(1,1)
  window2.setpos(1,1)

  active_win = window1
  window_name = "window1"
  handle_footer(window3,window_name)
  loop do
    if window3.touched? then
      window3.refresh
    end
    input = active_win.getch
    case input
    when "\t".ord
      if active_win == window1 then
        active_win = window2
        window_name = "window2"
      else
        active_win = window1
        window_name = "window1"
      end
      handle_footer(window3,window_name)
    when "l"
      active_win.clear
      y = 1
      o, s = Open3.capture2("ls -l")
      output = o.split("\n")
      output.each { |data|
        active_win.setpos(y, 1)
        active_win.addstr(data)
        y = y + 1
      }
      active_win.setpos(y,1)
    when "s"
      active_win.clear
      y = 1
      File.foreach('test_list.txt') { |line|
        active_win.setpos(y, 1)
        active_win.addstr(line)
        y = y + 1
      }
    else
      active_win.setpos(active_win.cury, active_win.curx)
      active_win.addstr(input)
    end
    active_win.box("|", "-")

    active_win.refresh
  end
rescue Exception => e
  Curses.addstr e.inspect + "\n"
  Curses.addstr e.backtrace.join("\n")
  Curses.getch
  Curses.close_screen
end
