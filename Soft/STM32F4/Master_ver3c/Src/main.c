/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "stm32f4xx_hal.h"
#include "fatfs.h"
#include "lcd_txt.h"
#include "lcdDisplay.h"
#include <string.h>
#define DS3231_ADD 0x68

/* Private variables ---------------------------------------------------------*/
I2C_HandleTypeDef hi2c1;
DMA_HandleTypeDef hdma_i2c1_rx;

SD_HandleTypeDef hsd;

UART_HandleTypeDef huart4;
UART_HandleTypeDef huart1;
UART_HandleTypeDef huart2;
UART_HandleTypeDef huart3;

//My code-----------------------------------------------------------------------------//
uint8_t send_data =0x41, receive_data2=0;
uint8_t devicesState[16] = "0000000000000000";
//SET Time
uint8_t setHourOn[11], setMinOn[11], setHourOff[11], setMinOff[11];
//DS3231
uint8_t BCD2DEC(uint8_t data);
uint8_t DEC2BCD(uint8_t data);
uint8_t receiveDataFromDS3231[7], sendDataToDS3231[7];
uint8_t second,minute,hour,day,date,month,year;
uint8_t oldsecond,oldminute,oldhour,oldday,olddate,oldmonth,oldyear;
uint8_t receiveDataFromEEPROM[2], sendDataToEEPROM[2];
uint8_t statusSend = 1;
//UART1 System
uint8_t numberOfButton = 1, numberOfDevice = 1;
uint8_t count1 = 0, tempdataReceiveFromSystem, flagReceiveAllDataFromSystem = 0;
uint8_t dataReceiveFromSystem[11], dataSendtoSystem[11];
uint8_t countSensor = 1 ,temperature = 0, humid = 0, gasDetection = 0, humanDetection = 0, power = 0;
//UART2 Internet
uint8_t count2 = 0, flagReceiveAllDataFromInternet = 0, tempdataReceiveFromInternet;
uint8_t dataReceiveFromInternet[18], devicesStateUpdateToInternet[18] = "S0000000000000000E";
uint8_t dataFromSensorToInternet[11] = "S03C01000TE";
uint8_t dataFromPowerToInternet[11] = "S03D04000PE";
//UART3 Module sim 800A
uint8_t dataReceiveFromSim800[100], tempdataReceiveFromSim800;
uint8_t count3 = 0, flagReceiveAllDataFromSim800 = 0, flagSms = 0;
uint8_t smsDetail[100], countDetail = 0;
//LCD
float var = 0.123;
char buffer[20];
uint8_t lcd_mode = 0, old_lcd_mode = 0;
//-------------------------------------------------------------------------------------//

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_DMA_Init(void);
static void MX_USART1_UART_Init(void);
static void MX_USART2_UART_Init(void);
static void MX_USART3_UART_Init(void);
static void MX_UART4_Init(void);
static void MX_I2C1_Init(void);
static void MX_SDIO_SD_Init(void);

//My code-----------------------------------------------------------------------------//
void sendRS485toSystem(void);
void setIDforButton(void);
void setIDforDevice(void);
void writeDataToDS3132(void);
void controlDevice(void);
void updateStateToInternet(void);
void updateDevicesState(void);
void sendDataFromSensorToInternet(void);
void sendDataFromPowerToInternet(void);
void answerSystem(void);
void processDataFromInternet(void);
void checkSetTime(void);
void checkTimeToReadSensor(void);
void Initsim900A(void);
void Call(void);
void sendMessage(char *s,int length);
void deleteSMS(void);
void processDataFromSim(void);
void processDetailSms (void);
void checkLCD(void);
uint8_t convertNumToStringMSB(uint8_t number);
uint8_t convertNumToStringLSB(uint8_t number);
uint8_t convertStringToNum(uint8_t MSB, uint8_t LSB);
uint8_t convertStringToNum3(uint8_t MSB1, uint8_t MSB, uint8_t LSB);
//-------------------------------------------------------------------------------------//

