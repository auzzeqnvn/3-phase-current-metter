
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
	.DEF _cnt=R6
	.DEF _data=R5
	.DEF _data1=R7
	.DEF _data1_msb=R8
	.DEF _data2=R9
	.DEF _data2_msb=R10
	.DEF _data3=R11
	.DEF _data3_msb=R12

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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x05
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
;#define CS_PHASE1_MCU   PORTC.4
;#define CS_PHASE2_MCU   PORTC.5
;#define CS_PHASE3_MCU   PORTC.3
;
;#define PHASE_1_ON  CS_PHASE1_MCU = 1
;#define PHASE_1_OFF CS_PHASE1_MCU = 0
;#define PHASE_2_ON  CS_PHASE2_MCU = 1
;#define PHASE_2_OFF CS_PHASE2_MCU = 0
;#define PHASE_3_ON  CS_PHASE3_MCU = 1
;#define PHASE_3_OFF CS_PHASE3_MCU = 0
;
;#define DOUT_MOSI_SPI_7753_MCU   PORTD.1
;#define DIN_MISO_SPI_7753_MCU    PIND.0
;#define DOUT_CLK_SPI_7753_MCU   PORTD.4
;
;//Dia chi cac thanh ghi SPI_ADE7753
;#define WAVEFORM        0x01,3
;#define AENERGY         0x02,3
;#define RAENERGY        0x03,3
;#define LAENERGY		0x04,3
;#define VAENERGY		0x05,3
;#define RVAENERGY		0x06,3
;#define LVAENERGY		0x07,3
;#define LVARENERGY		0x08,3
;#define MODE			0x09,2
;#define IRQEN			0x0A,2
;#define STATUS			0x0B,2
;#define RSTSTATUS		0x0C,2
;#define CH1OS			0x0D,1
;#define CH2OS			0x0E,1
;#define GAIN			0x0F,1
;#define PHCAL			0x10,1
;#define APOS			0x11,2
;#define WGAIN			0x12,2
;#define WDIV			0x13,1
;#define CFNUM			0x14,2
;#define CFDEN			0x15,2
;#define IRMS			0x16,3
;#define VRMS			0x17,3
;#define IRMSOS			0x18,2
;#define VRMSOS			0x19,2
;#define VAGAIN			0x1A,2
;#define VADIV			0x1B,1
;#define LINECYC			0x1C,2
;#define ZXTOUT			0x1D,2
;#define SAGCYC			0x1E,1
;#define SAGLVL			0x1F,1
;#define IPKLVL			0x20,1
;#define VPKLVL			0x21,1
;#define IPEAK			0x22,3
;#define RSTIPEAK		0x23,3
;#define VPEAK			0x24,3
;#define RSTVPEAK		0x25,3
;#define TEMP			0x26,1
;#define PERIOD			0x27,2
;#define TMODE			0x3D,1
;#define CHKSUM			0x3E,1
;#define DIEREV			0x3F,1
;
;void    SEND_DATA_LED(unsigned char  data_first,unsigned char  data_second,unsigned char  data_third);
;void    SCAN_LED(unsigned char num_led,unsigned char    data);
;
;unsigned char   cnt=1;
;unsigned char   data = 0;
;unsigned int   data1 = 0;
;unsigned int   data2 = 0;
;unsigned int   data3 = 0;
;
;unsigned long int   CURRENT = 0;
;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0073 {

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
; 0000 0074 // Reinitialize Timer1 value
; 0000 0075     TCNT1H=0xAA00 >> 8;
	LDI  R30,LOW(170)
	OUT  0x2D,R30
; 0000 0076     TCNT1L=0xAA00 & 0xff;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 0077 // Place your code here
; 0000 0078     if(cnt > 12) cnt=1;
	LDI  R30,LOW(12)
	CP   R30,R6
	BRSH _0x3
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0079     if(cnt == 1)    data = data1/1000;
_0x3:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x4
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RJMP _0xC5
; 0000 007A     else if(cnt == 2)    data = data1/100%10;
_0x4:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x6
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x2
	RJMP _0xC6
; 0000 007B     else if(cnt == 3)    data = data1/10%10;
_0x6:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x8
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x3
	RJMP _0xC6
; 0000 007C     else if(cnt == 4)    data = data1%10;
_0x8:
	LDI  R30,LOW(4)
	CP   R30,R6
	BRNE _0xA
	RCALL SUBOPT_0x0
	RJMP _0xC6
; 0000 007D     else if(cnt == 5)    data = data2/1000;
_0xA:
	LDI  R30,LOW(5)
	CP   R30,R6
	BRNE _0xC
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x1
	RJMP _0xC5
; 0000 007E     else if(cnt == 6)    data = data2/100%10;
_0xC:
	LDI  R30,LOW(6)
	CP   R30,R6
	BRNE _0xE
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x2
	RJMP _0xC6
; 0000 007F     else if(cnt == 7)    data = data2/10%10;
_0xE:
	LDI  R30,LOW(7)
	CP   R30,R6
	BRNE _0x10
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x3
	RJMP _0xC6
; 0000 0080     else if(cnt == 8)    data = data2%10;
_0x10:
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x12
	RCALL SUBOPT_0x4
	RJMP _0xC6
; 0000 0081     else if(cnt == 9)    data = data3/1000;
_0x12:
	LDI  R30,LOW(9)
	CP   R30,R6
	BRNE _0x14
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x1
	RJMP _0xC5
; 0000 0082     else if(cnt == 10)    data = data3/100%10;
_0x14:
	LDI  R30,LOW(10)
	CP   R30,R6
	BRNE _0x16
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x2
	RJMP _0xC6
; 0000 0083     else if(cnt == 11)    data = data3/10%10;
_0x16:
	LDI  R30,LOW(11)
	CP   R30,R6
	BRNE _0x18
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	RJMP _0xC6
; 0000 0084     else if(cnt == 12)    data = data3%10;
_0x18:
	LDI  R30,LOW(12)
	CP   R30,R6
	BRNE _0x1A
	RCALL SUBOPT_0x5
_0xC6:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
_0xC5:
	MOV  R5,R30
; 0000 0085     SCAN_LED(cnt++,data);
_0x1A:
	MOV  R30,R6
	INC  R6
	ST   -Y,R30
	MOV  R26,R5
	RCALL _SCAN_LED
; 0000 0086     data3++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
; 0000 0087 }
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
; 0000 008E {
_read_adc:
; .FSTART _read_adc
; 0000 008F     ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0090     // Delay needed for the stabilization of the ADC input voltage
; 0000 0091     delay_us(10);
	__DELAY_USB 37
; 0000 0092     // Start the AD conversion
; 0000 0093     ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0094     // Wait for the AD conversion to complete
; 0000 0095     while ((ADCSRA & (1<<ADIF))==0);
_0x1B:
	SBIS 0x6,4
	RJMP _0x1B
; 0000 0096     ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0097     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0098 }
; .FEND
;
;void    SEND_DATA_LED(unsigned char  data_first,unsigned char  data_second,unsigned char  data_third)
; 0000 009B {
_SEND_DATA_LED:
; .FSTART _SEND_DATA_LED
; 0000 009C     unsigned char   i;
; 0000 009D     unsigned char   data;
; 0000 009E     data = data_first;
	ST   -Y,R26
	RCALL __SAVELOCR2
;	data_first -> Y+4
;	data_second -> Y+3
;	data_third -> Y+2
;	i -> R17
;	data -> R16
	LDD  R16,Y+4
; 0000 009F     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x1F:
	CPI  R17,8
	BRSH _0x20
; 0000 00A0     {
; 0000 00A1         if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
	RCALL SUBOPT_0x6
	BRNE _0x21
	SBI  0x18,3
; 0000 00A2         else    DO_595_MOSI = 0;
	RJMP _0x24
_0x21:
	CBI  0x18,3
; 0000 00A3         data <<= 1;
_0x24:
	RCALL SUBOPT_0x7
; 0000 00A4         DO_595_SCK = 0;
; 0000 00A5         DO_595_SCK = 1;
; 0000 00A6     }
	SUBI R17,-1
	RJMP _0x1F
_0x20:
; 0000 00A7     data = data_second;
	LDD  R16,Y+3
; 0000 00A8     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x2C:
	CPI  R17,8
	BRSH _0x2D
; 0000 00A9     {
; 0000 00AA         if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
	RCALL SUBOPT_0x6
	BRNE _0x2E
	SBI  0x18,3
; 0000 00AB         else    DO_595_MOSI = 0;
	RJMP _0x31
_0x2E:
	CBI  0x18,3
; 0000 00AC         data <<= 1;
_0x31:
	RCALL SUBOPT_0x7
; 0000 00AD         DO_595_SCK = 0;
; 0000 00AE         DO_595_SCK = 1;
; 0000 00AF     }
	SUBI R17,-1
	RJMP _0x2C
_0x2D:
; 0000 00B0     data = data_third;
	LDD  R16,Y+2
; 0000 00B1     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x39:
	CPI  R17,8
	BRSH _0x3A
; 0000 00B2     {
; 0000 00B3         if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
	RCALL SUBOPT_0x6
	BRNE _0x3B
	SBI  0x18,3
; 0000 00B4         else    DO_595_MOSI = 0;
	RJMP _0x3E
_0x3B:
	CBI  0x18,3
; 0000 00B5         data <<= 1;
_0x3E:
	RCALL SUBOPT_0x7
; 0000 00B6         DO_595_SCK = 0;
; 0000 00B7         DO_595_SCK = 1;
; 0000 00B8     }
	SUBI R17,-1
	RJMP _0x39
_0x3A:
; 0000 00B9     CTRL_595_ON;
	SBI  0x18,1
; 0000 00BA     CTRL_595_OFF;
	CBI  0x18,1
; 0000 00BB }
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
;
;void    SCAN_LED(unsigned char num_led,unsigned char    data)
; 0000 00BE {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0000 00BF     unsigned char   byte1,byte2,byte3;
; 0000 00C0     byte1 = 0;
	ST   -Y,R26
	RCALL __SAVELOCR4
;	num_led -> Y+5
;	data -> Y+4
;	byte1 -> R17
;	byte2 -> R16
;	byte3 -> R19
	LDI  R17,LOW(0)
; 0000 00C1     byte2 = 0;
	LDI  R16,LOW(0)
; 0000 00C2     byte3 = 0;
	LDI  R19,LOW(0)
; 0000 00C3     switch(num_led)
	LDD  R30,Y+5
	RCALL SUBOPT_0x8
; 0000 00C4     {
; 0000 00C5         case    1:
	BRNE _0x4C
; 0000 00C6         {
; 0000 00C7             byte3 = 0x01;
	LDI  R19,LOW(1)
; 0000 00C8             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00C9             break;
	RJMP _0x4B
; 0000 00CA         }
; 0000 00CB         case    2:
_0x4C:
	RCALL SUBOPT_0x9
	BRNE _0x4D
; 0000 00CC         {
; 0000 00CD             byte3 = 0x02;
	LDI  R19,LOW(2)
; 0000 00CE             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00CF             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0000 00D0             break;
	RJMP _0x4B
; 0000 00D1         }
; 0000 00D2         case    3:
_0x4D:
	RCALL SUBOPT_0xA
	BRNE _0x4E
; 0000 00D3         {
; 0000 00D4             byte3 = 0x04;
	LDI  R19,LOW(4)
; 0000 00D5             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00D6             break;
	RJMP _0x4B
; 0000 00D7         }
; 0000 00D8         case    4:
_0x4E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4F
; 0000 00D9         {
; 0000 00DA             byte3 = 0x08;
	LDI  R19,LOW(8)
; 0000 00DB             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00DC             break;
	RJMP _0x4B
; 0000 00DD         }
; 0000 00DE         case    5:
_0x4F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x50
; 0000 00DF         {
; 0000 00E0             byte3 = 0x40;
	LDI  R19,LOW(64)
; 0000 00E1             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00E2             break;
	RJMP _0x4B
; 0000 00E3         }
; 0000 00E4         case    6:
_0x50:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x51
; 0000 00E5         {
; 0000 00E6             byte3 = 0x20;
	LDI  R19,LOW(32)
; 0000 00E7             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00E8             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0000 00E9             break;
	RJMP _0x4B
; 0000 00EA         }
; 0000 00EB         case    7:
_0x51:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x52
; 0000 00EC         {
; 0000 00ED             byte3 = 0x10;
	LDI  R19,LOW(16)
; 0000 00EE             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00EF             break;
	RJMP _0x4B
; 0000 00F0         }
; 0000 00F1         case    8:
_0x52:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x53
; 0000 00F2         {
; 0000 00F3             byte3 = 0x80;
	LDI  R19,LOW(128)
; 0000 00F4             byte2 = 0x00;
	LDI  R16,LOW(0)
; 0000 00F5             break;
	RJMP _0x4B
; 0000 00F6         }
; 0000 00F7         case    9:
_0x53:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x54
; 0000 00F8         {
; 0000 00F9             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0000 00FA             byte2 = 0x40;
	LDI  R16,LOW(64)
; 0000 00FB             break;
	RJMP _0x4B
; 0000 00FC         }
; 0000 00FD         case    10:
_0x54:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x55
; 0000 00FE         {
; 0000 00FF             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0000 0100             byte2 = 0x20;
	LDI  R16,LOW(32)
; 0000 0101             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0000 0102             break;
	RJMP _0x4B
; 0000 0103         }
; 0000 0104         case    11:
_0x55:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x56
; 0000 0105         {
; 0000 0106             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0000 0107             byte2 = 0x10;
	LDI  R16,LOW(16)
; 0000 0108             break;
	RJMP _0x4B
; 0000 0109         }
; 0000 010A         case    12:
_0x56:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x4B
; 0000 010B         {
; 0000 010C             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0000 010D             byte2 = 0x80;
	LDI  R16,LOW(128)
; 0000 010E             break;
; 0000 010F         }
; 0000 0110     }
_0x4B:
; 0000 0111     switch(data)
	LDD  R30,Y+4
	LDI  R31,0
; 0000 0112     {
; 0000 0113         case    0:
	SBIW R30,0
	BRNE _0x5B
; 0000 0114         {
; 0000 0115             byte1 |= 0xF9;
	ORI  R17,LOW(249)
; 0000 0116             break;
	RJMP _0x5A
; 0000 0117         }
; 0000 0118         case    1:
_0x5B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5C
; 0000 0119         {
; 0000 011A             byte1 |= 0x81;
	ORI  R17,LOW(129)
; 0000 011B             break;
	RJMP _0x5A
; 0000 011C         }
; 0000 011D         case    2:
_0x5C:
	RCALL SUBOPT_0x9
	BRNE _0x5D
; 0000 011E         {
; 0000 011F             byte1 |= 0xBA;
	ORI  R17,LOW(186)
; 0000 0120             break;
	RJMP _0x5A
; 0000 0121         }
; 0000 0122         case    3:
_0x5D:
	RCALL SUBOPT_0xA
	BRNE _0x5E
; 0000 0123         {
; 0000 0124             byte1 |= 0xAB;
	ORI  R17,LOW(171)
; 0000 0125             break;
	RJMP _0x5A
; 0000 0126         }
; 0000 0127         case    4:
_0x5E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x5F
; 0000 0128         {
; 0000 0129             byte1 |= 0xC3;
	ORI  R17,LOW(195)
; 0000 012A             break;
	RJMP _0x5A
; 0000 012B         }
; 0000 012C         case    5:
_0x5F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x60
; 0000 012D         {
; 0000 012E             byte1 |= 0x6B;
	ORI  R17,LOW(107)
; 0000 012F             break;
	RJMP _0x5A
; 0000 0130         }
; 0000 0131         case    6:
_0x60:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x61
; 0000 0132         {
; 0000 0133             byte1 |= 0x7B;
	ORI  R17,LOW(123)
; 0000 0134             break;
	RJMP _0x5A
; 0000 0135         }
; 0000 0136         case    7:
_0x61:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x62
; 0000 0137         {
; 0000 0138             byte1 = 0xA1;
	LDI  R17,LOW(161)
; 0000 0139             break;
	RJMP _0x5A
; 0000 013A         }
; 0000 013B         case    8:
_0x62:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x63
; 0000 013C         {
; 0000 013D             byte1 |= 0xFB;
	ORI  R17,LOW(251)
; 0000 013E             break;
	RJMP _0x5A
; 0000 013F         }
; 0000 0140         case    9:
_0x63:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x5A
; 0000 0141         {
; 0000 0142             byte1 |= 0xEB;
	ORI  R17,LOW(235)
; 0000 0143             break;
; 0000 0144         }
; 0000 0145     }
_0x5A:
; 0000 0146     SEND_DATA_LED(byte1,byte2,byte3);
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R19
	RCALL _SEND_DATA_LED
; 0000 0147 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;void    SPI_7753_SEND(unsigned char data)
; 0000 014A {
_SPI_7753_SEND:
; .FSTART _SPI_7753_SEND
; 0000 014B     unsigned char cnt;
; 0000 014C     unsigned char   tmp = data;
; 0000 014D     for(cnt = 0;cnt < 8; cnt++)
	ST   -Y,R26
	RCALL __SAVELOCR2
;	data -> Y+2
;	cnt -> R17
;	tmp -> R16
	LDD  R16,Y+2
	LDI  R17,LOW(0)
_0x66:
	CPI  R17,8
	BRSH _0x67
; 0000 014E     {
; 0000 014F         if((tmp & 0x80) == 0x80)   DOUT_MOSI_SPI_7753_MCU = 1;
	RCALL SUBOPT_0x6
	BRNE _0x68
	SBI  0x12,1
; 0000 0150         DOUT_MOSI_SPI_7753_MCU = 0;
_0x68:
	CBI  0x12,1
; 0000 0151         tmp <<= 1;
	LSL  R16
; 0000 0152         // DOUT_CLK_SPI_7753_MCU = 0;
; 0000 0153         DOUT_CLK_SPI_7753_MCU = 1;
	SBI  0x12,4
; 0000 0154         DOUT_CLK_SPI_7753_MCU = 0;
	CBI  0x12,4
; 0000 0155     }
	SUBI R17,-1
	RJMP _0x66
_0x67:
; 0000 0156 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; .FEND
;
;unsigned char    SPI_7753_RECEIVE(void)
; 0000 0159 {
_SPI_7753_RECEIVE:
; .FSTART _SPI_7753_RECEIVE
; 0000 015A     unsigned char cnt;
; 0000 015B     unsigned char data;
; 0000 015C     data = 0;
	RCALL __SAVELOCR2
;	cnt -> R17
;	data -> R16
	LDI  R16,LOW(0)
; 0000 015D     for(cnt = 0;cnt < 8; cnt++)
	LDI  R17,LOW(0)
_0x72:
	CPI  R17,8
	BRSH _0x73
; 0000 015E     {
; 0000 015F         // DOUT_CLK_SPI_7753_MCU = 0;
; 0000 0160         DOUT_CLK_SPI_7753_MCU = 1;
	SBI  0x12,4
; 0000 0161         if(DIN_MISO_SPI_7753_MCU == 1)   data += 1;
	SBIC 0x10,0
	SUBI R16,-LOW(1)
; 0000 0162         data <<= 1;
	LSL  R16
; 0000 0163         DOUT_CLK_SPI_7753_MCU = 0;
	CBI  0x12,4
; 0000 0164         // DOUT_CLK_SPI_7753_MCU = 0;
; 0000 0165         // DOUT_CLK_SPI_7753_MCU = 1;
; 0000 0166     }
	SUBI R17,-1
	RJMP _0x72
_0x73:
; 0000 0167     return data;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0168 }
; .FEND
;
;void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char d ...
; 0000 016B {
; 0000 016C     unsigned char data[4];
; 0000 016D     unsigned char   i;
; 0000 016E     data[0] = data_1;
;	IC_CS -> Y+10
;	addr -> Y+9
;	num_data -> Y+8
;	data_1 -> Y+7
;	data_2 -> Y+6
;	data_3 -> Y+5
;	data -> Y+1
;	i -> R17
; 0000 016F     data[1] = data_2;
; 0000 0170     data[2] = data_3;
; 0000 0171 
; 0000 0172     switch (IC_CS)
; 0000 0173     {
; 0000 0174         case 1:
; 0000 0175         {
; 0000 0176             PHASE_1_ON;
; 0000 0177             PHASE_2_OFF;
; 0000 0178             PHASE_3_OFF;
; 0000 0179             break;
; 0000 017A         }
; 0000 017B         case 2:
; 0000 017C         {
; 0000 017D             PHASE_1_OFF;
; 0000 017E             PHASE_2_ON;
; 0000 017F             PHASE_3_OFF;
; 0000 0180             break;
; 0000 0181         }
; 0000 0182         case 3:
; 0000 0183         {
; 0000 0184             PHASE_1_OFF;
; 0000 0185             PHASE_2_OFF;
; 0000 0186             PHASE_3_ON;
; 0000 0187             break;
; 0000 0188         }
; 0000 0189     }
; 0000 018A     //addr |= 0x80;
; 0000 018B     SPI_7753_SEND(addr);
; 0000 018C     delay_us(20);
; 0000 018D     for(i=0;i<num_data;i++)    SPI_7753_SEND(data[i]);
; 0000 018E PORTC.4 = 0;
; 0000 018F     PHASE_2_OFF;
; 0000 0190     PHASE_3_OFF;
; 0000 0191 }
;unsigned long int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
; 0000 0193 {
_ADE7753_READ:
; .FSTART _ADE7753_READ
; 0000 0194     unsigned char   i;
; 0000 0195     unsigned char   data[4];
; 0000 0196     unsigned long int res;
; 0000 0197     for(i=0;i<4;i++)    data[i] = 0;
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
_0x9B:
	CPI  R17,4
	BRSH _0x9C
	RCALL SUBOPT_0xB
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x9B
_0x9C:
; 0000 0198 switch (IC_CS)
	LDD  R30,Y+11
	RCALL SUBOPT_0x8
; 0000 0199     {
; 0000 019A         case 1:
	BRNE _0xA0
; 0000 019B         {
; 0000 019C             PHASE_1_ON;
	SBI  0x15,4
; 0000 019D             PHASE_2_OFF;
	CBI  0x15,5
; 0000 019E             PHASE_3_OFF;
	CBI  0x15,3
; 0000 019F             break;
	RJMP _0x9F
; 0000 01A0         }
; 0000 01A1         case 2:
_0xA0:
	RCALL SUBOPT_0x9
	BRNE _0xA7
; 0000 01A2         {
; 0000 01A3             PHASE_1_OFF;
	CBI  0x15,4
; 0000 01A4             PHASE_2_ON;
	SBI  0x15,5
; 0000 01A5             PHASE_3_OFF;
	CBI  0x15,3
; 0000 01A6             break;
	RJMP _0x9F
; 0000 01A7         }
; 0000 01A8         case 3:
_0xA7:
	RCALL SUBOPT_0xA
	BRNE _0x9F
; 0000 01A9         {
; 0000 01AA             PHASE_1_OFF;
	CBI  0x15,4
; 0000 01AB             PHASE_2_OFF;
	CBI  0x15,5
; 0000 01AC             PHASE_3_ON;
	SBI  0x15,3
; 0000 01AD             break;
; 0000 01AE         }
; 0000 01AF     }
_0x9F:
; 0000 01B0     addr &= 0x3F;
	LDD  R30,Y+10
	ANDI R30,LOW(0x3F)
	STD  Y+10,R30
; 0000 01B1     SPI_7753_SEND(addr);
	LDD  R26,Y+10
	RCALL _SPI_7753_SEND
; 0000 01B2     for(i=0;i<num_data;i++) data[i] = SPI_7753_RECEIVE();
	LDI  R17,LOW(0)
_0xB6:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0xB7
	RCALL SUBOPT_0xB
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _SPI_7753_RECEIVE
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0xB6
_0xB7:
; 0000 01B3 PORTC.4 = 0;
	CBI  0x15,4
; 0000 01B4     PHASE_2_OFF;
	CBI  0x15,5
; 0000 01B5     PHASE_3_OFF;
	CBI  0x15,3
; 0000 01B6     res = 0;
	LDI  R30,LOW(0)
	__CLRD1S 1
; 0000 01B7     for(i=0;i<num_data;i++)
	LDI  R17,LOW(0)
_0xBF:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0xC0
; 0000 01B8     {
; 0000 01B9         res <<= 8;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(8)
	RCALL __LSLD12
	RCALL SUBOPT_0xD
; 0000 01BA         res += data[i];
	RCALL SUBOPT_0xB
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	RCALL SUBOPT_0xC
	RCALL __CWD1
	RCALL __ADDD12
	RCALL SUBOPT_0xD
; 0000 01BB     }
	SUBI R17,-1
	RJMP _0xBF
_0xC0:
; 0000 01BC     return (res);
	__GETD1S 1
	LDD  R17,Y+0
	ADIW R28,12
	RET
; 0000 01BD }
; .FEND
;
;void    ADE7753_INIT(void)
; 0000 01C0 {
; 0000 01C1     ADE7753_WRITE(1,MODE,0x00,0x00,0x00);
; 0000 01C2     ADE7753_WRITE(1,SAGLVL,0X2a,0X00,0X00);
; 0000 01C3     ADE7753_WRITE(1,SAGCYC,0X04,0X00,0X00);
; 0000 01C4 }
;
;void main(void)
; 0000 01C7 {
_main:
; .FSTART _main
; 0000 01C8 // Declare your local variables here
; 0000 01C9 // Input/Output Ports initialization
; 0000 01CA // Port B initialization
; 0000 01CB // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=Out Bit0=In
; 0000 01CC DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(58)
	OUT  0x17,R30
; 0000 01CD // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=0 Bit0=T
; 0000 01CE PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01CF 
; 0000 01D0 // Port C initialization
; 0000 01D1 // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 01D2 DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(60)
	OUT  0x14,R30
; 0000 01D3 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01D4 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01D5 
; 0000 01D6 // Port D initialization
; 0000 01D7 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 01D8 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(18)
	OUT  0x11,R30
; 0000 01D9 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01DA PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01DB 
; 0000 01DC // Timer/Counter 0 initialization
; 0000 01DD // Clock source: System Clock
; 0000 01DE // Clock value: Timer 0 Stopped
; 0000 01DF TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 01E0 TCNT0=0x94;
	LDI  R30,LOW(148)
	OUT  0x32,R30
; 0000 01E1 
; 0000 01E2 // Timer/Counter 1 initialization
; 0000 01E3 // Clock source: System Clock
; 0000 01E4 // Clock value: 11059.200 kHz
; 0000 01E5 // Mode: Normal top=0xFFFF
; 0000 01E6 // OC1A output: Disconnected
; 0000 01E7 // OC1B output: Disconnected
; 0000 01E8 // Noise Canceler: Off
; 0000 01E9 // Input Capture on Falling Edge
; 0000 01EA // Timer Period: 2 ms
; 0000 01EB // Timer1 Overflow Interrupt: On
; 0000 01EC // Input Capture Interrupt: Off
; 0000 01ED // Compare A Match Interrupt: Off
; 0000 01EE // Compare B Match Interrupt: Off
; 0000 01EF TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 01F0 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 01F1 TCNT1H=0xA9;
	LDI  R30,LOW(169)
	OUT  0x2D,R30
; 0000 01F2 TCNT1L=0x9A;
	LDI  R30,LOW(154)
	OUT  0x2C,R30
; 0000 01F3 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 01F4 ICR1L=0x00;
	OUT  0x26,R30
; 0000 01F5 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01F6 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01F7 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01F8 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01F9 
; 0000 01FA // Timer/Counter 2 initialization
; 0000 01FB // Clock source: System Clock
; 0000 01FC // Clock value: Timer2 Stopped
; 0000 01FD // Mode: Normal top=0xFF
; 0000 01FE // OC2 output: Disconnected
; 0000 01FF ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0200 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0201 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0202 OCR2=0x00;
	OUT  0x23,R30
; 0000 0203 
; 0000 0204 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0205 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0206 
; 0000 0207 // External Interrupt(s) initialization
; 0000 0208 // INT0: Off
; 0000 0209 // INT1: Off
; 0000 020A MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 020B 
; 0000 020C // USART initialization
; 0000 020D // USART disabled
; 0000 020E UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 020F 
; 0000 0210 // Analog Comparator initialization
; 0000 0211 // Analog Comparator: Off
; 0000 0212 // The Analog Comparator's positive input is
; 0000 0213 // connected to the AIN0 pin
; 0000 0214 // The Analog Comparator's negative input is
; 0000 0215 // connected to the AIN1 pin
; 0000 0216 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0217 
; 0000 0218 // ADC initialization
; 0000 0219 // ADC Clock frequency: 345.600 kHz
; 0000 021A // ADC Voltage Reference: AREF pin
; 0000 021B ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 021C ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(133)
	OUT  0x6,R30
; 0000 021D SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 021E 
; 0000 021F // SPI initialization
; 0000 0220 // SPI disabled
; 0000 0221 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0222 
; 0000 0223 // TWI initialization
; 0000 0224 // TWI disabled
; 0000 0225 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0226 
; 0000 0227 // Global enable interrupts
; 0000 0228 #asm("sei")
	sei
; 0000 0229 //ADE7753_INIT();
; 0000 022A //PHASE_1_ON;
; 0000 022B while (1)
_0xC1:
; 0000 022C       {
; 0000 022D           CURRENT = ADE7753_READ(1,IRMS);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	STS  _CURRENT,R30
	STS  _CURRENT+1,R31
	STS  _CURRENT+2,R22
	STS  _CURRENT+3,R23
; 0000 022E           data1 = (unsigned int) (((unsigned long)read_adc(0)*500)/1023);
	LDI  R26,LOW(0)
	RCALL _read_adc
	CLR  R22
	CLR  R23
	__GETD2N 0x1F4
	RCALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3FF
	RCALL __DIVD21U
	__PUTW1R 7,8
; 0000 022F           data2 = (unsigned int)CURRENT*100;
	LDS  R26,_CURRENT
	LDS  R27,_CURRENT+1
	LDI  R30,LOW(100)
	RCALL __MULB1W2U
	__PUTW1R 9,10
; 0000 0230           //data3++;
; 0000 0231       }
	RJMP _0xC1
; 0000 0232 }
_0xC4:
	RJMP _0xC4
; .FEND

	.DSEG
_CURRENT:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	__GETW2R 7,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__GETW2R 9,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	__GETW2R 11,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	MOV  R30,R16
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LSL  R16
	CBI  0x18,5
	SBI  0x18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__PUTD1S 1
	RET


	.CSEG
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

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
