# This is completely contrived, Nokogiri can do all this on its own but
# I want to give an example of concern separation & msg passing using Cogs.
# All this does is print out top level ruby or c++ source files in my github repo.
# Obviously more can be done and better.

require_relative '../cog'
require 'rest-client'
require 'nokogiri'

# ========= #
# cog names #
# ========= #

cognection, cogmech, cogbot = nil

# ================= #
# cog instantiation #
# ================= #

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
  # simple page scraping
  page = Nokogiri::HTML(args[:page_body])
  page.css('a[class=text-bold]').each do |l|
    args[:scraped_repos] << "https://github.com#{l['href']}"
  end
  # yield list of repos
  args[:scraped_repos]
end

fileurl_grabber = Cog.new(
  read_only: %i[scraped_fileurls],
  accessors: %i[page_body],
  args: {
    scraped_fileurls: []
    }) do |args|
  args[:scraped_fileurls].clear
  # simple page scraping
  page = Nokogiri::HTML(args[:page_body])
  page.css('a[class=js-navigation-open]').each do |l|
    if /(\.rb|\.cpp|\.h)/ =~ l['href']
      args[:scraped_fileurls] << "https://github.com#{l['href']}"
    end
  end
  # yield list of file urls
  args[:scraped_fileurls]
end


# cogbot passes the state around and causes the other cogs to turn when their state changes.
cogbot = Cog.new(
  read_only: %i[scraped_repos],
  accessors: %i[page_body],
  args: {
  }) do |args|
  # turn cognection cog in init state
  cognection.turn
  # pass body to page parser
  repourl_grabber.page_body = cognection.body
  # turn repourl_grabber cog
  repourl_grabber.turn.each do |repo_url|
    # change url to get
    cognection.url = repo_url
    # turn the crank again on cognection
    fileurl_grabber.page_body = cognection.turn
    # output results of filename scrape, yield nil (o/p of puts)
    puts fileurl_grabber.turn
  end
end

cogbot.turn