int main(void)
{
  HAL_Init();
  SystemClock_Config();
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_USART1_UART_Init();
  MX_USART2_UART_Init();
  MX_USART3_UART_Init();
  MX_UART4_Init();
  MX_I2C1_Init();
  MX_SDIO_SD_Init();
  MX_FATFS_Init();

	//My code-----------------------------------------------------------------------------//
	
	HAL_UART_Receive_IT(&huart1,&receive_data2,1);
	HAL_UART_Receive_IT(&huart2,&receive_data2,1);
	HAL_UART_Receive_IT(&huart3,&receive_data2,1);
	HAL_UART_Receive_IT(&huart4,&receive_data2,1);
	
	//HAL_UART_Transmit_IT(&huart1,&send_data,1);
	//HAL_UART_Transmit_IT(&huart2,&send_data,1);
	//HAL_UART_Transmit_IT(&huart3,"AT\r\n",4);
	//HAL_UART_Transmit_IT(&huart4,&send_data,1);
	HAL_Delay(300);
	Initsim900A();
	deleteSMS();
	//Call();
	sendMessage("Giang dep trai",14);
	
	
	//Init LCD
	lcd_init();
	lcd_Intro();
	HAL_Delay(1000);
	lcd_clear();
	lcd_HomePage(day,date,month,year,hour,minute,second,temperature,power);
	HAL_Delay(500);

	//sprintf(buffer,"%0.4f",var);
	//lcd_puts(1,0,(int8_t*)buffer);

	//-------------------------------------------------------------------------------------//
  while (1)
  {
		//My code-----------------------------------------------------------------------------//
		
		HAL_I2C_Mem_Read_DMA(&hi2c1,DS3231_ADD<<1,0,I2C_MEMADD_SIZE_8BIT,receiveDataFromDS3231,7);
		checkTimeToReadSensor();
		checkSetTime();
		
		if(flagReceiveAllDataFromSystem == 1)
		{
			flagReceiveAllDataFromSystem = 0;
			HAL_Delay(200);
			answerSystem();
		}
		if(flagReceiveAllDataFromInternet == 1)
		{
			flagReceiveAllDataFromInternet = 0;
			processDataFromInternet();
		}
		if(flagReceiveAllDataFromSim800 == 1){
			processDataFromSim();
			flagReceiveAllDataFromSim800 = 0;
		}
		checkLCD();
		//-------------------------------------------------------------------------------------//
  }
}

//My code-----------------------------------------------------------------------------//
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin){
	//ENTER
	if(GPIO_Pin == GPIO_PIN_0){
		if(lcd_mode == 0){
			lcd_mode = 1;
		}
	}
	//BACK
	if(GPIO_Pin == GPIO_PIN_1){
		if(lcd_mode>0){
			lcd_mode = 0;
		}
	}
	//UP
	if(GPIO_Pin == GPIO_PIN_2){
		if(lcd_mode>0){
			lcd_mode--;
			if(lcd_mode == 0){
				lcd_mode=3;
			}
		}
	}
	//DOWN
	if(GPIO_Pin == GPIO_PIN_3){
		if(lcd_mode>0){
			lcd_mode++;
			if(lcd_mode>3){
				lcd_mode=1;
			}
		}	
	}
	//
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	if(huart->Instance==huart1.Instance){
		HAL_UART_Receive_IT(&huart1,&tempdataReceiveFromSystem,1);
		if(tempdataReceiveFromSystem == 'S'){
			count1 = 0;
			dataReceiveFromSystem[count1] = tempdataReceiveFromSystem;
			count1++;
		}
		if(tempdataReceiveFromSystem != 'S' && tempdataReceiveFromSystem != 'E'){
			dataReceiveFromSystem[count1] = tempdataReceiveFromSystem;
			count1++;
		}	
		if(tempdataReceiveFromSystem == 'E'){
			dataReceiveFromSystem[count1] = tempdataReceiveFromSystem;
			count1 = 0;
			flagReceiveAllDataFromSystem = 1;
			HAL_UART_Transmit_IT(&huart4,dataReceiveFromSystem,11);
		}
	}
	
	if(huart->Instance==huart2.Instance){
		HAL_UART_Receive_IT(&huart2,&tempdataReceiveFromInternet,1);
		if(tempdataReceiveFromInternet == 'S'){
			count2 = 0;
			dataReceiveFromInternet[count2] = tempdataReceiveFromInternet;
			count2++;
		}
		if(tempdataReceiveFromInternet != 'S' && tempdataReceiveFromInternet != 'E' && tempdataReceiveFromInternet != 0x0A && tempdataReceiveFromInternet != 0x0D){
			dataReceiveFromInternet[count2] = tempdataReceiveFromInternet;
			count2++;
		}	
		if(tempdataReceiveFromInternet == 'E'){
			dataReceiveFromInternet[count2] = tempdataReceiveFromInternet;
			count2 = 0;
			flagReceiveAllDataFromInternet = 1;
		}
	}
	if(huart->Instance==huart3.Instance){
		HAL_UART_Receive_IT(&huart3,&tempdataReceiveFromSim800,1);
		if(tempdataReceiveFromSim800 != 0x0A && tempdataReceiveFromSim800 != 0x0D){
			if(flagSms == 1 && countDetail == 2){
				smsDetail[count3] = tempdataReceiveFromSim800;
			}
			else{
				dataReceiveFromSim800[count3] = tempdataReceiveFromSim800;
			}
			count3++;
		}
		else if(tempdataReceiveFromSim800 == 0x0D){
			HAL_UART_Transmit_IT(&huart4,dataReceiveFromSim800,count3);
			flagReceiveAllDataFromSim800 = 1;
			count3 = 0;
			if(flagSms == 1){
				countDetail++;
			}
		}
		else{
			count3 = 0;
		}
	}
	if(huart->Instance==huart4.Instance){
		HAL_UART_Receive_IT(&huart4,&receive_data2,1);
		HAL_UART_Transmit_IT(&huart4,&receive_data2,1);
	}
}

