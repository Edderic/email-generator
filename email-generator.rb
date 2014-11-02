#! /home/edderic/.rvm/rubies/ruby-2.1.3/bin/ruby

require 'rubygems'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.google.com'

def create_mail_page
  "https://service.mail.com/registration.html?edition=us&lang=en&device=desktop#.23140-header-getaccount1-1"
end

module MyCapybaraTest
  class EmailCreator
    include Capybara::DSL
    def create
      visit(create_mail_page)
      fill_in 'First Name', with: 'Karla'
      fill_in 'Last Name', with: 'Buri-Tenezaca'
      find('select [value="FEMALE"]').select_option
      find('select.MonthPos option[value="1"]').select_option
      find('select.DayPos option[value="01"]').select_option
      find('select.YearPos option[value="24"]').select_option
      find('.EmailAddress input[type="text"]').set 'fakeEmailAddress'
      find('input[name="ListRegistrationData:3:ItemRegistrationData:BorderBoxRegistrationData:PanelRegistrationData:panelSetPassword:RowPassword:Field"]').set 'abcdefg1@'
      find('input[name="ListRegistrationData:3:ItemRegistrationData:BorderBoxRegistrationData:PanelRegistrationData:panelSetPassword:RowPasswordRetype:Field"]').set 'abcdefg1@'


      sleep(5)
    end
  end
end

emailCreator = MyCapybaraTest::EmailCreator.new
emailCreator.create
