!Machine 64
!Kernel k
!Param 8 2
!Param 4

	ISETP.GE.AND P0, pt, RZ, c[0x0][0x30]; //if 0>= count
	MOV R0, 1;
	MOV R2, c[0x0][0x20];
	MOV R3, c[0x0][0x24];
	@P0 EXIT;
	ISETP.EQ.AND P0, pt, R0, c[0x0][0x30]; //if 1 == count
	MOV R4, c[0x0][0x28];
	MOV R5, c[0x0][0x2c];
	MOV R6, 0x2; //R6 = counter = 2
	@P0 BRA !ENDLOOP
	IADD R4, R4, -0x8;

!Label LOOP
	LD.E R0, [R2];
	LD.E R1, [R2+0x4];
	IADD R6, R6, 0x2;
	IADD R4, R4, 0x8; //this instruction moved up to reduce stalling at line 24.
			  //because of this move, line 16 and 36 are added
	//need value of R0
	SHL R0, R0, 0x4;
	SHL R1, R1, 0x4;
	ISETP.LE.AND P0, pt, R6, c[0x0][0x30], pt;
	IADD R2, R2, 0x8; //this kind of instruction can be moved anywhere in the 
			  //loop to reduce stalling
	//Need value of R0
	ST.E [R4], R0;
	ST.E [R4+0x4], R1;
	@P0 BRA !LOOP;
	IADD R6, R6, -0x1;
	ISETP.EQ.AND P0, pt, R6, c[0x0][0x30], pt;
	@!P0 EXIT;
	IADD R4, R4, 0x8;

!Label ENDLOOP
	LD.E R0, [R2];
	SHL R0, R0, 0x4;
	ST.E [R4], R0;
	EXIT;

!EndKernel