void HAL_I2C_MemRxCpltCallback(I2C_HandleTypeDef *hi2c){
	if(hi2c->Instance==hi2c1.Instance){
		second = BCD2DEC(receiveDataFromDS3231[0]);
		minute = BCD2DEC(receiveDataFromDS3231[1]);
		hour = BCD2DEC(receiveDataFromDS3231[2]);
		
		day = BCD2DEC(receiveDataFromDS3231[3]);
		date = BCD2DEC(receiveDataFromDS3231[4]);
		month = BCD2DEC(receiveDataFromDS3231[5]);
		year = BCD2DEC(receiveDataFromDS3231[6]);
	}
}

//-------------------------------------------------------------------------------------//
//My code-----------------------------------------------------------------------------//

uint8_t BCD2DEC(uint8_t data){
	return (data>>4)*10 + (data&0x0f);
}

uint8_t DEC2BCD(uint8_t data){
	return (data/10)<<4|(data%10);
}

uint8_t convertNumToStringMSB(uint8_t number){
	return (number/10)+48;
}

uint8_t convertNumToStringLSB(uint8_t number){
	return (number%10)+48;
}

uint8_t convertStringToNum(uint8_t MSB, uint8_t LSB){
	MSB = MSB - 48;
	LSB = LSB - 48;
	return (MSB*10+LSB);
}

uint8_t convertStringToNum3(uint8_t MSB1, uint8_t MSB, uint8_t LSB){
	MSB1 = MSB1 - 48;
	MSB = MSB - 48;
	LSB = LSB - 48;
	return (MSB1*100 + MSB*10 +LSB);
}

void writeDataToDS3132(void){
	sendDataToDS3231[0] = DEC2BCD(0);
	sendDataToDS3231[1] = DEC2BCD(46);
	sendDataToDS3231[2] = DEC2BCD(10);
	
	sendDataToDS3231[3] = DEC2BCD(5);
	sendDataToDS3231[4] = DEC2BCD(21);
	sendDataToDS3231[5] = DEC2BCD(9);
	sendDataToDS3231[6] = DEC2BCD(17);
	HAL_I2C_Mem_Write_IT(&hi2c1,DS3231_ADD<<1,0,I2C_MEMADD_SIZE_8BIT,sendDataToDS3231,7);
}

void sendRS485toSystem(void){
	HAL_GPIO_WritePin(GPIOD,GPIO_PIN_12,GPIO_PIN_SET);
	HAL_GPIO_WritePin(GPIOB,GPIO_PIN_5,GPIO_PIN_SET);
	HAL_Delay(100);
	HAL_UART_Transmit_IT(&huart1,dataSendtoSystem,11);
	HAL_UART_Transmit_IT(&huart4,dataSendtoSystem,11);
	HAL_Delay(100);
	HAL_GPIO_WritePin(GPIOB,GPIO_PIN_5,GPIO_PIN_RESET);
	HAL_GPIO_WritePin(GPIOD,GPIO_PIN_12,GPIO_PIN_RESET);
}
void setIDforButton(void){
	static uint8_t i = 0;
	for(i = 0; i<(dataReceiveFromSystem[9]-48);i++){
		dataSendtoSystem[0]  = 'S';
		dataSendtoSystem[1]  = '1';
		dataSendtoSystem[2]  = '2';
		dataSendtoSystem[3]  = 'B';
		dataSendtoSystem[4]  = convertNumToStringMSB(numberOfButton);
		dataSendtoSystem[5]  = convertNumToStringLSB(numberOfButton);
		dataSendtoSystem[6]  = 'D';
		dataSendtoSystem[7]  = convertNumToStringMSB(numberOfButton);
		dataSendtoSystem[8]  = convertNumToStringLSB(numberOfButton);
		dataSendtoSystem[9]  = convertNumToStringLSB(i+1);
		dataSendtoSystem[10] = 'E';
		numberOfButton++;
		sendRS485toSystem();
		HAL_Delay(400);
	}
}

