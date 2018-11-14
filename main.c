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

#define NUM_SAMPLE  20
#define NUM_FILTER  5


void    SEND_DATA_LED(unsigned char  data_first,unsigned char  data_second,unsigned char  data_third);
void    SCAN_LED(unsigned char num_led,unsigned char    data);

unsigned char   Uc_Ledcnt=1;

unsigned int   Uint_dataLed1 = 0;
unsigned int   Uint_dataLed2 = 0;
unsigned int   Uint_dataLed3 = 0;

bit Bit_sample_full =0;

unsigned int Uint_Current1_Array[NUM_SAMPLE];
unsigned int Uint_Current2_Array[NUM_SAMPLE];
unsigned int Uint_Current3_Array[NUM_SAMPLE];
unsigned char   Uc_Current_Array_Cnt = 0;

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    unsigned char   data = 0;
// Reinitialize Timer1 value
    TCNT1H=0xAA00 >> 8;
    TCNT1L=0xAA00 & 0xff;
// Place your code here
    if(Uc_Ledcnt > 12) Uc_Ledcnt=1;
    if(Uc_Ledcnt == 1)    data = Uint_dataLed1/1000;
    else if(Uc_Ledcnt == 2)    data = Uint_dataLed1/100%10;
    else if(Uc_Ledcnt == 3)    data = Uint_dataLed1/10%10;
    else if(Uc_Ledcnt == 4)    data = Uint_dataLed1%10;
    else if(Uc_Ledcnt == 5)    data = Uint_dataLed2/1000;
    else if(Uc_Ledcnt == 6)    data = Uint_dataLed2/100%10;
    else if(Uc_Ledcnt == 7)    data = Uint_dataLed2/10%10;
    else if(Uc_Ledcnt == 8)    data = Uint_dataLed2%10;
    else if(Uc_Ledcnt == 9)    data = Uint_dataLed3/1000;
    else if(Uc_Ledcnt == 10)    data = Uint_dataLed3/100%10;
    else if(Uc_Ledcnt == 11)    data = Uint_dataLed3/10%10;
    else if(Uc_Ledcnt == 12)    data = Uint_dataLed3%10;
    SCAN_LED(Uc_Ledcnt++,data);
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
        DO_595_SCK = 0;
    }
    data = data_second;
    for(i=0;i<8;i++)
    {
        if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        DO_595_SCK = 0;
    }
    data = data_third;
    for(i=0;i<8;i++)
    {
        if((data & 0x80) == 0x80)    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        DO_595_SCK = 0;
    }
    CTRL_595_ON;
    CTRL_595_OFF;
}

void    SCAN_LED(unsigned char num_led,unsigned char    data)
{
    unsigned char   byte1,byte2,byte3;
    byte1 = 0;
    byte2 = 0;
    byte3 = 0;
    switch(num_led)
    {
        case    1:
        {
            byte3 = 0x01;
            byte2 = 0x00;
            break;
        }
        case    2:
        {
            byte3 = 0x02;
            byte2 = 0x00;
            byte1 = 0x04;
            break;
        }
        case    3:
        {
            byte3 = 0x04;
            byte2 = 0x00;
            break;
        }
        case    4:
        {
            byte3 = 0x08;
            byte2 = 0x00;
            break;
        }
        case    5:
        {
            byte3 = 0x40;
            byte2 = 0x00;
            break;
        }
        case    6:
        {
            byte3 = 0x20;
            byte2 = 0x00;
            byte1 = 0x04;
            break;
        }
        case    7:
        {
            byte3 = 0x10;
            byte2 = 0x00;
            break;
        }
        case    8:
        {
            byte3 = 0x80;
            byte2 = 0x00;
            break;
        }
        case    9:
        {
            byte3 = 0x00;
            byte2 = 0x40;
            break;
        }
        case    10:
        {
            byte3 = 0x00;
            byte2 = 0x20;
            byte1 = 0x04;
            break;
        }
        case    11:
        {
            byte3 = 0x00;
            byte2 = 0x10;
            break;
        }
        case    12:
        {
            byte3 = 0x00;
            byte2 = 0x80;
            break;
        }
    }
    switch(data)
    {
        case    0:
        {
            byte1 |= 0xF9;
            break;
        }
        case    1:
        {
            byte1 |= 0x81;
            break;
        }
        case    2:
        {
            byte1 |= 0xBA;
            break;
        }
        case    3:
        {
            byte1 |= 0xAB;
            break;
        }
        case    4:
        {
            byte1 |= 0xC3;
            break;
        }
        case    5:
        {
            byte1 |= 0x6B;
            break;
        }
        case    6:
        {
            byte1 |= 0x7B;
            break;
        }
        case    7:
        {
            byte1 = 0xA1;
            break;
        }
        case    8:
        {
            byte1 |= 0xFB;
            break;
        }
        case    9:
        {
            byte1 |= 0xEB;
            break;
        }    
    }
    SEND_DATA_LED(byte1,byte2,byte3);
}




void    READ_AMP(void)
{
    unsigned int Uint_Tmp;
    unsigned int Uint_CurrentTmp_Array[NUM_SAMPLE];
    unsigned char   Uc_loop1_cnt,Uc_loop2_cnt;
    unsigned int   Ul_Sum;

    Uint_Current1_Array[Uc_Current_Array_Cnt] = ADE7753_READ(1,IRMS);
    Uint_Current2_Array[Uc_Current_Array_Cnt] = ADE7753_READ(2,IRMS);
    Uint_Current3_Array[Uc_Current_Array_Cnt] = ADE7753_READ(3,IRMS);
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
            Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_Current1_Array[Uc_loop1_cnt];
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
        Uint_dataLed1 = Ul_Sum;

        /* Xu ly du lieu L2 */
        /* Chuyen sang bo nho dem*/
        for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
        {
            Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_Current2_Array[Uc_loop1_cnt];
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

        /* Xu ly du lieu L3 */
        /* Chuyen sang bo nho dem*/
        for(Uc_loop1_cnt = 0; Uc_loop1_cnt<NUM_SAMPLE; Uc_loop1_cnt++)
        {
            Uint_CurrentTmp_Array[Uc_loop1_cnt] = Uint_Current3_Array[Uc_loop1_cnt];
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
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

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
ADE7753_INIT();
delay_ms(10000);
while (1)
    {
        delay_ms(300);
        READ_AMP();
    }
}
