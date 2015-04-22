#!/usr/bin/swipl -q -g main -s

main(_) :-
  read(Filename),
  read(Expectations),
  consult('expectations/expectations.pl'),
  consult(Filename),
  run_expectations(Expectations, Results),
  write_results(Results).

run_expectations(Expectations, Results) :-
  maplist(run_expectation, Expectations, Results).

run_expectation(Expectation, result(Expectation, Result)) :- eval_expectation(Expectation,Result).

eval_expectation(expectation(Binding, inspection('HasBinding')), true) :-
  usesPredicate(Binding, _), !.
eval_expectation(expectation(Binding, inspection('HasForall')), true) :-
  hasForall(Binding), !.
eval_expectation(expectation(Binding, inspection('HasFindall')), true) :-
  hasFindall(Binding), !.
eval_expectation(expectation(Binding, inspection('HasNot')), true) :-
  hasNot(Binding), !.
eval_expectation(expectation(Binding, inspection('HasUsage', Other)), true) :-
   usesPredicate(Binding, Other), !.
eval_expectation(_, false).


write_results(Results) :-
  write('{"expectationResults":['),
  forall(member(Result, Results), write_result(Result)),
  write(']}').


write_result(result(expectation(Binding, inspection(Inspection)), Result)) :-
  writef('{"expectation":{"binding":"%w", "inspection":"%w"},"result":%w}',
    [Binding, Inspection, Result]).


