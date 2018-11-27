
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 11.059200 MHz
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
	.DEF _Uc_Current_Array_Cnt=R7
	.DEF _AI10_Current_Set=R8
	.DEF _AI10_Current_Set_msb=R9
	.DEF _Uc_Buzzer_cnt=R6
	.DEF _Uc_Timer_cnt=R11
	.DEF _Uc_Select_led=R10

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
	.DB  0x0,0x0,0x0,0x0
	.DB  0x1,0x0

_0x40003:
	.DB  0xF9,0x81,0xBA,0xAB,0xC3,0x6B,0x7B,0xA1
	.DB  0xFB,0xEB
_0x40004:
	.DB  0x1,0x0,0x2,0x0,0x4,0x0,0x8,0x0
	.DB  0x40,0x0,0x20,0x0,0x10,0x0,0x80,0x0
	.DB  0x0,0x40,0x0,0x20,0x0,0x10,0x0,0x80

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _BCDLED
	.DW  _0x40003*2

	.DW  0x18
	.DW  _LED_SELECT
	.DW  _0x40004*2

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
;#include "led.h"
;
;
;#define BUZZER  PORTC.2
;
;#define BUZZER_ON   BUZZER = 1
;#define BUZZER_OFF  BUZZER = 0
;
;#define CURRENT_MAX_SET 15
;#define CURRENT_MIN_SET 8
;
;/* So luong mau lay de tinh toan */
;#define NUM_SAMPLE  5
;/* So luong noise loai bo */
;#define NUM_FILTER  1
;
;bit Bit_Warning_1 = 0;
;bit Bit_Warning_2 = 0;
;bit Bit_Warning_3 = 0;
;
;
;
;
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
;unsigned int    AI10_Current_Set;
;
;unsigned char   Uc_Buzzer_cnt = 0;
;
;unsigned char   Uc_Timer_cnt = 0;
;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0047 {

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
; 0000 0048 // Reinitialize Timer1 value
; 0000 0049     TCNT1H=0xAA00 >> 8;
	LDI  R30,LOW(170)
	OUT  0x2D,R30
; 0000 004A     TCNT1L=0xAA00 & 0xff;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 004B // Place your code here
; 0000 004C     // Uc_Timer_cnt++;
; 0000 004D     if(Uc_Timer_cnt < 200)  Uc_Timer_cnt++;
	LDI  R30,LOW(200)
	CP   R11,R30
	BRSH _0x3
	INC  R11
; 0000 004E 
; 0000 004F     LED();
_0x3:
	RCALL _LED
; 0000 0050 
; 0000 0051     if(Bit_Warning_1 || Bit_Warning_2 || Bit_Warning_3)
	SBRC R2,0
	RJMP _0x5
	SBRC R2,1
	RJMP _0x5
	SBRS R2,2
	RJMP _0x4
_0x5:
; 0000 0052     {
; 0000 0053         Uc_Buzzer_cnt++;
	INC  R6
; 0000 0054         if(Uc_Buzzer_cnt < 100) BUZZER_ON;
	LDI  R30,LOW(100)
	CP   R6,R30
	BRSH _0x7
	SBI  0x15,2
; 0000 0055         else    if(Uc_Buzzer_cnt < 200) BUZZER_OFF;
	RJMP _0xA
_0x7:
	LDI  R30,LOW(200)
	CP   R6,R30
	BRSH _0xB
	CBI  0x15,2
; 0000 0056         else Uc_Buzzer_cnt = 0;
	RJMP _0xE
_0xB:
	CLR  R6
; 0000 0057     }
_0xE:
_0xA:
; 0000 0058     else    BUZZER_OFF;
	RJMP _0xF
_0x4:
	CBI  0x15,2
; 0000 0059 }
_0xF:
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
; 0000 0060 {
_read_adc:
; .FSTART _read_adc
; 0000 0061     ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0062     // Delay needed for the stabilization of the ADC input voltage
; 0000 0063     delay_us(10);
	__DELAY_USB 37
; 0000 0064     // Start the AD conversion
; 0000 0065     ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0066     // Wait for the AD conversion to complete
; 0000 0067     while ((ADCSRA & (1<<ADIF))==0);
_0x12:
	SBIS 0x6,4
	RJMP _0x12
; 0000 0068     ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0069     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 006A }
; .FEND
;/*
;Doc gia tri dong dien L1, L2 ,L3
;Loai bo cac nhieu co bien do lon.
;Lay trung binh cac gia tri con lai.
;Cap nhat gia tri dong dien.
;*/
;void    Read_Current(void)
; 0000 0072 {
_Read_Current:
; .FSTART _Read_Current
; 0000 0073     unsigned int Uint_Tmp;
; 0000 0074     unsigned int Uint_CurrentTmp_Array[NUM_SAMPLE];
; 0000 0075     unsigned char   Uc_loop1_cnt,Uc_loop2_cnt;
; 0000 0076     unsigned int   Ul_Sum;
; 0000 0077     unsigned long Ul_tmp;
; 0000 0078 
; 0000 0079     Ul_tmp = ((unsigned long) Read_ADE7753(1,IRMS)/800);
	SBIW R28,14
	RCALL __SAVELOCR6
;	Uint_Tmp -> R16,R17
;	Uint_CurrentTmp_Array -> Y+10
;	Uc_loop1_cnt -> R19
;	Uc_loop2_cnt -> R18
;	Ul_Sum -> R20,R21
;	Ul_tmp -> Y+6
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	__GETD1N 0x320
	RCALL SUBOPT_0x2
; 0000 007A     AI10__Current_L1[Uc_Current_Array_Cnt] = (unsigned int) (Ul_tmp);
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 007B 
; 0000 007C     Ul_tmp = ((unsigned long) Read_ADE7753(2,IRMS)/1105);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL SUBOPT_0x1
	__GETD1N 0x451
	RCALL SUBOPT_0x2
; 0000 007D     AI10__Current_L2[Uc_Current_Array_Cnt] = (unsigned int) (Ul_tmp);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
; 0000 007E 
; 0000 007F     Ul_tmp = ((unsigned long) Read_ADE7753(3,IRMS)/577);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL SUBOPT_0x1
	__GETD1N 0x241
	RCALL SUBOPT_0x2
; 0000 0080     AI10__Current_L3[Uc_Current_Array_Cnt] = (unsigned int) (Ul_tmp);
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x4
; 0000 0081 
; 0000 0082     AI10_Current_Set = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R8,R30
; 0000 0083     AI10_Current_Set = AI10_Current_Set*(CURRENT_MAX_SET-CURRENT_MIN_SET)*100/1024 + CURRENT_MIN_SET*100;
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL __MULW12U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	RCALL __MULW12U
	RCALL __LSRW2
	MOV  R30,R31
	LDI  R31,0
	SUBI R30,LOW(-800)
	SBCI R31,HIGH(-800)
	MOVW R8,R30
; 0000 0084 
; 0000 0085     Uc_Current_Array_Cnt++;
	INC  R7
; 0000 0086     if(Uc_Current_Array_Cnt >= NUM_SAMPLE)
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0x15
; 0000 0087     {
; 0000 0088         Bit_sample_full = 1;
	SET
	BLD  R2,3
; 0000 0089         Uc_Current_Array_Cnt = 0;
	CLR  R7
; 0000 008A     }
; 0000 008B 
; 0000 008C     if(Bit_sample_full == 0)
_0x15:
	SBRC R2,3
	RJMP _0x16
; 0000 008D     {
; 0000 008E         Uint_dataLed1 = 0;
	LDI  R30,LOW(0)
	STS  _Uint_dataLed1,R30
	STS  _Uint_dataLed1+1,R30
; 0000 008F         Uint_dataLed2 = 0;
	STS  _Uint_dataLed2,R30
	STS  _Uint_dataLed2+1,R30
; 0000 0090         Uint_dataLed3 = 0;
	STS  _Uint_dataLed3,R30
	STS  _Uint_dataLed3+1,R30
; 0000 0091     }
; 0000 0092     else
	RJMP _0x17
_0x16:
; 0000 0093     {
; 0000 0094         /* Xu ly du lieu L1 */
; 0000 0095         /* Chuyen sang bo nho dem*/
; 0000 0096         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x19:
	CPI  R19,5
	BRSH _0x1A
; 0000 0097         {
; 0000 0098             Uint_CurrentTmp_Array[Uc_loop1_cnt] = AI10__Current_L1[Uc_loop1_cnt];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	MOV  R30,R19
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0099         }
	SUBI R19,-1
	RJMP _0x19
_0x1A:
; 0000 009A         /* Sắp xếp tu min-> max*/
; 0000 009B         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x1C:
	CPI  R19,5
	BRSH _0x1D
; 0000 009C         {
; 0000 009D             for(Uc_loop2_cnt = Uc_loop1_cnt; Uc_loop2_cnt<NUM_SAMPLE; Uc_loop2_cnt++)
	MOV  R18,R19
_0x1F:
	CPI  R18,5
	BRSH _0x20
; 0000 009E             {
; 0000 009F                 if(Uint_CurrentTmp_Array[Uc_loop1_cnt] > Uint_CurrentTmp_Array[Uc_loop2_cnt])
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xB
	BRSH _0x21
; 0000 00A0                 {
; 0000 00A1                     Uint_Tmp = Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xC
; 0000 00A2                     Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_CurrentTmp_Array[Uc_loop2_cnt];
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0000 00A3                     Uint_CurrentTmp_Array[Uc_loop2_cnt] = Uint_Tmp;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
; 0000 00A4                 }
; 0000 00A5             }
_0x21:
	SUBI R18,-1
	RJMP _0x1F
_0x20:
; 0000 00A6         }
	SUBI R19,-1
	RJMP _0x1C
_0x1D:
; 0000 00A7         /* Loc phan du lieu nhieu thap va cao */
; 0000 00A8         Ul_Sum = 0;
	RCALL SUBOPT_0x10
; 0000 00A9         for(Uc_loop1_cnt = NUM_FILTER;Uc_loop1_cnt<(NUM_SAMPLE - NUM_FILTER); Uc_loop1_cnt++)
_0x23:
	CPI  R19,4
	BRSH _0x24
; 0000 00AA         {
; 0000 00AB             Ul_Sum += Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x11
; 0000 00AC         }
	SUBI R19,-1
	RJMP _0x23
_0x24:
; 0000 00AD         Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
	RCALL SUBOPT_0x12
; 0000 00AE         /* Xuat du lieu len led */
; 0000 00AF         if(Uc_Timer_cnt == 200) Uint_dataLed1 = Ul_Sum;
	BRNE _0x25
	__PUTWMRN _Uint_dataLed1,0,20,21
; 0000 00B0 
; 0000 00B1         if(AI10_Current_Set < Uint_dataLed1)    Bit_Warning_1 =1;
_0x25:
	LDS  R30,_Uint_dataLed1
	LDS  R31,_Uint_dataLed1+1
	CP   R8,R30
	CPC  R9,R31
	BRSH _0x26
	SET
	RJMP _0x4C
; 0000 00B2         else Bit_Warning_1 = 0;
_0x26:
	CLT
_0x4C:
	BLD  R2,0
; 0000 00B3 
; 0000 00B4         /* Xu ly du lieu L2 */
; 0000 00B5         /* Chuyen sang bo nho dem*/
; 0000 00B6         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x29:
	CPI  R19,5
	BRSH _0x2A
; 0000 00B7         {
; 0000 00B8             Uint_CurrentTmp_Array[Uc_loop1_cnt] = AI10__Current_L2[Uc_loop1_cnt];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	MOV  R30,R19
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xE
; 0000 00B9         }
	SUBI R19,-1
	RJMP _0x29
_0x2A:
; 0000 00BA         /* Sắp xếp tu min-> max*/
; 0000 00BB         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x2C:
	CPI  R19,5
	BRSH _0x2D
; 0000 00BC         {
; 0000 00BD             for(Uc_loop2_cnt = Uc_loop1_cnt; Uc_loop2_cnt<NUM_SAMPLE; Uc_loop2_cnt++)
	MOV  R18,R19
_0x2F:
	CPI  R18,5
	BRSH _0x30
; 0000 00BE             {
; 0000 00BF                 if(Uint_CurrentTmp_Array[Uc_loop1_cnt] > Uint_CurrentTmp_Array[Uc_loop2_cnt])
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xB
	BRSH _0x31
; 0000 00C0                 {
; 0000 00C1                     Uint_Tmp = Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xC
; 0000 00C2                     Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_CurrentTmp_Array[Uc_loop2_cnt];
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0000 00C3                     Uint_CurrentTmp_Array[Uc_loop2_cnt] = Uint_Tmp;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
; 0000 00C4                 }
; 0000 00C5             }
_0x31:
	SUBI R18,-1
	RJMP _0x2F
_0x30:
; 0000 00C6         }
	SUBI R19,-1
	RJMP _0x2C
_0x2D:
; 0000 00C7 
; 0000 00C8         /* Loc phan du lieu nhieu thap va cao */
; 0000 00C9         Ul_Sum = 0;
	RCALL SUBOPT_0x10
; 0000 00CA         for(Uc_loop1_cnt = NUM_FILTER;Uc_loop1_cnt<(NUM_SAMPLE - NUM_FILTER); Uc_loop1_cnt++)
_0x33:
	CPI  R19,4
	BRSH _0x34
; 0000 00CB         {
; 0000 00CC             Ul_Sum += Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x11
; 0000 00CD         }
	SUBI R19,-1
	RJMP _0x33
_0x34:
; 0000 00CE         Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
	RCALL SUBOPT_0x12
; 0000 00CF         /* Xuat du lieu len led */
; 0000 00D0         if(Uc_Timer_cnt == 200) Uint_dataLed2 = Ul_Sum;
	BRNE _0x35
	__PUTWMRN _Uint_dataLed2,0,20,21
; 0000 00D1         if(AI10_Current_Set < Uint_dataLed2)    Bit_Warning_2 =1;
_0x35:
	LDS  R30,_Uint_dataLed2
	LDS  R31,_Uint_dataLed2+1
	CP   R8,R30
	CPC  R9,R31
	BRSH _0x36
	SET
	RJMP _0x4D
; 0000 00D2         else Bit_Warning_2 = 0;
_0x36:
	CLT
_0x4D:
	BLD  R2,1
; 0000 00D3 
; 0000 00D4         /* Xu ly du lieu L3 */
; 0000 00D5         /* Chuyen sang bo nho dem*/
; 0000 00D6         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x39:
	CPI  R19,5
	BRSH _0x3A
; 0000 00D7         {
; 0000 00D8             Uint_CurrentTmp_Array[Uc_loop1_cnt] = AI10__Current_L3[Uc_loop1_cnt];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	MOV  R30,R19
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xE
; 0000 00D9         }
	SUBI R19,-1
	RJMP _0x39
_0x3A:
; 0000 00DA         /* Sắp xếp tu min-> max*/
; 0000 00DB         for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
	LDI  R19,LOW(0)
_0x3C:
	CPI  R19,5
	BRSH _0x3D
; 0000 00DC         {
; 0000 00DD             for(Uc_loop2_cnt = Uc_loop1_cnt; Uc_loop2_cnt<NUM_SAMPLE; Uc_loop2_cnt++)
	MOV  R18,R19
_0x3F:
	CPI  R18,5
	BRSH _0x40
; 0000 00DE             {
; 0000 00DF                 if(Uint_CurrentTmp_Array[Uc_loop1_cnt] > Uint_CurrentTmp_Array[Uc_loop2_cnt])
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xB
	BRSH _0x41
; 0000 00E0                 {
; 0000 00E1                     Uint_Tmp = Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xC
; 0000 00E2                     Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_CurrentTmp_Array[Uc_loop2_cnt];
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0000 00E3                     Uint_CurrentTmp_Array[Uc_loop2_cnt] = Uint_Tmp;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
; 0000 00E4                 }
; 0000 00E5             }
_0x41:
	SUBI R18,-1
	RJMP _0x3F
_0x40:
; 0000 00E6         }
	SUBI R19,-1
	RJMP _0x3C
_0x3D:
; 0000 00E7         /* Loc phan du lieu nhieu thap va cao */
; 0000 00E8         Ul_Sum = 0;
	RCALL SUBOPT_0x10
; 0000 00E9         for(Uc_loop1_cnt = NUM_FILTER;Uc_loop1_cnt<(NUM_SAMPLE - NUM_FILTER); Uc_loop1_cnt++)
_0x43:
	CPI  R19,4
	BRSH _0x44
; 0000 00EA         {
; 0000 00EB             Ul_Sum += Uint_CurrentTmp_Array[Uc_loop1_cnt];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x11
; 0000 00EC         }
	SUBI R19,-1
	RJMP _0x43
_0x44:
; 0000 00ED         Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
	RCALL SUBOPT_0x12
; 0000 00EE         /* Xuat du lieu len led */
; 0000 00EF         if(Uc_Timer_cnt == 200)
	BRNE _0x45
; 0000 00F0         {
; 0000 00F1             Uint_dataLed3 = Ul_Sum;
	__PUTWMRN _Uint_dataLed3,0,20,21
; 0000 00F2             Uc_Timer_cnt = 0;
	CLR  R11
; 0000 00F3         }
; 0000 00F4         if(AI10_Current_Set < Uint_dataLed3)    Bit_Warning_3 =1;
_0x45:
	LDS  R30,_Uint_dataLed3
	LDS  R31,_Uint_dataLed3+1
	CP   R8,R30
	CPC  R9,R31
	BRSH _0x46
	SET
	RJMP _0x4E
; 0000 00F5         else Bit_Warning_3 = 0;
_0x46:
	CLT
_0x4E:
	BLD  R2,2
; 0000 00F6     }
_0x17:
; 0000 00F7 }
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
;
;void main(void)
; 0000 00FA {
_main:
; .FSTART _main
; 0000 00FB // Declare your local variables here
; 0000 00FC // Input/Output Ports initialization
; 0000 00FD // Port B initialization
; 0000 00FE // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=Out Bit0=In
; 0000 00FF DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(58)
	OUT  0x17,R30
; 0000 0100 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=0 Bit0=T
; 0000 0101 PORTB=(0<<PORTB7) | (0<<PORTB6) | (1<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(42)
	OUT  0x18,R30
; 0000 0102 
; 0000 0103 // Port C initialization
; 0000 0104 // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 0105 DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(60)
	OUT  0x14,R30
; 0000 0106 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0107 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0108 
; 0000 0109 // Port D initialization
; 0000 010A // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 010B DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(18)
	OUT  0x11,R30
; 0000 010C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 010D PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 010E 
; 0000 010F // Timer/Counter 0 initialization
; 0000 0110 // Clock source: System Clock
; 0000 0111 // Clock value: Timer 0 Stopped
; 0000 0112 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0113 TCNT0=0x94;
	LDI  R30,LOW(148)
	OUT  0x32,R30
; 0000 0114 
; 0000 0115 // Timer/Counter 1 initialization
; 0000 0116 // Clock source: System Clock
; 0000 0117 // Clock value: 11059.200 kHz
; 0000 0118 // Mode: Normal top=0xFFFF
; 0000 0119 // OC1A output: Disconnected
; 0000 011A // OC1B output: Disconnected
; 0000 011B // Noise Canceler: Off
; 0000 011C // Input Capture on Falling Edge
; 0000 011D // Timer Period: 2 ms
; 0000 011E // Timer1 Overflow Interrupt: On
; 0000 011F // Input Capture Interrupt: Off
; 0000 0120 // Compare A Match Interrupt: Off
; 0000 0121 // Compare B Match Interrupt: Off
; 0000 0122 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0123 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 0124 TCNT1H=0xA9;
	LDI  R30,LOW(169)
	OUT  0x2D,R30
; 0000 0125 TCNT1L=0x9A;
	LDI  R30,LOW(154)
	OUT  0x2C,R30
; 0000 0126 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0127 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0128 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0129 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 012A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 012B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 012C 
; 0000 012D // Timer/Counter 2 initialization
; 0000 012E // Clock source: System Clock
; 0000 012F // Clock value: Timer2 Stopped
; 0000 0130 // Mode: Normal top=0xFF
; 0000 0131 // OC2 output: Disconnected
; 0000 0132 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0133 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0134 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0135 OCR2=0x00;
	OUT  0x23,R30
; 0000 0136 
; 0000 0137 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0138 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0139 
; 0000 013A // External Interrupt(s) initialization
; 0000 013B // INT0: Off
; 0000 013C // INT1: Off
; 0000 013D MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 013E 
; 0000 013F // USART initialization
; 0000 0140 // USART disabled
; 0000 0141 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0142 
; 0000 0143 // Analog Comparator initialization
; 0000 0144 // Analog Comparator: Off
; 0000 0145 // The Analog Comparator's positive input is
; 0000 0146 // connected to the AIN0 pin
; 0000 0147 // The Analog Comparator's negative input is
; 0000 0148 // connected to the AIN1 pin
; 0000 0149 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 014A 
; 0000 014B // ADC initialization
; 0000 014C // ADC Clock frequency: 345.600 kHz
; 0000 014D // ADC Voltage Reference: AREF pin
; 0000 014E ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 014F ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(133)
	OUT  0x6,R30
; 0000 0150 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0151 
; 0000 0152 // SPI initialization
; 0000 0153 // SPI disabled
; 0000 0154 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0155 
; 0000 0156 // TWI initialization
; 0000 0157 // TWI disabled
; 0000 0158 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0159 
; 0000 015A // Global enable interrupts
; 0000 015B #asm("sei")
	sei
; 0000 015C Uint_dataLed1 = 8888;
	LDI  R30,LOW(8888)
	LDI  R31,HIGH(8888)
	STS  _Uint_dataLed1,R30
	STS  _Uint_dataLed1+1,R31
; 0000 015D Uint_dataLed2 = 8888;
	STS  _Uint_dataLed2,R30
	STS  _Uint_dataLed2+1,R31
; 0000 015E Uint_dataLed3 = 8888;
	STS  _Uint_dataLed3,R30
	STS  _Uint_dataLed3+1,R31
; 0000 015F ADE_7753_init();
	RCALL _ADE_7753_init
; 0000 0160 Bit_Warning_1 =1;
	SET
	BLD  R2,0
; 0000 0161 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0162 Bit_Warning_1 = 0;
	CLT
	BLD  R2,0
; 0000 0163 while (1)
_0x48:
; 0000 0164     {
; 0000 0165         Read_Current();
	RCALL _Read_Current
; 0000 0166     }
	RJMP _0x48
; 0000 0167 }
_0x4B:
	RJMP _0x4B
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
	MOV  R30,R16
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x20006
	SBI  0x12,1
; 0001 000C         else DOUT_MOSI_SPI_7753_MCU = 0;
	RJMP _0x20009
_0x20006:
	CBI  0x12,1
; 0001 000D 
; 0001 000E         tmp <<= 1;
_0x20009:
	RCALL SUBOPT_0x13
; 0001 000F         DOUT_CLK_SPI_7753_MCU = 1;
; 0001 0010         delay_us(40);
; 0001 0011         DOUT_CLK_SPI_7753_MCU = 0;
	RCALL SUBOPT_0x14
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
; 0001 001D         data <<= 1;
	RCALL SUBOPT_0x13
; 0001 001E         DOUT_CLK_SPI_7753_MCU = 1;
; 0001 001F         delay_us(40);
; 0001 0020         if(DIN_MISO_SPI_7753_MCU == 1)   data += 1;
	SBIC 0x10,0
	SUBI R16,-LOW(1)
; 0001 0021         DOUT_CLK_SPI_7753_MCU = 0;
	RCALL SUBOPT_0x14
; 0001 0022         delay_us(40);
; 0001 0023 
; 0001 0024     }
	SUBI R17,-1
	RJMP _0x20011
