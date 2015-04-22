#!/usr/bin/swipl -q -g main -s

:- [expectations_runner].

main(_) :-
  read(Filename),
  read(Expectations),
  consult('expectations/expectations.pl'),
  consult(Filename),
  run_expectations(Expectations, Results),
  write_results(Results).

write_results(Results) :-
  write('{"expectationResults":['),
  forall(member(Result, Results), write_result(Result)),
  write(']}').


write_result(result(expectation(Binding, inspection(Inspection)), Result)) :-
  writef('{"expectation":{"binding":"%w", "inspection":"%w"},"result":%w}',
    [Binding, Inspection, Result]).


