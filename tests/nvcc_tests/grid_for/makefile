CYCLES = 100000000
BLOCKS = 8

main: main.cu
	nvcc main.cu -o main -lcuda

1.k: 1.cu
	nvcc 1.cu -o 1.k -cubin -arch sm_20

short.k: short.asm
	asf short.asm -o short.k

short2.k: short2.asm
	asf short2.asm -o short2.k

short4.k: short4.asm
	asf short4.asm -o short4.k

original: 1.k main
	./main 1.k _Z1kPiS_i $(CYCLES) $(BLOCKS)

short: short.k main
	./main short.k k $(CYCLES) $(BLOCKS)

short2: short2.k main
	./main short2.k k $(CYCLES) $(BLOCKS)

short4: short4.k main
	./main short4.k k $(CYCLES) $(BLOCKS)

clean:
	rm -Rf main *.k
