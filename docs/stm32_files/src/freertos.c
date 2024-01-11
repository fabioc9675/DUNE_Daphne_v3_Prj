/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * File Name          : freertos.c
  * Description        : Code for freertos applications
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2021 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under Ultimate Liberty license
  * SLA0044, the "License"; You may not use this file except in compliance with
  * the License. You may obtain a copy of the License at:
  *                             www.st.com/SLA0044
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "FreeRTOS.h"
#include "task.h"
#include "main.h"
#include "cmsis_os.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include <stdio.h>
#include <string.h>
#include <usart.h>
#include <queue.h>
#include <semphr.h>

#include <tim.h>
#include "daphne_bitstream.h"
#include "daphne_usbserial_hal.h"
#include "daphne_clocks_hal.h"
#include "daphne_afe_hal.h"
#include "daphne_cm_hal.h"
#include "daphne_cmds.h"
#include "daphne_spi_fpga.h"

#include "w25qxxConf.h"
#include "w25qxx.h"

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
typedef StaticSemaphore_t osStaticMutexDef_t;
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN Variables */

/* CLOCK CODE BEGIN Variables */


/* CLOCK CODE END Variables */

/* UART CODE BEGIN Variables */
void delay_us (uint16_t us);
extern const char daphneprompt[10];

char str_rcv[100];
char buff_str[50];
const char version[]={"@version : v1.0 rev. 1 \n\n\r"};
// DMA RX
uint8_t data[DMA_BUF_SIZE+1] = {'\0'};   		 /* Data buffer that contains newly received data */
Receive_StatusTypeDef cmd_rcv_flag=RCV_NONE;
extern uint8_t dma_rx_buf[DMA_BUF_SIZE];         /* Circular buffer for DMA */
int8_t DMATXcompleteFlag=1;

uint8_t BuffStrSerial[DMA_BUF_SIZE]; 			// 128 characteres
uint8_t writeidx = 0;
int32_t Timeoutcounter=0;
int8_t Timeoutflag=0;
int8_t statusRX_OVF=0;
int8_t statusRX_Timeout=0;

uint32_t sideA=0;
uint32_t sideB=0;

/* UART CODE END Variables */
//extern uint8_t spi_tx_buf[SPI_BUF_SIZE];
extern uint8_t spi_tx_buf[SPI_BUF_SIZE];
typedef enum {
	none,
	waitdata,
	zone1,
	zone2,
	endzone1,
	endzone2,
	fillbuffer
}buffertypedef_t;

buffertypedef_t spibuffstate;
buffertypedef_t spibuffstate_next;

extern BufferCircular_t fpgabitstreambuffer;
uint32_t writeidx2 = 0;

uint32_t spiTxNumBytes=0;
uint32_t spiMemNumPage=0;


#define spiTx_buflocaloffset SPI_BUF_SIZE/2

uint8_t dataflash[]={"TEAM DAPHNE: HI MIGUEL, HI JUAN, HI FABIAN, HI JAVIER     ."
				"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_!$%&/()---------XXXXXXXXXXX"
				"TEST DE MEMORIA RAM ESCRITURA EN PAGINA 1                      ."
				"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_!$%&/()---------YYYYYYYYYYY"
				"TEST DE MEMORIA RAM ESCRITURA EN PAGINA 2                      ."
				"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_!$%&/()---------XXXXXXXXXXX"
				"TEST DE MEMORIA RAM ESCRITURA EN PAGINA 3                      ."
				"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_!$%&/()---------YYYYYYYYYYY"
};

uint8_t *pbuffer=&dataflash[0];

uint32_t pageidx, sectoridx;

uint32_t counterOVF=0;
uint32_t counterIDLE=0;

uint8_t dataFlashRead[512];

extern stateFlow_t bitflow;

typedef enum {
	BitInit_st,
	BitIdle_st,
	GetBitstream_st,
	GetBitstream_datarcv_st,
	GetBitstream_datawritetomem_st,
	LoadBitstream_st,
	LoadBitstream_ReadSPIToBuffer_st,
	LoadBitstream_PacketToTx_st,
	LoadBitstream_SendDataToSPI_st,
	Bitstream_SendDataflashToPC_st
}bitstreamdataflow_t;
bitstreamdataflow_t Bitstreamdataflow;

/* MACHINE STATE CODE BEGIN Variables */
typedef enum {
	Init_st,
	Idle_st,
	Read_st,
	PowerUpSeq_st,
	CmdRcv_st,
	ExecuteCmd_st,
	ExecuteCmdwaitcmplt_st,
	BitstreamRcv_st,
	ReadFlashBitstreamRcv_st,
	LoadFlashToFPGA_st,
	SerialBitstreamRcv_st,
	EthBitstreamRcv_st
}scdataflow_t;
scdataflow_t scdataflow;

/* MACHINE STATE CODE END Variables */

/* Buffer used for transmission */
uint8_t aTxBuffer[] = "**** SPI ****\n";
// uint8_t aTxBuffer[] = "aaaaaaaaaaaaaa";
uint8_t outBuffer[4][8] = { "fabian \0", "andres \0", "castano\0", "usuga  \0" };
// uint8_t outBuffer[4][8] = {"aaaaaaaa","aaaaaaaa","aaaaaaaa","aaaaaaaa"};
uint8_t inData[8];
uint8_t cont = 0;

#ifdef __GNUC__
#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif
PUTCHAR_PROTOTYPE
{
    HAL_UART_Transmit(&huart1 , (uint8_t *)&ch, 1, 0xFFFF);
    return ch;
}

/* END TEST MEMORY FLASH  */


