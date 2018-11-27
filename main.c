/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 3 Phase current metter
Version : 1.0
Date    : 11/10/2018
Author  : 
Company : 
Comments: 
Do va hien thi cuong do dong dien
Su dung IC ADE7753


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include <delay.h>
#include <ADE7753.h>

// Declare your global variables here
#define DO_595_LATCH  PORTB.1
#define DO_595_MOSI    PORTB.3
#define DO_595_SCK    PORTB.5

#define CTRL_595_ON     DO_595_LATCH = 1
#define CTRL_595_OFF    DO_595_LATCH = 0

#define BUZZER  PORTC.2

#define BUZZER_ON   BUZZER = 1
#define BUZZER_OFF  BUZZER = 0

#define CURRENT_MAX_SET 15
#define CURRENT_MIN_SET 8

/* He so dieu chinh dien ap doc duoc cua tung pha */
#define PHASE_1_SCALE   100
#define PHASE_2_SCALE   124
#define PHASE_3_SCALE   116

/* So luong mau lay de tinh toan */
#define NUM_SAMPLE  5
/* So luong noise loai bo */
#define NUM_FILTER  1

bit Bit_Warning_1 = 0;
bit Bit_Warning_2 = 0;
bit Bit_Warning_3 = 0;


void    SEND_DATA_LED(unsigned char  data_first,unsigned char  data_second,unsigned char  data_third);
void    SCAN_LED(unsigned char num_led,unsigned char    data);

unsigned char   Uc_Select_led=1;

/* Cac gia tri hien thi tren cac led */
unsigned int   Uint_dataLed1 = 0;
unsigned int   Uint_dataLed2 = 0;
unsigned int   Uint_dataLed3 = 0;

/* Co bao da lay du luong mau de tinh toan */
bit Bit_sample_full =0;

/* mang luu gia tri dong dien */
unsigned int AI10__Current_L1[NUM_SAMPLE];
unsigned int AI10__Current_L2[NUM_SAMPLE];
unsigned int AI10__Current_L3[NUM_SAMPLE];
unsigned char   Uc_Current_Array_Cnt = 0;

unsigned int    AI10_Current_Set;

unsigned char   Uc_Buzzer_cnt = 0;

unsigned char   Uc_Timer_cnt = 0;

unsigned char   BCDLED[11]={0xF9,0x81,0xBA,0xAB,0xC3,0x6B,0x7B,0xA1,0xFB,0xEB,0};
unsigned int    LED[12] = {0x0001,0x0002,0x0004,0x0008,0x0040,0x0020,0x0010,0x0080,0x4000,0x2000,0x1000,0x8000};



// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    unsigned char   data = 0;
// Reinitialize Timer1 value
    TCNT1H=0xAA00 >> 8;
    TCNT1L=0xAA00 & 0xff;
