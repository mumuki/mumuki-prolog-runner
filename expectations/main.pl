#!/usr/bin/swipl -q -g main -s

main(_) :-
  %read(Filename),
  read(Expectations),
  consult(expectations),
  %consult(Filename),
  run_expectations(Expectations, Results),
  write_results(Results).

run_expectations(Expectations, Results) :-
  maplist(eval_expectation, Expectations, Results).

eval_expectation(Expectation, result(Expectation, false)).

write_results(Results) :-
  write('{"expectationResults":['),
  forall(member(Result, Results), write_result(Result)),
  write(']}').

write_result(result(expectation(Binding, Inspection), Result)) :-
  writef('{"expectation":{"binding":"%w", "inspection":"%w"},"result":%w}',
    [Binding, Inspection, Result]).


