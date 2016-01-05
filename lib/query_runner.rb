require 'mumukit'

require_relative './with_swipl'

class QueryRunner < Mumukit::Hook
  include Mumukit::WithTempfile
  include Mumukit::WithCommandLine
  include WithSwipl

  def run_query!(request)
    eval_query(request.query, compile_query(request))
  end

  def compile_query(request)
    "#{request.extra}\n#{request.content}"
  end

  def eval_query(query, source)
    file = write_tempfile! source

    run_command "#{swipl_path} --quiet -f query/query_runner.pl -t \"main('#{query}','#{file.path}')\" 2>&1"
  ensure
    file.unlink
  end

end