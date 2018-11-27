#include "led.h"
#include "mega8.h"
#include "delay.h"

unsigned char   BCDLED[11]={0xF9,0x81,0xBA,0xAB,0xC3,0x6B,0x7B,0xA1,0xFB,0xEB,0};
unsigned int    LED_SELECT[12] = {0x0001,0x0002,0x0004,0x0008,0x0040,0x0020,0x0010,0x0080,0x4000,0x2000,0x1000,0x8000};


unsigned char   Uc_Select_led=1;

/* Cac gia tri hien thi tren cac led */
unsigned int   Uint_dataLed1 = 0;
unsigned int   Uint_dataLed2 = 0;
unsigned int   Uint_dataLed3 = 0;


void    LED(void)
{
    unsigned char data;
    if(Uc_Select_led > NUM_7SEG) Uc_Select_led=1;

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

    SCAN_LED(Uc_Select_led,data);
    Uc_Select_led++;
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
        if((data & 0x80))    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        //delay_us(3);
        DO_595_SCK = 0;
        //delay_us(1);
    }
    data = data_second;
    for(i=0;i<8;i++)
    {
        if((data & 0x80))    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        //delay_us(3);
        DO_595_SCK = 0;
        //delay_us(1);
    }
    data = data_third;
    for(i=0;i<8;i++)
    {
        if((data & 0x80))    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        //delay_us(3);
        DO_595_SCK = 0;
        //delay_us(1);
    }
    CTRL_595_ON;
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
   
    byte2 = (LED_SELECT[num_led-1] >> 8) & 0xff;
    byte3 = LED_SELECT[num_led-1] & 0xff;
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