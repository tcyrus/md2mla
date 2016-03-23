require 'uglifier'

task :default => ["build_mla", "build_apa"]

task :build_mla do
  puts "Browserifying"
  puts system("browserify -t coffeeify browser.md2mla.coffee > js/md2mla.js")

  puts "Building minified self-contained index.html"
  html = File.read('template_md2mla.html')
  bundled = html.split("\n").map{|line|
    if line =~ /\<script.*src=\"(.*)\"/
      path = $1
      js = Uglifier.compile(File.read(path))
      "<script type='text/javascript'>#{js}</script>"
    else
      line
    end
  }
  File.open('built/mla/index.html', 'w'){|f| f.puts bundled}
end

task :build_apa do
  puts "Browserifying"
  puts system("browserify -t coffeeify browser.md2apa.coffee > js/md2apa.js")

  puts "Building minified self-contained index.html"
  html = File.read('template_md2apa.html')
  bundled = html.split("\n").map{|line|
    if line =~ /\<script.*src=\"(.*)\"/
      path = $1
      js = Uglifier.compile(File.read(path))
      "<script type='text/javascript'>#{js}</script>"
    else
      line
    end
  }
  File.open('built/apa/index.html', 'w'){|f| f.puts bundled}
end
