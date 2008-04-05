module Kernel
  def acquire(*paths)
    
    paths.each do |path|
      # Do files first
      Dir[File.join(path, '*.rb')].each do |entry|
        require entry if File.file? entry
      end
      
      # Do dirs last, assuming their contents may depend on earlier definitions
      Dir[File.join(path, '*')].each do |entry|
        acquire entry if File.directory? entry
      end
    end
    
  end
end