void setIDforDevice(void){
	static uint8_t i = 0;
	for(i = 0; i<(dataReceiveFromSystem[9]-48);i++){
		dataSendtoSystem[0]  = 'S';
		dataSendtoSystem[1]  = '1';
		dataSendtoSystem[2]  = '2';
		dataSendtoSystem[3]  = 'B';
		dataSendtoSystem[4]  = convertNumToStringMSB(numberOfDevice);
		dataSendtoSystem[5]  = convertNumToStringLSB(numberOfDevice);
		dataSendtoSystem[6]  = '0';
		dataSendtoSystem[7]  = '0';
		dataSendtoSystem[8]  = '0';
		dataSendtoSystem[9]  = convertNumToStringLSB(i+1);
		dataSendtoSystem[10] = 'E';
		numberOfDevice++;
		sendRS485toSystem();
	}
}

void controlDevice(void){
		dataSendtoSystem[0]  = 'S';
		dataSendtoSystem[1]  = '1';
		dataSendtoSystem[2]  = '0';
		dataSendtoSystem[3]  = 'D';
		dataSendtoSystem[4]  = dataReceiveFromSystem[7];
		dataSendtoSystem[5]  = dataReceiveFromSystem[8];
		dataSendtoSystem[6]  = '0';
		dataSendtoSystem[7]  = '0';
		dataSendtoSystem[8]  = '0';
		dataSendtoSystem[9]  = dataReceiveFromSystem[9];
		dataSendtoSystem[10] = 'E';
		sendRS485toSystem();
}

void updateDevicesState(void){
	uint8_t i;
	i = convertStringToNum(dataSendtoSystem[4],dataSendtoSystem[5]);
	devicesState[i] = dataSendtoSystem[9];
}

void updateStateToInternet(void){
	uint8_t i;
	for(i=1;i<16;i++){
			devicesStateUpdateToInternet[i+1] = devicesState[i];
	}
	HAL_UART_Transmit_IT(&huart2,devicesStateUpdateToInternet,18);
	HAL_Delay(100);
}

void sendDataFromSensorToInternet(void){
	HAL_UART_Transmit_IT(&huart2,dataFromSensorToInternet,11);
	HAL_Delay(100);
}

