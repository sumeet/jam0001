IGNORE = ["TEMPLATE", "htmls"]
team_names = Dir.glob('*').select {|f| !IGNORE.include?(f) and File.directory? f}

`mkdir -p docs/htmls`

team_names.each do |tn|
  page = "https://github.com/langjam/jam0001/tree/main/#{tn}"
  cmd = ["monolith", page, '-j', '-o', "docs/htmls/#{tn}.html"]
  p cmd
  fail "bailing" unless system(*cmd)
end
