require 'cdk'
require 'ostruct'

begin
  curses_win = Ncurses.initscr
  Ncurses.curs_set(0)
  cdkscreen = CDK::SCREEN.new(curses_win)
  CDK::Draw.initCDKColor
  mesg = ["</26/B>Hello!", "#{Ncurses.COLS}", "#{Ncurses.LINES}"]
  label = CDK::LABEL.new(cdkscreen, CDK::CENTER, CDK::CENTER, mesg, mesg.count, true, false)

  cdkscreen.refresh
  label.wait(' ')
  # .move(x, y, relative to prior location?, refresh automatically?)
  label.move(10, 10, false, true)
  label.wait(' ')
ensure
  CDK::SCREEN.endCDK
end
