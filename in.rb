#!/usr/bin/env ruby

require 'mysql2'
require 'json'
require 'fileutils'

destDir = ARGV[0]
FileUtils.mkdir_p destDir
destination = File.join(destDir, "concourse-mysql-resource.XXXXXX")

sSource = STDIN.read
source = JSON.parse(sSource)

host = source["source"]["host"]
user = source["source"]["user"]
password = source["source"]["password"]
database = source["source"]["database"]
version = previous_version = source["version"]["id"]

client = Mysql2::Client.new(:host => host, :username => user, :password => password, :database => database)

ret = []
results = client.query("SELECT * FROM concourseresource WHERE id = #{version};")
result = nil
results.each do |r|
    result = r
end

File.open(destination, 'w') { |file| file.write(result.to_json) }

metadata = []
ret = {
    "version": {
        "id": version
    },
    "metadata": metadata
}

puts ret.to_json