void sendDataFromPowerToInternet(void){
	HAL_UART_Transmit_IT(&huart2,dataFromPowerToInternet,11);
	HAL_Delay(100);
}
void answerSystem(void){
	//control device
	if(dataReceiveFromSystem[2] == '0'){
		controlDevice();
		updateDevicesState();
		updateStateToInternet();
	}
	//set ma device
	if(dataReceiveFromSystem[2] == '2'){
		if(dataReceiveFromSystem[8] == 'B'){
			setIDforButton();
		}
		if(dataReceiveFromSystem[8] == 'D'){
			setIDforDevice();
		}
	}
	//receive data from sensor
	if(dataReceiveFromSystem[2] == '3'){
		if(dataReceiveFromSystem[9] == 'T'){
			dataFromSensorToInternet[9]= 'T';
			dataFromSensorToInternet[7] = dataReceiveFromSystem[7];
			dataFromSensorToInternet[8] = dataReceiveFromSystem[8];
			sendDataFromSensorToInternet();
			temperature = convertStringToNum(dataReceiveFromSystem[7],dataReceiveFromSystem[8]);
		}
		if(dataReceiveFromSystem[9] == 'H'){
			dataFromSensorToInternet[9]= 'H';
			dataFromSensorToInternet[7] = dataReceiveFromSystem[7];
			dataFromSensorToInternet[8] = dataReceiveFromSystem[8];
			sendDataFromSensorToInternet();
			humid = convertStringToNum(dataReceiveFromSystem[7],dataReceiveFromSystem[8]);
		}
		if(dataReceiveFromSystem[9] == 'G'){
			dataFromSensorToInternet[9]= 'G';
			dataFromSensorToInternet[7] = dataReceiveFromSystem[7];
			dataFromSensorToInternet[8] = dataReceiveFromSystem[8];
			sendDataFromSensorToInternet();
			gasDetection = convertStringToNum(dataReceiveFromSystem[7],dataReceiveFromSystem[8]);
		}
		if(dataReceiveFromSystem[9] == 'M'){
			dataFromSensorToInternet[9]= 'M';
			dataFromSensorToInternet[7] = dataReceiveFromSystem[7];
			dataFromSensorToInternet[8] = dataReceiveFromSystem[8];
			sendDataFromSensorToInternet();
			humanDetection = convertStringToNum(dataReceiveFromSystem[7],dataReceiveFromSystem[8]);
		}
		if(dataReceiveFromSystem[9] == 'P'){
			dataFromPowerToInternet[6] = dataReceiveFromSystem[6];
			dataFromPowerToInternet[7] = dataReceiveFromSystem[7];
			dataFromPowerToInternet[8] = dataReceiveFromSystem[8];
			sendDataFromPowerToInternet();
			power = convertStringToNum3(dataReceiveFromSystem[6],dataReceiveFromSystem[7],dataReceiveFromSystem[8]);
		}
	}
	
}

void processDataFromInternet(void){
	uint8_t i,tempHour,tempMin;
	if(dataReceiveFromInternet[1] == '0'){
		 for(i=1;i<16;i++){
				if(devicesState[i] != dataReceiveFromInternet[i+1]){
					devicesState[i] = dataReceiveFromInternet[i+1];
					dataSendtoSystem[0]  = 'S';
					dataSendtoSystem[1]  = '1';
					dataSendtoSystem[2]  = '0';
					dataSendtoSystem[3]  = 'D';
					dataSendtoSystem[4]  = convertNumToStringMSB(i);
					dataSendtoSystem[5]  = convertNumToStringLSB(i);
					dataSendtoSystem[6]  = '0';
					dataSendtoSystem[7]  = '0';
					dataSendtoSystem[8]  = '0';
					dataSendtoSystem[9]  = devicesState[i];
					dataSendtoSystem[10] = 'E';
					HAL_Delay(200);
					//Gui ve cho UART 1
					sendRS485toSystem();
					updateDevicesState();
					HAL_Delay(100);
					//HAL_UART_Transmit_IT(&huart2,dataSendtoSystem,11);
					HAL_Delay(100);
				}
		 }
	}
	if(dataReceiveFromInternet[1] == '1'){
			i = convertStringToNum(dataReceiveFromInternet[3],dataReceiveFromInternet[4]);
			tempHour = convertStringToNum(dataReceiveFromInternet[5],dataReceiveFromInternet[6]);
			tempMin = convertStringToNum(dataReceiveFromInternet[7],dataReceiveFromInternet[8]);
			if(dataReceiveFromInternet[9] == '1'){
					setHourOn[i] = tempHour;
					setMinOn[i] = tempMin;
			}
			if(dataReceiveFromInternet[9] == '0'){
					setHourOff[i] = tempHour;
					setMinOff[i] = tempMin;
			}
	}
}

