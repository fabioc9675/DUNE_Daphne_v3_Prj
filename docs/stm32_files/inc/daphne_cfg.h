/**
  ******************************************************************************
  * @file    daphne_cfg.h
  * @author  Daphne Microcontroller Team
  *          Juan Vega Martinez
  * @brief   Header file of daphne configuration module.
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef DAPHNE_CFG_H
#define DAPHNE_CFG_H

#ifdef __cplusplus
extern "C" {
#endif

/*Interfaces Daphne connections */
#include "main.h"

/* Handler Power Monitoring*/
#define PWR_I2Chandler hi2c1

 /* Handler Voltage Monitoring*/
#define VM_ADChandler hadc3

/*Handler Current Monitoring*/
#define CM_SPIhandler hspi4

/*Handler CDR CLOCKs*/
#define CDR_CLOCKS_I2Chandler hi2c2

/*Handler USB Serial Handler*/
#define USBSERIAL_UARThandler huart1


#define SDA1_PinNumber  	SDA1_Pin
#define SDA1_GPIO_PortName	SDA1_GPIO_Port
#define SCL1_PinNumber		SCL1_Pin
#define	SCL1_GPIO_PortName	SCL1_GPIO_Port

#define CM_ADC_CSn_PinNumber		CM_ADC_CSn_Pin
#define CM_ADC_DRDYn_PinNumber		CM_ADC_DRDY_Pin
#define CM_ADC_RESETn_PinNumber		CM_ADC_RESETn_Pin
#define CM_ADC_START_PinNumber		CM_ADC_START_Pin
#define CM_PGA_CSn_PinNumber		CM_PGA_CSn_Pin

#define CM_ADC_CSn_PortName			CM_ADC_CSn_GPIO_Port
#define CM_ADC_DRDYn_PortName		CM_ADC_DRDY_GPIO_Port
#define CM_ADC_RESETn_PortName		CM_ADC_RESETn_GPIO_Port
#define CM_ADC_START_PortName		CM_ADC_START_GPIO_Port
#define CM_PGA_CSn_PortName			CM_ADC_CSn_GPIO_Port

// High Level Selector TRIM MUX current
#define CM_A0_PinNumber		    	CM_A0_Pin
#define CM_A1_PinNumber				CM_A1_Pin

#define CM_A0_PortName				CM_A0_GPIO_Port
#define CM_A1_PortName 				CM_A1_GPIO_Port

// Low Level Selector TRIM MUX current
#define AFE_MUX_A0_PinNumber		MUXA0_Pin
#define AFE_MUX_A1_PinNumber		MUXA1_Pin
#define AFE_MUX_EN0_PinNumber 		MUXEN0_Pin
#define AFE_MUX_EN1_PinNumber		MUXEN1_Pin
#define AFE_MUX_EN2_PinNumber		MUXEN2_Pin
#define AFE_MUX_EN3_PinNumber		MUXEN3_Pin
#define AFE_MUX_EN4_PinNumber		MUXEN4_Pin
#define AFE_MUX_EN5_PinNumber		MUXEN5_Pin
#define AFE_MUX_EN6_PinNumber		MUXEN6_Pin
#define AFE_MUX_EN7_PinNumber		MUXEN7_Pin
#define AFE_MUX_EN8_PinNumber		MUXEN8_Pin
#define AFE_MUX_EN9_PinNumber		MUXEN9_Pin

#define AFE_MUX_A0_PortName			MUXA0_GPIO_Port
#define AFE_MUX_A1_PortName			MUXA1_GPIO_Port
#define AFE_MUX_EN0_PortName		MUXEN0_GPIO_Port
#define AFE_MUX_EN1_PortName		MUXEN1_GPIO_Port
#define AFE_MUX_EN2_PortName		MUXEN2_GPIO_Port
#define AFE_MUX_EN3_PortName		MUXEN3_GPIO_Port
#define AFE_MUX_EN4_PortName		MUXEN4_GPIO_Port
#define AFE_MUX_EN5_PortName		MUXEN5_GPIO_Port
#define AFE_MUX_EN6_PortName		MUXEN6_GPIO_Port
#define AFE_MUX_EN7_PortName		MUXEN7_GPIO_Port
#define AFE_MUX_EN8_PortName		MUXEN8_GPIO_Port
#define AFE_MUX_EN9_PortName		MUXEN9_GPIO_Port

/*AFE*/
/*Fabian code*/

#define DAC_SDO_Pin 				GPIO_PIN_10
#define DAC_SDO_GPIO_Port 			GPIOF
#define DAC_LDACn_Pin 				GPIO_PIN_2
#define DAC_LDACn_GPIO_Port 		GPIOB
#define DAC_SYNCn_Pin 				GPIO_PIN_12
#define DAC_SYNCn_GPIO_Port 		GPIOF
#define DAC_DIN_Pin					GPIO_PIN_13
#define DAC_DIN_GPIO_Port 			GPIOF
#define DAC_SCLK_Pin 				GPIO_PIN_14
#define DAC_SCLK_GPIO_Port 			GPIOF

#define VBIAS_EN_Pin 				GPIO_PIN_0
#define VBIAS_EN_GPIO_Port 			GPIOG


#define AFE_RST_P_Pin 			AFE_RST_Pin
#define AFE_RST_P_GPIO_Port 	AFE_RST_GPIO_Port
#define AFE_PDN_P_Pin 			AFE_PDN_Pin
#define AFE_PDN_P_GPIO_Port 	AFE_PDN_GPIO_Port

