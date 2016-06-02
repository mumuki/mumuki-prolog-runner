require 'json'
require 'mumukit/inspection'

class Mumukit::Inspection::PlainInspection
  def to_term
    "inspection('#{type}')"
  end
end

class Mumukit::Inspection::TargetedInspection
  def to_term
    "inspection('#{type}',#{Integer(target)})" rescue "inspection('#{type}','#{target}')"
  end
end

class Mumukit::Inspection::NegatedInspection
  def to_term
    "not(#{@inspection.to_term})"
  end
end

class ExpectationsHook < Mumukit::Templates::FileHook
  isolated true

  def command_line(filename)
    "#{swipl_path} -f #{filename} --quiet -t main 2>&1"
  end

  def compile_file_content(request)
    ExpectationsFile.new(request).render
  end

  def post_process_file(file, result, status)
    JSON.parse(result)['expectationResults'] rescue []
  end
end

class ExpectationsFile
  def initialize(request)
    @content = request.content
    @expectation_terms = self.class.expectations_to_terms(request.expectations)
  end

  def self.expectations_to_terms(expectations)
    '[' + expectations.map do |e|
      "expectation('#{e['binding']}',#{inspection_to_term(e['inspection'])})"
    end.join(',') + ']'
  end

  def self.inspection_to_term(s)
    Mumukit::Inspection.parse(s).to_term
  end

  def render
    ERB.new(File.read('lib/main.pl.erb')).result(binding)
  end
end
