predToHead(pred(PredicateName, Arity), Head) :-
  between(0, 9, Arity),
  functor(Head, PredicateName, Arity).

clauseElements(Predicate, Elements):-
	predToHead(Predicate, Head),
	clause(Head, Clause),
	clauseToList(Clause, Elements).

clauseToList((A,B), [A | BToList]):- clauseToList(B, BToList).
clauseToList(A, [A]):- functor(A,Name,_), Name \= (',').

usesPredicate(Predicate, UsedPredicate):-
	clauseElements(Predicate, Elements),
	member(ClauseElement, Elements),
	isOrContains(ClauseElement, UsedPredicate).

isOrContains(ClauseElement, Predicate):- predToHead(Predicate, ClauseElement).
isOrContains(ClauseElement, Predicate):-
	ClauseElement =.. [_|Args],
	member(Arg, Args),
	not(var(Arg)),
	isOrContains(Arg, Predicate).

%%	This would require a parametrized expectation
numberOfClauses(Predicate, Amount):-
	predToHead(Predicate, Head),
	findall(_,clause(Head,_), Clauses),
	length(Clauses, Amount).

recursive(Predicate):-
	usesPredicate(Predicate, Predicate).

hasForall(Predicate):-
	usesPredicate(Predicate, pred(forall,2)).

hasNot(Predicate):-
	usesPredicate(Predicate, pred(not,1)).

hasFindall(Predicate):-
	usesPredicate(Predicate, pred(findall,3)).

hasCut(Predicate):-
	usesPredicate(Predicate, pred(!,0)).