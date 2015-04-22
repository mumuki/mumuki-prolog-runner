:- ['../expectations_runner'].

comparing_pred(X):- X > 3.
negating_pred(X):- between(1,5,X), not(X > 3).
listing_pred(Xs):- findall(X, between(1,5,X), Xs).
complex_pred(_):- forall((between(1,5,X), A is X + 2), not(A = 2)).

:- begin_tests(expectations).

test(does_not_detect_positive_expectations_when_absent):-
  run_expectations(
    [expectation(listing_pred, inspection('HasNot'))],
    [result(expectation(listing_pred, inspection('HasNot')), false)]).

test(detects_positive_expectations_when_present):-
  run_expectations(
    [expectation(listing_pred, inspection('HasFindall'))],
    [result(expectation(listing_pred, inspection('HasFindall')), true)]).

test(detects_negative_expectations):-
  run_expectations(
    [expectation(listing_pred, not(inspection('HasNot')))],
    [result(expectation(listing_pred, not(inspection('HasNot'))), true)]).

test(detects_targeted_expectations_when_present):-
  run_expectations(
    [expectation(negating_pred, inspection('HasUsage', between))],
    [result(expectation(negating_pred, inspection('HasUsage', between)), true)]).


test(does_not_detect_targeted_expectations_when_absent):-
  run_expectations(
    [expectation(listing_pred, inspection('HasUsage', between))],
    [result(expectation(listing_pred, inspection('HasUsage', between)), false)]).


:- end_tests(expectations).
