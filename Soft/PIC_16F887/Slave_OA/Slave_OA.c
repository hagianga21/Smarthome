/**************************************
 * DEFINE REGISTERS
 **************************************/
#define WAVEFORM 0x01
#define AENERGY 0x02
#define RAENERGY 0x03
#define LAENERGY 0x04
#define VAENERGY 0x05
#define LVAENERGY 0x06
#define LVARENERGY 0x07
#define MODE 0x09
#define IRQEN 0x0A
#define STATUS 0x0B
#define RSTSTATUS 0x0C
#define CH1OS 0x0D
#define CH2OS 0x0E
#define GAIN 0x0F
#define PHCAL 0x10
#define APOS 0x11
#define WGAIN 0x12
#define WDIV 0x12
#define CFNUM 0x14
#define CFDEN 0x15
#define IRMS 0x16
#define VRMS 0x17
#define IRMSOS 0x18
#define VRMSOS 0x19
#define VAGAIN 0x1A
#define VADIV 0x1B
#define LINECYC 0x1C
#define ZXTOUT 0x1D
#define SAGCYC 0x1E
#define SAGLVL 0x1F
#define IPKLVL 0x20
#define VPKLVL 0x21
#define IPEAK 0x22
#define RSTIPEAK 0x23
#define VPEAK 0x24
#define RSTVPEAK 0x25
#define TEMP 0x26
#define PERIOD 0x27
#define TMODE 0x3D
#define CHKSUM 0x3E
#define DIEREV 0x3F
#define ZX 0x0010
#define CYCEND 0x0004

#define CS PORTC.B0
/**************************************
 * DEFINE VARIABLES
 **************************************/
long outputADE;
float voltage, ampe, activepower;
/**************************************
 * DEFINE SUBROUTINES
 **************************************/
void Write_ADE7753(char add, long write_buffer, int bytes_to_write);
long Read_ADE7753(char add, char bytes_to_read);
void HienthiUART (long outputADE, int bytes_to_write);
void Hienthisofloat (float so);
void Test(void);
int getresetInterruptStatus(void);
int getInterruptStatus(void);
float getVRMS(void);
float getIRMS(void);
float getAPOWER(void);
/**************************************
 * MAIN
 **************************************/
void main()
{
     voltage = 0;
     ampe = 0;
     activepower = 0;
     TRISC.B0 = 0;
     PORTC.B0 = 1;
     UART1_Init(9600);
     Delay_ms(200);
     SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_HIGH_2_LOW);
     Delay_ms(200);

     Write_ADE7753(GAIN,0x0,1);
     Write_ADE7753(MODE,0x008C,2);                      //0b0000000010001100
     //Write_ADE7753(APOS,0x998E,2);                      //0b1001100110001110
     //Write_ADE7753(VRMSOS,0xF900,2);                    //0b1111100000000000
     //Write_ADE7753(IRMSOS,0xFEBE,2);                    //0b1111111010111110

     Delay_ms(200);
     //Test();
     while(1)
     {

     UART1_Write_Text("\nDien ap: ");
     voltage = getVRMS();
     Hienthisofloat(voltage);
     Delay_ms(200);
     
     UART1_Write_Text("\nDong dien: ");
     ampe = getIRMS();
     Hienthisofloat(ampe);
     Delay_ms(500);

     UART1_Write_Text("\nCong suat: ");
     activepower = getAPOWER();
     Hienthisofloat(activepower);
     Delay_ms(500);

     }
}

/**************************************
 * WRITE ADE7753
 **************************************/
void Write_ADE7753(char add, long write_buffer, int bytes_to_write)
{
     char cmd;
     char this_write;
     int i;
     cmd  = 0x80;
     add = add|cmd;
     CS = 0;
     SPI1_Write(add);
     Delay_ms(2);

     for (i = 0; i < bytes_to_write; i++)
     {
     this_write = (char) (write_buffer>> (8*((bytes_to_write-1)-i)));
     SPI1_Write(this_write);
     Delay_ms(2);
     }
     CS=1;
}
/**************************************
 * READ ADE7753
 **************************************/
long Read_ADE7753(char add, char bytes_to_read)
{
    long result;
    int i;
    char reader_buf;
    CS = 0;
    SPI1_Write(add);
    Delay_ms(2);
    for (i = 1; i <= bytes_to_read; i++)
    {
         reader_buf =  SPI1_Read(0x00);
         Delay_ms(2);
         result = result | reader_buf;
         if(i < bytes_to_read)
         result = result << 8;
    }
    CS = 1;
    return result;
}
/**************************************
 * DISLAY TO UART
 **************************************/
