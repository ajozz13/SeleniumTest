
require "selenium-webdriver"

class AutoBrowser
  attr_reader :driver, :wait

  def initialize
    drivers_path = File.absolute_path( __dir__ ) #"../drivers"
    drivers_path.sub! 'autobrowser', 'drivers'
    #puts "PATH: #{ drivers_path }"
    Selenium::WebDriver::Chrome.driver_path = "#{ drivers_path }/chromedriver"
    Selenium::WebDriver::Firefox.driver_path = "#{ drivers_path }/geckodriver"
    @wait = Selenium::WebDriver::Wait.new( :timeout => 10 )
  end

  def setup_browser type
    @driver = case type
      when "chrome"
        Selenium::WebDriver.for :chrome
      when "firefox"
        Selenium::WebDriver.for :firefox
      else
        raise "Browser #{ type } is not supported."
    end
    @driver
  end

  def cleanup
    unless @driver.nil?
        @driver.close
        @driver = nil
    end
  end

  def delay time=3
    sleep time
    time
  end

  def to_s
    "Driver: #{ @driver }"
  end
end
