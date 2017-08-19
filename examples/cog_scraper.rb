# This is completely contrived, Nokogiri can do all this on its own but
# I want to give an example of concern separation & msg passing using Cogs.
# All this does is print out top level ruby or c++ source files in my github repo.
# Obviously more can be done and better.


require_relative '../cog'
require 'rest-client'
require 'nokogiri'

# cog names
cognection, cogmech, cogbot = nil

# cog instantiation
cognection = Cog.new(
  read_only: %i[response body],
  accessors: %i[url],
  args: {
    url: 'https://github.com/mark-jordanovic-lewis'
  }) do |args|
  args[:response] = RestClient.get args[:url]
  args[:body] = args[:response].body
end

repourl_grabber = Cog.new(
  read_only: %i[scraped_repos],
  accessors: %i[page_body],
  args: {
    scraped_repos: []
    }) do |args|
  page = Nokogiri::HTML(args[:page_body])
  page.css('a[class=text-bold]').each {|l| args[:scraped_repos] << l['href'] }
  args[:scraped_repos]
end

fileurl_grabber = Cog.new(
  read_only: %i[scraped_filepaths],
  accessors: %i[page_body],
  args: {
    scraped_filepaths: []
    }) do |args|
  page = Nokogiri::HTML(args[:page_body])
  page.css('a[class=js-navigation-open]').each do |l|
    args[:scraped_filepaths] << l['href'] if /(\.rb|\.cpp|\.h)/ =~ l['href']
  end
  args[:scraped_filepaths]
end


# cogbot passes the state around and causes the other cogs to turn when their state changes.
cogbot = Cog.new(
  read_only: %i[scraped_repos],
  accessors: %i[page_body],
  args: {
  }) do |args|
  cognection.turn
  repourl_grabber.page_body = cognection.body
  repourl_grabber.turn.each do |repo_url|
    cognection.url = "https://github.com#{repo_url}"
    fileurl_grabber.page_body = cognection.turn
    puts fileurl_grabber.turn
  end
end

cogbot.turn
