MAIN = mainSM

mainL1: mainL1.cu
	nvcc mainL1.cu -o mainL1 -lcuda

mainEQ: mainEQ.cu
	nvcc mainEQ.cu -o mainEQ -lcuda

mainSM: mainSM.cu
	nvcc mainSM.cu -o mainSM -lcuda

1.k: 1
	asf 1 -o 1.k

1cg.k: 1cg
	asf 1cg -o 1cg.k

2cg.k: 2cg
	asf 2cg -o 2cg.k

3cg.k: 3cg
	asf 3cg -o 3cg.k

4cg.k: 4cg
	asf 4cg -o 4cg.k

2.k: 2
	asf 2 -o 2.k

3.k: 3
	asf 3 -o 3.k

run1: 1.k $(MAIN)
	./$(MAIN) 1.k k 28672000 1024 1 3

run1cg: 1cg.k $(MAIN)
	./$(MAIN) 1cg.k k 245760000 1024 1 3

run2cg: 2cg.k $(MAIN)
	./$(MAIN) 2cg.k k 245760000 1024 1 3

run4cg: 4cg.k $(MAIN)
	./$(MAIN) 4cg.k k 245760000 1024 1 3

run2: 2.k $(MAIN)
	./$(MAIN) 2.k k 26624000 1024 1 3

run3: 3.k $(MAIN)
	./$(MAIN) 3.k k 24576000 1024 1 3

clean:
	rm -Rf *.k mainSM mainL1 mainEQ
