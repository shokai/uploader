#!/usr/bin/env ruby

require 'lib/uploader'

token = 'token'

c = UploadClient.new
c.token = 'token'
ARGV.each{|i|
  begin
    url = c.upload(i, 'http://localhost:4567/')
  rescue => e
    STDERR.puts e
    next
  end
  puts url
}
