#! /home/edderic/.rvm/rubies/ruby-2.1.3/bin/ruby

require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'yaml'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.google.com'

class Person
  attr_reader :first_name, :last_name, :genderLetter
  def initialize(args)
    @first_name = args['first_name']
    @last_name = args['last_name']
    @genderLetter = args['genderLetter']
  end

  def email
    "#{@first_name.gsub(' ','')}.#{@last_name.split(' ')[0]}"
  end

  def gender
    @genderLetter == "F" ? "FEMALE" : "MALE"
  end

  def name
    "#{@first_name} #{@last_name}"
  end
end

class EmailCreator
  include Capybara::DSL
  def initialize(person, common)
    puts "...Processing..."
    puts "name: #{person.name}"
    puts "email: #{person.email}"
    puts "password: #{common['password']}"

    visit(common.fetch('mail_creation_page'))

    fill_in 'First Name', with: person.first_name
    fill_in 'Last Name', with: person.last_name
    find("select [value='#{person.gender}']").select_option
    find('select.MonthPos option[value="1"]').select_option
    find('select.DayPos option[value="01"]').select_option
    find('select.YearPos option[value="24"]').select_option
    find('.EmailAddress input[type="text"]').set person.email
    find('input[name*="RowPassword:Field"]').set common['password']
    find('input[name*="RowPasswordRetype:Field"]').set common['password']
    find(".SecurityQuestion option[value='#{common['question_id']}']").select_option
    fill_in "Your Answer", with: "#{common['answer']}"

    puts "Do next person? (y)"
    ans = nil
    until (ans == 'y' || ans == 'Y') do
      ans = STDIN.gets.chomp
    end
  end
end

file_path = "#{Dir.pwd}/#{ARGV[0]}"

puts "Reading #{file_path}"
people_file = File.read(file_path)
people_yaml = YAML.load(people_file)
common = people_yaml['common']
people = people_yaml['people']

people.each do |person_hash|
  person = Person.new(person_hash)
  EmailCreator.new(person, common)
end
