require 'json'

require 'mumukit'
require 'mumukit/inspection'

class Mumukit::Inspection::PlainInspection
  def to_term
    "inspection('#{type}')"
  end
end

class Mumukit::Inspection::TargetedInspection
  def to_term
    "inspection('#{type}','#{target}')"
  end
end

class Mumukit::Inspection::NegatedInspection
  def to_term
    "not(#{@inspection.to_term})"
  end
end

class ExpectationsRunner
  include Mumukit

  def run_expectations!(expectations, content)
    terms = expectations_to_terms(expectations)

    file = Tempfile.new('mumuki.expectations')
    file.write(content)
    file.close

    command = "echo \"'#{file.path}'. #{terms}.\" | expectations/main.pl"
    JSON.parse %x{#{command}}
  end

  def expectations_to_terms(expectations)
    '[' + expectations.map do |e|
      "expectation('#{e['binding']}',#{inspection_to_term(e['inspection'])})"
    end.join('') + ']'
  end

  def inspection_to_term(s)
    Inspection.parse(s).to_term
  end
end