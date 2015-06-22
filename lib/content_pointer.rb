class ContentPointer
  def initialize(content, offset=0)
    @content = content
    @offset = offset
  end

  def line_at(n)
    @content.split("\n")[line_number n]
  end

  def line_number(n)
    n - @offset
  end
end
