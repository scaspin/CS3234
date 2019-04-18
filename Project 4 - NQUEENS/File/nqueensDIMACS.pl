%Write a Prolog procedure nqueensFile(+Nat, +File) with Nat being the number of queens, n, to be placed on a commensurate chess board, that creates a ﬁle File in DIMACS format for MiniSat that contains a SAT representation of the corresponding N-Queens problem. Do not implement any other constraint other than the one stated in the problem statement above (e.g. do not exploit symmetry or other possible features of the problem).

nqueensFile(N, File):- 
	term_string(File, FileST),
	string_concat(FileST, ".cnf", FileName),
	open(FileName, write, St),
	write(St, "p cnf "), 
	Squares is N*N,
	term_string(Squares, SN),
	write(St, SN),
	write(St, " "),
	ClausesCount is 4*N*N + 10*N -9, % did some math
	write(St, ClausesCount),
	nl(St), !,
	writeAll(N, St), !,
	close(St).

writeAll(N, St):- rows(1, N, St), !,
		columns(1, N, St), !,
		StartPos is N*(N-1)+1, diagonalPos(StartPos, N, St), !,
		StartNeg is N*N, diagonalNeg(StartNeg, N, St).

% go row by row and print corresponding line of positives and then opposites
rows(Start, N, _) :- Start is N*N+1.
rows(Start, N, St) :- 
	RangeStart is Start+N-1,
	range(Start, RangeStart, List), !,
	atomics_to_string(List, " ", String), 
	write(St, String),
	write(St, " 0"),
	nl(St),
	opposite(List, St), !, 
	NextRows is Start + N,
	rows(NextRows, N, St).

% stops when past last column (N+1) is reached
columns(End, N, _):- End is N+1. 
columns(Start, N, St) :- 
	rangeUp(Start, N, List),
	atomics_to_string(List," ", String),
	write(St, String),
	write(St, " 0"),
	nl(St),
	opposite(List, St),
	NextCols is Start +1,
	columns(NextCols, N, St).

diagonalPos(N, N, _).
diagonalPos(Start, N, St):-
	rangeDiagPos(Start, N, List),!,
	opposite(List, St),!,
	((Start>N, NextDiag is Start-N);(Start<N+1, NextDiag is Start+1)),
	diagonalPos(NextDiag, N, St).

diagonalNeg(1, _, _).
diagonalNeg(Start, N, St):-
	rangeDiagNeg(Start, N, List), !,
	opposite(List, St),!,
	((Start>(N*(N-1)+1), NextDiag is Start-1);(NextDiag is Start-N)),
	diagonalNeg(NextDiag, N, St).

%finds range between two numbers (all in a single row
range(J,J,Final):- Final = [J].
range(I,J,[I|Ns]) :- I < J, I1 is I + 1, range(I1,J,Ns).
range(J,J,Final):- Final = [J].

% gets value of all squares in a single column
rangeUp(Start, N, Final):- Start+N > (N*N), Final = [Start].
rangeUp(Start, N, [Start|Tail]):- I1 is Start+N, rangeUp(I1, N, Tail).

% gets value of all squares in positive diagonal with a single square on the edge of board
rangeDiagPos(Start, N, Final):- (0 is mod(Start, N); Start+N+1>(N*N)), Final = [Start].
rangeDiagPos(Start, N, [Start|Tail]):- I1 is Start+N+1, rangeDiagPos(I1, N, Tail).

rangeDiagNeg(Start, N, Final):- (0 is mod(Start, N); Start<N+1), Final = [Start].
rangeDiagNeg(Start, N, [Start|Tail]):- I1 is Start-(N-1), rangeDiagNeg(I1, N, Tail).

opposite(List, St):- 
	% negate(NewList, NegList), % create new list containing opposite clauses
	pairs(List, Pairs),
	printPairs(Pairs, St).

% prints and formats a list of lists containing conflict pairs	
printPairs([], _).
printPairs([Head|Tail], St):-
	negate(Head, NH),
	atomics_to_string(NH, " ", String), 
	write(St, String), 
	write(St, " 0"),
	nl(St),
	printPairs(Tail, St).

pairs(L, Pairs):-
  findall([A,B], (member(A, L), member(B, L), A<B), Pairs).

negate([], []).
negate([Head|Tail], NList):- NHead is -Head, NList = [NHead| NewTail], negate(Tail, NewTail).


