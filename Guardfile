# More info at https://github.com/guard/guard#readme

directories %w(lib spec).select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

guard :rspec, cmd: 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^examples/(.+)\.rb$}){ |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
