module Mumuki::FileTestCompiler

  def create_compilation_file!(test, content)
    file = Tempfile.new("mumuki.#{id}.compile")
    file.write(compile(test, content))
    file.close
    file
  end

end
