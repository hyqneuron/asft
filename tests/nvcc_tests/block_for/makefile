CYCLES = 100000000
THREADS = 1024

main: main.cu
	nvcc main.cu -o main -lcuda

1.k: 1.cu
	nvcc 1.cu -o 1.k -cubin -arch sm_20

short.k: short.asm
	asf short.asm -o short.k

original: 1.k main
	./main 1.k _Z1kPiS_i $(CYCLES) $(THREADS)

short: short.k main
	./main short.k k $(CYCLES) $(THREADS)

clean:
	rm -Rf main *.k
