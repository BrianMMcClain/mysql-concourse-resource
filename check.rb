#!/usr/bin/env ruby

# {
#   "source": {
#     "host": "...",
#     "user": "...",
#     "password": "..."
#     "database": "..."
#     "table": "..."
#   },
#   "version": { "id": 1423 }
# }

require 'mysql2'
require 'json'

sSource = ARGF.read
source = JSON.parse(sSource)

host = source["source"]["host"]
user = source["source"]["user"]
password = source["source"]["password"]
database = source["source"]["database"]

STDERR.puts source
STDERR.puts source["version"]

previous_version = 0
if source.has_key?("version") and not source["version"].nil?
    previous_version = source["version"]["id"]
end

client = Mysql2::Client.new(:host => host, :username => user, :password => password, :database => database)

ret = []
results = client.query("SELECT * FROM concourseresource WHERE id > #{previous_version};")
results.each do |r|
    ret << { "id": "#{r["id"]}"}
end

puts ret.to_json