class WWPassException < StandardError
  def initialize(message, reason = ' ')
    super message + reason
  end  
end