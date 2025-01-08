Usage:
1 build the data file: 
  - cat t10m.dat.tgz.part* > t10m.dat.tgz 
  - tar -xzvf t10m.dat.tgz
2 build and run
make COMP=nvfortran run
make COMP=gfortran run (equivalent to make run)
make COMP=intel run
3 check the results
Tt should print: "Success: All candidates_ref are found in candidates."

Code:
The entry point is the routine INTER7_CANDIDATE_PAIRS in inter7_candidate_pairs.F
It contains the collision detection algorithm for /INTER/TYPE7 (somewhat simplified)
