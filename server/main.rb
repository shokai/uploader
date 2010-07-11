#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack'
require 'erb'
require 'json'
require 'digest/md5'
require 'yaml'

begin
  @@config = YAML::load open(File.dirname(__FILE__) + '/config.yaml')
rescue
  puts 'config.yaml not found'
  exit 1
end
p @@config

def token?(token)
  return false if !token
  @@config['token'].each{|i|
    return true if i == token
  }
  false
end

post '/' do
  p params[:token]
  if !token?(params['token'])
    @mes = {'error' => 'token error'}.to_json
  else
    if !params[:data]
      @mes = {'error' => 'file data not found'}.to_json
    else
      filename = nil
      key = nil
      loop do
        now = Time.now
        time = "#{now.to_i}_#{now.usec}"
        key = "#{Digest::MD5.hexdigest(time)}"
        key += "."+params[:file_ext].downcase if params[:file_ext] and params[:file_ext].size > 0
        filename = File.dirname(__FILE__) + "/public/#{key}"
        break if !File.exists?(filename)
      end
      open(filename, 'w+b'){|f|
        f.write(params[:data])
        @mes = {
          'message' => 'success',
          'key' => key,
          'size' => params[:data].size
        }.to_json
      }
    end
  end
end

get '/' do
  erb :index
end
