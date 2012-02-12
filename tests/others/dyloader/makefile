BLOCKS=1

main: main.cu
	/usr/local/cuda/bin/nvcc main.cu -o main -lcuda

loader: loader.asf
	asf loader.asf -o loader.k

test: main loader
	./main loader.k k 0 $(BLOCKS)

debug: main loader
	/usr/local/cuda/bin/cuda-gdb main
