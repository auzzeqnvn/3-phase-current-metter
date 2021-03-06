#include "led.h"
#include "mega8.h"
#include "delay.h"

unsigned char   BCDLED[11]={0xF9,0x81,0xBA,0xAB,0xC3,0x6B,0x7B,0xA1,0xFB,0xEB,0};

unsigned char   Uc_Select_led=1;

/* 
Cac gia tri hien thi tren cac led
Cap nhat gia tri vao cac bien nay de hien thi len led
*/
unsigned int   Uint_dataLed1 = 0;
unsigned int   Uint_dataLed2 = 0;
unsigned int   Uint_dataLed3 = 0;

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
        DO_595_SCK = 0;
    }
    data = data_second;
    for(i=0;i<8;i++)
    {
        if((data & 0x80))    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        DO_595_SCK = 0;
    }
    data = data_third;
    for(i=0;i<8;i++)
    {
        if((data & 0x80))    DO_595_MOSI = 1;
        else    DO_595_MOSI = 0;
        data <<= 1;
        DO_595_SCK = 1;
        DO_595_SCK = 0;
    }
    CTRL_595_ON;
    CTRL_595_OFF;
}

/* 
Ham quet led
num_led: Thu tu led
data: Du lieu hien thi tren led.
*/
void    SCAN_LED(void)
{
    unsigned char   byte1,byte2,byte3;
    unsigned char    data;
    unsigned char   bit_left;
    bit_left = 0x01;
    byte1 = 0;
    byte2 = 0;
    byte3 = 0;

    Uc_Select_led++;
    bit_left <<= (Uc_Select_led-1);
    if(Uc_Select_led > 8)   
    {
        Uc_Select_led = 1;
        bit_left = 0x01;
    }
    /* 7-seg 1*/
    data = Uint_dataLed1/1000;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x01;
    data = Uint_dataLed1/100%10;
    byte1 = BCDLED[data];
    byte1 |= 0x04;
    if(byte1 & bit_left) byte3 |= 0x02;
    data = Uint_dataLed1/10%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x04;
    data = Uint_dataLed1%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x08;
    /* 7-seg 2 */
    data = Uint_dataLed2/1000;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x40;
    data = Uint_dataLed2/100%10;
    byte1 = BCDLED[data];
    byte1 |= 0x04;
    if(byte1 & bit_left) byte3 |= 0x20;
    data = Uint_dataLed2/10%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x10;
    data = Uint_dataLed2%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x80;
    /* 7-seg 3 */
    data = Uint_dataLed3/1000;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte2 |= 0x40;
    data = Uint_dataLed3/100%10;
    byte1 = BCDLED[data];
    byte1 |= 0x04;
    if(byte1 & bit_left) byte2 |= 0x20;
    data = Uint_dataLed3/10%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte2 |= 0x10;
    data = Uint_dataLed3%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte2 |= 0x80;

    SEND_DATA_LED(bit_left,byte2,byte3);
}