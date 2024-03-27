require 'json'

PROFILE="~/Library/Application Support/BraveSoftware/Brave-Browser/**/Bookmarks"

path = File.expand_path(PROFILE)

items = []

# recursivly iterate through the bookmarks where each branch is a root which has children and children is a folder type
def iterate_bookmarks(items, branch)
	if branch['type'] == 'folder'
		branch['children'].each do |child|
			items += iterate_bookmarks(items, child)
		end
	else
		items << { title: branch['name'], arg: branch['url'] }
	end
	return items
end

Dir.glob(path) do |file_path|

	bookmarks = JSON.parse(IO.read(file_path))
	bookmarks['roots'].each_value do |branch|
		items += iterate_bookmarks(items, branch)
	end
	# print json
  
  # Example of reading the file, uncomment if needed
  # File.read(file_path) do |content|
  #   puts content
  # end
end



query = ARGV[0]


print JSON.dump({ items:  })
