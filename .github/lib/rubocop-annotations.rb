#!/usr/bin/env ruby

require 'json'
require 'octokit'

json = JSON.parse(STDIN.read)

offences_count = 0

json["files"].each do |file|
  offences_count += file["offenses"].size
end

if offences_count > 0

  client = Octokit::Client.new(:access_token => ENV.fetch('GITHUB_TOKEN'))

  client.create_pull_request_review(ENV.fetch("GITHUB_REPOSITORY"), ENV.fetch("PULL_REQUEST_NUMBER"), {
    event: 'REQUEST_CHANGES',
    body: "#{offences_count} code style issues need fixing"
  })

  exit(1)
end
