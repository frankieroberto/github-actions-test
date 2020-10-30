#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'octokit'

json = JSON.parse(STDIN.read)

offences_count = 0

json['files'].each do |file|
  offences_count += file['offenses'].size
end

client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'))

repo = ENV.fetch('GITHUB_REPOSITORY')
pr = ENV.fetch('PULL_REQUEST_NUMBER')

if offences_count.zero?
  client.create_pull_request_review(repo, pr, event: 'APPROVE')
else
  client.create_pull_request_review(
    repo,
    pr,
    event: 'REQUEST_CHANGES',
    body: "#{offences_count} code style issues need fixing"
  )

  exit(1)
end
