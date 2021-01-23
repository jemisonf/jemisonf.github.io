require 'fileutils'
require 'optparse'

options = {}

OptionParser.new do |opts|
    opts.banner = "Usage: mkpost.rb --name my-post-file --year 1970 --day 1 --month 1"

    opts.on("--year=YEAR", "--year YEAR", "-y YEAR", "year of the post") do |y|
        options[:year] = y
    end
    opts.on("-day=DAY", "--day DAY", "-d DAY", "day of the post") do |d|
        options[:day] = d
    end
    opts.on("--month=MONTH", "--month MONTH", "-m MONTH", "month of the post") do |m|
        options[:month] = m
    end

    opts.on("--name=NAME", "--name NAME", "-n NAME", "name of the post") do |n|
        options[:name] = n
    end
end.parse!

puts Dir.getwd

FileUtils.cp("#{Dir.getwd}/_posts/template.md", "#{Dir.getwd}/_posts/#{options[:year]}-#{options[:month]}-#{options[:day]}-#{options[:name]}.md")