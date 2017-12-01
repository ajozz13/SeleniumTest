require_relative "../autobrowser"
require "minitest/autorun"
require "minitest/pride"

class TestAutoBrowser < Minitest::Test

  def setup
    @browser = AutoBrowser.new
  end

  def teardown
    @browser.cleanup
  end

  def test_exception_report
    err = assert_raises RuntimeError do
      msg = @browser.setup_browser "ie"
    end
    assert_match /not supported/, err.message
  end

  def test_setup_chrome
    @browser.setup_browser "chrome"
    refute_nil @browser, "Browser did not setup correctly for chrome"
  end

  def test_setup_firefox
    @browser.setup_browser "firefox"
    refute_nil @browser, "Browser did not setup correctly for firefox"
  end

  def test_delay_time
    @browser.setup_browser "chrome"
    st = @browser.delay
    assert_equal st, 3, "Sleep time #{ st } is not the expected 3"
  end

  def test_teardown_should_set_driver_to_nil
      @browser.setup_browser "chrome"
      @browser.cleanup
      assert_nil @browser.driver, "Browser driver should be nil."
  end

  def test_wait_until
    driver = @browser.setup_browser "chrome"
    driver.navigate.to "https://www.ibcinc.com/pactrak/aams"
    driver.find_element( :id, 'username' ).send_keys "aochoa"
    driver.find_element( :id, 'pass' ).send_keys "*******"
    driver.find_element( :id, 'logon_btn' ).click
    did_it_show = @browser.wait.until { driver.find_element( :id, 'activity_panel' ).displayed? }
    assert( did_it_show , "The element did not get displayed" )
  end

  def test_to_string
    driver = @browser.setup_browser "chrome"
    assert_match /::Chrome::/, "#{driver}", "The driver to_string did not work"
    driver = @browser.setup_browser "firefox"
    assert_match /::Firefox::/, "#{driver}", "The driver to_string did not work"
  end

end
