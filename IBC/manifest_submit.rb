require_relative "../autobrowser/autobrowser"
require "minitest/autorun"
require "minitest/pride"

#http://docs.seattlerb.org/minitest/Minitest/Assertions.html
#https://gist.github.com/huangzhichong/3284966

class TestManifestSubmit < Minitest::Test
  def setup
    @auto = AutoBrowser.new
    @browser = @auto.setup_browser "chrome"
    @browser.navigate.to "https://www.ibcinc.com/manifest-submit"
  end

  def teardown
    @auto.cleanup
  end

  def test_should_submit_test
    to_email = "it@ibcinc.com"
    my_email = "aochoa@ibcinc.com"
    man_id = "20175677-a"
    flight_date = "2017-11-17"
    flight_origin = "bog"
    flight_destination = "nyc"
    flight_id = "aa123"
    master = "18056423441"
    data = "12,,123456789,,,,\"LHR\",\"USA\",,,,,1,\"0.44\",\"P\",\"APX\",,10,,\"ADHESIVE CHEMICALS\",,,\"P\",\"P\",\"ST\",,,,,,\"SOME COMPANY A\",\"123 MAIN STREET\",,\"LONDON\",,\"LE4 6BW\",\"GB\",\"+442087594076\",\"HUGO JORGE\",\"COMPANY 1\",\"211 BOSTON STREET\",\"MIDDLETON\",\"MASSACHUSETTS\",\"MA\",\"01949\",\"US\",5085551212,joe@example.com,\"123-45-6789\",\"THIS IS A COMMENT\"\n12,,125353363,,,,\"LHR\",\"MEX\",,,,,1,\"1.1\",\"P\",\"APX\",,1,,\"MUSIC CD\",,,\"P\",\"P\",\"ST\",,,,,,\"SOME COMPANY A\",\"123 MAIN STREET\",,\"LONDON\",,\"LE4 6BW\",\"GB\",\"+442087594076\",\"SERGIO HERRERO\",\"COMPANY 2\",\"CDA DEL RAYO 20, COL LA HERRADURA\",\"EDO DE MEXICO\",\"MEXICO\",,53920,\"MX\",,eli.smith@example.com,,\"THIS IS A MUCH LONGER COMMENT BUT IT STILL WORKS\""

    @browser.find_element( :id, 'to_email' ).send_keys to_email
    @browser.find_element( :id, 'email_list' ).send_keys my_email
    @browser.find_element( :id, 'man_id' ).send_keys man_id
    #select any date from the date selector
    selector = @browser.find_element( :xpath, '//*[@id="date_flight"]/div[1]' )
    selector.click  #callup the datepicker
    selector.find_element( :xpath, ".//div[1]/table[1]/tbody[1]/tr[2]/td[1]" ).click

    @browser.find_element( :id, 'origin' ).send_keys flight_origin
    @browser.find_element( :id, 'destination' ).send_keys flight_destination
    @browser.find_element( :id, 'flight_id' ).send_keys flight_id
    @browser.find_element( :id, 'master' ).send_keys master
    #Test mode checkbox
    @browser.find_element( :xpath, '//*[@id="testing"]/parent::div'  ).click

    @browser.find_element( :id, 'aams_data' ).send_keys data
    @browser.find_element( :id, 'send_form' ).click
    @auto.delay 5
    element = @browser.find_element(:id, "msg-header")
    assert( element.displayed?, "Can't see popup window" )
    assert( element.text.include?( "Thank you" ),"Thank you did not show up?" )
    element = @browser.find_element( :id, 'msg_desc' )
    assert_match /input is being tested/, element.text, "The message was not displayed?"
  end

  def test_should_check_bad_manifest
    master = "1805642344"
    element = @browser.find_element( :id, 'master' )
    element.send_keys master, :tab
    assert_match /true/, element.attribute( 'aria-invalid' ), "The auto-validation did not work"
  end

end