// Place your code here
    Uc_Timer_cnt++;
    if(Uc_Timer_cnt > 200)  Uc_Timer_cnt = 0;

    if(Uc_Select_led > 12) Uc_Select_led=1;
    if(Uc_Select_led == 1)    data = Uint_dataLed1/1000;
    else if(Uc_Select_led == 2)    data = Uint_dataLed1/100%10;
    else if(Uc_Select_led == 3)    data = Uint_dataLed1/10%10;
    else if(Uc_Select_led == 4)    data = Uint_dataLed1%10;
    else if(Uc_Select_led == 5)    data = Uint_dataLed2/1000;
    else if(Uc_Select_led == 6)    data = Uint_dataLed2/100%10;
    else if(Uc_Select_led == 7)    data = Uint_dataLed2/10%10;
    else if(Uc_Select_led == 8)    data = Uint_dataLed2%10;
    else if(Uc_Select_led == 9)    data = Uint_dataLed3/1000;
    else if(Uc_Select_led == 10)    data = Uint_dataLed3/100%10;
    else if(Uc_Select_led == 11)    data = Uint_dataLed3/10%10;
    else if(Uc_Select_led == 12)    data = Uint_dataLed3%10;

    // if(Bit_Warning_1 || Bit_Warning_2 || Bit_Warning_3)
    // {
    //     if(Bit_Warning_1)
    //     {
    //         if((Uc_Select_led == 1 || Uc_Select_led == 2 || Uc_Select_led == 3 || Uc_Select_led == 4) && Uc_Timer_cnt < 100) SCAN_LED(Uc_Select_led,10);
    //         else SCAN_LED(Uc_Select_led,data);
    //     }

    //     if(Bit_Warning_2)
    //     {
    //         if((Uc_Select_led == 5 || Uc_Select_led == 6 || Uc_Select_led == 7 || Uc_Select_led == 8) && Uc_Timer_cnt < 100) SCAN_LED(Uc_Select_led,10);
    //         else SCAN_LED(Uc_Select_led,data);
    //     }

    //     if(Bit_Warning_3)
    //     {
    //         if((Uc_Select_led == 9 || Uc_Select_led == 10 || Uc_Select_led == 11 || Uc_Select_led == 12) && Uc_Timer_cnt < 100)  SCAN_LED(Uc_Select_led,10);
    //         else SCAN_LED(Uc_Select_led,data);
    //     }   
    // }
    // else    
    SCAN_LED(Uc_Select_led,data);
    Uc_Select_led++;

    if(Bit_Warning_1 || Bit_Warning_2 || Bit_Warning_3) 
    {
        Uc_Buzzer_cnt++;
        if(Uc_Buzzer_cnt < 100) BUZZER_ON;
        else    if(Uc_Buzzer_cnt < 200) BUZZER_OFF;
        else Uc_Buzzer_cnt = 0;
    }
    else    BUZZER_OFF;
}

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | ADC_VREF_TYPE;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
    // Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    return ADCW;
}

/* 
Gui data ra led 
Gui lan luot data_first, data_second, data_third
Khi gui het du lieu se tien hanh xuat du lieu
*/
void    SEND_DATA_LED(unsigned char  data_first,unsigned char  data_second,unsigned char  data_third)
{
    unsigned char   i;
    unsigned char   data;
    data = data_first;
    for(i=0;i<8;i++)
    {
        if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        delay_us(3);
        DO_595_SCK = 0;
        delay_us(1);
    }
     DO_595_MOSI = 1;
    data = data_second;
    for(i=0;i<8;i++)
    {
        if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        delay_us(3);
        DO_595_SCK = 0;
        delay_us(1);
    }
     DO_595_MOSI = 1;
    data = data_third;
    for(i=0;i<8;i++)
    {
        if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        delay_us(3);
        DO_595_SCK = 0;
        delay_us(1);
    }
     DO_595_MOSI = 1;
    CTRL_595_ON;
    delay_us(15);
    CTRL_595_OFF;
}

/* 
Ham quet led
num_led: Thu tu led
data: Du lieu hien thi tren led.
*/
void    SCAN_LED(unsigned char num_led,unsigned char    data)
{
    unsigned char   byte1,byte2,byte3;
    byte1 = 0;
    byte2 = 0;
    byte3 = 0;
   
    byte2 = (LED[num_led-1] >> 8) & 0xff;
    byte3 = LED[num_led-1] & 0xff;
    if(num_led == 2 || num_led == 6 || num_led == 10)   byte1 = 0x04;
    byte1 |= BCDLED[data];
    if(data == 10)  
    {
        byte3 = 0;
        byte2 = 0;
        byte1 = 0;
    }
    SEND_DATA_LED(byte1,byte2,byte3);
}



