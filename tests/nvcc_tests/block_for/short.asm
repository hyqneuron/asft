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
	IMAD R4, -R1, 3, R4;
	IADD R10, R2, R1;//R10,11=next2nd_addr
	MOV R11, R3;
	IADD R12, R4, R1;
	MOV R13, R5;
	IADD R14, R10, R1;
	IADD R16, R12, R1;
	MOV R15, R3;
	MOV R17, R5;

	ISETP.GE.AND P0, pt, R2, R0, pt; //done_m >= dolim?
	@P0 EXIT;
	//done_m <= dolim -2 ? do2: do1
	IMAD R0, -R1, 3, R0;
	ISETP.LE.AND P0, pt, R2, R0, pt;
	@!P0 IMAD R0, R1, 3, R0;
	@!P0 BRA !ENDLOOP


!Label LOOP
	LD.E.CG R6, [R2];
	LD.E.CG R7, [R10];
	LD.E.CG R8, [R14];
	IMAD R4,  R1, 3, R4;
	IMAD R12, R1, 3, R12;
	IMAD R16, R1, 3, R16;
	IMAD R2, R1,  3, R2;
	SHL R6, R6, 0x4;
	SHL R7, R7, 0x4;
	SHL R8, R8, 0x4;
	IMAD R10, R1, 3, R10;
	IMAD R14, R1, 3, R14;
	ISETP.LE.AND P0, pt, R2, R0, pt;
	ST.E.CG [R4], R6;
	ST.E.CG [R12],R7;
	ST.E.CG [R16],R8;
	@P0 BRA !LOOP
	IADD R0, R0, R1;
	IMAD R0, R1, 3, R0;
	ISETP.EQ.AND P0, pt, R2, R0, pt;
	@P0 EXIT;

!Label ENDLOOP

	IMAD R4, R1, 3, R4;

!Label SUBEND
	LD.E.CG R6, [R2];
	IADD R2, R2, R1;
	SHL R6, R6, 0x4;
	ST.E.CG [R4], R6;
	IADD R4, R4, R1;
	ISETP.LT.AND P0, pt, R2, R0, pt;
	@P0 BRA !SUBEND
	EXIT;

!EndKernel