_0x20012:
; 0001 0025     return data;
	MOV  R30,R16
	RJMP _0x2000001
; 0001 0026 }
; .FEND
;
;void    Write_ADE7753(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char d ...
; 0001 0029 {
_Write_ADE7753:
; .FSTART _Write_ADE7753
; 0001 002A     unsigned char data[4];
; 0001 002B     unsigned char   i;
; 0001 002C     data[0] = data_1;
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	IC_CS -> Y+10
;	addr -> Y+9
;	num_data -> Y+8
;	data_1 -> Y+7
;	data_2 -> Y+6
;	data_3 -> Y+5
;	data -> Y+1
;	i -> R17
	LDD  R30,Y+7
	STD  Y+1,R30
; 0001 002D     data[1] = data_2;
	LDD  R30,Y+6
	STD  Y+2,R30
; 0001 002E     data[2] = data_3;
	LDD  R30,Y+5
	STD  Y+3,R30
; 0001 002F 
; 0001 0030     switch (IC_CS)
	LDD  R30,Y+10
	RCALL SUBOPT_0x15
; 0001 0031     {
; 0001 0032         case 1:
	BRNE _0x2001B
; 0001 0033         {
; 0001 0034             PHASE_1_ON;
	SBI  0x15,4
; 0001 0035             PHASE_2_OFF;
	RCALL SUBOPT_0x16
; 0001 0036             PHASE_3_OFF;
; 0001 0037             break;
	RJMP _0x2001A
; 0001 0038         }
; 0001 0039         case 2:
_0x2001B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20022
; 0001 003A         {
; 0001 003B             PHASE_1_OFF;
	CBI  0x15,4
; 0001 003C             PHASE_2_ON;
	SBI  0x15,5
; 0001 003D             PHASE_3_OFF;
	CBI  0x15,3
; 0001 003E             break;
	RJMP _0x2001A
; 0001 003F         }
; 0001 0040         case 3:
_0x20022:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2001A
; 0001 0041         {
; 0001 0042             PHASE_1_OFF;
	CBI  0x15,4
; 0001 0043             PHASE_2_OFF;
	CBI  0x15,5
; 0001 0044             PHASE_3_ON;
	SBI  0x15,3
; 0001 0045             break;
; 0001 0046         }
; 0001 0047     }
_0x2001A:
; 0001 0048     addr |= 0x80;
	LDD  R30,Y+9
	ORI  R30,0x80
	STD  Y+9,R30
; 0001 0049     Send_cmd_ADE7753(addr);
	LDD  R26,Y+9
	RCALL _Send_cmd_ADE7753
; 0001 004A     delay_us(20);
	__DELAY_USB 74
; 0001 004B     for(i=0;i<num_data;i++)    Send_cmd_ADE7753(data[i]);
	LDI  R17,LOW(0)
_0x20031:
	LDD  R30,Y+8
	CP   R17,R30
	BRSH _0x20032
	RCALL SUBOPT_0x17
	MOVW R26,R28
	ADIW R26,1
	RCALL SUBOPT_0x9
	LD   R26,X
	RCALL _Send_cmd_ADE7753
	SUBI R17,-1
	RJMP _0x20031
_0x20032:
; 0001 004C PORTC.4 = 0;
	CBI  0x15,4
; 0001 004D     PHASE_2_OFF;
	RCALL SUBOPT_0x16
; 0001 004E     PHASE_3_OFF;
; 0001 004F }
	LDD  R17,Y+0
	ADIW R28,11
	RET
; .FEND
;unsigned long    Read_ADE7753(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
; 0001 0051 {
_Read_ADE7753:
; .FSTART _Read_ADE7753
; 0001 0052     unsigned char   i;
; 0001 0053     unsigned char   data[4];
; 0001 0054     unsigned long int res;
; 0001 0055     for(i=0;i<4;i++)    data[i] = 0;
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
	RCALL SUBOPT_0x17
	MOVW R26,R28
	ADIW R26,5
	RCALL SUBOPT_0x9
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x2003A
_0x2003B:
; 0001 0056 switch (IC_CS)
	LDD  R30,Y+11
	RCALL SUBOPT_0x15
; 0001 0057     {
; 0001 0058         case 1:
	BRNE _0x2003F
; 0001 0059         {
; 0001 005A             PHASE_1_ON;
	SBI  0x15,4
; 0001 005B             PHASE_2_OFF;
	RCALL SUBOPT_0x16
; 0001 005C             PHASE_3_OFF;
; 0001 005D             break;
	RJMP _0x2003E
; 0001 005E         }
; 0001 005F         case 2:
_0x2003F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20046
; 0001 0060         {
; 0001 0061             PHASE_1_OFF;
	CBI  0x15,4
; 0001 0062             PHASE_2_ON;
	SBI  0x15,5
; 0001 0063             PHASE_3_OFF;
	CBI  0x15,3
; 0001 0064             break;
	RJMP _0x2003E
; 0001 0065         }
; 0001 0066         case 3:
_0x20046:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2003E
; 0001 0067         {
; 0001 0068             PHASE_1_OFF;
	CBI  0x15,4
; 0001 0069             PHASE_2_OFF;
	CBI  0x15,5
; 0001 006A             PHASE_3_ON;
	SBI  0x15,3
; 0001 006B             break;
; 0001 006C         }
; 0001 006D     }
_0x2003E:
; 0001 006E     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0001 006F     addr &= 0x3F;
	LDD  R30,Y+10
	ANDI R30,LOW(0x3F)
	STD  Y+10,R30
; 0001 0070     Send_cmd_ADE7753(addr);
	LDD  R26,Y+10
	RCALL _Send_cmd_ADE7753
; 0001 0071     for(i=0;i<num_data;i++) data[i] = Read_data_ADE7753();
	LDI  R17,LOW(0)
_0x20055:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x20056
	RCALL SUBOPT_0x17
	MOVW R26,R28
	ADIW R26,5
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _Read_data_ADE7753
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20055
_0x20056:
; 0001 0072 PORTC.4 = 0;
	CBI  0x15,4
; 0001 0073     PHASE_2_OFF;
	RCALL SUBOPT_0x16
; 0001 0074     PHASE_3_OFF;
; 0001 0075     res = 0;
	LDI  R30,LOW(0)
	__CLRD1S 1
; 0001 0076     for(i=0;i<num_data;i++)
	LDI  R17,LOW(0)
_0x2005E:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x2005F
; 0001 0077     {
; 0001 0078         res <<= 8;
	RCALL SUBOPT_0x18
	LDI  R30,LOW(8)
	RCALL __LSLD12
	RCALL SUBOPT_0x19
; 0001 0079         res += data[i];
	RCALL SUBOPT_0x17
	MOVW R26,R28
	ADIW R26,5
	RCALL SUBOPT_0x9
	LD   R30,X
	LDI  R31,0
	RCALL SUBOPT_0x18
	RCALL __CWD1
	RCALL __ADDD12
	RCALL SUBOPT_0x19
; 0001 007A     }
	SUBI R17,-1
	RJMP _0x2005E
_0x2005F:
; 0001 007B     return (res);
	__GETD1S 1
	LDD  R17,Y+0
	ADIW R28,12
	RET
; 0001 007C }
; .FEND
;
;
;void    ADE_7753_init(void)
; 0001 0080 {
_ADE_7753_init:
; .FSTART _ADE_7753_init
; 0001 0081     unsigned int   reg = 0;
; 0001 0082     Write_ADE7753(1,MODE,0x00,0x00,0x00);
	RCALL __SAVELOCR2
;	reg -> R16,R17
	__GETWRN 16,17,0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
; 0001 0083     delay_ms(500);
; 0001 0084     reg = 0;
	__GETWRN 16,17,0
; 0001 0085     reg |= (1<<SWRST);
	ORI  R16,LOW(64)
; 0001 0086     Write_ADE7753(1,MODE,(reg>>8)&0xFF,reg & 0xff,0x00);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1A
	ST   -Y,R17
	ST   -Y,R16
	RCALL SUBOPT_0x1C
; 0001 0087     delay_ms(500);
; 0001 0088     reg = Read_ADE7753(1,MODE);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1D
; 0001 0089     delay_ms(500);
	RCALL SUBOPT_0x1E
; 0001 008A     reg = Read_ADE7753(1,MODE);
	RCALL SUBOPT_0x1D
; 0001 008B     reg |= (1<<DISHPF) | (1<<WAVSEL0) | (1<<WAVSEL1);
	__ORWRN 16,17,24577
; 0001 008C     // Write_ADE7753(1,MODE,(reg>>8)&0xFF,reg & 0xff,0x00);
; 0001 008D     delay_ms(500);
	RCALL SUBOPT_0x1E
; 0001 008E     Write_ADE7753(1,SAGLVL,0X2a,0X00,0X00);
	LDI  R30,LOW(31)
	ST   -Y,R30
	RCALL SUBOPT_0x0
	LDI  R30,LOW(42)
	ST   -Y,R30
	RCALL SUBOPT_0x1B
	LDI  R26,LOW(0)
	RCALL _Write_ADE7753
; 0001 008F     Write_ADE7753(1,SAGCYC,0XFF,0X00,0X00);
	RCALL SUBOPT_0x0
	LDI  R30,LOW(30)
	ST   -Y,R30
	RCALL SUBOPT_0x0
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL SUBOPT_0x1B
	LDI  R26,LOW(0)
	RCALL _Write_ADE7753
; 0001 0090 }
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;#include "led.h"
;#include "mega8.h"
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
;unsigned char   BCDLED[11]={0xF9,0x81,0xBA,0xAB,0xC3,0x6B,0x7B,0xA1,0xFB,0xEB,0};

	.DSEG
;unsigned int    LED_SELECT[12] = {0x0001,0x0002,0x0004,0x0008,0x0040,0x0020,0x0010,0x0080,0x4000,0x2000,0x1000,0x8000};
;
;
;unsigned char   Uc_Select_led=1;
;
;/* Cac gia tri hien thi tren cac led */
;unsigned int   Uint_dataLed1 = 0;
;unsigned int   Uint_dataLed2 = 0;
;unsigned int   Uint_dataLed3 = 0;
;
;
;void    LED(void)
; 0002 0012 {

	.CSEG
_LED:
; .FSTART _LED
; 0002 0013     unsigned char data;
; 0002 0014     if(Uc_Select_led > NUM_7SEG) Uc_Select_led=1;
	ST   -Y,R17
;	data -> R17
	LDI  R30,LOW(12)
	CP   R30,R10
	BRSH _0x40005
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0002 0015 
; 0002 0016     if(Uc_Select_led == 1)    data = Uint_dataLed1/1000;
_0x40005:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x40006
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RJMP _0x4004C
; 0002 0017     else if(Uc_Select_led == 2)    data = Uint_dataLed1/100%10;
_0x40006:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x40008
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x21
	RJMP _0x4004D
; 0002 0018     else if(Uc_Select_led == 3)    data = Uint_dataLed1/10%10;
_0x40008:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x4000A
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x22
	RJMP _0x4004D
; 0002 0019     else if(Uc_Select_led == 4)    data = Uint_dataLed1%10;
_0x4000A:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x4000C
	RCALL SUBOPT_0x1F
	RJMP _0x4004D
; 0002 001A     else if(Uc_Select_led == 5)    data = Uint_dataLed2/1000;
_0x4000C:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x4000E
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x20
	RJMP _0x4004C
; 0002 001B     else if(Uc_Select_led == 6)    data = Uint_dataLed2/100%10;
_0x4000E:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x40010
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x21
	RJMP _0x4004D
; 0002 001C     else if(Uc_Select_led == 7)    data = Uint_dataLed2/10%10;
_0x40010:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x40012
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x22
	RJMP _0x4004D
; 0002 001D     else if(Uc_Select_led == 8)    data = Uint_dataLed2%10;
_0x40012:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x40014
	RCALL SUBOPT_0x23
	RJMP _0x4004D
; 0002 001E     else if(Uc_Select_led == 9)    data = Uint_dataLed3/1000;
_0x40014:
	LDI  R30,LOW(9)
	CP   R30,R10
	BRNE _0x40016
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x20
	RJMP _0x4004C
; 0002 001F     else if(Uc_Select_led == 10)    data = Uint_dataLed3/100%10;
_0x40016:
	LDI  R30,LOW(10)
	CP   R30,R10
	BRNE _0x40018
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x21
	RJMP _0x4004D
; 0002 0020     else if(Uc_Select_led == 11)    data = Uint_dataLed3/10%10;
_0x40018:
	LDI  R30,LOW(11)
	CP   R30,R10
	BRNE _0x4001A
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x22
	RJMP _0x4004D
; 0002 0021     else if(Uc_Select_led == 12)    data = Uint_dataLed3%10;
_0x4001A:
	LDI  R30,LOW(12)
	CP   R30,R10
	BRNE _0x4001C
	RCALL SUBOPT_0x24
_0x4004D:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
_0x4004C:
	MOV  R17,R30
; 0002 0022 
; 0002 0023     SCAN_LED(Uc_Select_led,data);
_0x4001C:
	ST   -Y,R10
	MOV  R26,R17
	RCALL _SCAN_LED
; 0002 0024     Uc_Select_led++;
	INC  R10
; 0002 0025 }
	LD   R17,Y+
	RET
; .FEND
;
;/*
;Gui data ra led
;Gui lan luot data_first, data_second, data_third
;Khi gui het du lieu se tien hanh xuat du lieu
;*/
;void    SEND_DATA_LED(unsigned char  data_first,unsigned char  data_second,unsigned char  data_third)
; 0002 002D {
_SEND_DATA_LED:
; .FSTART _SEND_DATA_LED
; 0002 002E     unsigned char   i;
; 0002 002F     unsigned char   data;
; 0002 0030     data = data_first;
	ST   -Y,R26
	RCALL __SAVELOCR2
;	data_first -> Y+4
;	data_second -> Y+3
;	data_third -> Y+2
;	i -> R17
;	data -> R16
	LDD  R16,Y+4
; 0002 0031     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x4001E:
	CPI  R17,8
	BRSH _0x4001F
; 0002 0032     {
; 0002 0033         if((data & 0x80))    DO_595_MOSI = 1;
	SBRS R16,7
	RJMP _0x40020
	SBI  0x18,3
; 0002 0034         else    DO_595_MOSI = 0;
	RJMP _0x40023
_0x40020:
	CBI  0x18,3
; 0002 0035         data <<= 1;
_0x40023:
	RCALL SUBOPT_0x25
; 0002 0036         DO_595_SCK = 1;
; 0002 0037         //delay_us(3);
; 0002 0038         DO_595_SCK = 0;
; 0002 0039         //delay_us(1);
; 0002 003A     }
	SUBI R17,-1
	RJMP _0x4001E
_0x4001F:
; 0002 003B     data = data_second;
	LDD  R16,Y+3
; 0002 003C     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x4002B:
	CPI  R17,8
	BRSH _0x4002C
; 0002 003D     {
; 0002 003E         if((data & 0x80))    DO_595_MOSI = 1;
	SBRS R16,7
	RJMP _0x4002D
	SBI  0x18,3
; 0002 003F         else    DO_595_MOSI = 0;
	RJMP _0x40030
_0x4002D:
	CBI  0x18,3
; 0002 0040         data <<= 1;
_0x40030:
	RCALL SUBOPT_0x25
; 0002 0041         DO_595_SCK = 1;
; 0002 0042         //delay_us(3);
; 0002 0043         DO_595_SCK = 0;
; 0002 0044         //delay_us(1);
; 0002 0045     }
	SUBI R17,-1
	RJMP _0x4002B
_0x4002C:
; 0002 0046     data = data_third;
	LDD  R16,Y+2
; 0002 0047     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x40038:
	CPI  R17,8
	BRSH _0x40039
; 0002 0048     {
; 0002 0049         if((data & 0x80))    DO_595_MOSI = 1;
	SBRS R16,7
	RJMP _0x4003A
	SBI  0x18,3
; 0002 004A         else    DO_595_MOSI = 0;
	RJMP _0x4003D
_0x4003A:
	CBI  0x18,3
; 0002 004B         data <<= 1;
_0x4003D:
	RCALL SUBOPT_0x25
; 0002 004C         DO_595_SCK = 1;
; 0002 004D         //delay_us(3);
; 0002 004E         DO_595_SCK = 0;
; 0002 004F         //delay_us(1);
; 0002 0050     }
	SUBI R17,-1
	RJMP _0x40038
_0x40039:
; 0002 0051     CTRL_595_ON;
	SBI  0x18,1
; 0002 0052     CTRL_595_OFF;
	CBI  0x18,1
; 0002 0053 }
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
; 0002 005B {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0002 005C     unsigned char   byte1,byte2,byte3;
; 0002 005D     byte1 = 0;
	ST   -Y,R26
	RCALL __SAVELOCR4
;	num_led -> Y+5
;	data -> Y+4
;	byte1 -> R17
;	byte2 -> R16
;	byte3 -> R19
	LDI  R17,LOW(0)
; 0002 005E     byte2 = 0;
	LDI  R16,LOW(0)
; 0002 005F     byte3 = 0;
	LDI  R19,LOW(0)
; 0002 0060 
; 0002 0061     byte2 = (LED_SELECT[num_led-1] >> 8) & 0xff;
	RCALL SUBOPT_0x26
	RCALL __GETW1P
	MOV  R30,R31
	LDI  R31,0
	MOV  R16,R30
; 0002 0062     byte3 = LED_SELECT[num_led-1] & 0xff;
	RCALL SUBOPT_0x26
	LD   R30,X
	MOV  R19,R30
; 0002 0063     if(num_led == 2 || num_led == 6 || num_led == 10)   byte1 = 0x04;
	LDD  R26,Y+5
	CPI  R26,LOW(0x2)
	BREQ _0x40049
	CPI  R26,LOW(0x6)
	BREQ _0x40049
	CPI  R26,LOW(0xA)
	BRNE _0x40048
_0x40049:
	LDI  R17,LOW(4)
; 0002 0064     byte1 |= BCDLED[data];
_0x40048:
	LDD  R30,Y+4
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R30,Z
	OR   R17,R30
; 0002 0065     if(data == 10)
	LDD  R26,Y+4
	CPI  R26,LOW(0xA)
	BRNE _0x4004B
; 0002 0066     {
; 0002 0067         byte3 = 0;
	LDI  R19,LOW(0)
; 0002 0068         byte2 = 0;
	LDI  R16,LOW(0)
; 0002 0069         byte1 = 0;
	LDI  R17,LOW(0)
; 0002 006A     }
; 0002 006B     SEND_DATA_LED(byte1,byte2,byte3);
_0x4004B:
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R19
	RCALL _SEND_DATA_LED
; 0002 006C }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND

	.DSEG
_Uint_dataLed1:
	.BYTE 0x2
_Uint_dataLed2:
	.BYTE 0x2
_Uint_dataLed3:
	.BYTE 0x2
_AI10__Current_L1:
	.BYTE 0xA
_AI10__Current_L2:
	.BYTE 0xA
_AI10__Current_L3:
	.BYTE 0xA
_BCDLED:
	.BYTE 0xB
_LED_SELECT:
	.BYTE 0x18

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _Read_ADE7753
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	RCALL __DIVD21U
	__PUTD1S 6
	MOV  R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_AI10__Current_L1)
	LDI  R27,HIGH(_AI10__Current_L1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4:
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_AI10__Current_L2)
	LDI  R27,HIGH(_AI10__Current_L2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_AI10__Current_L3)
	LDI  R27,HIGH(_AI10__Current_L3)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:68 WORDS
SUBOPT_0x7:
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,10
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x9:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	RCALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x9
	LD   R0,X+
	LD   R1,X
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,10
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x9
	RCALL __GETW1P
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0x9
	LD   R16,X+
	LD   R17,X
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xD:
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,10
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0x9
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
	STD  Z+1,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	__GETWRN 20,21,0
	LDI  R19,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0x9
	RCALL __GETW1P
	__ADDWRR 20,21,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x12:
	MOVW R26,R20
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL __DIVW21U
	MOVW R20,R30
	LDI  R30,LOW(200)
	CP   R30,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LSL  R16
	SBI  0x12,4
	__DELAY_USB 147
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CBI  0x12,4
	__DELAY_USB 147
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	CBI  0x15,5
	CBI  0x15,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(0)
	RCALL _Write_ADE7753
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Read_ADE7753
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	LDS  R26,_Uint_dataLed1
	LDS  R27,_Uint_dataLed1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	LDS  R26,_Uint_dataLed2
	LDS  R27,_Uint_dataLed2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
	LDS  R26,_Uint_dataLed3
	LDS  R27,_Uint_dataLed3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LSL  R16
	SBI  0x18,5
	CBI  0x18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDD  R30,Y+5
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_LED_SELECT)
	LDI  R27,HIGH(_LED_SELECT)
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x9


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

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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
