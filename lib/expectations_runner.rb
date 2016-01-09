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

class ExpectationsRunner < Mumukit::Hook
  include Mumukit

  def run_expectations!(request)
    terms = expectations_to_terms(request.expectations)

    file = Tempfile.new('mumuki.expectations')
    file.write(request.content)
    file.close

    command = "echo \"'#{file.path}'. #{terms}.\" |  #{swipl_path} -q -t main -f expectations/main.pl"
    JSON.parse(%x{#{command}})['expectationResults']
  end

  def expectations_to_terms(expectations)
    '[' + expectations.map do |e|
      "expectation('#{e['binding']}',#{inspection_to_term(e['inspection'])})"
    end.join(',') + ']'
  end

  def inspection_to_term(s)
    Inspection.parse(s).to_term
  end
end
