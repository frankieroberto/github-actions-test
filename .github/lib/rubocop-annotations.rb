#!/usr/bin/env ruby

require 'json'
require 'octokit'

client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])

json = JSON.parse(STDIN.read)

offences_count = 0

json["files"].each do |file|
  offences_count += file["offenses"].size
end

if offences_count > 0
  puts "#{offences_count} code style issues need fixing"
  exit(1)
end
