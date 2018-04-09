#!/usr/bin/env ruby

require 'mysql2'
require 'json'
require 'fileutils'

# Figure out where we'll be storing the output
destDir = ARGV[0]
FileUtils.mkdir_p destDir
destination = File.join(destDir, "concourse-mysql-resource.XXXXXX")

# Parse the credentials that are provided on STDIN
sSource = STDIN.read
source = JSON.parse(sSource)
host = source["source"]["host"]
user = source["source"]["user"]
password = source["source"]["password"]
database = source["source"]["database"]
version = previous_version = source["version"]["id"]

# Connect to the MySQL server and query for the specified row
client = Mysql2::Client.new(:host => host, :username => user, :password => password, :database => database)

ret = []
results = client.query("SELECT * FROM concourseresource WHERE id = #{version};")
result = nil
results.each do |r|
    result = r
end

# Write the results to the pre-defined location
File.open(destination, 'w') { |file| file.write(result.to_json) }

# Compile the metadata to make public to the Concourse users
metadata = []
ret = {
    "version": {
        "id": version
    },
    "metadata": metadata
}

# Return the expected JSON to STDOUT
puts ret.to_json