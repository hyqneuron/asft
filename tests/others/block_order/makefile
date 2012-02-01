BLOCKS=12

main: main.cu
	nvcc main.cu -o main -lcuda

1.k: 1
	asf 1 -o 1.k
k: 1.k main
	./main 1.k k $(BLOCKS)

kkk: 1.k main
	./main 1.k kkk 1

clean:
	rm *.k main -Rf
