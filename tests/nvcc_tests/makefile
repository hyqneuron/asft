CYCLES=10000000

main: main.cu
	nvcc main.cu -o main -lcuda

1.k: 1.cu
	nvcc -cubin -o 1.k -arch sm_20 1.cu

short.k: short.asm
	asfermi short.asm -o short.k

long.k: long.asm
	asfermi long.asm -o long.k

original: 1.k main
	./main 1.k _Z1kPiS_i $(CYCLES)

short: short.k main
	./main short.k k $(CYCLES)

long: long.k main
	./main long.k k $(CYCLES)

clean:
	rm *.k main --force
