// Declare your global variables here
#define DO_595_LATCH  PORTB.1
#define DO_595_MOSI    PORTB.3
#define DO_595_SCK    PORTB.5

#define CTRL_595_ON     DO_595_LATCH = 1
#define CTRL_595_OFF    DO_595_LATCH = 0

#define NUM_7SEG    12

extern unsigned int   Uint_dataLed1;
extern unsigned int   Uint_dataLed2;
extern unsigned int   Uint_dataLed3;

void    SEND_DATA_LED(unsigned char  data_first,unsigned char  data_second,unsigned char  data_third);
void    SCAN_LED(void);