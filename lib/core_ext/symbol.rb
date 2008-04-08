class Object
  
  # Corresponds with Merb's String#/
  def /(o)
    File.join(self.to_s, o.to_s)
  end
  
end