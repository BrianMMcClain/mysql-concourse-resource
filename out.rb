#!/usr/bin/env ruby

require 'mysql2'
require 'json'
require 'fileutils'

sSource = STDIN.read
source = JSON.parse(sSource)

sourceDir = ARGV[0]

host = source["source"]["host"]
user = source["source"]["user"]
password = source["source"]["password"]
database = source["source"]["database"]
table = source["source"]["table"]

column = source["params"]["column"]
value = source["params"]["value"]
sqlPath = source["params"]["sql_path"]

sourceFile = File.join(sourceDir, sqlPath)
outSQL = File.read(sourceFile)
sqlSource = JSON.parse(outSQL)
version = sqlSource["id"]

client = Mysql2::Client.new(:host => host, :username => user, :password => password, :database => database)
client.query("UPDATE #{table} SET #{column}=#{value} WHERE id = #{version};")

metadata = []
sqlSource.keys.each do |k|
    metadata << {"name": k, "value": sqlSource[k].to_s}
end

metadata << {"name": "timestamp", "value": Time.now.to_s}

ret = {
    "version": {
        "id": version.to_s
    },
    "metadata": metadata
}

puts ret.to_json