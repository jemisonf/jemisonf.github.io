puts "Creating Project -----\n"

puts "Project name: "
name = gets.chomp

puts "Short project description: "
desc = gets.chomp

puts "Project url: (https://github.com/$name) "
github = gets.chomp
github = "https://github.com/jemisonf/#{name}" if github.length == 0

File.open("./_projects/#{name}.md", "w") do |f|
    f.puts "---\n"
    f.puts "name: #{name}\n"
    f.puts "short_description: #{desc}\n"
    f.puts "github: #{github}\n"
    f.puts "layout: project\n"
    f.puts "---\n"
    f.puts "\n"
    f.puts "#{desc}"
end
