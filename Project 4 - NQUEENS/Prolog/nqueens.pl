%Write a Prolog (do not use Constraint Logic Programming features of ECLiPSe) procedure nqueens(+Nat, ?Solution) with Nat being the number of queens, n, to be placed on a commen-surate chess board, that succeeds when Solution is a list, in increasing order, of the n squares on which one of the n queen can be safely placed.
%For example, nqueens(8, [3, 13, 18, 32, 33, 47, 52, 62]) succeeds.
%For example, nqueens(8, S) returns all the solutions through backtracking.


% finds rows and converts to squares, format output
nqueens(N,SortSquares) :-
    range(1,N,Us),
    queens(Us,[],Qs),
    convert2square(Qs, 1, Squares, N),	%proper numbering of squares
    sort(Squares, SortSquares).

% places a queen based on existing queens
queens([],Qs,Qs).
queens(Us,Ps,Qs) :-
    select(Q,Us,Us1),
    \+ attack(Q,Ps), % no room for attack from already placed queens
    queens(Us1,[Q|Ps],Qs).

% Generates all possible rows
range(J,J,[J]).
range(I,J,[I|Ns]) :-
    I < J, I1 is I + 1, range(I1,J,Ns).

% sets conditions for an attack to happen given existing queens
attack(Q,Qs) :- attack(Q,1,Qs).
attack(X,N,[Y|_]) :- X is Y + N.	%row up
attack(X,N,[Y|_]) :- X is Y - N.	%row down
attack(X,N,[_|Ys]) :-
    N1 is N + 1, attack(X,N1,Ys).	%diagonal

% convert the labeling of queens from row placed to square on board
convert2square([], _ , [], _).
convert2square([Row|Tail], Col, Sqs, N) :- Sq is (((Row-1)*N)+Col), Sqs = [Sq|NewSqs], NewCol is Col+1, convert2square(Tail, NewCol, NewSqs, N).

% Resources
%
% visulaization help:
% https://www.metalevel.at/queens/
%
% logic help:
% https://www.geeksforgeeks.org/n-queen-problem-backtracking-3/
%

