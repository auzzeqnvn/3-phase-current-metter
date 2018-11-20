
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 11,059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Uc_Select_led=R7
	.DEF _Uint_dataLed1=R8
	.DEF _Uint_dataLed1_msb=R9
	.DEF _Uint_dataLed2=R10
	.DEF _Uint_dataLed2_msb=R11
	.DEF _Uint_dataLed3=R12
	.DEF _Uint_dataLed3_msb=R13
	.DEF _Uc_Current_Array_Cnt=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : 3 Phase current metter
;Version : 1.0
;Date    : 11/10/2018
;Author  :
;Company :
;Comments:
;Do va hien thi cuong do dong dien
;Su dung IC ADE7753
;
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <ADE7753.h>
;
;// Declare your global variables here
;#define DO_595_LATCH  PORTB.1
;#define DO_595_MOSI    PORTB.3
;#define DO_595_SCK    PORTB.5
;
;#define CTRL_595_ON     DO_595_LATCH = 1
;#define CTRL_595_OFF    DO_595_LATCH = 0
;
;#define BUZZER  PORTC.2
;
;#define BUZZER_ON   BUZZER = 1
;#define BUZZER_OFF  BUZZER = 0
;
;/* So luong mau lay de tinh toan */
;#define NUM_SAMPLE  20
;/* So luong noise loai bo */
;#define NUM_FILTER  5
;
;
;void    SEND_DATA_LED(unsigned char  data_first,unsigned char  data_second,unsigned char  data_third);
;void    SCAN_LED(unsigned char num_led,unsigned char    data);
;
;unsigned char   Uc_Select_led=1;
;
;/* Cac gia tri hien thi tren cac led */
;unsigned int   Uint_dataLed1 = 0;
;unsigned int   Uint_dataLed2 = 0;
;unsigned int   Uint_dataLed3 = 0;
;
;/* Co bao da lay du luong mau de tinh toan */
;bit Bit_sample_full =0;
;
;/* mang luu gia tri dong dien */
;unsigned int AI10__Current_L1[NUM_SAMPLE];
;unsigned int AI10__Current_L2[NUM_SAMPLE];
;unsigned int AI10__Current_L3[NUM_SAMPLE];
;unsigned char   Uc_Current_Array_Cnt = 0;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0046 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0047     unsigned char   data = 0;
; 0000 0048 // Reinitialize Timer1 value
; 0000 0049     TCNT1H=0xAA00 >> 8;
	ST   -Y,R17
;	data -> R17
	LDI  R17,0
	LDI  R30,LOW(170)
	OUT  0x2D,R30
; 0000 004A     TCNT1L=0xAA00 & 0xff;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 004B // Place your code here
; 0000 004C     if(Uc_Select_led > 12) Uc_Select_led=1;
	LDI  R30,LOW(12)
	CP   R30,R7
	BRSH _0x3
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 004D     if(Uc_Select_led == 1)    data = Uint_dataLed1/1000;
_0x3:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x4
	MOVW R26,R8
	RCALL SUBOPT_0x0
	RJMP _0x97
; 0000 004E     else if(Uc_Select_led == 2)    data = Uint_dataLed1/100%10;
_0x4:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x6
	MOVW R26,R8
	RCALL SUBOPT_0x1
	RJMP _0x98
; 0000 004F     else if(Uc_Select_led == 3)    data = Uint_dataLed1/10%10;
_0x6:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x8
	MOVW R26,R8
	RCALL SUBOPT_0x2
	RJMP _0x98
; 0000 0050     else if(Uc_Select_led == 4)    data = Uint_dataLed1%10;
_0x8:
	LDI  R30,LOW(4)
	CP   R30,R7
	BRNE _0xA
	MOVW R26,R8
	RJMP _0x98
; 0000 0051     else if(Uc_Select_led == 5)    data = Uint_dataLed2/1000;
_0xA:
	LDI  R30,LOW(5)
	CP   R30,R7
	BRNE _0xC
	MOVW R26,R10
	RCALL SUBOPT_0x0
	RJMP _0x97
; 0000 0052     else if(Uc_Select_led == 6)    data = Uint_dataLed2/100%10;
_0xC:
	LDI  R30,LOW(6)
	CP   R30,R7
	BRNE _0xE
	MOVW R26,R10
	RCALL SUBOPT_0x1
	RJMP _0x98
; 0000 0053     else if(Uc_Select_led == 7)    data = Uint_dataLed2/10%10;
_0xE:
	LDI  R30,LOW(7)
	CP   R30,R7
	BRNE _0x10
	MOVW R26,R10
	RCALL SUBOPT_0x2
	RJMP _0x98
; 0000 0054     else if(Uc_Select_led == 8)    data = Uint_dataLed2%10;
_0x10:
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x12
	MOVW R26,R10
	RJMP _0x98
; 0000 0055     else if(Uc_Select_led == 9)    data = Uint_dataLed3/1000;
_0x12:
	LDI  R30,LOW(9)
	CP   R30,R7
	BRNE _0x14
	MOVW R26,R12
	RCALL SUBOPT_0x0
	RJMP _0x97
; 0000 0056     else if(Uc_Select_led == 10)    data = Uint_dataLed3/100%10;
_0x14:
	LDI  R30,LOW(10)
	CP   R30,R7
	BRNE _0x16
	MOVW R26,R12
	RCALL SUBOPT_0x1
	RJMP _0x98
