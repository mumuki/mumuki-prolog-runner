require 'mumukit'

#FIXME use ActiveSupport
class Object
  def try
    yield self
  end
end


class NilClass
  def try
    self
  end
end

#FIXME may be extracted to mumukit
class Feedback
  def initialize
    @suggestions = []
  end

  def check(key, &block)
    binding = block.call
    if binding
      @suggestions << I18n.t(key, binding)
    end
  end

  def build
    @suggestions.map { |it| "* #{it}" }.join("\n")
  end
end

class FeedbackRunner < Mumukit::Stub
  attr_accessor :content, :pointer, :test_results

  def run_feedback!(request, results)
    self.content = request.content
    self.test_results = results.test_results[0]
    self.pointer = TestCompiler.new_pointer(request)

    build_feedback [
        :missing_predicate,
        :operator_error,
        :clauses_not_together,
        :singleton_variables,
        :wrong_distinct_operator,
        :wrong_comma,
        :not_sufficiently_instantiated,
        :test_failed]
  end

  def build_feedback(checks)
    feedback = Feedback.new
    checks.each { |it| feedback.check(it, &c(it)) }
    feedback.build
  end

  def c(selector)
    lambda { self.send(selector) }
  end

  def wrong_distinct_operator
    (/.{0,9}(\/=|<>|!=).{0,9}/.match content).try do |it|
      {near: it[0]}
    end
  end

  def clauses_not_together
    (/Clauses of .*:(.*) are not together in the source-file/.match test_results).try do |it|
      {target: it[1]}
    end
  end

  def singleton_variables
    (/Singleton variables: \[(.*)\]/.match test_results).try do |it|
      {target: it[1]}
    end
  end

  def test_failed
    /test (.*): failed/ =~ test_results
  end

  def not_sufficiently_instantiated
    (/received error: (.*): Arguments are not sufficiently instantiated/.match test_results).try do |it|
      {target: it[1]}
    end
  end

  def operator_error
    (/ERROR: .*:(.*):.*: Syntax error: Operator expected/.match test_results).try do |it|
      {line: pointer.line_at(it[1].to_i) }
    end
  end


  def wrong_comma
    /ERROR: (.*): Full stop in clause-body\? Cannot redefine ,\/2/ =~ test_results
  end

  def missing_predicate
    (/.*:(.*): Undefined procedure: .*:(.*)/.match test_results).try do |it|
      {target: it[1],
       missing: it[2]} unless it[1].include? 'unit body'
    end
  end

end