void checkSetTime(void){
	uint8_t i;
	for(i=1;i<11;i++){
		if(setHourOn[i] > 0 || setMinOn[i] > 0){
				if(setHourOn[i] == hour && setMinOn[i] == minute){
						setHourOn[i] = 0;
						setMinOn[i] = 0;
						dataSendtoSystem[0]  = 'S';
						dataSendtoSystem[1]  = '1';
						dataSendtoSystem[2]  = '0';
						dataSendtoSystem[3]  = 'D';
						dataSendtoSystem[4]  = convertNumToStringMSB(i);
						dataSendtoSystem[5]  = convertNumToStringLSB(i);
						dataSendtoSystem[6]  = '0';
						dataSendtoSystem[7]  = '0';
						dataSendtoSystem[8]  = '0';
						dataSendtoSystem[9]  = '1';
						dataSendtoSystem[10] = 'E';
						sendRS485toSystem();
						HAL_GPIO_WritePin(GPIOD,GPIO_PIN_13,GPIO_PIN_SET);
						updateDevicesState();
						updateStateToInternet();
				}
		}
		if(setHourOff[i] > 0 || setMinOff[i] > 0){
				if(setHourOff[i] == hour && setMinOff[i] == minute && second < 4){
						setHourOff[i] = 0;
						setMinOff[i] = 0;
						dataSendtoSystem[0]  = 'S';
						dataSendtoSystem[1]  = '1';
						dataSendtoSystem[2]  = '0';
						dataSendtoSystem[3]  = 'D';
						dataSendtoSystem[4]  = convertNumToStringMSB(i);
						dataSendtoSystem[5]  = convertNumToStringLSB(i);
						dataSendtoSystem[6]  = '0';
						dataSendtoSystem[7]  = '0';
						dataSendtoSystem[8]  = '0';
						dataSendtoSystem[9]  = '0';
						dataSendtoSystem[10] = 'E';
						sendRS485toSystem();
						HAL_GPIO_WritePin(GPIOD,GPIO_PIN_13,GPIO_PIN_RESET);
						updateDevicesState();
						updateStateToInternet();
				}
		}
	}
}

void checkTimeToReadSensor(void){
	if(minute != oldminute){
		if(statusSend == 1){
				strcpy((char *)dataSendtoSystem,"S13C01000TE");
				HAL_Delay(100);
				sendRS485toSystem();
				statusSend++;
		}
		else if(statusSend == 2){
				strcpy((char *)dataSendtoSystem,"S13C01000HE");
				HAL_Delay(100);
				sendRS485toSystem();
				statusSend++;
		}
		else if(statusSend == 3){
				strcpy((char *)dataSendtoSystem,"S13D04000PE");
				HAL_Delay(100);
				sendRS485toSystem();
				statusSend = 1;
		}
		/*
		else if(statusSend == 4){
				strcpy((char *)dataSendtoSystem,"S13D04000IE");
				HAL_Delay(100);
				sendRS485toSystem();
				statusSend++;
		}
		else if(statusSend == 5){
				strcpy((char *)dataSendtoSystem,"S13D04000PE");
				HAL_Delay(100);
				sendRS485toSystem();
				statusSend = 1;
		}
		*/
		/*
		if(minute%5 == 0){
				strcpy((char *)dataSendtoSystem,"S13D04000PE");
				HAL_Delay(100);
				sendRS485toSystem();
		}
		else if(minute%4 == 0){
				strcpy((char *)dataSendtoSystem,"S13D04000IE");
				HAL_Delay(100);
				sendRS485toSystem();
		}
		else if(minute%3 == 0){
				strcpy((char *)dataSendtoSystem,"S13D04000VE");
				HAL_Delay(100);
				sendRS485toSystem();
		}
		else if(minute%2 == 0){
				strcpy((char *)dataSendtoSystem,"S13C01000TE");
				HAL_Delay(100);
				sendRS485toSystem();
		}
		else if(minute%2 !=0){
				strcpy((char *)dataSendtoSystem,"S13C01000HE");
				sendRS485toSystem();
				HAL_Delay(100);
		}
		*/
		oldminute = minute;
	}
}

void Initsim900A(void){
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)"AT\r\n",4);	//Tat che do phan hoi
	HAL_Delay(300);
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)"ATE0\r\n",6);	//Tat che do phan hoi
	HAL_Delay(300);
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)"AT+CMGF=1\r\n",11); //Dua tin nhan ve che do text
	HAL_Delay(300);
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)"AT+CLIP=1\r\n",11); //Hien thi thong tin cuoc goi toi
	HAL_Delay(300);
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)"AT+CNMI=2,1,0,0,0\r\n",19); // bao hieu khi co 1 tin nhan gui toi: +CMTI: "SM",1
	HAL_Delay(300);
}

void Call(void){
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)"ATD0939863350;\r\n",16); //0935185037 0939863350 
	HAL_Delay(15000);
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)"ATH\r\n",5);
	HAL_Delay(2000);
}
void sendMessage(char *s,int length){
	uint8_t send = 0x1A;
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)"AT+CMGS=\"0939863350\"\r\n",22);
	HAL_Delay(3000);
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)s,length);
	HAL_Delay(3000);
	HAL_UART_Transmit_IT(&huart3,&send,1);
	HAL_Delay(3000);
}
void deleteSMS(void){
	HAL_UART_Transmit_IT(&huart3,(uint8_t *)"AT+CMGDA=\"DEL ALL\"\r\n",22);
	HAL_Delay(3000);
}

