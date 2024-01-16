/**
 ******************************************************************************
 * @file    hal_gpio.h
 * @author  Fabian Castano
 * @brief   This file contains all the function prototypes for
 *          the hal_gpio.c file
 ******************************************************************************
 */

#ifndef __HAL_GPIO_H__
#define __HAL_GPIO_H__

/* Includes ------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

/* Variables -----------------------------------------------------------------*/

/* TypeDef ------------------------------------------------------------------*/
#define FALSE 0
#define TRUE 1

#define LOW_STATE 0
#define HIGH_STATE 1

/* Extern Variables -----------------------------------------------------------------*/

// AFE Pins
#define AFE_PDN_P_Pin 498
#define AFE_RST_P_Pin 497

#define AFE0_SEN_Pin 496
#define AFE1_SEN_Pin 496
#define AFE2_SEN_Pin 496
#define AFE3_SEN_Pin 496
#define AFE4_SEN_Pin 496

// DAC Pins
#define DAC_LDACn_Pin 492
#define DAC_SYNCn_Pin 492

#define LDAC0_TRM_Pin 496
#define LDAC1_TRM_Pin 493
#define LDAC2_TRM_Pin 493
#define LDAC3_TRM_Pin 493
#define LDAC4_TRM_Pin 493

#define SYNC0_TRM_Pin 497
#define SYNC1_TRM_Pin 494
#define SYNC2_TRM_Pin 494
#define SYNC3_TRM_Pin 494
#define SYNC4_TRM_Pin 494

#define LDAC0_OFF_Pin 496
#define LDAC1_OFF_Pin 493
#define LDAC2_OFF_Pin 493
#define LDAC3_OFF_Pin 493
#define LDAC4_OFF_Pin 493

#define SYNC0_OFF_Pin 497
#define SYNC1_OFF_Pin 494
#define SYNC2_OFF_Pin 494
#define SYNC3_OFF_Pin 494
#define SYNC4_OFF_Pin 494

/* Prototype -----------------------------------------------------------------*/

/* Base functions */

/* GPIO init functions */
void MX_GPIO_Init(void);
void HAL_GPIO_PinOut_Init(int gpio_pin);

/* GPIO state functions */
void HAL_GPIO_WritePin(int gpio_port, int gpio_pin, int value);

#endif /* __HAL_GPIO_H__ */
