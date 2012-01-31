!Machine 64
!Kernel k
!Param 8 2
!Param 4

//R0 input addr limit
//R1 row_size
//R2,3 input_addr
//R4,5 otput_addr
//R6 loader

	MOV R0, c[0x0][0x30];
	MOV R1, 0x4;
	ISCADD R0, R0, c[0x0][0x20], 2;
	MOV R2, c[0x0][0x20];
	MOV R3, c[0x0][0x24];
	MOV R4, c[0x0][0x28];
	MOV R5, c[0x0][0x2c];

	S2R R1, SR_Tid_X;
	SHL R1, R1, 0x2; //R1 = tid * 4
	IADD R2, R2, R1; //input_addr loaded
	IADD R4, R4, R1; //output_add loaded
	MOV R1, c[0x0][0x8];
	SHL R1, R1, 0x2; //row size loaded
	ISCADD R4, -R1, R4, 1;
	IADD R10, R2, R1;//R10,11=next2nd_addr
	MOV R11, R3;
	IADD R12, R4, R1;
	MOV R13, R5;

	ISETP.GE.AND P0, pt, R2, R0, pt; //done_m >= dolim?
	@P0 EXIT;
	//done_m <= dolim -2 ? do2: do1
	ISCADD R0, -R1, R0, 1;
	ISETP.LE.AND P0, pt, R2, R0, pt;
	@!P0 BRA !ENDLOOP


!Label LOOP
	LD.E R6, [R2];
	LD.E R7, [R10];
	ISCADD R4, R1, R4, 1;
	ISCADD R12,R1, R12,1;
	SHL R6, R6, 0x4;
	ISCADD R2, R1, R2, 1;
	SHL R7, R7, 0x4;
	ISCADD R10, R1, R10, 1;
	ISETP.LE.AND P0, pt, R2, R0, pt;
	ST.E [R4], R6;
	ST.E [R12],R7;
	@P0 BRA !LOOP
	IADD R0, R0, R1;
	ISETP.EQ.AND P0, pt, R2, R0, pt;
	@!P0 EXIT;

!Label ENDLOOP
	ISCADD R1, R1, R4, 1;
	LD.E R6, [R2];
	SHL R6, R6, 0x4;
	ST.E [R4], R6;
	EXIT;

!EndKernel
