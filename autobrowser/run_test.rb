require_relative 'autobrowser'
=begin
  For a selaniume usage example view: https://gist.github.com/huangzhichong/3284966
  The AutoBrowser object is simply a selanium driver wrapper class. the object is the selanium driver
=end

ex_code = 0
begin
  print "start driver...."
  auto = AutoBrowser.new
  @browser = auto.setup_browser "chrome"
  print "done.  Navigating to"
  @browser.navigate.to "https://www.ibcinc.com/pactrak/aams"
  print "'#{ @browser.title }'....."
  puts "Done."

  @browser.find_element( :id, 'username' ).send_keys "aochoa"
  @browser.find_element( :id, 'pass' ).send_keys "********"
  @browser.find_element( :id, 'logon_btn' ).click
  auto.delay 5
  element = @browser.find_element( :id, 'activity_panel' )

  puts "classes: #{ element.attribute( 'class' ) } "
  puts "is displayed? #{ @browser.find_element( :id, 'master_num' ).displayed? }"
  #assert(  )
rescue Exception => ex
  STDERR.write ex
  puts ex.backtrace
  ex_code = 2
ensure
  auto.cleanup
  exit ex_code
end
