#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack'
require 'json'
require 'digest/md5'

post '/' do
  if !params["data"]
    @mes = {"message" => 'error'}.to_json
  else
    now = Time.now
    time = "#{now.to_i}_#{now.usec}"
    ext = params['file_ext'].downcase if params['file_ext']
    key = "#{Digest::MD5.hexdigest(time)}.#{ext}"
    open(File.dirname(__FILE__) + "/public/#{key}", 'w+b'){|f|
      f.write(params["data"])
      @mes = {
        'message' => 'success',
        'key' => key,
        'size' => params['data'].size
      }.to_json
    }
  end
end

get '/' do
  redirect './readme'
end
