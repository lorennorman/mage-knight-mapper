require 'coffee-script'

library_name = "mage_knight"

task :build do |t|
  concat_libs = []
  concat_libs << CoffeeScript.compile(File.read("./lib/#{library_name}.coffee"))

  Dir['./lib/*.coffee'].each do |file|
    compiled_js = CoffeeScript.compile(File.read(file))
    concat_libs << compiled_js unless concat_libs.include?(compiled_js)
  end

  File.write "./lib/build/#{library_name}.js", concat_libs.join("\n")
end

task :default => :build