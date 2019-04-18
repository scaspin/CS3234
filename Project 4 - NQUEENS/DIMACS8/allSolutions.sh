#!/bin/sh

while :; do
  minisat nqueens8.cnf 8solved
  if [ `head -1 8solved` = UNSAT ]; then
    break
  fi
  tail -1 8solved |
    awk '{
      for(i=1;i<NF;++i) { $i = -$i }
      print
    }' >> nqueens8.cnf
done
