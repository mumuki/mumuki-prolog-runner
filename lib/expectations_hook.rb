class PrologExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  def language
    'Prolog'
  end

  def compile_content(content)
    content.strip
  end
end
