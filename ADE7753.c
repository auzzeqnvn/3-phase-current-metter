#include "ADE7753.h"
#include "delay.h"


void    Send_cmd_ADE7753(unsigned char data)
{
    unsigned char cnt;
    unsigned char   tmp = data;
    for(cnt = 0;cnt < 8; cnt++)
    {
        if((tmp & 0x80) == 0x80)   DOUT_MOSI_SPI_7753_MCU = 1;
        else DOUT_MOSI_SPI_7753_MCU = 0;

        tmp <<= 1;
        DOUT_CLK_SPI_7753_MCU = 1;
        delay_us(40);
        DOUT_CLK_SPI_7753_MCU = 0;
        delay_us(40);
    }
}

unsigned char    Read_data_ADE7753(void)
{
    unsigned char cnt;
    unsigned char data;
    data = 0;
    for(cnt = 0;cnt < 8; cnt++)
    {
        data <<= 1;
        DOUT_CLK_SPI_7753_MCU = 1;
        delay_us(40);
        if(DIN_MISO_SPI_7753_MCU == 1)   data += 1;
        DOUT_CLK_SPI_7753_MCU = 0;
        delay_us(40);
        
    }
    return data;
}

void    Write_ADE7753(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char data_2,unsigned char data_3)
{
    unsigned char data[4];
    unsigned char   i;
    data[0] = data_1;
    data[1] = data_2;
    data[2] = data_3;

    switch (IC_CS)
    {
        case 1:
        {
            PHASE_1_ON;
            PHASE_2_OFF;
            PHASE_3_OFF;
            break;
        }
        case 2:
        {
            PHASE_1_OFF;
            PHASE_2_ON;
            PHASE_3_OFF;
            break;
        }
        case 3:
        {
            PHASE_1_OFF;
            PHASE_2_OFF;
            PHASE_3_ON;
            break;
        }
    }
    addr |= 0x80;
    Send_cmd_ADE7753(addr);
    delay_us(20);
    for(i=0;i<num_data;i++)    Send_cmd_ADE7753(data[i]);
    PHASE_1_OFF;
    PHASE_2_OFF;
    PHASE_3_OFF;
}
unsigned long    Read_ADE7753(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
{
    unsigned char   i;
    unsigned char   data[4];
    unsigned long int res;
    for(i=0;i<4;i++)    data[i] = 0;
    switch (IC_CS)
    {
        case 1:
        {
            PHASE_1_ON;
            PHASE_2_OFF;
            PHASE_3_OFF;
            break;
        }
        case 2:
        {
            PHASE_1_OFF;
            PHASE_2_ON;
            PHASE_3_OFF;
            break;
        }
        case 3:
        {
            PHASE_1_OFF;
            PHASE_2_OFF;
            PHASE_3_ON;
            break;
        }
    }
    delay_ms(10);
    addr &= 0x3F;
    Send_cmd_ADE7753(addr);
    for(i=0;i<num_data;i++) data[i] = Read_data_ADE7753();
    PHASE_1_OFF;
    PHASE_2_OFF;
    PHASE_3_OFF;
    res = 0;
    for(i=0;i<num_data;i++)
    {
        res <<= 8;
        res += data[i];
    }
    return (res);
}


void    ADE_7753_init(void)
{
    unsigned int   reg = 0;
    Write_ADE7753(1,MODE,0x00,0x00,0x00);
    delay_ms(500);
    reg = 0; 
    reg |= (1<<SWRST);
    Write_ADE7753(1,MODE,(reg>>8)&0xFF,reg & 0xff,0x00);
    delay_ms(500);
    reg = Read_ADE7753(1,MODE);
    delay_ms(500);
    reg = Read_ADE7753(1,MODE);
    reg |= (1<<DISHPF) | (1<<WAVSEL0) | (1<<WAVSEL1);
    // Write_ADE7753(1,MODE,(reg>>8)&0xFF,reg & 0xff,0x00);
    delay_ms(500);
    Write_ADE7753(1,SAGLVL,0X2a,0X00,0X00);
    Write_ADE7753(1,SAGCYC,0XFF,0X00,0X00);
}