/* USER CODE END Variables */
/* Definitions for defaultTask */
osThreadId_t defaultTaskHandle;
const osThreadAttr_t defaultTask_attributes = {
  .name = "defaultTask",
  .stack_size = 256 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for ClocksTask */
osThreadId_t ClocksTaskHandle;
const osThreadAttr_t ClocksTask_attributes = {
  .name = "ClocksTask",
  .stack_size = 256 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for LedTask */
osThreadId_t LedTaskHandle;
const osThreadAttr_t LedTask_attributes = {
  .name = "LedTask",
  .stack_size = 128 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for FPGAspiTask */
osThreadId_t FPGAspiTaskHandle;
const osThreadAttr_t FPGAspiTask_attributes = {
  .name = "FPGAspiTask",
  .stack_size = 256 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for GetCMDsTask */
osThreadId_t GetCMDsTaskHandle;
const osThreadAttr_t GetCMDsTask_attributes = {
  .name = "GetCMDsTask",
  .stack_size = 256 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for mainTask */
osThreadId_t mainTaskHandle;
const osThreadAttr_t mainTask_attributes = {
  .name = "mainTask",
  .stack_size = 256 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for TimeoutTask */
osThreadId_t TimeoutTaskHandle;
const osThreadAttr_t TimeoutTask_attributes = {
  .name = "TimeoutTask",
  .stack_size = 128 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for BitstreamTask */
osThreadId_t BitstreamTaskHandle;
const osThreadAttr_t BitstreamTask_attributes = {
  .name = "BitstreamTask",
  .stack_size = 256 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for cmdQueues */
osMessageQueueId_t cmdQueuesHandle;
const osMessageQueueAttr_t cmdQueues_attributes = {
  .name = "cmdQueues"
};
/* Definitions for TaskMutex */
osMutexId_t TaskMutexHandle;
osStaticMutexDef_t TaskMutexControlBlock;
const osMutexAttr_t TaskMutex_attributes = {
  .name = "TaskMutex",
  .cb_mem = &TaskMutexControlBlock,
  .cb_size = sizeof(TaskMutexControlBlock),
};

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN FunctionPrototypes */
void Disable_all_devices(void);
void Disable_all_AFE(void);

void DMATX_FullTransferComplete(DMA_HandleTypeDef *hdma);
void DMARX_HalfTransferComplete(DMA_HandleTypeDef *hdma);
void DMARX_FullTransferComplete(DMA_HandleTypeDef *hdma);

QUEUE_StatusTypeDef Read_CMDqueue(cmdqueue_TypeDef *valuercv);
QUEUE_StatusTypeDef Write_CMDqueue(cmdqueue_TypeDef valuesend);
extern void sendmsg(char *str);

/* USER CODE END FunctionPrototypes */

void StartDefaultTask(void *argument);
void StartClocksTask(void *argument);
void StartLedTask(void *argument);
void StartFPGAspiTask(void *argument);
void StartGetCMDsTask(void *argument);
void StartmainTask(void *argument);
void StartTimeoutTask(void *argument);
void StartBitstreamTask(void *argument);

void MX_FREERTOS_Init(void); /* (MISRA C 2004 rule 8.1) */

/**
  * @brief  FreeRTOS initialization
  * @param  None
  * @retval None
  */
void MX_FREERTOS_Init(void) {
  /* USER CODE BEGIN Init */

  /* USER CODE END Init */
  /* Create the mutex(es) */
  /* creation of TaskMutex */
  TaskMutexHandle = osMutexNew(&TaskMutex_attributes);

  /* USER CODE BEGIN RTOS_MUTEX */
  /* add mutexes, ... */
  /* USER CODE END RTOS_MUTEX */

  /* USER CODE BEGIN RTOS_SEMAPHORES */
  /* add semaphores, ... */
  /* USER CODE END RTOS_SEMAPHORES */

  /* USER CODE BEGIN RTOS_TIMERS */
  /* start timers, add new ones, ... */
  /* USER CODE END RTOS_TIMERS */

  /* Create the queue(s) */
  /* creation of cmdQueues */
  cmdQueuesHandle = osMessageQueueNew (64, sizeof(cmdqueue_TypeDef), &cmdQueues_attributes);

  /* USER CODE BEGIN RTOS_QUEUES */
  /* add queues, ... */
  /* USER CODE END RTOS_QUEUES */

  /* Create the thread(s) */
  /* creation of defaultTask */
  defaultTaskHandle = osThreadNew(StartDefaultTask, NULL, &defaultTask_attributes);

  /* creation of ClocksTask */
  ClocksTaskHandle = osThreadNew(StartClocksTask, NULL, &ClocksTask_attributes);

  /* creation of LedTask */
  LedTaskHandle = osThreadNew(StartLedTask, NULL, &LedTask_attributes);

  /* creation of FPGAspiTask */
  FPGAspiTaskHandle = osThreadNew(StartFPGAspiTask, NULL, &FPGAspiTask_attributes);

  /* creation of GetCMDsTask */
  GetCMDsTaskHandle = osThreadNew(StartGetCMDsTask, NULL, &GetCMDsTask_attributes);

  /* creation of mainTask */
  mainTaskHandle = osThreadNew(StartmainTask, NULL, &mainTask_attributes);

  /* creation of TimeoutTask */
  TimeoutTaskHandle = osThreadNew(StartTimeoutTask, NULL, &TimeoutTask_attributes);

  /* creation of BitstreamTask */
  BitstreamTaskHandle = osThreadNew(StartBitstreamTask, NULL, &BitstreamTask_attributes);

  /* USER CODE BEGIN RTOS_THREADS */
  /* add threads, ... */
  /* USER CODE END RTOS_THREADS */

  /* USER CODE BEGIN RTOS_EVENTS */
  /* add events, ... */
  /* USER CODE END RTOS_EVENTS */

}

/* USER CODE BEGIN Header_StartDefaultTask */
/**
  * @brief  Function implementing the defaultTask thread.
  * @param  argument: Not used
  * @retval None
  */
/* USER CODE END Header_StartDefaultTask */
void StartDefaultTask(void *argument)
{
  /* USER CODE BEGIN StartDefaultTask */
  /* Infinite loop */
  extern DMA_HandleTypeDef hdma_usart1_rx;
  char msg1[128];

  if(HAL_UART_Receive_DMA(&huart1, (uint8_t*)dma_rx_buf, DMA_BUF_SIZE) != HAL_OK)
  {
    Error_Handler();
   }

  __HAL_UART_ENABLE_IT(&huart1, UART_IT_IDLE);   // enable idle line interrupt
  __HAL_DMA_DISABLE_IT(&hdma_usart1_rx, DMA_IT_HT);

  //sprintf (msg1, "\n\r UART + COMMANDs + AFE INTEGRATION ");
  //sendmsg(msg1);

  for(;;)
  {
	  HAL_GPIO_TogglePin (LED0_GPIO_Port, LED0_Pin); // Led Indicator FPGA clocks ON
	  osDelay(2000);
  }
  /* USER CODE END StartDefaultTask */
}

/* USER CODE BEGIN Header_StartClocksTask */
/**
* @brief Function implementing the ClocksTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartClocksTask */
void StartClocksTask(void *argument)
{
  /* USER CODE BEGIN StartClocksTask */
  /* Infinite loop */
/*
  char msg[64];
  HAL_TIMCLKStatusTypeDef timclkstatus;

  osDelay(50); //Delay
  //Disable_all_devices();
  timclkstatus = TIMCLK_Init();
  if (timclkstatus != HAL_TIMCLK_OK) {
	  sprintf (msg,"FPGA Clocks Uninitialized \n\r");
	  sprintf (msg,"Timing and Clocks Error code : %d\n\r", timclkstatus);
  } else {
	  sprintf (msg,"FPGA Clocks Initialized\n\r");
  }
  sendmsg(msg);
*/
  for(;;)
  {
    osDelay(1000);
  }
  /* USER CODE END StartClocksTask */
}

/* USER CODE BEGIN Header_StartLedTask */
/**
* @brief Function implementing the LedTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartLedTask */
void StartLedTask(void *argument)
{
  /* USER CODE BEGIN StartLedTask */
  /* Infinite loop */

  for(;;)
  {
    osDelay(1000);
  }
  /* USER CODE END StartLedTask */
}

/* USER CODE BEGIN Header_StartFPGAspiTask */
/**
* @brief Function implementing the FPGAspiTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartFPGAspiTask */
void StartFPGAspiTask(void *argument)
{
  /* USER CODE BEGIN StartFPGAspiTask */
  /* Infinite loop */
	extern FPGA_HandleTypeDef hfpga_spi;
	extern uint8_t FPGARequestdata;
	// usart input buffer
	uint8_t U1RXBUFF[10];     // buffer to receive data from USART3
	extern uint8_t DATA_TEST[640];
	///* Buffer used for reception */
	//uint8_t aRxBuffer[BUFFERSIZE];
	uint8_t SPI2TXBUFF[640];

	osDelay(100);
  /*FPGA SPI communication Init Configuration*/
    MX_FPGA_SPI_Init();
  /*FPGA SPI communication End Configuration*/
    FPGARequestdata=0;
  for(;;)
  {
	  if (FPGARequestdata==1){
		  HAL_FPGA_RequireDataSample(&hfpga_spi, U1RXBUFF, SPI2TXBUFF, 640, 0xFF);
		  HAL_UART_Transmit(&huart1, SPI2TXBUFF, 640, 1000);
		  FPGARequestdata=0;
      }
      osDelay(100);
  }
  /* USER CODE END StartFPGAspiTask */
}

/* USER CODE BEGIN Header_StartGetCMDsTask */
/**
* @brief Function implementing the GetCMDsTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartGetCMDsTask */
void StartGetCMDsTask(void *argument)
{
  /* USER CODE BEGIN StartGetCMDsTask */
  /* Infinite loop */

    int counter;
	char msg[128];
	QUEUE_StatusTypeDef state;
	cmdqueue_TypeDef cmd;
	int lengthstr=0;
	osStatus_t val2;

	typedef enum {idle,get_serialcommands,get_ethcommands,get_serialbitstream,get_ethbitstream} mode_t;
	mode_t mode=idle;

  // Cuando el micro arranque hay que leer la configuración de la memoria FRAM
  cmd_rcv_flag=RCV_NONE;

  for(;;)
  {
	  switch (mode){
	   case idle:

		   if (cmd_rcv_flag == RCV_SERIAL){
			   mode=get_serialcommands;
		   }
		   else if (cmd_rcv_flag == RCV_ETH) {
			   mode=get_ethcommands;
		   }
		  /* else if (scdataflow == SerialBitstreamRcv_st ){
			   mode=get_serialbitstream;
		   }
		   else if (scdataflow == EthBitstreamRcv_st ){
			   mode=get_ethbitstream;
		   }*/
		   else{
			   mode=idle;
		   }
		   break;

	   case get_serialcommands:
		   // extract command from Serial buffer
		   cmd_rcv_flag=RCV_NONE;
		   cmd=cmdEmpty;
		   if ( getcmd((char *) BuffStrSerial, &cmd, &lengthstr) == EXIT_FAILURE){
			   mode=idle; // Abort to write to queue command
			   break;
		   }
		   // Write command to Queue
		   state = Write_CMDqueue(cmd);
		   //Ask for the Queue state
		   if (state==QUEUE_FULL){
			   sprintf (msg, "\n\rCommand received but not registered internally");
			   sendmsg(msg);
			   sprintf (msg, "\n\rQueue commands Full, wait a time before send it again\n\r");
			   sendmsg(msg);
		   }
		   if (state==QUEUE_ERROR){
			   sprintf (msg, "\n\rCommand received but not registered internally");
			   sendmsg(msg);
			   sprintf (msg, "\n\rQueue Command write error  internally");
			   sendmsg(msg);
		   }
		   //sprintf (msg, "\n\r>");
		   //sendmsg(msg);
		   mode=idle;
		   break;

	   case get_ethcommands:
		   // extract command from Serial buffer
		   if ( getcmd((char *) BuffStrSerial, &cmd, &lengthstr) == EXIT_FAILURE){
		  	   mode=idle; // Abort to write to queue command
		       break;
		    }
		    // write command to Queue
	   		state = Write_CMDqueue(cmd);
		    if (state==QUEUE_FULL){
		      sprintf (msg,"\n\rCommand received but not registered internally \n\r Queue commands Full, wait a time before send it again\n\r");
		      sendmsg(msg);
		      sprintf (msg,"\n\r Queue commands Full, wait a time before send it again\n\r");
		      sendmsg(msg);
		    }
		  	mode=idle;
		  	break;

	   case get_serialbitstream:
	   			   //write to SPI memory function
	   			   if (scdataflow == SerialBitstreamRcv_st){
	   				   // Status  Bitstream
	   				   sprintf (msg,"\n\r bytes Received\n\r");
	   				   sendmsg(msg);
	   			   	   mode=get_serialbitstream;
	   			   }
	   			   else{
	   				   mode=idle;
	   			   }
	   			   break;

	   case get_ethbitstream:

	   			   if (scdataflow == EthBitstreamRcv_st ){
	   			   	   mode=get_serialbitstream;
	   			   }
	   			   else{
	   				   mode=idle;
	   			   }
	   			   break;

	   default: mode=idle;
		   break;
	  }

	  osDelay(100);

  }
  /* USER CODE END StartGetCMDsTask */
}

/* USER CODE BEGIN Header_StartmainTask */
/**
* @brief Function implementing the mainTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartmainTask */
void StartmainTask(void *argument)
{
  /* USER CODE BEGIN StartmainTask */
  /* Infinite loop */
	int i;
	char msg[256];
	QUEUE_StatusTypeDef state;
	cmdqueue_TypeDef cmds;
	osStatus_t val1;
    scdataflow=Init_st;
    CMD_StatusTypeDef cmdstatus;

    /* Handle FPGA */
    FPGA_HandleTypeDef *handlehfpga0;
    extern FPGA_HandleTypeDef hfpga_spi;

    /*Current Monitoring Debug INIT variables*/
    uint8_t CMREGs[9]={0,0,0,0,0,0,0,0};
    uint8_t CMPGAREG=0;;
    /*Current Monitoring Debug END variables*/

    /*Clock INIT Init variables*/
    HAL_TIMCLKStatusTypeDef timclkstatus;
    /*Clock End variables*/


	extern DMA_HandleTypeDef hdma_spi3_tx;

	__HAL_DMA_ENABLE_IT(&hdma_spi3_tx, DMA_IT_HT);
	__HAL_DMA_ENABLE_IT(&hdma_spi3_tx, DMA_IT_TC);


    osDelay(200); //Delay
    HAL_TIM_Base_Start(&htim4);
    Disable_all_devices();
	/* uC to FPGA*/
	// Disable RESETn  (Active LOW)
    HAL_GPIO_WritePin (RESETn_GPIO_Port, RESETn_Pin,GPIO_PIN_SET);
    sprintf (msg,"[   OK   ]  Disable all devices\n\r"); // before printf
    sendmsg(msg);
    osDelay(50);


    /*Clock Init configuration*/
    timclkstatus = TIMCLK_Init();
    if (timclkstatus != HAL_TIMCLK_OK) {
  	  sprintf (msg,"[  ERROR  ] Clocks not initialized \n\r");
  	  sendmsg(msg);
  	osDelay(50);
  	  sprintf (msg," Error code : %d\n\r", timclkstatus);
  	  sendmsg(msg);
    } else {
  	  sprintf (msg,"[   OK   ] Started Clocks\n\r");
  	  sendmsg(msg);
    }
    osDelay(50);

    /*Clock End configuration*/

    /*Disable Pins Current Monitoring Init configuration*/
	HAL_GPIO_WritePin(CM_ADC_CSn_GPIO_Port, CM_ADC_CSn_Pin, HIGH_STATE);
	HAL_GPIO_WritePin(CM_PGA_CSn_GPIO_Port, CM_PGA_CSn_Pin, HIGH_STATE);
	HAL_GPIO_WritePin(CM_ADC_RESETn_GPIO_Port, CM_ADC_RESETn_Pin, HIGH_STATE);
	/*Disable Pins Current Monitoring End configuration*/

	/*Disable Pins Bias Voltaje Control Init configuration*/
	HAL_GPIO_WritePin(VBIAS_EN_GPIO_Port, VBIAS_EN_Pin, LOW_STATE);
    /*Disable Pins Bias Voltaje Control End configuration*/


	/*AFE Init configuration*/
	//Disable_all_AFE(); 	/* Disable only for Test Current Monitoring*/
    sprintf (msg,"  AFE init\n\r");
    sendmsg(msg);
    osDelay(50);

    AFEx_config();
	osDelay(20);
	AFE_RST_HIGH;
	osDelay(10);
	AFE_RST_LOW;
	osDelay(100);
	AFEx_Init();
	osDelay(100);

	sprintf (msg,"[   OK   ] AFE Block\n\r");
	sendmsg(msg);
	osDelay(50);

	HAL_GPIO_WritePin(VBIAS_EN_GPIO_Port, VBIAS_EN_Pin, HIGH_STATE);

	//FPGA reset high level. (review this code.. pendient)
	handlehfpga0 = &hfpga_spi;
	HAL_GPIO_WritePin(handlehfpga0->RSTn_Port, handlehfpga0->RSTn_Pin, GPIO_PIN_RESET);
	osDelay(1);
	HAL_GPIO_WritePin(handlehfpga0->RSTn_Port, handlehfpga0->RSTn_Pin, GPIO_PIN_SET);
	osDelay(20);

	/*AFE End configuration*/


	/******REMOVE AFTER THE VGAIN TEST *********/
	/* DISABLE AFE : POWER DOWN and RESET*/
	//Enable Reset (Active HIGH)
		 //HAL_GPIO_WritePin (AFE_RST_GPIO_Port, AFE_RST_Pin,GPIO_PIN_SET);
	//Enable Power Down (Active HIGH)
		 //HAL_GPIO_WritePin (AFE_PDN_GPIO_Port, AFE_PDN_Pin,GPIO_PIN_SET);
	// Disable AFE Chip Select(Active LOW)
		 //HAL_GPIO_WritePin (AFE0_AFE_SEn_GPIO_Port, AFE0_AFE_SEn_Pin,GPIO_PIN_SET);
		 //HAL_GPIO_WritePin (AFE1_AFE_SEn_GPIO_Port, AFE1_AFE_SEn_Pin,GPIO_PIN_SET);
		 //HAL_GPIO_WritePin (AFE2_AFE_SEN_GPIO_Port, AFE2_AFE_SEN_Pin,GPIO_PIN_SET);
		 //HAL_GPIO_WritePin (AFE3_AFE_SEn_GPIO_Port, AFE3_AFE_SEn_Pin,GPIO_PIN_SET);
		 //HAL_GPIO_WritePin (AFE4_AFE_SEn_GPIO_Port, AFE4_AFE_SEn_Pin,GPIO_PIN_SET);
	// Disable
		 //HAL_GPIO_WritePin(VBIAS_EN_GPIO_Port, VBIAS_EN_Pin, LOW_STATE);
	/******REMOVE AFTER THE VGAIN TEST *********/


	/*Current Monitoring Init configuration*/
	CM_Init();
	ADC24bits_readbackregisters(&CM_SPIhandler, CMREGs);
	sprintf (msg,"[   OK   ] Current Monitoring Init\n\r");
	sendmsg(msg);
	osDelay(50);
	/*Current Monitoring End configuration*/

	/*Flash Memory test*/
		//printf("w25qxx Init Begin...\r\n");

	HAL_GPIO_WritePin(SPIRamHld_GPIO_Port, SPIRamHld_Pin, GPIO_PIN_SET); // Disable HOLD Input
	HAL_GPIO_WritePin(SPIFRamCS_GPIO_Port, SPIFRamCS_Pin, GPIO_PIN_SET); // Disable Chip Select FRAM MEMORY

	W25qxx_Init();
/*
		//printf("Flash memory Init ..\r\n");
	W25qxx_EraseChip();
	W25qxx_EraseSector(0);
	W25qxx_WritePage(&dataflash, 0, 0,256);
	W25qxx_ReadPage(&dataFlashRead, 0, 0,256);

	for (i=0;i<256;i++){
		sprintf(msg,"%c", dataFlashRead[i]);
		sendmsg(msg);
		osDelay(10);
	}
*/
		//printf("\r\n");

    /* End Flash Memory Test */

  //sprintf (msg, "\n\r>");
  sendmsg(daphneprompt);
  osDelay(5);

  uint32_t xx=0;
  bitflow = Normal_st;

   for(;;)
   {
 		  switch (scdataflow){
 		  	   case Init_st:
 		  		   // Setup Initial devices
 		  		   // Load Default values from FRAM memory to Internal Memory
 		  		   // Ask for the power up sequence flag and reboot the Microconcontroller (Soft_reset)
 		  		   // Ask for the bitstream flag, send the message and recevied the bitstream and load to FPGA for the first time.

 		  		   scdataflow=Idle_st;
 		  		   break;

 		  	   case Idle_st:
 		  		   	   	   // Ask if exist an some cmds into the queue
 		  		           xx= osMessageQueueGetCount (cmdQueuesHandle);
 		  		   	       state = Read_CMDqueue(&cmds);
 		  		   	      if (state==QUEUE_OK  && ( cmds.dev != 0 || cmds.msg!=0)){
 		  		   	    	 scdataflow=Read_st;
 		  		   	       } else {
 		  		   	    	 scdataflow=Idle_st;
 		  		   	       }
 		  		   	   	    break;
 		  	   case Read_st:

 		  		   if (state==QUEUE_OK  && ( cmds.dev != 0 || cmds.msg!=0) ){
 		  		 		sprintf (msg, "\n\rExecuting command %d ...",cmds.cmd);
 		  		 		sendmsg(msg);
 		  		 		scdataflow=ExecuteCmd_st;

 		  		    }else{
 		  		    	if (state==QUEUE_ERROR){
 		  		    		sprintf (msg, "\n\rRead Queue error command");
 		  		    		sendmsg(msg);
 		  		    	}
 		  		    	scdataflow=Idle_st;
 		  		    }
 		  		    break;

 		  	   case ExecuteCmd_st:


 		  		   cmdstatus= executecmd(cmds,msg); // Execute commands , msg contains the message status.
 		  		   sendmsg(msg);
 		  		   delay_us(100);
 		  		   //sprintf (msg, "\n\r>");
 		  		   sendmsg(daphneprompt);
 		  		   delay_us(100);

 		  		   if (bitflow == BitstreamStart_st){ // Loadbitstream
 		  			 scdataflow=BitstreamRcv_st;
 		  		   }else if (bitflow == BitstreamToPC_st){
 		  			 scdataflow=ReadFlashBitstreamRcv_st;
 		  		   }
 		  		else if (bitflow == BitstreamFromFlashToFPGA_st){
 		  				  			 scdataflow=LoadFlashToFPGA_st;}
 		  		   else {
 		  		      scdataflow=Idle_st;
 		  		   }
 		  		   break;

 		  	   case ExecuteCmdwaitcmplt_st:
 		  		   scdataflow=Idle_st;
 		  		   break;
 		  	   case PowerUpSeq_st:
 		  		   scdataflow=Idle_st;
 		  		   break;

 		  	   case CmdRcv_st:
 		  		   scdataflow=Idle_st;
 		  		   break;
	           case BitstreamRcv_st:

	        	   if (bitflow==BitstreamStart_st ){
	        		   scdataflow=BitstreamRcv_st;
	        	   } else{
	        		   bitflow=Normal_st;
	        		   scdataflow=Idle_st;
	        		   sendmsg(daphneprompt);
	        		   delay_us(100);
	        	   }
		  		   break;
	           case ReadFlashBitstreamRcv_st:

	        	   if (bitflow == BitstreamToPC_st){
	        		   scdataflow=ReadFlashBitstreamRcv_st;
	        	   }else{
	        		   scdataflow=Idle_st;
	        		   sendmsg(daphneprompt);
	        		   delay_us(100);
	        	   }
	        	   break;

	           case LoadFlashToFPGA_st:

	        	   if (bitflow == BitstreamFromFlashToFPGA_st){
	        		   scdataflow=LoadFlashToFPGA_st;
	        	   }else{
	        		   scdataflow=Idle_st;
	        		   sendmsg(daphneprompt);
	        		   delay_us(100);
	        	   }
	        	   break;

	  	   default: scdataflow=Idle_st; break;

	  }

	  osDelay(200);
  }
  /* USER CODE END StartmainTask */
}

/* USER CODE BEGIN Header_StartTimeoutTask */
/**
* @brief Function implementing the TimeoutTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartTimeoutTask */
void StartTimeoutTask(void *argument)
{
  /* USER CODE BEGIN StartTimeoutTask */
  /* Infinite loop */
	Timeoutcounter=1000;
	for(;;)
	{
		  if (Bitstreamdataflow==GetBitstream_datawritetomem_st){

			  if (Timeoutcounter>0 ){

				  Timeoutcounter--;
			  }
			  else{
				  Timeoutflag = 1;
			  }
		  }
		  osDelay(20);
	}
  /* USER CODE END StartTimeoutTask */
}

/* USER CODE BEGIN Header_StartBitstreamTask */
/**
* @brief Function implementing the BitstreamTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartBitstreamTask */
void StartBitstreamTask(void *argument)
{
  /* USER CODE BEGIN StartBitstreamTask */
  /* Infinite loop */

	 int i;
	 uint32_t timeoutbitstream=0;
	 char msg1[128];

	 /*** Init Send bitstream to PC **** */
	  char SizeBitstream_4Bytes[4]={0,0,0,0};
	  uint32_t SizeBitstream_int32=0;
	  uint32_t NumMaxSector =0;
	  uint32_t LastBytesSector = 0;
	 /**** End Send bitstream to PC **** */

/*	extern DMA_HandleTypeDef hdma_spi3_tx;
		char msg1[128];
	    int i;
	    uint32_t timeoutbitstream=0;
		//bitstreamdataflow_t Bitstreamdataflow;

		__HAL_DMA_ENABLE_IT(&hdma_spi3_tx, DMA_IT_HT);
		__HAL_DMA_ENABLE_IT(&hdma_spi3_tx, DMA_IT_TC);
*/
		//HAL_SPI_Transmit_DMA(&hspi1, (uint8_t*) spi_tx_buf, 128 );
		//sprintf (msg1, "\n\r SPI datos enviado");
		//sendmsg(msg1);
		//printf("w25qxx Init Begin...\r\n");

		//HAL_GPIO_WritePin(FLASH_HOLD_GPIO_Port, FLASH_HOLD_Pin, GPIO_PIN_SET);
		//W25qxx_Init();
		//printf("w25qxx Done Begin...\r\n");
		//W25qxx_EraseChip();
		//W25qxx_EraseSector(0);
		//pbuffer=&dataflash[0];
		//W25qxx_WritePage(&dataflash, 0, 0,256);
		//W25qxx_ReadPage(&dataFlashRead, 0, 0,256);

		//for (i=0;i<256;i++){
		//	printf("%c", dataFlashRead[i]);
		//}
		//osDelay(100);

		printf("\r\n");
		Bitstreamdataflow= BitInit_st;

	  for(;;)
	  {

		  switch (Bitstreamdataflow){
			  	   case BitInit_st: Bitstreamdataflow = BitIdle_st;
									spibuffstate = none;
									spibuffstate_next=none;
									spiMemNumPage =0; // 65536 pages 256 bytes
									break;
			  	   case BitIdle_st: if (bitflow==BitstreamStart_st){ //
			  		   	   	   	   	  Bitstreamdataflow=GetBitstream_st;
			  		   	   	   	   	  timeoutbitstream=0;

			  		   	   	   	   	  osDelay(20);
			  		   	   	   	   	  sprintf (msg1, "\n\r Erasing Flash Memory");
			  		   	   	 		  sendmsg(msg1);



			  		   	   	 	      fpgabitstreambuffer.CurrIDX=0; // init buffer 0
			  		   	   	 		  fpgabitstreambuffer.Counter=0; // init buffer 0
			  		   	   	   	   	  W25qxx_EraseChip();


			  		   	   	   	   	  sprintf (msg1, "\n\r Waiting Bitstream");
			  		   	   	  		  sendmsg(msg1);

			  		   	   	  		  counterOVF=0; // DEBUG
			  		   	   	  		  counterIDLE=0;

			  		   	   	  		  statusRX_OVF=0; //RX status
			  		   	   	  		  statusRX_Timeout=0; // RXStatus

			  	   	   	   	   	    } else if (bitflow== BitstreamToPC_st ){
			  	   	   	   	   	    	Bitstreamdataflow=Bitstream_SendDataflashToPC_st;
			  	   	   	   	   	    }
			  	   	   	   	else if (bitflow == BitstreamFromFlashToFPGA_st){
			  	   	   	   			  	   	   	   	   	    	Bitstreamdataflow = LoadBitstream_st;
			  	   	   	   			  	   	   	   	   	    }
			  	   	   	   	   	    else {
			  	   	   	   	   		  Bitstreamdataflow=BitIdle_st;
			  	   	   	   	   	    }
								    break;
		           case GetBitstream_st:  if (spibuffstate == none){ // Nada recibiendo..
		        	   	   	   	   	   	   	   if (++timeoutbitstream > 10000) // 100 segundos
		        	  	           	   	   	   {
		        	  	        	   	   	   	  bitflow=Normal_st;
		        	  	        	   	   	   	  Bitstreamdataflow=BitIdle_st;

		        	  	        	   	   	   	  sprintf (msg1, "\n\rTimeout Bitstream file");
		        	  	        	   	   		  sendmsg(msg1);

		        	  	           	   	   	    } else
		        	  	           	   	   	   	{
		        	  	           	   	           if (timeoutbitstream % 20==0){
		        	  	           	   	        	   sprintf (msg1, ".");
		        	  	           	   	        	   sendmsg(msg1);
		        	  	           	   	           }
		        	  	           	   	           	  Bitstreamdataflow=GetBitstream_st;
		        	  	           	   	   	   	}

		           	   	   	   	   	   	  }else{
		           	   	   	   	   	   		 sprintf (msg1, "\n\r Receiving bitstream file");
		           	   	   	   	  		     sendmsg(msg1);
		           	   	   	   	  		     osDelay(1);
		           	   	   	   	   	   		 Bitstreamdataflow= GetBitstream_datarcv_st;
		           	   	   	   	   	   		 timeoutbitstream=0; // Reset timeout
		           	   	   	   	   	   		 spibuffstate = waitdata;
		           	   	   	   	   	   	  }


		           	   	   	   	   	   	  break;
			  	   case GetBitstream_datarcv_st:
			  		   	   	   	   	       // Preguntar si hay datos en el buffer suficiente para escriir una pagina
			  		   	   	   	   	   	   // Escribir la pagina
		  		   	   	   	   	   		   	  if (spibuffstate != waitdata ){
		  		   	   	   	   	   		   		 Timeoutcounter=300; // Timeout;
			  		   	   	   	   		  		 Bitstreamdataflow=GetBitstream_datawritetomem_st;
			  		   	   	   	   		  		 spibuffstate_next=zone1; // Control de flujo de escritura
			  		   	   	   	   		  		 sideA=0;
			  		   	   	   	   		  		 sideB=0;
			  		   	   	   	  		  	  }else
			  		   	   	   	   		  	  {
			  		   	   	   	   		  		 Bitstreamdataflow=GetBitstream_datarcv_st;
			  		   	   	   	   		  	  }

			  		   	   	   	   	   	   break;
		           case GetBitstream_datawritetomem_st:

										       if (statusRX_OVF == 1 && fpgabitstreambuffer.CurrIDX >= SPI_BUF_SIZE/2 && spibuffstate_next==zone1 ){
										    	     statusRX_OVF=0;
													 spibuffstate = zone1;
													 spibuffstate_next=zone2;
													 Timeoutcounter=300; // Reset Timeout Counter;
													 sideA++;
												}else if (statusRX_OVF == 1 && fpgabitstreambuffer.CurrIDX < SPI_BUF_SIZE/2 && fpgabitstreambuffer.buffovf==1 && spibuffstate_next==zone2){
													statusRX_OVF=0;
													spibuffstate = zone2;
													spibuffstate_next=zone1;
													fpgabitstreambuffer.buffovf=0; // Clear OVF
													 Timeoutcounter=300; // Reset Timeout Counter;
													 sideB++;
												}else if (Timeoutflag== 1 &&   fpgabitstreambuffer.CurrIDX < SPI_BUF_SIZE/2){
													spibuffstate = endzone1;
													Timeoutcounter=300; // Reset Timeout Counter;
													Timeoutflag=0;
													sideA++;
												}else if (Timeoutflag== 1 &&   fpgabitstreambuffer.CurrIDX >= SPI_BUF_SIZE/2){
													spibuffstate = endzone2;
													Timeoutcounter=300; // Reset Timeout Counter;
													Timeoutflag=0;
													sideB++;
												}else{
													spibuffstate = fillbuffer;
												}



		        	   	   	   	   	   	   if (spibuffstate == zone1 ){
											 W25qxx_WriteSector(&fpgabitstreambuffer.data[0], spiMemNumPage, 0, 4096);
											 ++spiMemNumPage;
											 spibuffstate = fillbuffer;
										   }
		        	   	   	   	   	   	   else if (spibuffstate == zone2 ){
		        	   	   	   	   	   		   W25qxx_WriteSector(&fpgabitstreambuffer.data[BUFFER_SIZE_MEMORY/2], spiMemNumPage, 0, BUFFER_SIZE_MEMORY/2);
		        	   	   	   	   	   		   ++spiMemNumPage;
		        	   	   	   	   	   		   spibuffstate = fillbuffer;
		        	   	   	   	  	       }
		        	   	   	   	   	   	   else if (spibuffstate == endzone1){
		        	   	   	   	   	   		   spibuffstate = none;
		        	   	   	   	   	   		   bitflow=BitstreamEnd_st;
		        	   	   	   	   		       Bitstreamdataflow=BitInit_st;

		        	   	   	   	   	   		   W25qxx_WriteSector(&fpgabitstreambuffer.data, spiMemNumPage, 0, fpgabitstreambuffer.CurrIDX+1);
		        	   	   	   	   	   		   ++spiMemNumPage;
		        	   	   	   	   	   		   W25qxx_WriteSector(&fpgabitstreambuffer.Counter,4095,0,4);
		        	   	   	   	   		       sprintf (msg1, "\n\r Bitstream recevied OK1");
		        	   	   	   	   		       sendmsg(msg1);
		        	   	   	   	   		       osDelay(20);
		        	   	   	   	   		       sprintf (msg1, "\n\r Bytes Received : %lu", fpgabitstreambuffer.Counter );
		        	   	   	   	   		       sendmsg(msg1);
		        	   	   	   	   		       sprintf (msg1, "\n\r Flash Memory Sector writen : %lu",spiMemNumPage);
		        	   	   	   	   		       sendmsg(msg1);
		        	   	   	   	   		        osDelay(20);


		        	   	   	   	   	   	   }
		        	   	   	   	   	   	   else if (spibuffstate == endzone2){
		        	   	   	   	   	   		   spibuffstate = none;
		        	   	   	   	   		       bitflow=BitstreamEnd_st;
		        	   	   	   	   		       Bitstreamdataflow=BitInit_st;

		        	   	   	   	   	   		   W25qxx_WriteSector(&fpgabitstreambuffer.data[BUFFER_SIZE_MEMORY/2], spiMemNumPage, 0, fpgabitstreambuffer.CurrIDX-(BUFFER_SIZE_MEMORY/2)+1);
		        	   	   	   	   	   		   ++spiMemNumPage;
		        	   	   	   	   	   		   W25qxx_WriteSector(&fpgabitstreambuffer.Counter,4095,0,4);
		        	   	   	   	   		       sprintf (msg1, "\n\r Bitstream recevied OK2");
		        	   	   	   	   			   sendmsg(msg1);
		        	   	   	   	   			   osDelay(20);
		        	   	   	   	   			   sprintf (msg1, "\n\r Bytes Received : %lu", fpgabitstreambuffer.Counter );
		        	   	   	   	   		       sendmsg(msg1);
		        	   	   	   	   		       osDelay(20);
		        	   	   	   	   		       sprintf (msg1, "\n\r Flash Memory Sector writed : %lu",spiMemNumPage);
		        	   	   	   	   		       sendmsg(msg1);
		        	   	   	   	   		       osDelay(20);

		        	   	   	   	 	       }
		        	   	   	   	   	   	   else{
		        	   	   	   	   	   		   Bitstreamdataflow=GetBitstream_datawritetomem_st;
		        	   	   	   	   	   	   }

		        	   	   	   	   	   	   if ( spiMemNumPage >= FLASHMEMORY_MAXSECTOR){
		        	   	   	   	   	   		   printf("Memory is Full");
		        	   	   	   	   	   		   bitflow=Normal_st;
		        	   	   	   	   	   		   spibuffstate = none;
		        	   	   	   	   	   		   Bitstreamdataflow=BitInit_st;
		        	   	   	   	   	   	   }
		        	   	   	   	   	   	   //HAL_SPI_Transmit_DMA(&hspi1, (uint8_t*) spi_tx_buf, SPI_BUF_SIZE );
		        	   	   	   	           //Bitstreamdataflow=GetBitstream_datawritetomem_st; // if llego toda la trama del bitstream
		        	   	   	   	   	   	   break;

		           case Bitstream_SendDataflashToPC_st:

										   W25qxx_ReadSector(&SizeBitstream_4Bytes,4095,0,4);  // ·Sector 4095
										   SizeBitstream_int32 = *((uint32_t *) SizeBitstream_4Bytes);
										   NumMaxSector = (SizeBitstream_int32/4096)+1;
										   //NumMaxSector = 100;
										   LastBytesSector = (SizeBitstream_int32 % 4096);
										   //LastBytesSector = 100;

										   for( pageidx=0;pageidx<NumMaxSector;pageidx++ ){

											   if ( pageidx == NumMaxSector -1 ){
												   W25qxx_ReadSector(&fpgabitstreambuffer.data, pageidx, 0, LastBytesSector);
												   for( sectoridx=0;sectoridx<LastBytesSector;sectoridx++ ){
													   sprintf (msg1, "%c",fpgabitstreambuffer.data[sectoridx] );
													   sendmsg(msg1);
													   delay_us(15);
													  // osDelay(1);
													}

											   } else{
												   W25qxx_ReadSector(&fpgabitstreambuffer.data, pageidx, 0, 4096);
												   for( sectoridx=0;sectoridx<4096;sectoridx++ ){
													   sprintf (msg1, "%c",fpgabitstreambuffer.data[sectoridx] );
													   sendmsg(msg1);
													   delay_us(15);
													  // osDelay(1);
													}
											   }
										   }
										   Bitstreamdataflow=BitInit_st;
										   bitflow=Normal_st;
										   break;

			  	   case LoadBitstream_st:
										   W25qxx_ReadSector(&SizeBitstream_4Bytes,4095,0,4);  // ·Sector 4095
										   if (SizeBitstream_4Bytes > 0){

											   SendBitstream(SizeBitstream_4Bytes);
										   }
										   else {
											   sendmsg("Bitstream not found in Flash Memory");
											   delay_us(100);
										   }

										   Bitstreamdataflow=BitInit_st;
										   bitflow=Normal_st;
										   break;
		           case LoadBitstream_ReadSPIToBuffer_st:  break;
			  	   case LoadBitstream_PacketToTx_st: break;
		           case LoadBitstream_SendDataToSPI_st:  break;

			  	   default: Bitstreamdataflow=Idle_st; break;
		  }
	    osDelay(10);
  }
  /* USER CODE END StartBitstreamTask */
}

/* Private application code --------------------------------------------------*/
/* USER CODE BEGIN Application */

void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart){
	//HAL_GPIO_TogglePin (LD3_GPIO_Port, LD3_Pin);
	DMATXcompleteFlag=1;
	return;
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{	 	uint32_t lengthstr=0;
		uint32_t tmp_idx=0;
        uint16_t offset;
        RXStatusTypeDef statusRX2;

        uint32_t lengthstr2=0;
        uint32_t tmp_idx2=0;
        uint32_t offset2;



       RXStatusTypeDef statusRX;
       extern DMA_Event_t dma_uart_rx;

        HAL_GPIO_TogglePin (LED0_GPIO_Port, LED0_Pin);
        // revisar porque en el sexto envío de comandos , hay un grave error de direccoines que hace que los leds se apagen.
    	// Era un problema de direcciones buffStrSerial+offset pero ya esta arreglado
    	if ( bitflow==BitstreamStart_st ){

    		offset=dma_uart_rx.prevlength;
    		dma_uart_rx.dmaovf=0;
    		statusRX = process_data_bitstream(&huart1, (&fpgabitstreambuffer), &lengthstr2);

    		/*tmp_idx2 = writeidx2 + lengthstr2;
    		if ( tmp_idx2 >= SPI_BUF_SIZE) {
    				tmp_idx2 = ( lengthstr2 - (SPI_BUF_SIZE - writeidx2) ) - 1 ;
    		}
    		writeidx2 = tmp_idx2;*/
    		if (statusRX == STATUS_DMAOVF_IT){
    			counterOVF=counterOVF+1;
    			//Timeoutcounter=100;
    			statusRX_OVF=1;
    			spibuffstate=fillbuffer; // received 256 bytes
    		}

    		if (statusRX == STATUS_IDLE_IT){
    			counterIDLE=counterIDLE+1;
    		}
    //Arreglar los disparos de las zonas
    	  /*  if (statusRX == STATUS_DMAOVF_IT &&fpgabitstreambuffer.CurrIDX >= SPI_BUF_SIZE/2){
    			 spibuffstate = zone1;
    		}else if (statusRX == STATUS_DMAOVF_IT && fpgabitstreambuffer.CurrIDX < SPI_BUF_SIZE/2 && fpgabitstreambuffer.buffovf==1 ){
    			spibuffstate = zone2;
    			fpgabitstreambuffer.buffovf=0; // Clear OVF
    		}else if (Timeoutflag== 1 &&   fpgabitstreambuffer.CurrIDX < SPI_BUF_SIZE/2){
    			spibuffstate = endzone1;
    		}else if (Timeoutflag== 1 &&   fpgabitstreambuffer.CurrIDX >= SPI_BUF_SIZE/2){
    			spibuffstate = endzone2;
    		}else{
    			//spibuffstate = fillbuffer;
    			return;
    		}
    */

    		return;

    	} else {

    		statusRX2=process_data(&huart1, (&BuffStrSerial[writeidx]), &lengthstr);
    		if (statusRX2== STATUS_CMDRCV_OK ){
    				 cmd_rcv_flag= RCV_SERIAL;
    				 writeidx = 0;
    				 return;
    		} else if ( statusRX2 == STATUS_DMAOVF_IT ){
    				writeidx = 0;
    				tmp_idx=0;
    		} else{
    				tmp_idx = writeidx + lengthstr;
    				if ( tmp_idx >= DMA_BUF_SIZE/2) {
    					tmp_idx = 0;
    				}
    				writeidx = tmp_idx;
    		}


    	}
    	return;
}

void DMARX_FullTransferComplete(DMA_HandleTypeDef *hdma){

	// HAL_GPIO_TogglePin (LD3_GPIO_Port, LD3_Pin);
	return;
}

QUEUE_StatusTypeDef Read_CMDqueue(cmdqueue_TypeDef *valuercv){

	if ( xQueueReceive( cmdQueuesHandle , valuercv , 100 ) != pdTRUE){
		return QUEUE_EMPTY;
	}
	else {
		return QUEUE_OK;
    }

}

QUEUE_StatusTypeDef Write_CMDqueue(cmdqueue_TypeDef valuesend){

	if ( xQueueSend( cmdQueuesHandle , &valuesend, 100) != pdTRUE){
		return QUEUE_FULL;
	}
	else {
		return QUEUE_OK;
    }

}

void Disable_all_AFE(void){
	/* AFE */
	//Enable Reset (Active HIGH)
		 HAL_GPIO_WritePin (AFE_RST_GPIO_Port, AFE_RST_Pin,GPIO_PIN_SET);
	//Enable Power Down (Active HIGH)
		 HAL_GPIO_WritePin (AFE_PDN_GPIO_Port, AFE_PDN_Pin,GPIO_PIN_SET);
	// Disable AFE Chip Select(Active LOW)
		 HAL_GPIO_WritePin (AFE0_AFE_SEn_GPIO_Port, AFE0_AFE_SEn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE1_AFE_SEn_GPIO_Port, AFE1_AFE_SEn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE2_AFE_SEN_GPIO_Port, AFE2_AFE_SEN_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE3_AFE_SEn_GPIO_Port, AFE3_AFE_SEn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE4_AFE_SEn_GPIO_Port, AFE4_AFE_SEn_Pin,GPIO_PIN_SET);
	//Disable LDACn and SYNCn (Active LOW)
		 //***** OFFSET
		 HAL_GPIO_WritePin (AFE0_OFF_LDACn_GPIO_Port, AFE0_OFF_LDACn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE1_OFF_LDACn_GPIO_Port, AFE1_OFF_LDACn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE2_OFF_LDACn_GPIO_Port, AFE2_OFF_LDACn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE3_OFF_LDACn_GPIO_Port, AFE3_OFF_LDACn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE4_OFF_LDACn_GPIO_Port, AFE4_OFF_LDACn_Pin,GPIO_PIN_SET);

		 HAL_GPIO_WritePin (AFE0_OFF_SYNCn_GPIO_Port, AFE0_OFF_SYNCn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE1_OFF_SYNCn_GPIO_Port, AFE1_OFF_SYNCn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE2_OFF_SYNCn_GPIO_Port, AFE2_OFF_SYNCn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE3_OFF_SYNCn_GPIO_Port, AFE3_OFF_SYNCn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE4_OFF_SYNCn_GPIO_Port, AFE4_OFF_SYNCn_Pin,GPIO_PIN_SET);

	     //***** TRIM
		 HAL_GPIO_WritePin (AFE0_TRM_LDACn_GPIO_Port, AFE0_TRM_SYNCn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE1_TRM_LDACn_GPIO_Port, AFE1_TRM_LDACn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE2_TRM_LDACn_GPIO_Port, AFE2_TRM_LDACn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE3_TRM_LDACn_GPIO_Port, AFE3_TRM_LDACn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE4_TRM_LDACn_GPIO_Port, AFE4_TRM_LDACn_Pin,GPIO_PIN_SET);

		 HAL_GPIO_WritePin (AFE0_TRM_SYNCn_GPIO_Port, AFE0_TRM_SYNCn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE1_TRM_SYNCn_GPIO_Port, AFE1_TRM_SYNCn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE2_TRM_SYNCn_GPIO_Port, AFE2_TRM_SYNCn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE3_TRM_SYNCn_GPIO_Port, AFE3_TRM_SYNCn_Pin,GPIO_PIN_SET);
		 HAL_GPIO_WritePin (AFE4_TRM_SYNCn_GPIO_Port, AFE4_TRM_SYNCn_Pin,GPIO_PIN_SET);

}
void Disable_all_devices(void){

/* AFE */
//Enable Reset (Active HIGH)
	 HAL_GPIO_WritePin (AFE_RST_GPIO_Port, AFE_RST_Pin,GPIO_PIN_SET);
//Enable Power Down (Active HIGH)
	 HAL_GPIO_WritePin (AFE_PDN_GPIO_Port, AFE_PDN_Pin,GPIO_PIN_SET);
// Disable AFE Chip Select(Active LOW)
	 HAL_GPIO_WritePin (AFE0_AFE_SEn_GPIO_Port, AFE0_AFE_SEn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE1_AFE_SEn_GPIO_Port, AFE1_AFE_SEn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE2_AFE_SEN_GPIO_Port, AFE2_AFE_SEN_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE3_AFE_SEn_GPIO_Port, AFE3_AFE_SEn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE4_AFE_SEn_GPIO_Port, AFE4_AFE_SEn_Pin,GPIO_PIN_SET);
//Disable LDACn and SYNCn (Active LOW)
	 //***** OFFSET
	 HAL_GPIO_WritePin (AFE0_OFF_LDACn_GPIO_Port, AFE0_OFF_LDACn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE1_OFF_LDACn_GPIO_Port, AFE1_OFF_LDACn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE2_OFF_LDACn_GPIO_Port, AFE2_OFF_LDACn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE3_OFF_LDACn_GPIO_Port, AFE3_OFF_LDACn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE4_OFF_LDACn_GPIO_Port, AFE4_OFF_LDACn_Pin,GPIO_PIN_SET);

	 HAL_GPIO_WritePin (AFE0_OFF_SYNCn_GPIO_Port, AFE0_OFF_SYNCn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE1_OFF_SYNCn_GPIO_Port, AFE1_OFF_SYNCn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE2_OFF_SYNCn_GPIO_Port, AFE2_OFF_SYNCn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE3_OFF_SYNCn_GPIO_Port, AFE3_OFF_SYNCn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE4_OFF_SYNCn_GPIO_Port, AFE4_OFF_SYNCn_Pin,GPIO_PIN_SET);

     //***** TRIM
	 HAL_GPIO_WritePin (AFE0_TRM_LDACn_GPIO_Port, AFE0_TRM_SYNCn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE1_TRM_LDACn_GPIO_Port, AFE1_TRM_LDACn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE2_TRM_LDACn_GPIO_Port, AFE2_TRM_LDACn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE3_TRM_LDACn_GPIO_Port, AFE3_TRM_LDACn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE4_TRM_LDACn_GPIO_Port, AFE4_TRM_LDACn_Pin,GPIO_PIN_SET);

	 HAL_GPIO_WritePin (AFE0_TRM_SYNCn_GPIO_Port, AFE0_TRM_SYNCn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE1_TRM_SYNCn_GPIO_Port, AFE1_TRM_SYNCn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE2_TRM_SYNCn_GPIO_Port, AFE2_TRM_SYNCn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE3_TRM_SYNCn_GPIO_Port, AFE3_TRM_SYNCn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (AFE4_TRM_SYNCn_GPIO_Port, AFE4_TRM_SYNCn_Pin,GPIO_PIN_SET);

/* uC to FPGA*/
	 // Disable RESETn  (Active LOW)
	 HAL_GPIO_WritePin (RESETn_GPIO_Port, RESETn_Pin,GPIO_PIN_SET);
	 // Disable CSn (Active Low)
	 HAL_GPIO_WritePin (CSn_GPIO_Port, CSn_Pin,GPIO_PIN_SET);
/* Slave Serial */
	 // Disable RESETn  (Active LOW)
	 HAL_GPIO_WritePin (SS_PROG_B_GPIO_Port, SS_PROG_B_Pin,GPIO_PIN_SET);

/*CM*/
	 //Enable RESETn (Active LOW)
	HAL_GPIO_WritePin (CM_ADC_RESETn_GPIO_Port, CM_ADC_RESETn_Pin,GPIO_PIN_RESET);
	 //Disable ADC_START (Active HIGH)
	HAL_GPIO_WritePin (CM_ADC_START_GPIO_Port, CM_ADC_START_Pin,GPIO_PIN_RESET);
	 //Disable ADC CS (Active LOW)
	HAL_GPIO_WritePin (CM_ADC_CSn_GPIO_Port, CM_ADC_CSn_Pin,GPIO_PIN_SET);
	 // Disable PGA CS (Active LOW)
	HAL_GPIO_WritePin (CM_PGA_CSn_GPIO_Port, CM_PGA_CSn_Pin,GPIO_PIN_SET);

/*Memory FLASH and FRAM*/
	// disable FLASH CS (Active LOW)
	HAL_GPIO_WritePin (SPIFlshCS_GPIO_Port, SPIFlshCS_Pin,GPIO_PIN_SET);
	// disable FRAM CS (Active LOW)
	HAL_GPIO_WritePin (SPIFRamCS_GPIO_Port, SPIFRamCS_Pin,GPIO_PIN_SET);
	// disable FLASH CS (Active LOW)
	HAL_GPIO_WritePin (SPIRamHld_GPIO_Port, SPIRamHld_Pin, GPIO_PIN_SET);

/*DAC*/
	 HAL_GPIO_WritePin (DAC_LDACn_GPIO_Port, DAC_LDACn_Pin,GPIO_PIN_SET);
	 HAL_GPIO_WritePin (DAC_SYNCn_GPIO_Port, DAC_SYNCn_Pin,GPIO_PIN_SET);
}

void delay_us (uint16_t us)
{
	__HAL_TIM_SET_COUNTER(&htim4,0);  // set the counter value a 0
	while (__HAL_TIM_GET_COUNTER(&htim4) < us);  // wait for the counter to reach the us input in the parameter
}




/* USER CODE END Application */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