void HienthiUART (long outputADE, int bytes_to_write)
{
    int i;
    char this_write;
    for (i = 0; i < bytes_to_write; i++)
     {
     this_write = (char) (outputADE>> (8*((bytes_to_write-1)-i)));
     UART1_Write(this_write);
     }
}
/**************************************
 * DISLAY FLOAT TO UART
 **************************************/
void Hienthisofloat (float so)
{
     char kq[15];
     FloatToStr(so,kq);
     UART1_Write_Text(kq);
}
/**************************************
 * RESET INTERRUPT
 **************************************/
long getresetInterruptStatus(void){
   return Read_ADE7753(RSTSTATUS,2);
}
/**************************************
 * GET INTERRUPT
 **************************************/
long getInterruptStatus(void){
   return Read_ADE7753(STATUS,2);
}
/**************************************
 * GET VRMS
 **************************************/
float getVRMS (void)
{
      int i, j;
      long totalv, vrmsraw;
      float vrmsreal;
      totalv = 0;
      j = 0;
      Write_ADE7753(IRQEN,0x0010,2);
      for(i=0;i<10;i++)
      {
          getresetInterruptStatus();
          while(! (getInterruptStatus() & ZX)){
                  j++;
                  if(j>100){
                  j=0;
                  break;
                  }
          }
          outputADE=Read_ADE7753(VRMS,3);
          Delay_ms(20);
          totalv=totalv+outputADE;
          Delay_ms(25);
     }
     getresetInterruptStatus();
     vrmsraw = totalv/10;

     vrmsraw = vrmsraw & 0xFFFFFF;
     //HienthiUART(vrmsraw,6);
     vrmsreal = (float)vrmsraw;
     vrmsreal = vrmsreal * 0.00033834;
     vrmsreal = vrmsreal- 2626.4;
     //Hienthisofloat(vrmsreal);
     if(vrmsreal > 400 || vrmsreal < 0){
         vrmsreal = 0;
     }
     return vrmsreal;
}
/**************************************
 * GET IRMS
 **************************************/
float getIRMS(void)
{
     int i, j;
     long totali, irmsraw;
     float irmsreal;
     totali = 0;
     j = 0;
     Write_ADE7753(IRQEN,0x0010,2);
     for(i=0;i<10;i++)
     {
          getresetInterruptStatus();
          while(! (getInterruptStatus() & ZX)){
                  j++;
                  if(j>100){
                  j=0;
                  break;
                  }
          }
          outputADE=Read_ADE7753(IRMS,3);
          Delay_ms(20);
          totali=totali+outputADE;
          Delay_ms(25);
     }
     getresetInterruptStatus();
     irmsraw = totali/10;
     irmsraw = irmsraw & 0xFFFFFF;
     irmsreal = (float)irmsraw;
     irmsreal = irmsreal * 0.00003714;
     irmsreal = irmsreal- 288.1919;
     //Hienthisofloat(irmsreal);
     if(irmsreal > 40 || irmsreal < 0){
        irmsreal = 0;
     }
     return irmsreal;
}

float getAPOWER(void)
{
     int i, j;
     long apraw;
     float apreal;
     apraw = 0;
     apreal =0;
     Write_ADE7753(LINECYC,100,2);
     Delay_ms(500);
     Write_ADE7753(MODE,0x0080,2);
     Delay_ms(500);
     Write_ADE7753(IRQEN,0x0004,2);
     Delay_ms(500);
     getresetInterruptStatus();
     while(! (getInterruptStatus() & CYCEND)){
          j++;
          if(j>200){
          j=0;
          break;
          }
     }
     
     getresetInterruptStatus();
     while(! (getInterruptStatus() & CYCEND)){
          j++;
          if(j>200){
          j=0;
          break;
          }
     }
     getresetInterruptStatus();
     outputADE=Read_ADE7753(LAENERGY,3);
     Delay_ms(500);
     apraw = outputADE;
     apraw = apraw & 0xFFFF;
     //HienthiUART(apraw,3);
     apreal = (float)apraw;
     apreal = apreal * 1.6425;
     apreal = apreal + 0.14;
     Write_ADE7753(LINECYC,0xFFFF,2);
     Delay_ms(500);
     if(apreal < 8 || apreal > 2000){
         apreal = 0;
     }
     return apreal;
}
/**************************************
 * TEST ADE7753
 **************************************/

void Test (void)
{
    Write_ADE7753(LINECYC,0xABEF,2);
    outputADE = Read_ADE7753(LINECYC,2);
    HienthiUART(outputADE,2);
}