/* 
Doc gia tri dong dien L1, L2 ,L3
Loai bo cac nhieu co bien do lon.
Lay trung binh cac gia tri con lai.
Cap nhat gia tri dong dien.
*/
void    Read_Current(void)
{
    unsigned int Uint_Tmp;
    unsigned int Uint_CurrentTmp_Array[NUM_SAMPLE];
    unsigned char   Uc_loop1_cnt,Uc_loop2_cnt;
    unsigned int   Ul_Sum;
    unsigned long Ul_tmp;

    // Ul_tmp = ((unsigned long) Read_ADE7753(1,IRMS) * PHASE_1_SCALE)/100/IRMS_scale;
    Ul_tmp = ((unsigned long) Read_ADE7753(1,IRMS)/800);
    // if(Ul_tmp < 450 && Ul_tmp > 100)    Ul_tmp = Ul_tmp*1.1814146648 + Ul_tmp*Ul_tmp*0.0000095023 - Ul_tmp*Ul_tmp*Ul_tmp*0.0000000917;
    // else if(Ul_tmp >500 && Ul_tmp < 550)    Ul_tmp = Ul_tmp -(Ul_tmp-500)*15/50;
    // else if(Ul_tmp > 750)    Ul_tmp = Ul_tmp* 0.9553164373 - Ul_tmp*Ul_tmp*0.0000099864 + Ul_tmp*Ul_tmp*Ul_tmp*0.0000000213;
    //Ul_tmp = Ul_tmp + Ul_tmp*0.08;
    AI10__Current_L1[Uc_Current_Array_Cnt] = (unsigned int) (Ul_tmp);
    // Ul_tmp = ((unsigned long) Read_ADE7753(2,IRMS) * PHASE_2_SCALE)/100/IRMS_scale;
    Ul_tmp = ((unsigned long) Read_ADE7753(2,IRMS)/1105);
    AI10__Current_L2[Uc_Current_Array_Cnt] = (unsigned int) (Ul_tmp);
    //Ul_tmp = ((unsigned long) Read_ADE7753(3,IRMS) * PHASE_3_SCALE)/100/IRMS_scale;
    Ul_tmp = ((unsigned long) Read_ADE7753(3,IRMS)/577);
    AI10__Current_L3[Uc_Current_Array_Cnt] = (unsigned int) (Ul_tmp);

    AI10_Current_Set = read_adc(0);
    AI10_Current_Set = AI10_Current_Set*(CURRENT_MAX_SET-CURRENT_MIN_SET)*100/1024 + CURRENT_MIN_SET*100; 

    Uc_Current_Array_Cnt++;
    if(Uc_Current_Array_Cnt >= NUM_SAMPLE)
    {
        Bit_sample_full = 1;
        Uc_Current_Array_Cnt = 0;
    }

    if(Bit_sample_full == 0)
    {
        Uint_dataLed1 = 0;
        Uint_dataLed2 = 0;
        Uint_dataLed3 = 0;
    }
    else
    {
        /* Xu ly du lieu L1 */
        /* Chuyen sang bo nho dem*/
        for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
        {
            Uint_CurrentTmp_Array[Uc_loop1_cnt] = AI10__Current_L1[Uc_loop1_cnt];
        }
        /* Sắp xếp tu min-> max*/
        for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
        {
            for(Uc_loop2_cnt = Uc_loop1_cnt; Uc_loop2_cnt<NUM_SAMPLE; Uc_loop2_cnt++)
            {
                if(Uint_CurrentTmp_Array[Uc_loop1_cnt] > Uint_CurrentTmp_Array[Uc_loop2_cnt])
                {
                    Uint_Tmp = Uint_CurrentTmp_Array[Uc_loop1_cnt];
                    Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_CurrentTmp_Array[Uc_loop2_cnt];
                    Uint_CurrentTmp_Array[Uc_loop2_cnt] = Uint_Tmp;
                }
            }
        }
        /* Loc phan du lieu nhieu thap va cao */
        Ul_Sum = 0;
        for(Uc_loop1_cnt = NUM_FILTER;Uc_loop1_cnt<(NUM_SAMPLE - NUM_FILTER); Uc_loop1_cnt++)
        {
            Ul_Sum += Uint_CurrentTmp_Array[Uc_loop1_cnt];
        }
        Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
        //if(Ul_Sum > 500)    Ul_Sum = Ul_Sum*1.263550988 + Ul_Sum*Ul_Sum*0.0000695432 - Ul_Sum*Ul_Sum*Ul_Sum*0.000000193;
        /* Xuat du lieu len led */
        Uint_dataLed1 = Ul_Sum;
        if(AI10_Current_Set < Uint_dataLed1)    Bit_Warning_1 =1;
        else Bit_Warning_1 = 0;

        /* Xu ly du lieu L2 */
        /* Chuyen sang bo nho dem*/
        for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
        {
            Uint_CurrentTmp_Array[Uc_loop1_cnt] = AI10__Current_L2[Uc_loop1_cnt];
        }
        /* Sắp xếp tu min-> max*/
        for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
        {
            for(Uc_loop2_cnt = Uc_loop1_cnt; Uc_loop2_cnt<NUM_SAMPLE; Uc_loop2_cnt++)
            {
                if(Uint_CurrentTmp_Array[Uc_loop1_cnt] > Uint_CurrentTmp_Array[Uc_loop2_cnt])
                {
                    Uint_Tmp = Uint_CurrentTmp_Array[Uc_loop1_cnt];
                    Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_CurrentTmp_Array[Uc_loop2_cnt];
                    Uint_CurrentTmp_Array[Uc_loop2_cnt] = Uint_Tmp;
                }
            }
        }

        /* Loc phan du lieu nhieu thap va cao */
        Ul_Sum = 0;
        for(Uc_loop1_cnt = NUM_FILTER;Uc_loop1_cnt<(NUM_SAMPLE - NUM_FILTER); Uc_loop1_cnt++)
        {
            Ul_Sum += Uint_CurrentTmp_Array[Uc_loop1_cnt];
        }
        Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
        /* Xuat du lieu len led */
        Uint_dataLed2 = Ul_Sum;
        if(AI10_Current_Set < Uint_dataLed2)    Bit_Warning_2 =1;
        else Bit_Warning_2 = 0;

        /* Xu ly du lieu L3 */
        /* Chuyen sang bo nho dem*/
        for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
        {
            Uint_CurrentTmp_Array[Uc_loop1_cnt] = AI10__Current_L3[Uc_loop1_cnt];
        }
        /* Sắp xếp tu min-> max*/
        for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
        {
            for(Uc_loop2_cnt = Uc_loop1_cnt; Uc_loop2_cnt<NUM_SAMPLE; Uc_loop2_cnt++)
            {
                if(Uint_CurrentTmp_Array[Uc_loop1_cnt] > Uint_CurrentTmp_Array[Uc_loop2_cnt])
                {
                    Uint_Tmp = Uint_CurrentTmp_Array[Uc_loop1_cnt];
                    Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_CurrentTmp_Array[Uc_loop2_cnt];
                    Uint_CurrentTmp_Array[Uc_loop2_cnt] = Uint_Tmp;
                }
            }
        }
        /* Loc phan du lieu nhieu thap va cao */
        Ul_Sum = 0;
        for(Uc_loop1_cnt = NUM_FILTER;Uc_loop1_cnt<(NUM_SAMPLE - NUM_FILTER); Uc_loop1_cnt++)
        {
            Ul_Sum += Uint_CurrentTmp_Array[Uc_loop1_cnt];
        }
        Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
        /* Xuat du lieu len led */
        Uint_dataLed3 = Ul_Sum;
        if(AI10_Current_Set < Uint_dataLed3)    Bit_Warning_3 =1;
        else Bit_Warning_3 = 0;
    }
}

void main(void)
{
// Declare your local variables here
// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=Out Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=0 Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (1<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=Out 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x94;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 11059.200 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 2 ms
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0xA9;
TCNT1L=0x9A;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 345.600 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")
Uint_dataLed1 = 1234;
Uint_dataLed2 = 2345;
Uint_dataLed3 = 8818;
ADE_7753_init();
Bit_Warning_1 =1;
delay_ms(100);
Bit_Warning_1 = 0;
while (1)
    {
        Read_Current();       
        delay_ms(500); 
    }
}