/********** AFE0 block init definition *************/
//AFE
#define AFE0_SEN_Pin 			AFE0_AFE_SEn_Pin
#define AFE0_SEN_GPIO_Port 		AFE0_AFE_SEn_GPIO_Port
//TRIM
#define LDAC0_TRM_Pin 			AFE0_TRM_LDACn_Pin
#define LDAC0_TRM_GPIO_Port 	AFE0_TRM_LDACn_GPIO_Port
#define SYNC0_TRM_Pin 			AFE0_TRM_SYNCn_Pin
#define SYNC0_TRM_GPIO_Port 	AFE0_TRM_SYNCn_GPIO_Port
//OFFSET
#define LDAC0_OFF_Pin 			AFE0_OFF_LDACn_Pin
#define LDAC0_OFF_GPIO_Port 	AFE0_OFF_LDACn_GPIO_Port
#define SYNC0_OFF_Pin 			AFE0_OFF_SYNCn_Pin
#define SYNC0_OFF_GPIO_Port 	AFE0_OFF_SYNCn_GPIO_Port
/********** AFE0 block end definition *************/

/********** AFE1 block init definition *************/
//AFE
#define AFE1_SEN_Pin 			AFE1_AFE_SEn_Pin
#define AFE1_SEN_GPIO_Port 		AFE1_AFE_SEn_GPIO_Port
//TRIM
#define SYNC1_TRM_Pin 			AFE1_TRM_SYNCn_Pin
#define SYNC1_TRM_GPIO_Port 	AFE1_TRM_SYNCn_GPIO_Port
#define LDAC1_TRM_Pin 			AFE1_TRM_LDACn_Pin
#define LDAC1_TRM_GPIO_Port 	AFE1_TRM_LDACn_GPIO_Port
//OFFSET
#define SYNC1_OFF_Pin 			AFE1_OFF_SYNCn_Pin
#define SYNC1_OFF_GPIO_Port 	AFE1_OFF_SYNCn_GPIO_Port
#define LDAC1_OFF_Pin 			AFE1_OFF_LDACn_Pin
#define LDAC1_OFF_GPIO_Port 	AFE1_OFF_LDACn_GPIO_Port

/*********** AFE1 block end definition *************/

/*********** AFE2 block init definition *************/
//AFE
#define AFE2_SEN_Pin 			AFE2_AFE_SEN_Pin
#define AFE2_SEN_GPIO_Port 		AFE2_AFE_SEN_GPIO_Port
//TRIM
#define SYNC2_TRM_Pin 			AFE2_TRM_SYNCn_Pin
#define SYNC2_TRM_GPIO_Port 	AFE2_TRM_SYNCn_GPIO_Port
#define LDAC2_TRM_Pin 			AFE2_TRM_LDACn_Pin
#define LDAC2_TRM_GPIO_Port 	AFE2_TRM_LDACn_GPIO_Port
//OFFSET
#define SYNC2_OFF_Pin 			AFE2_OFF_SYNCn_Pin
#define SYNC2_OFF_GPIO_Port 	AFE2_OFF_SYNCn_GPIO_Port
#define LDAC2_OFF_Pin 			AFE2_OFF_LDACn_Pin
#define LDAC2_OFF_GPIO_Port 	AFE2_OFF_LDACn_GPIO_Port
/*********** AFE2 block end definition *************/

/*********** AFE3 Block init definition *************/
//AFE
#define AFE3_SEN_Pin			AFE3_AFE_SEn_Pin
#define AFE3_SEN_GPIO_Port 		AFE3_AFE_SEn_GPIO_Port
//TRIM DAC
#define SYNC3_TRM_Pin 			AFE3_TRM_SYNCn_Pin
#define SYNC3_TRM_GPIO_Port 	AFE3_TRM_SYNCn_GPIO_Port
#define LDAC3_TRM_Pin 			AFE3_TRM_LDACn_Pin
#define LDAC3_TRM_GPIO_Port 	AFE3_TRM_LDACn_GPIO_Port
//OFFSET DAC
#define SYNC3_OFF_Pin 			AFE3_OFF_SYNCn_Pin
#define SYNC3_OFF_GPIO_Port 	AFE3_OFF_SYNCn_GPIO_Port
#define LDAC3_OFF_Pin 			AFE3_OFF_LDACn_Pin
#define LDAC3_OFF_GPIO_Port 	AFE3_OFF_LDACn_GPIO_Port
/*********** AFE3 block end definition *************/

/*********** AFE4 Block init definition *************/
//AFE
#define AFE4_SEN_Pin 			AFE4_AFE_SEn_Pin
#define AFE4_SEN_GPIO_Port 		AFE4_AFE_SEn_GPIO_Port
//TRIM
#define LDAC4_TRM_Pin 			AFE4_TRM_LDACn_Pin
#define LDAC4_TRM_GPIO_Port 	AFE4_TRM_LDACn_GPIO_Port
#define SYNC4_TRM_Pin 			AFE4_TRM_SYNCn_Pin
#define SYNC4_TRM_GPIO_Port 	AFE4_TRM_SYNCn_GPIO_Port
//OFFSET
#define LDAC4_OFF_Pin 			AFE4_OFF_LDACn_Pin
#define LDAC4_OFF_GPIO_Port 	AFE4_OFF_LDACn_GPIO_Port
#define SYNC4_OFF_Pin 			AFE4_OFF_SYNCn_Pin
#define SYNC4_OFF_GPIO_Port		AFE4_OFF_SYNCn_GPIO_Port
/*********** AFE4 block end definition *************/





#endif /* DAPHNE_CFG_HAL_H */
