
require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  def self.scrape_index_page(index_url)
    html = open(index_url) #opens
    webpage = Nokogiri::HTML(html) #organizes

    students = []

    webpage.css("div.roster-cards-container").each do |card|
      card.css("div.student-card a").each do |student|
        url = student.attribute("href").value
        location = student.css("p.student-location").text
        name = student.css("h4.student-name").text
        students << {name: name, location: location, profile_url: url}
      end
    end 
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url) 
    profile_page = Nokogiri::HTML(html)
    socials = []
    student_hash = {}

    profile_page.css("div.social-icon-container a").each do |index|
      socials << index.attributes["href"].value
    end

    socials.each do |social|
      if social.include?("twitter")
        student_hash[:twitter] = social
      elsif social.include?("linkedin")
        student_hash[:linkedin] = social
      elsif social.include?("github")
        student_hash[:github] = social
      else 
        student_hash[:blog] = social
      end
    end 
    student_hash[:profile_quote] = profile_page.css("div.profile-quote").text
    student_hash[:bio] =  profile_page.css("p").text
    student_hash
  end

end
