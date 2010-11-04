ENV['DYLD_FRAMEWORK_PATH'] = ENV['BUILT_PRODUCTS_DIR']
Dir.glob(File.expand_path('../**/*_test.rb', __FILE__)).each { |test| require test }