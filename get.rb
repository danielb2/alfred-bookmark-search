require 'json'

PROFILE="~/Library/Application Support/BraveSoftware/Brave-Browser/*/Bookmarks"

path = File.expand_path(PROFILE)

@items = []

def iterate_bookmarks(branch)
  if branch['type'] == 'folder'
    branch['children'].each do |child|
      iterate_bookmarks(child)
    end
  else
    @items << { title: branch['name'], arg: branch['url'], subtitle: branch['url'] }
  end
end

Dir.glob(path) do |file_path|
  bookmarks = JSON.parse(IO.read(file_path))
  bookmarks['roots'].each_value do |branch|
    iterate_bookmarks(branch)
  end
end

print JSON.dump({ items: @items  })