void processDetailSms (void){
	if(strcmp((const char *)smsDetail,"Turn on device 1") == 0){
		devicesState[1]='1';
		strcpy((char *)dataSendtoSystem,"S10D010001E");
		sendRS485toSystem();
		updateStateToInternet();
		sendMessage("System turned on device 1",25);
	}
	if(strcmp((const char *)smsDetail,"Turn off device 1") == 0){
		devicesState[1]='0';
		strcpy((char *)dataSendtoSystem,"S10D010000E");
		sendRS485toSystem();
		updateStateToInternet();
		sendMessage("System turned off device 1",26);
	}
}
	
void processDataFromSim(void){
	int i;
	if(strstr((char *)dataReceiveFromSim800,"+CMTI:") != NULL){
		flagSms = 1;
		for(i=0;i<100;i++){
			smsDetail[i]=0;
		}
		
	}
	if(flagSms == 1){
		HAL_UART_Transmit_IT(&huart3,(uint8_t *)"AT+CMGR=1\r\n",11);
		HAL_Delay(2000);
		flagSms = 0;
		countDetail = 0;
		for(i=0;i<100;i++){
			dataReceiveFromSim800[i] = 0;
		}
		deleteSMS();
		processDetailSms();
	}
	
}

void checkLCD(void){
	if(lcd_mode != old_lcd_mode){
		lcd_clear();
		old_lcd_mode = lcd_mode;
	}
	if(lcd_mode == 0){
		lcd_HomePage(day,date,month,year,hour,minute,second,temperature,power);
	}
	if(lcd_mode == 1){
		lcd_Mode_1_page();
	}
	if(lcd_mode == 2){
		lcd_Mode_2_page();
	}
	if(lcd_mode == 3){
		lcd_Mode_3_page();
	}
}
//-------------------------------------------------------------------------------------//

/** System Clock Configuration
*/
void SystemClock_Config(void)
{

  RCC_OscInitTypeDef RCC_OscInitStruct;
  RCC_ClkInitTypeDef RCC_ClkInitStruct;

    /**Configure the main internal regulator output voltage 
    */
  __HAL_RCC_PWR_CLK_ENABLE();

  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

    /**Initializes the CPU, AHB and APB busses clocks 
    */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 8;
  RCC_OscInitStruct.PLL.PLLN = 336;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 7;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Initializes the CPU, AHB and APB busses clocks 
    */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV4;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure the Systick interrupt time 
    */
  HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/1000);

    /**Configure the Systick 
    */
  HAL_SYSTICK_CLKSourceConfig(SYSTICK_CLKSOURCE_HCLK);

  /* SysTick_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(SysTick_IRQn, 0, 0);
}

/* I2C1 init function */
static void MX_I2C1_Init(void)
{

  hi2c1.Instance = I2C1;
  hi2c1.Init.ClockSpeed = 400000;
  hi2c1.Init.DutyCycle = I2C_DUTYCYCLE_2;
  hi2c1.Init.OwnAddress1 = 0;
  hi2c1.Init.AddressingMode = I2C_ADDRESSINGMODE_7BIT;
  hi2c1.Init.DualAddressMode = I2C_DUALADDRESS_DISABLE;
  hi2c1.Init.OwnAddress2 = 0;
  hi2c1.Init.GeneralCallMode = I2C_GENERALCALL_DISABLE;
  hi2c1.Init.NoStretchMode = I2C_NOSTRETCH_DISABLE;
  if (HAL_I2C_Init(&hi2c1) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

}

/* SDIO init function */
static void MX_SDIO_SD_Init(void)
{

  hsd.Instance = SDIO;
  hsd.Init.ClockEdge = SDIO_CLOCK_EDGE_RISING;
  hsd.Init.ClockBypass = SDIO_CLOCK_BYPASS_DISABLE;
  hsd.Init.ClockPowerSave = SDIO_CLOCK_POWER_SAVE_DISABLE;
  hsd.Init.BusWide = SDIO_BUS_WIDE_1B;
  hsd.Init.HardwareFlowControl = SDIO_HARDWARE_FLOW_CONTROL_DISABLE;
  hsd.Init.ClockDiv = 0;

}

/* UART4 init function */
static void MX_UART4_Init(void)
{

  huart4.Instance = UART4;
  huart4.Init.BaudRate = 9600;
  huart4.Init.WordLength = UART_WORDLENGTH_8B;
  huart4.Init.StopBits = UART_STOPBITS_1;
  huart4.Init.Parity = UART_PARITY_NONE;
  huart4.Init.Mode = UART_MODE_TX_RX;
  huart4.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart4.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart4) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

}

