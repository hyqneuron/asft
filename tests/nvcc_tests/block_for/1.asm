
code for sm_20
	Function : _Z1kPiS_i
/*0000*/     MOV R1, c [0x1] [0x100];
/*0008*/     S2R R0, SR_Tid_X;
/*0010*/     ISETP.GE.AND P0, pt, R0, c [0x0] [0x30], pt;
/*0018*/     @P0 EXIT;
/*0020*/     MOV32I R8, 0x4;
/*0028*/     IMUL.HI R3, R0, 0x4;
/*0030*/     IMAD R6.CC, R0, R8, c [0x0] [0x20];
/*0038*/     IADD.X R7, R3, c [0x0] [0x24];
/*0040*/     IMAD R4.CC, R0, R8, c [0x0] [0x28];
/*0048*/     IADD R0, R0, c [0x0] [0x8];
/*0050*/     LD.E R2, [R6];
/*0058*/     IADD.X R5, R3, c [0x0] [0x2c];
/*0060*/     ISETP.LT.AND P0, pt, R0, c [0x0] [0x30], pt;
/*0068*/     SHL R2, R2, 0x4;
/*0070*/     ST.E [R4], R2;
/*0078*/     @P0 BRA 0x28;
/*0080*/     EXIT;
	..........................


