1.k: 1
	asf 1 -o 1.k

2.k: 2
	asf 2 -o 2.k

3.k: 3
	asf 3 -o 3.k

run1: 1.k
	O 1.k k 28672000 1024 1 3

run2: 2.k
	O 2.k k 26624000 1024 1 3

run3: 3.k
	O 3.k k 24576000 1024 1 3

clean:
	rm -Rf *.k
