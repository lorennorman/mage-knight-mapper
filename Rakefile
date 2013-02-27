require 'coffee-script'

library_name = "mage_knight"

task :build do
  concat_libs = []
  concat_libs << CoffeeScript.compile(File.read("./lib/#{library_name}.coffee"))

  Dir['./lib/*.coffee'].each do |file|
    compiled_js = CoffeeScript.compile(File.read(file))
    concat_libs << compiled_js unless concat_libs.include?(compiled_js)
  end

  File.write "./public/build/#{library_name}.js", concat_libs.join("\n")
end

desc "Generate a source and spec file pair in the correct load path"
task :generate_resource, [:resource_name] do |t, args|
  raise "Usage: rake generate_resource [resource_name]" unless args.resource_name

  resource_path = "lib/#{args.resource_name}.coffee"
  resource_spec = "specs/#{args.resource_name}_spec.coffee"

  raise "File already exists." if [resource_path, resource_spec].any? do |file|
    File.exists?(file)
  end

  class_name = args.resource_name.capitalize

  # Render the source template into lib/
  File.write resource_path,
<<-RESOURCE_FILE
class #{class_name}
  constructor: (opts={}) ->

MageKnight.#{class_name} = #{class_name}
RESOURCE_FILE

  # Render the spec template into spec/
  File.write resource_spec,
<<-RESOURCE_SPEC
describe "#{class_name}", ->
  it "exists!", ->
    (expect MageKnight.#{class_name}).not.to.be undefined

RESOURCE_SPEC
end


task :default => :build
