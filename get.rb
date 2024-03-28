require 'json'

@items  = []
def get_for_browsers
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

  bookmarks.each do |browser, path|
    get_for_browser(browser, File.expand_path(path))
  end
end

def get_for_browser(browser, path)
  Dir.glob(path) do |file_path|
    bookmarks = JSON.parse(IO.read(file_path))
    bookmarks['roots'].each_value { |branch| iterate_bookmarks(browser, branch) }
  end
end

def iterate_bookmarks(browser, branch)
  if branch['type'] == 'folder'
    branch['children'].each { |child| iterate_bookmarks(browser, child) }
  else
    @items << {
      icon: { path: "./#{browser}_icon.png" },
      title: branch['name'], arg: branch['url'], subtitle: branch['url']
    }
  end
end

get_for_browsers

print JSON.dump({ items: @items  })