/* USART1 init function */
static void MX_USART1_UART_Init(void)
{

  huart1.Instance = USART1;
  huart1.Init.BaudRate = 9600;
  huart1.Init.WordLength = UART_WORDLENGTH_8B;
  huart1.Init.StopBits = UART_STOPBITS_1;
  huart1.Init.Parity = UART_PARITY_NONE;
  huart1.Init.Mode = UART_MODE_TX_RX;
  huart1.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart1.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart1) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

}

/* USART2 init function */
static void MX_USART2_UART_Init(void)
{

  huart2.Instance = USART2;
  huart2.Init.BaudRate = 9600;
  huart2.Init.WordLength = UART_WORDLENGTH_8B;
  huart2.Init.StopBits = UART_STOPBITS_1;
  huart2.Init.Parity = UART_PARITY_NONE;
  huart2.Init.Mode = UART_MODE_TX_RX;
  huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart2.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart2) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

}

/* USART3 init function */
static void MX_USART3_UART_Init(void)
{

  huart3.Instance = USART3;
  huart3.Init.BaudRate = 9600;
  huart3.Init.WordLength = UART_WORDLENGTH_8B;
  huart3.Init.StopBits = UART_STOPBITS_1;
  huart3.Init.Parity = UART_PARITY_NONE;
  huart3.Init.Mode = UART_MODE_TX_RX;
  huart3.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart3.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart3) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

}

/** 
  * Enable DMA controller clock
  */
static void MX_DMA_Init(void) 
{
  /* DMA controller clock enable */
  __HAL_RCC_DMA1_CLK_ENABLE();

  /* DMA interrupt init */
  /* DMA1_Stream0_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(DMA1_Stream0_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA1_Stream0_IRQn);

}

/** Configure pins as 
        * Analog 
        * Input 
        * Output
        * EVENT_OUT
        * EXTI
*/
static void MX_GPIO_Init(void)
{

  GPIO_InitTypeDef GPIO_InitStruct;

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOE_CLK_ENABLE();
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOD_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5 
                          |GPIO_PIN_0|GPIO_PIN_1, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14|GPIO_PIN_15, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_5, GPIO_PIN_RESET);

  /*Configure GPIO pins : PE2 PE3 PE4 PE5 
                           PE0 PE1 */
  GPIO_InitStruct.Pin = GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5 
                          |GPIO_PIN_0|GPIO_PIN_1;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
  HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);

  /*Configure GPIO pin : PC2 */
  GPIO_InitStruct.Pin = GPIO_PIN_2;
  GPIO_InitStruct.Mode = GPIO_MODE_IT_FALLING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

  /*Configure GPIO pins : PD12 PD13 PD14 PD15 */
  GPIO_InitStruct.Pin = GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14|GPIO_PIN_15;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
  HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);

  /*Configure GPIO pins : PD0 PD1 PD3 */
  GPIO_InitStruct.Pin = GPIO_PIN_0|GPIO_PIN_1|GPIO_PIN_3;
  GPIO_InitStruct.Mode = GPIO_MODE_IT_FALLING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);

  /*Configure GPIO pin : PB5 */
  GPIO_InitStruct.Pin = GPIO_PIN_5;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /* EXTI interrupt init*/
  HAL_NVIC_SetPriority(EXTI0_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI0_IRQn);

  HAL_NVIC_SetPriority(EXTI1_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI1_IRQn);

  HAL_NVIC_SetPriority(EXTI2_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI2_IRQn);

  HAL_NVIC_SetPriority(EXTI3_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI3_IRQn);

}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @param  None
  * @retval None
  */
void _Error_Handler(char * file, int line)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  while(1) 
  {
  }
  /* USER CODE END Error_Handler_Debug */ 
}

#ifdef USE_FULL_ASSERT

/**
   * @brief Reports the name of the source file and the source line number
   * where the assert_param error has occurred.
   * @param file: pointer to the source file name
   * @param line: assert_param error line source number
   * @retval None
   */
void assert_failed(uint8_t* file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
    ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */

}

#endif

/**
  * @}
  */ 

/**
  * @}
*/ 

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
