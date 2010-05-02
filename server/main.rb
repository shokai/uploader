#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack'
require 'json'
require 'digest/md5'

post '/' do
  if params["data"] and params["file_ext"]
    now = Time.now
    time = "#{now.to_i}_#{now.usec}"
    ext = params['file_ext'].downcase
    key = "#{Digest::MD5.hexdigest(time)}.#{ext}"
    open(File.dirname(__FILE__) + "/public/#{key}", 'w+b'){|f|
      f.write(params["data"])
    }
    @mes = {
      'message' => 'success',
      'key' => key
    }.to_json
  else
    @mes = {"message" => 'error'}.to_json
  end
end

get '/' do
  redirect './readme'
end
