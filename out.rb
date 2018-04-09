#!/usr/bin/env ruby

require 'mysql2'
require 'json'
require 'fileutils'

sourceDir = ARGV[0]

# Read in and parse the credentials from STDIN
sSource = STDIN.read
source = JSON.parse(sSource)

host = source["source"]["host"]
user = source["source"]["user"]
password = source["source"]["password"]
database = source["source"]["database"]
table = source["source"]["table"]

column = source["params"]["column"]
value = source["params"]["value"]
sqlPath = source["params"]["sql_path"]

# Read in the JSON-ified SQL row from the indicated path
sourceFile = File.join(sourceDir, sqlPath)
outSQL = File.read(sourceFile)
sqlSource = JSON.parse(outSQL)
version = sqlSource["id"]

# Connect to the MySQL server and update the specified row
client = Mysql2::Client.new(:host => host, :username => user, :password => password, :database => database)
client.query("UPDATE #{table} SET #{column}=#{value} WHERE id = #{version};")

# Compile the metadata to make public to the Concourse users
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

# Return the expected JSON to STDOUT
puts ret.to_json