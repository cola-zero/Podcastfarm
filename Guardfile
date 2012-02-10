# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
end

guard 'spin', :rspec => false do
  # TestUnit
  watch(%r|^test/(.*)_test\.rb$|)
  watch(%r|^lib/(.*)([^/]+)\.rb$|)      { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb$|)     { "test" }
  watch(%r|^app/controllers/(.*)\.rb$|) { |m| "test/functional/#{m[1]}_test.rb" }
  watch(%r|^app/models/(.*)\.rb$|)      { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r|^lib/podcastfarm/(.*)\.rb$|) { |m| "test/unit/#{m[1]}_test.rb" }
end
