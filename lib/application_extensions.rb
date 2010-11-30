module ApplicationExtensions
  def url_sanitize(string)
    string.downcase.gsub(/[^[:alnum:]]/,'')
  end
end
