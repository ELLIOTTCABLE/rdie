class Object
  
  # Yes, slightly more verbose. Yes, slightly more semantic and beautiful.
  # Most of all, it's just... different.
  def on_execute(file, &block)
    yield if $0 == file
  end
  
end