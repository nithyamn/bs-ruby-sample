require 'rubygems'
require 'selenium-webdriver'
# Input capabilities
username = ENV['BROWSERSTACK_USERNAME']
accessKey = ENV['BROWSERSTACK_ACCESS_KEY']
build_name = ENV['BROWSERSTACK_BUILD_NAME']
browserstack_local = ENV['BROWSERSTACK_LOCAL']
browserstack_local_identifier = ENV['BROWSERSTACK_LOCAL_IDENTIFIER']

puts(username)
puts(accessKey)
puts(build_name)
puts(browserstack_local)
puts(browserstack_local_identifier)
caps = Selenium::WebDriver::Remote::Capabilities.new
caps["os"] = "Windows"
caps["os_version"] = "10"
caps["browser"] = "Chrome"
caps["browser_version"] = "latest"
caps['javascriptEnabled'] = 'true'
caps['name'] = 'BStack-[Ruby] Sample Test' # test name
caps['build'] = build_name # CI/CD job or build name
caps['browserstack.local'] = browserstack_local
caps['browserstack.localIdentifier'] = browserstack_local_identifier
driver = Selenium::WebDriver.for(:remote,
  :url => "https://"+username+":"+accessKey+"@hub-cloud.browserstack.com/wd/hub",
  :desired_capabilities => caps)
# Searching for 'BrowserStack' on google.com
driver.navigate.to "http://localhost:8888"
sleep(5)
driver.navigate.to "http://www.google.com"
element = driver.find_element(:name, "q")
element.send_keys "BrowserStack"
element.submit
wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
begin
  wait.until { !driver.title.match(/BrowserStack/i).nil? }
  driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"passed", "reason": "Yaay! Title matched!"}}')
rescue
  driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"failed", "reason": "Oops! Title did not match"}}')
end
driver.quit 