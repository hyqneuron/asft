
	code for sm_20
		Function : _Z1kPiS_i
	/*0000*/      	MOV R1, c [0x1] [0x100];
	/*0008*/      	S2R R8, SR_Tid_X;
	/*0010*/      	ISETP.GE.AND P0, pt, R8, c [0x0] [0x30], pt;
	/*0018*/      	@P0 EXIT;
	/*0020*/      	MOV R0, c [0x0] [0x8];
	/*0028*/      	MOV32I R7, 0x4;
	/*0030*/      	PBK 0x150;
	/*0038*/      	IMUL.HI R6, R0, 0x4;
	/*0040*/      	SHL.W R0, R0, 0x2;
	/*0048*/      	IMUL.HI R3, R8, 0x4;
	/*0050*/      	IMAD R4.CC, R8, R7, c [0x0] [0x20];
	/*0058*/      	IADD.X R5, R3, c [0x0] [0x24];
	/*0060*/      	IMAD R2.CC, R8, R7, c [0x0] [0x28];
	/*0068*/      	IADD R8, R8, c [0x0] [0x8];
	/*0070*/      	LD.E R9, [R4];
	/*0078*/      	IADD.X R3, R3, c [0x0] [0x2c];
	/*0080*/      	ISETP.GE.AND P0, pt, R8, c [0x0] [0x30], pt;
	/*0088*/      	SHL R9, R9, 0x4;
	/*0090*/      	ST.E [R2], R9;
	/*0098*/      	@P0 BRK;
	/*00a0*/      	IADD R4.CC, R4, R0;
	/*00a8*/      	IADD R10, R8, c [0x0] [0x8];
	/*00b0*/      	IADD.X R5, R5, R6;
	/*00b8*/      	IADD R2.CC, R2, R0;
	/*00c0*/      	ISETP.GE.AND P0, pt, R10, c [0x0] [0x30], pt;
	/*00c8*/      	LD.E R9, [R4];
	/*00d0*/      	IADD.X R3, R3, R6;
	/*00d8*/      	SHL R9, R9, 0x4;
	/*00e0*/      	ST.E [R2], R9;
	/*00e8*/      	@P0 BRK;
	/*00f0*/      	IADD R4.CC, R4, R0;
	/*00f8*/      	MOV R9, c [0x0] [0x8];
	/*0100*/      	IADD.X R5, R5, R6;
	/*0108*/      	IADD R10.CC, R2, R0;
	/*0110*/      	ISCADD R8, R9, R8, 0x1;
	/*0118*/      	LD.E R4, [R4];
	/*0120*/      	IADD.X R11, R3, R6;
	/*0128*/      	ISETP.LT.AND P0, pt, R8, c [0x0] [0x30], pt;
	/*0130*/      	SHL R2, R4, 0x4;
	/*0138*/      	ST.E [R10], R2;
	/*0140*/      	@!P0 BRK;
	/*0148*/      	BRA 0x48;
	/*0150*/      	EXIT;
		..........................


