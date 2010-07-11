#!/usr/bin/env ruby
# upload client for MacOSX
require 'rubygems'
require 'net/http'
require 'uri'
require 'open-uri'
require 'json'

class UploadClient

  def initialize
    @token = 'token'
  end

  def token=(t)
    @token = t
  end

  def upload(filename, url)
    open(filename, 'rb'){|f|
      bin = f.read
      boundary = '----UPLOADER_BOUNDARY----'
      file_ext = ''
      file_ext = file.split(/\./).last if file =~ /\..+/
      data = <<EOF
--#{boundary}\r
content-disposition: form-data; name="file_ext"\r
\r
#{file_ext}\r
--#{boundary}\r
content-disposition: form-data; name="token"\r
\r
#{@token}\r
--#{boundary}\r
content-disposition: form-data; name="data"\r
\r
#{bin}\r
--#{boundary}--\r
EOF
  
      header = {
        'Content-Length' => data.size.to_s,
        'Content-type' => "multipart/form-data; boundary=#{boundary}"
      }
      
      uploader = URI.parse(url)
      Net::HTTP.start(uploader.host, uploader.port) {|http|
        response = http.post(uploader.path, data, header)
        begin
          p res = JSON.parse(response.body)
          if res['error']
            throw #{res['error']}
          end
          if res['size'].to_i != bin.size
            throw 'file size error!'
          end
          if res['key']
            return url = "#{url}#{res['key']}"
          end
        rescue => e
          throw e
        end
      }
    }
  end
end
