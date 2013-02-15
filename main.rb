require 'sinatra'

library_name = "mage_knight"

get "/#{library_name}.js" do
  concat_libs = []
  concat_libs << coffee(File.read("./lib/#{library_name}.coffee"))

  Dir['./lib/*.coffee'].each do |file|
    compiled_js = coffee(File.read(file))
    concat_libs << compiled_js unless concat_libs.include?(compiled_js)
  end

  content_type 'text/javascript'
  concat_libs.join("\n")
end

get '/specs.js' do
  concat_specs = Dir['./specs/*.coffee'].map do |file|
    File.read(file)
  end.join("\n")

  coffee concat_specs, bare: true
end