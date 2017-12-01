require_relative "../autobrowser/autobrowser"
require "minitest/autorun"
require "minitest/pride"

class TestPactrakAAMS < Minitest::Test
  def setup
    @auto = AutoBrowser.new
    @user = "aochoa"
    @pass = "*********"
  end

  def teardown
    @auto.cleanup
  end

  def test_should_logon
    @browser = @auto.setup_browser "chrome"
    @browser.navigate.to "https://www.ibcinc.com/pactrak/aams"
    @browser.find_element( :id, 'username' ).send_keys @user
    @browser.find_element( :id, 'pass' ).send_keys @pass
    @browser.find_element( :id, 'logon_btn' ).click
    @auto.delay 5
    element = @browser.find_element( :id, 'activity_panel' )
    puts "Class: '#{ element.attribute( 'class' ) }'"
    assert_match /visible/, element.attribute( 'class' ), "logon did not succeed."
    @browser.find_element( :id, 'logout_link' ).click
  end

  def test_complete_master_search_fail_message
    #Fails because this is not an AirAMS master
    @browser = @auto.setup_browser "chrome"
    @browser.navigate.to "https://www.ibcinc.com/pactrak/aams"
    @browser.find_element( :id, 'username' ).send_keys @user
    @browser.find_element( :id, 'pass' ).send_keys @pass
    @browser.find_element( :id, 'logon_btn' ).click
    @auto.delay 5
    @browser.find_element( :id, 'master_num' ).send_keys "489 6604 3622"
    @browser.find_element( :id, 'master_search' ).click
    @auto.delay 8
    element = @browser.find_element( :id, 'answer_master' )
    puts "Class: '#{ element.attribute( 'class' ) }'"
    assert_match /error/, element.attribute( 'class' ), "search did not failed"
    @browser.find_element( :id, 'logout_link' ).click
  end

  def test_complete_master_search_was_successful
    #Should be successful search
    @browser = @auto.setup_browser "chrome"
    @browser.navigate.to "https://www.ibcinc.com/pactrak/aams"
    @browser.find_element( :id, 'username' ).send_keys @user
    @browser.find_element( :id, 'pass' ).send_keys @pass
    @browser.find_element( :id, 'logon_btn' ).click
    @auto.delay 5
    @browser.find_element( :id, 'master_num' ).send_keys "057 6042 2935"
    @browser.find_element( :id, 'master_search' ).click
    @auto.delay 8
    element = @browser.find_element( :id, 'answer_master' )
    assert_match '', element.attribute( 'class' ), "search failed"
    element = @browser.find_element( :id, 'answer' )
    puts "#{element.size}"
    assert_equal element.size.width, 721, "size did not match"
    assert_equal element.size.height, 508, "size did not match"
    @browser.find_element( :id, 'logout_link' ).click
  end

end
