./parser example.txt
llvm-as-13 IRTree.ll 
llc-13 IRTree.bc
clang-13 -c IRTree.s
clang-13 IRTree.o -o IRTree
./IRTree