; 0000 0057     else if(Uc_Select_led == 11)    data = Uint_dataLed3/10%10;
_0x16:
	LDI  R30,LOW(11)
	CP   R30,R7
	BRNE _0x18
	MOVW R26,R12
	RCALL SUBOPT_0x2
	RJMP _0x98
; 0000 0058     else if(Uc_Select_led == 12)    data = Uint_dataLed3%10;
_0x18:
	LDI  R30,LOW(12)
	CP   R30,R7
	BRNE _0x1A
	MOVW R26,R12
_0x98:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
_0x97:
	MOV  R17,R30
; 0000 0059     SCAN_LED(Uc_Select_led++,data);
_0x1A:
	MOV  R30,R7
	INC  R7
	ST   -Y,R30
	MOV  R26,R17
	RCALL _SCAN_LED
; 0000 005A }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0061 {
; 0000 0062     ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 0063     // Delay needed for the stabilization of the ADC input voltage
; 0000 0064     delay_us(10);
; 0000 0065     // Start the AD conversion
; 0000 0066     ADCSRA|=(1<<ADSC);
; 0000 0067     // Wait for the AD conversion to complete
; 0000 0068     while ((ADCSRA & (1<<ADIF))==0);
; 0000 0069     ADCSRA|=(1<<ADIF);
; 0000 006A     return ADCW;
; 0000 006B }
;
;/*
;Gui data ra led
;Gui lan luot data_first, data_second, data_third
;Khi gui het du lieu se tien hanh xuat du lieu
;*/
;void    SEND_DATA_LED(unsigned char  data_first,unsigned char  data_second,unsigned char  data_third)
; 0000 0073 {
_SEND_DATA_LED:
; .FSTART _SEND_DATA_LED
; 0000 0074     unsigned char   i;
; 0000 0075     unsigned char   data;
; 0000 0076     data = data_first;
	ST   -Y,R26
	RCALL __SAVELOCR2
;	data_first -> Y+4
;	data_second -> Y+3
;	data_third -> Y+2
;	i -> R17
;	data -> R16
	LDD  R16,Y+4
; 0000 0077     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x1F:
	CPI  R17,8
	BRSH _0x20
; 0000 0078     {
; 0000 0079         if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
	RCALL SUBOPT_0x3
	BRNE _0x21
	SBI  0x18,3
; 0000 007A         else    DO_595_MOSI = 0;
	RJMP _0x24
_0x21:
	CBI  0x18,3
; 0000 007B         data <<= 1;
_0x24:
	RCALL SUBOPT_0x4
; 0000 007C         DO_595_SCK = 1;
; 0000 007D         DO_595_SCK = 0;
; 0000 007E     }
	SUBI R17,-1
	RJMP _0x1F
_0x20:
; 0000 007F     data = data_second;
	LDD  R16,Y+3
; 0000 0080     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x2C:
	CPI  R17,8
	BRSH _0x2D
; 0000 0081     {
; 0000 0082         if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
	RCALL SUBOPT_0x3
	BRNE _0x2E
	SBI  0x18,3
; 0000 0083         else    DO_595_MOSI = 0;
	RJMP _0x31
_0x2E:
	CBI  0x18,3
; 0000 0084         data <<= 1;
_0x31:
	RCALL SUBOPT_0x4
; 0000 0085         DO_595_SCK = 1;
; 0000 0086         DO_595_SCK = 0;
; 0000 0087     }
	SUBI R17,-1
	RJMP _0x2C
_0x2D:
; 0000 0088     data = data_third;
	LDD  R16,Y+2
; 0000 0089     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x39:
	CPI  R17,8
	BRSH _0x3A
; 0000 008A     {
; 0000 008B         if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
	RCALL SUBOPT_0x3
	BRNE _0x3B
	SBI  0x18,3
; 0000 008C         else    DO_595_MOSI = 0;
	RJMP _0x3E
_0x3B:
	CBI  0x18,3
; 0000 008D         data <<= 1;
_0x3E:
	RCALL SUBOPT_0x4
; 0000 008E         DO_595_SCK = 1;
; 0000 008F         DO_595_SCK = 0;
; 0000 0090     }
	SUBI R17,-1
	RJMP _0x39
_0x3A:
; 0000 0091     CTRL_595_ON;
	SBI  0x18,1
; 0000 0092     CTRL_595_OFF;
	CBI  0x18,1
; 0000 0093 }
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
;
;/*
;Ham quet led
;num_led: Thu tu led
;data: Du lieu hien thi tren led.
;*/
;void    SCAN_LED(unsigned char num_led,unsigned char    data)
; 0000 009B {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0000 009C     unsigned char   byte1,byte2,byte3;
; 0000 009D     byte1 = 0;
	ST   -Y,R26
	RCALL __SAVELOCR4
;	num_led -> Y+5
;	data -> Y+4
;	byte1 -> R17
;	byte2 -> R16
;	byte3 -> R19
	LDI  R17,LOW(0)
; 0000 009E     byte2 = 0;
	LDI  R16,LOW(0)
; 0000 009F     byte3 = 0;
	LDI  R19,LOW(0)
; 0000 00A0     switch(num_led)
	LDD  R30,Y+5
	RCALL SUBOPT_0x5
; 0000 00A1     {
; 0000 00A2         case    1:
	BRNE _0x4C
; 0000 00A3         {
; 0000 00A4             byte3 = 0x01;
	LDI  R19,LOW(1)
; 0000 00A5             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00A6             break;
	RJMP _0x4B
; 0000 00A7         }
; 0000 00A8         case    2:
_0x4C:
	RCALL SUBOPT_0x6
	BRNE _0x4D
; 0000 00A9         {
; 0000 00AA             byte3 = 0x02;
	LDI  R19,LOW(2)
; 0000 00AB             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00AC             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0000 00AD             break;
	RJMP _0x4B
; 0000 00AE         }
; 0000 00AF         case    3:
_0x4D:
	RCALL SUBOPT_0x7
	BRNE _0x4E
; 0000 00B0         {
; 0000 00B1             byte3 = 0x04;
	LDI  R19,LOW(4)
; 0000 00B2             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00B3             break;
	RJMP _0x4B
; 0000 00B4         }
; 0000 00B5         case    4:
_0x4E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4F
; 0000 00B6         {
; 0000 00B7             byte3 = 0x08;
	LDI  R19,LOW(8)
; 0000 00B8             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00B9             break;
	RJMP _0x4B
; 0000 00BA         }
; 0000 00BB         case    5:
_0x4F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x50
; 0000 00BC         {
; 0000 00BD             byte3 = 0x40;
	LDI  R19,LOW(64)
; 0000 00BE             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00BF             break;
	RJMP _0x4B
; 0000 00C0         }
; 0000 00C1         case    6:
_0x50:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x51
; 0000 00C2         {
; 0000 00C3             byte3 = 0x20;
	LDI  R19,LOW(32)
; 0000 00C4             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00C5             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0000 00C6             break;
	RJMP _0x4B
; 0000 00C7         }
; 0000 00C8         case    7:
_0x51:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x52
; 0000 00C9         {
; 0000 00CA             byte3 = 0x10;
	LDI  R19,LOW(16)
; 0000 00CB             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00CC             break;
	RJMP _0x4B
; 0000 00CD         }
; 0000 00CE         case    8:
_0x52:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x53
; 0000 00CF         {
; 0000 00D0             byte3 = 0x80;
	LDI  R19,LOW(128)
; 0000 00D1             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00D2             break;
	RJMP _0x4B
; 0000 00D3         }
; 0000 00D4         case    9:
_0x53:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x54
; 0000 00D5         {
; 0000 00D6             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0000 00D7             byte2 = 0x40;
	LDI  R16,LOW(64)
; 0000 00D8             break;
	RJMP _0x4B
; 0000 00D9         }
; 0000 00DA         case    10:
_0x54:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x55
; 0000 00DB         {
; 0000 00DC             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0000 00DD             byte2 = 0x20;
	LDI  R16,LOW(32)
; 0000 00DE             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0000 00DF             break;
	RJMP _0x4B
; 0000 00E0         }
; 0000 00E1         case    11:
_0x55:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x56
; 0000 00E2         {
; 0000 00E3             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0000 00E4             byte2 = 0x10;
	LDI  R16,LOW(16)
; 0000 00E5             break;
	RJMP _0x4B
; 0000 00E6         }
; 0000 00E7         case    12:
_0x56:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x4B
; 0000 00E8         {
; 0000 00E9             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0000 00EA             byte2 = 0x80;
	LDI  R16,LOW(128)
; 0000 00EB             break;
; 0000 00EC         }
; 0000 00ED     }
_0x4B:
; 0000 00EE     switch(data)
	LDD  R30,Y+4
	LDI  R31,0
; 0000 00EF     {
; 0000 00F0         case    0:
	SBIW R30,0
	BRNE _0x5B
; 0000 00F1         {
; 0000 00F2             byte1 |= 0xF9;
	ORI  R17,LOW(249)
; 0000 00F3             break;
	RJMP _0x5A
; 0000 00F4         }
; 0000 00F5         case    1:
_0x5B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5C
; 0000 00F6         {
; 0000 00F7             byte1 |= 0x81;
	ORI  R17,LOW(129)
; 0000 00F8             break;
	RJMP _0x5A
; 0000 00F9         }
; 0000 00FA         case    2:
_0x5C:
	RCALL SUBOPT_0x6
	BRNE _0x5D
; 0000 00FB         {
; 0000 00FC             byte1 |= 0xBA;
	ORI  R17,LOW(186)
; 0000 00FD             break;
	RJMP _0x5A
; 0000 00FE         }
; 0000 00FF         case    3:
_0x5D:
	RCALL SUBOPT_0x7
	BRNE _0x5E
; 0000 0100         {
; 0000 0101             byte1 |= 0xAB;
	ORI  R17,LOW(171)
; 0000 0102             break;
	RJMP _0x5A
; 0000 0103         }
; 0000 0104         case    4:
_0x5E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x5F
; 0000 0105         {
; 0000 0106             byte1 |= 0xC3;
	ORI  R17,LOW(195)
; 0000 0107             break;
	RJMP _0x5A
; 0000 0108         }
; 0000 0109         case    5:
_0x5F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x60
; 0000 010A         {
; 0000 010B             byte1 |= 0x6B;
	ORI  R17,LOW(107)
; 0000 010C             break;
	RJMP _0x5A
; 0000 010D         }
; 0000 010E         case    6:
_0x60:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x61
; 0000 010F         {
; 0000 0110             byte1 |= 0x7B;
	ORI  R17,LOW(123)
; 0000 0111             break;
	RJMP _0x5A
; 0000 0112         }
; 0000 0113         case    7:
_0x61:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x62
; 0000 0114         {
; 0000 0115             byte1 = 0xA1;
	LDI  R17,LOW(161)
; 0000 0116             break;
	RJMP _0x5A
; 0000 0117         }
; 0000 0118         case    8:
_0x62:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x63
; 0000 0119         {
; 0000 011A             byte1 |= 0xFB;
	ORI  R17,LOW(251)
; 0000 011B             break;
	RJMP _0x5A
; 0000 011C         }
; 0000 011D         case    9:
_0x63:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x5A
; 0000 011E         {
; 0000 011F             byte1 |= 0xEB;
	ORI  R17,LOW(235)
; 0000 0120             break;
; 0000 0121         }
; 0000 0122     }
_0x5A:
; 0000 0123     SEND_DATA_LED(byte1,byte2,byte3);
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R19
	RCALL _SEND_DATA_LED
; 0000 0124 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;
;
;/*
;Doc gia tri dong dien L1, L2 ,L3
;Loai bo cac nhieu co bien do lon.
;Lay trung binh cac gia tri con lai.
;Cap nhat gia tri dong dien.
;*/
;void    Read_Current(void)
; 0000 012F {
_Read_Current:
; .FSTART _Read_Current
; 0000 0130     unsigned int Uint_Tmp;
; 0000 0131     unsigned int Uint_CurrentTmp_Array[NUM_SAMPLE];
; 0000 0132     unsigned char   Uc_loop1_cnt,Uc_loop2_cnt;
; 0000 0133     unsigned int   Ul_Sum;
; 0000 0134 
; 0000 0135     AI10__Current_L1[Uc_Current_Array_Cnt] = Read_ADE7753(1,IRMS);
	SBIW R28,40
	RCALL __SAVELOCR6
;	Uint_Tmp -> R16,R17
;	Uint_CurrentTmp_Array -> Y+6
;	Uc_loop1_cnt -> R19
;	Uc_loop2_cnt -> R18
;	Ul_Sum -> R20,R21
	MOV  R30,R6
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0136     AI10__Current_L2[Uc_Current_Array_Cnt] = Read_ADE7753(2,IRMS);
	MOV  R30,R6
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x9
	PUSH R31
	PUSH R30
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0xC
; 0000 0137     AI10__Current_L3[Uc_Current_Array_Cnt] = Read_ADE7753(3,IRMS);
	MOV  R30,R6
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x9
	PUSH R31
	PUSH R30
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0xC
; 0000 0138 
; 0000 0139     Uc_Current_Array_Cnt++;
	INC  R6
; 0000 013A     if(Uc_Current_Array_Cnt >= NUM_SAMPLE)
	LDI  R30,LOW(20)
	CP   R6,R30
	BRLO _0x65
; 0000 013B     {
; 0000 013C         Bit_sample_full = 1;
	SET
	BLD  R2,0
; 0000 013D         Uc_Current_Array_Cnt = 0;
	CLR  R6
; 0000 013E     }
; 0000 013F 
; 0000 0140     if(Bit_sample_full == 0)
_0x65:
	SBRC R2,0
	RJMP _0x66
; 0000 0141     {
; 0000 0142         Uint_dataLed1 = 0;
	CLR  R8
	CLR  R9
; 0000 0143         Uint_dataLed2 = 0;
	CLR  R10
	CLR  R11
; 0000 0144         Uint_dataLed3 = 0;
	CLR  R12
	CLR  R13
; 0000 0145     }
; 0000 0146     else
	RJMP _0x67
_0x66:
; 0000 0147     {
; 0000 0148         /* Xu ly du lieu L1 */
; 0000 0149         /* Chuyen sang bo nho dem*/
; 0000 014A         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x69:
	CPI  R19,20
	BRSH _0x6A
; 0000 014B         {
; 0000 014C             Uint_CurrentTmp_Array[Uc_loop1_cnt] = AI10__Current_L1[Uc_loop1_cnt];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	MOV  R30,R19
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
; 0000 014D         }
	SUBI R19,-1
	RJMP _0x69
_0x6A:
; 0000 014E         /* Sắp xếp tu min-> max*/
; 0000 014F         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x6C:
	CPI  R19,20
	BRSH _0x6D
; 0000 0150         {
; 0000 0151             for(Uc_loop2_cnt = Uc_loop1_cnt; Uc_loop2_cnt<NUM_SAMPLE; Uc_loop2_cnt++)
	MOV  R18,R19
_0x6F:
	CPI  R18,20
	BRSH _0x70
; 0000 0152             {
; 0000 0153                 if(Uint_CurrentTmp_Array[Uc_loop1_cnt] > Uint_CurrentTmp_Array[Uc_loop2_cnt])
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	BRSH _0x71
; 0000 0154                 {
; 0000 0155                     Uint_Tmp = Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
; 0000 0156                     Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_CurrentTmp_Array[Uc_loop2_cnt];
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
; 0000 0157                     Uint_CurrentTmp_Array[Uc_loop2_cnt] = Uint_Tmp;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x16
; 0000 0158                 }
; 0000 0159             }
_0x71:
	SUBI R18,-1
	RJMP _0x6F
_0x70:
; 0000 015A         }
	SUBI R19,-1
	RJMP _0x6C
_0x6D:
; 0000 015B         /* Loc phan du lieu nhieu thap va cao */
; 0000 015C         Ul_Sum = 0;
	RCALL SUBOPT_0x17
; 0000 015D         for(Uc_loop1_cnt = NUM_FILTER;Uc_loop1_cnt<(NUM_SAMPLE - NUM_FILTER); Uc_loop1_cnt++)
_0x73:
	CPI  R19,15
	BRSH _0x74
; 0000 015E         {
; 0000 015F             Ul_Sum += Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x18
; 0000 0160         }
	SUBI R19,-1
	RJMP _0x73
_0x74:
; 0000 0161         Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
	RCALL SUBOPT_0x19
; 0000 0162         /* Xuat du lieu len led */
; 0000 0163         Uint_dataLed1 = Ul_Sum;
	MOVW R8,R20
; 0000 0164 
; 0000 0165         /* Xu ly du lieu L2 */
; 0000 0166         /* Chuyen sang bo nho dem*/
; 0000 0167         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x76:
	CPI  R19,20
	BRSH _0x77
; 0000 0168         {
; 0000 0169             Uint_CurrentTmp_Array[Uc_loop1_cnt] = AI10__Current_L2[Uc_loop1_cnt];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	MOV  R30,R19
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x15
; 0000 016A         }
	SUBI R19,-1
	RJMP _0x76
_0x77:
; 0000 016B         /* Sắp xếp tu min-> max*/
; 0000 016C         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x79:
	CPI  R19,20
	BRSH _0x7A
; 0000 016D         {
; 0000 016E             for(Uc_loop2_cnt = Uc_loop1_cnt; Uc_loop2_cnt<NUM_SAMPLE; Uc_loop2_cnt++)
	MOV  R18,R19
_0x7C:
	CPI  R18,20
	BRSH _0x7D
; 0000 016F             {
; 0000 0170                 if(Uint_CurrentTmp_Array[Uc_loop1_cnt] > Uint_CurrentTmp_Array[Uc_loop2_cnt])
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	BRSH _0x7E
; 0000 0171                 {
; 0000 0172                     Uint_Tmp = Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
; 0000 0173                     Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_CurrentTmp_Array[Uc_loop2_cnt];
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
; 0000 0174                     Uint_CurrentTmp_Array[Uc_loop2_cnt] = Uint_Tmp;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x16
; 0000 0175                 }
; 0000 0176             }
_0x7E:
	SUBI R18,-1
	RJMP _0x7C
_0x7D:
; 0000 0177         }
	SUBI R19,-1
	RJMP _0x79
_0x7A:
; 0000 0178 
; 0000 0179         /* Loc phan du lieu nhieu thap va cao */
; 0000 017A         Ul_Sum = 0;
	RCALL SUBOPT_0x17
; 0000 017B         for(Uc_loop1_cnt = NUM_FILTER;Uc_loop1_cnt<(NUM_SAMPLE - NUM_FILTER); Uc_loop1_cnt++)
_0x80:
	CPI  R19,15
	BRSH _0x81
; 0000 017C         {
; 0000 017D             Ul_Sum += Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x18
; 0000 017E         }
	SUBI R19,-1
	RJMP _0x80
_0x81:
; 0000 017F         Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
	RCALL SUBOPT_0x19
; 0000 0180         /* Xuat du lieu len led */
; 0000 0181         Uint_dataLed2 = Ul_Sum;
	MOVW R10,R20
; 0000 0182 
; 0000 0183         /* Xu ly du lieu L3 */
; 0000 0184         /* Chuyen sang bo nho dem*/
; 0000 0185         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x83:
	CPI  R19,20
	BRSH _0x84
; 0000 0186         {
; 0000 0187             Uint_CurrentTmp_Array[Uc_loop1_cnt] = AI10__Current_L3[Uc_loop1_cnt];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	MOV  R30,R19
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x15
; 0000 0188         }
	SUBI R19,-1
	RJMP _0x83
_0x84:
; 0000 0189         /* Sắp xếp tu min-> max*/
; 0000 018A         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x86:
	CPI  R19,20
	BRSH _0x87
; 0000 018B         {
; 0000 018C             for(Uc_loop2_cnt = Uc_loop1_cnt; Uc_loop2_cnt<NUM_SAMPLE; Uc_loop2_cnt++)
	MOV  R18,R19
_0x89:
	CPI  R18,20
	BRSH _0x8A
; 0000 018D             {
; 0000 018E                 if(Uint_CurrentTmp_Array[Uc_loop1_cnt] > Uint_CurrentTmp_Array[Uc_loop2_cnt])
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	BRSH _0x8B
; 0000 018F                 {
; 0000 0190                     Uint_Tmp = Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
; 0000 0191                     Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_CurrentTmp_Array[Uc_loop2_cnt];
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
; 0000 0192                     Uint_CurrentTmp_Array[Uc_loop2_cnt] = Uint_Tmp;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x16
; 0000 0193                 }
; 0000 0194             }
_0x8B:
	SUBI R18,-1
	RJMP _0x89
_0x8A:
; 0000 0195         }
	SUBI R19,-1
	RJMP _0x86
_0x87:
; 0000 0196         /* Loc phan du lieu nhieu thap va cao */
; 0000 0197         Ul_Sum = 0;
	RCALL SUBOPT_0x17
; 0000 0198         for(Uc_loop1_cnt = NUM_FILTER;Uc_loop1_cnt<(NUM_SAMPLE - NUM_FILTER); Uc_loop1_cnt++)
_0x8D:
	CPI  R19,15
	BRSH _0x8E
; 0000 0199         {
; 0000 019A             Ul_Sum += Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x18
; 0000 019B         }
	SUBI R19,-1
	RJMP _0x8D
_0x8E:
; 0000 019C         Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
	RCALL SUBOPT_0x19
; 0000 019D         /* Xuat du lieu len led */
; 0000 019E         Uint_dataLed3 = Ul_Sum;
	MOVW R12,R20
; 0000 019F     }
_0x67:
; 0000 01A0 }
	RCALL __LOADLOCR6
	ADIW R28,46
	RET
; .FEND
;
;void main(void)
; 0000 01A3 {
_main:
; .FSTART _main
; 0000 01A4 // Declare your local variables here
; 0000 01A5 // Input/Output Ports initialization
; 0000 01A6 // Port B initialization
; 0000 01A7 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=Out Bit0=In
; 0000 01A8 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(58)
	OUT  0x17,R30
; 0000 01A9 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=0 Bit0=T
; 0000 01AA PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01AB 
; 0000 01AC // Port C initialization
; 0000 01AD // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 01AE DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(60)
	OUT  0x14,R30
; 0000 01AF // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01B0 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01B1 
; 0000 01B2 // Port D initialization
; 0000 01B3 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 01B4 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(18)
	OUT  0x11,R30
; 0000 01B5 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01B6 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01B7 
; 0000 01B8 // Timer/Counter 0 initialization
; 0000 01B9 // Clock source: System Clock
; 0000 01BA // Clock value: Timer 0 Stopped
; 0000 01BB TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 01BC TCNT0=0x94;
	LDI  R30,LOW(148)
	OUT  0x32,R30
; 0000 01BD 
; 0000 01BE // Timer/Counter 1 initialization
; 0000 01BF // Clock source: System Clock
; 0000 01C0 // Clock value: 11059.200 kHz
; 0000 01C1 // Mode: Normal top=0xFFFF
; 0000 01C2 // OC1A output: Disconnected
; 0000 01C3 // OC1B output: Disconnected
; 0000 01C4 // Noise Canceler: Off
; 0000 01C5 // Input Capture on Falling Edge
; 0000 01C6 // Timer Period: 2 ms
; 0000 01C7 // Timer1 Overflow Interrupt: On
; 0000 01C8 // Input Capture Interrupt: Off
; 0000 01C9 // Compare A Match Interrupt: Off
; 0000 01CA // Compare B Match Interrupt: Off
; 0000 01CB TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 01CC TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 01CD TCNT1H=0xA9;
	LDI  R30,LOW(169)
	OUT  0x2D,R30
; 0000 01CE TCNT1L=0x9A;
	LDI  R30,LOW(154)
	OUT  0x2C,R30
; 0000 01CF ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 01D0 ICR1L=0x00;
	OUT  0x26,R30
; 0000 01D1 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01D2 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01D3 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01D4 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01D5 
; 0000 01D6 // Timer/Counter 2 initialization
; 0000 01D7 // Clock source: System Clock
; 0000 01D8 // Clock value: Timer2 Stopped
; 0000 01D9 // Mode: Normal top=0xFF
; 0000 01DA // OC2 output: Disconnected
; 0000 01DB ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 01DC TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 01DD TCNT2=0x00;
	OUT  0x24,R30
; 0000 01DE OCR2=0x00;
	OUT  0x23,R30
; 0000 01DF 
; 0000 01E0 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01E1 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 01E2 
; 0000 01E3 // External Interrupt(s) initialization
; 0000 01E4 // INT0: Off
; 0000 01E5 // INT1: Off
; 0000 01E6 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 01E7 
; 0000 01E8 // USART initialization
; 0000 01E9 // USART disabled
; 0000 01EA UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 01EB 
; 0000 01EC // Analog Comparator initialization
; 0000 01ED // Analog Comparator: Off
; 0000 01EE // The Analog Comparator's positive input is
; 0000 01EF // connected to the AIN0 pin
; 0000 01F0 // The Analog Comparator's negative input is
; 0000 01F1 // connected to the AIN1 pin
; 0000 01F2 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01F3 
; 0000 01F4 // ADC initialization
; 0000 01F5 // ADC Clock frequency: 345.600 kHz
; 0000 01F6 // ADC Voltage Reference: AREF pin
; 0000 01F7 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 01F8 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(133)
	OUT  0x6,R30
; 0000 01F9 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01FA 
; 0000 01FB // SPI initialization
; 0000 01FC // SPI disabled
; 0000 01FD SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 01FE 
; 0000 01FF // TWI initialization
; 0000 0200 // TWI disabled
; 0000 0201 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0202 
; 0000 0203 // Global enable interrupts
; 0000 0204 #asm("sei")
	sei
; 0000 0205 Uint_dataLed1 = 8888;
	LDI  R30,LOW(8888)
	LDI  R31,HIGH(8888)
	MOVW R8,R30
; 0000 0206 Uint_dataLed2 = 8888;
	MOVW R10,R30
; 0000 0207 Uint_dataLed3 = 8888;
	MOVW R12,R30
; 0000 0208 delay_ms(10000);
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL _delay_ms
; 0000 0209 BUZZER_ON;
	SBI  0x15,2
; 0000 020A delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 020B BUZZER_OFF;
	CBI  0x15,2
; 0000 020C while (1)
_0x93:
; 0000 020D     {
; 0000 020E         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
; 0000 020F         Read_Current();
	RCALL _Read_Current
; 0000 0210     }
	RJMP _0x93
; 0000 0211 }
_0x96:
	RJMP _0x96
; .FEND
;#include "ADE7753.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "delay.h"
;
;
;void    Send_cmd_ADE7753(unsigned char data)
; 0001 0006 {

	.CSEG
_Send_cmd_ADE7753:
; .FSTART _Send_cmd_ADE7753
; 0001 0007     unsigned char cnt;
; 0001 0008     unsigned char   tmp = data;
; 0001 0009     for(cnt = 0;cnt < 8; cnt++)
	ST   -Y,R26
	RCALL __SAVELOCR2
;	data -> Y+2
;	cnt -> R17
;	tmp -> R16
	LDD  R16,Y+2
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,8
	BRSH _0x20005
; 0001 000A     {
; 0001 000B         if((tmp & 0x80) == 0x80)   DOUT_MOSI_SPI_7753_MCU = 1;
	RCALL SUBOPT_0x3
	BRNE _0x20006
	SBI  0x12,1
; 0001 000C         else DOUT_MOSI_SPI_7753_MCU = 0;
	RJMP _0x20009
_0x20006:
	CBI  0x12,1
; 0001 000D 
; 0001 000E         tmp <<= 1;
_0x20009:
	LSL  R16
; 0001 000F         DOUT_CLK_SPI_7753_MCU = 1;
	RCALL SUBOPT_0x1A
; 0001 0010         delay_us(40);
; 0001 0011         DOUT_CLK_SPI_7753_MCU = 0;
	RCALL SUBOPT_0x1B
; 0001 0012         delay_us(40);
; 0001 0013     }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 0014 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; .FEND
;
;unsigned char    Read_data_ADE7753(void)
; 0001 0017 {
_Read_data_ADE7753:
; .FSTART _Read_data_ADE7753
; 0001 0018     unsigned char cnt;
; 0001 0019     unsigned char data;
; 0001 001A     data = 0;
	RCALL __SAVELOCR2
;	cnt -> R17
;	data -> R16
	LDI  R16,LOW(0)
; 0001 001B     for(cnt = 0;cnt < 8; cnt++)
	LDI  R17,LOW(0)
_0x20011:
	CPI  R17,8
	BRSH _0x20012
; 0001 001C     {
; 0001 001D         DOUT_CLK_SPI_7753_MCU = 1;
	RCALL SUBOPT_0x1A
; 0001 001E         delay_us(40);
; 0001 001F         if(DIN_MISO_SPI_7753_MCU == 1)   data += 1;
	SBIC 0x10,0
	SUBI R16,-LOW(1)
; 0001 0020         data <<= 1;
	LSL  R16
; 0001 0021         DOUT_CLK_SPI_7753_MCU = 0;
	RCALL SUBOPT_0x1B
; 0001 0022         delay_us(40);
; 0001 0023     }
	SUBI R17,-1
	RJMP _0x20011
_0x20012:
; 0001 0024     return data;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0001 0025 }
; .FEND
;
;void    Write_ADE7753(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char d ...
; 0001 0028 {
; 0001 0029     unsigned char data[4];
; 0001 002A     unsigned char   i;
; 0001 002B     data[0] = data_1;
;	IC_CS -> Y+10
;	addr -> Y+9
;	num_data -> Y+8
;	data_1 -> Y+7
;	data_2 -> Y+6
;	data_3 -> Y+5
;	data -> Y+1
;	i -> R17
; 0001 002C     data[1] = data_2;
; 0001 002D     data[2] = data_3;
; 0001 002E 
; 0001 002F     switch (IC_CS)
; 0001 0030     {
; 0001 0031         case 1:
; 0001 0032         {
; 0001 0033             PHASE_1_ON;
; 0001 0034             PHASE_2_OFF;
; 0001 0035             PHASE_3_OFF;
; 0001 0036             break;
; 0001 0037         }
; 0001 0038         case 2:
; 0001 0039         {
; 0001 003A             PHASE_1_OFF;
; 0001 003B             PHASE_2_ON;
; 0001 003C             PHASE_3_OFF;
; 0001 003D             break;
; 0001 003E         }
; 0001 003F         case 3:
; 0001 0040         {
; 0001 0041             PHASE_1_OFF;
; 0001 0042             PHASE_2_OFF;
; 0001 0043             PHASE_3_ON;
; 0001 0044             break;
; 0001 0045         }
; 0001 0046     }
; 0001 0047     addr |= 0x80;
; 0001 0048     Send_cmd_ADE7753(addr);
; 0001 0049     delay_us(20);
; 0001 004A     for(i=0;i<num_data;i++)    Send_cmd_ADE7753(data[i]);
; 0001 004B PORTC.4 = 0;
; 0001 004C     PHASE_2_OFF;
; 0001 004D     PHASE_3_OFF;
; 0001 004E }
;unsigned int    Read_ADE7753(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
; 0001 0050 {
_Read_ADE7753:
; .FSTART _Read_ADE7753
; 0001 0051     unsigned char   i;
; 0001 0052     unsigned char   data[4];
; 0001 0053     unsigned long int res;
; 0001 0054     for(i=0;i<4;i++)    data[i] = 0;
	ST   -Y,R26
	SBIW R28,8
	ST   -Y,R17
;	IC_CS -> Y+11
;	addr -> Y+10
;	num_data -> Y+9
;	i -> R17
;	data -> Y+5
;	res -> Y+1
	LDI  R17,LOW(0)
_0x2003A:
	CPI  R17,4
	BRSH _0x2003B
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x10
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x2003A
_0x2003B:
; 0001 0055 switch (IC_CS)
	LDD  R30,Y+11
	RCALL SUBOPT_0x5
; 0001 0056     {
; 0001 0057         case 1:
	BRNE _0x2003F
; 0001 0058         {
; 0001 0059             PHASE_1_ON;
	SBI  0x15,4
; 0001 005A             PHASE_2_OFF;
	CBI  0x15,5
; 0001 005B             PHASE_3_OFF;
	CBI  0x15,3
; 0001 005C             break;
	RJMP _0x2003E
; 0001 005D         }
; 0001 005E         case 2:
_0x2003F:
	RCALL SUBOPT_0x6
	BRNE _0x20046
; 0001 005F         {
; 0001 0060             PHASE_1_OFF;
	CBI  0x15,4
; 0001 0061             PHASE_2_ON;
	SBI  0x15,5
; 0001 0062             PHASE_3_OFF;
	CBI  0x15,3
; 0001 0063             break;
	RJMP _0x2003E
; 0001 0064         }
; 0001 0065         case 3:
_0x20046:
	RCALL SUBOPT_0x7
	BRNE _0x2003E
; 0001 0066         {
; 0001 0067             PHASE_1_OFF;
	CBI  0x15,4
; 0001 0068             PHASE_2_OFF;
	CBI  0x15,5
; 0001 0069             PHASE_3_ON;
	SBI  0x15,3
; 0001 006A             break;
; 0001 006B         }
; 0001 006C     }
_0x2003E:
; 0001 006D     addr &= 0x3F;
	LDD  R30,Y+10
	ANDI R30,LOW(0x3F)
	STD  Y+10,R30
; 0001 006E     Send_cmd_ADE7753(addr);
	LDD  R26,Y+10
	RCALL _Send_cmd_ADE7753
; 0001 006F     for(i=0;i<num_data;i++) data[i] = Read_data_ADE7753();
	LDI  R17,LOW(0)
_0x20055:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x20056
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x9
	PUSH R31
	PUSH R30
	RCALL _Read_data_ADE7753
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20055
_0x20056:
; 0001 0070 PORTC.4 = 0;
	CBI  0x15,4
; 0001 0071     PHASE_2_OFF;
	CBI  0x15,5
; 0001 0072     PHASE_3_OFF;
	CBI  0x15,3
; 0001 0073     res = 0;
	LDI  R30,LOW(0)
	__CLRD1S 1
; 0001 0074     for(i=0;i<num_data;i++)
	LDI  R17,LOW(0)
_0x2005E:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x2005F
; 0001 0075     {
; 0001 0076         res <<= 8;
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(8)
	RCALL __LSLD12
	RCALL SUBOPT_0x1E
; 0001 0077         res += data[i];
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x10
	LD   R30,X
	LDI  R31,0
	RCALL SUBOPT_0x1D
	RCALL __CWD1
	RCALL __ADDD12
	RCALL SUBOPT_0x1E
; 0001 0078     }
	SUBI R17,-1
	RJMP _0x2005E
_0x2005F:
; 0001 0079     return (res/3600);
	RCALL SUBOPT_0x1D
	__GETD1N 0xE10
	RCALL __DIVD21U
	LDD  R17,Y+0
	ADIW R28,12
	RET
; 0001 007A }
; .FEND

	.DSEG
_AI10__Current_L1:
	.BYTE 0x28
_AI10__Current_L2:
	.BYTE 0x28
_AI10__Current_L3:
	.BYTE 0x28

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	MOV  R30,R16
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LSL  R16
	SBI  0x18,5
	CBI  0x18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_AI10__Current_L1)
	LDI  R27,HIGH(_AI10__Current_L1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x9:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RJMP _Read_ADE7753

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_AI10__Current_L2)
	LDI  R27,HIGH(_AI10__Current_L2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_AI10__Current_L3)
	LDI  R27,HIGH(_AI10__Current_L3)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:68 WORDS
SUBOPT_0xE:
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0x9
	MOVW R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x10:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x11:
	RCALL __GETW1P
	MOVW R26,R0
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x12:
	RCALL SUBOPT_0x10
	LD   R0,X+
	LD   R1,X
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x10
	RCALL __GETW1P
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x10
	LD   R16,X+
	LD   R17,X
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x14:
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x10
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	RCALL SUBOPT_0x9
	ST   Z,R16
	STD  Z+1,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	__GETWRN 20,21,0
	LDI  R19,LOW(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	RCALL SUBOPT_0x10
	RCALL __GETW1P
	__ADDWRR 20,21,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	MOVW R26,R20
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	SBI  0x12,4
	__DELAY_USB 147
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CBI  0x12,4
	__DELAY_USB 147
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__PUTD1S 1
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
