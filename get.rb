require 'json'

def get_for_browsers(items)
  bookmarks = {
    "brave": '~/Library/Application Support/BraveSoftware/Brave-Browser/*/Bookmarks',
    "brave_beta": '~/Library/Application Support/BraveSoftware/Brave-Browser-Beta/*/Bookmarks',
    "chrome": '~/Library/Application Support/Google/Chrome/*/Bookmarks',
    "chromium": '~/Library/Application Support/Chromium/*/Bookmarks',
    "opera": '~/Library/Application Support/com.operasoftware.Opera/Bookmarks',
    "sidekick": '~/Library/Application Support/Sidekick/*/Bookmarks',
    "vivaldi": '~/Library/Application Support/Vivaldi/*/Bookmarks',
    "edge": '~/Library/Application Support/Microsoft Edge/*/Bookmarks',
    "arc": "~/Library/Application Support/Arc/User Data/*/Bookmarks",
  }

  bookmarks.each { |browser, path| get_for_browser(browser, File.expand_path(path), items) }
  items
end

def get_for_browser(browser, path, items)
  Dir.glob(path) do |file_path|
    bookmarks = JSON.parse(IO.read(file_path))
    bookmarks['roots'].each_value { |branch| iterate_bookmarks(browser, branch, items) }
  end
end

def iterate_bookmarks(browser, branch, items)
  if branch['type'] == 'folder'
    branch['children'].each { |child| iterate_bookmarks(browser, child, items) }
  else
    items << {
      icon: { path: "./#{browser}_icon.png" },
      title: branch['name'], arg: branch['url'], subtitle: branch['url']
    }
  end
end

print JSON.dump({ items: get_for_browsers([])  })
