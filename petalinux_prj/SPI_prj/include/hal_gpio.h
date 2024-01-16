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
#define PDN_AFE0 496
#define PDN_AFE1 496
#define PDN_AFE2 496
#define PDN_AFE3 496
#define PDN_AFE4 496

#define RST_AFE0 497
#define RST_AFE1 497
#define RST_AFE2 497
#define RST_AFE3 497
#define RST_AFE4 497

#define SEN_AFE0 498
#define SEN_AFE1 498
#define SEN_AFE2 498
#define SEN_AFE3 498
#define SEN_AFE4 498

// DAC Pins
#define LDAC_BIAS 492
#define SYNC_BIAS 492

#define LDAC_TRM_DAC0 493
#define LDAC_TRM_DAC1 493
#define LDAC_TRM_DAC2 493
#define LDAC_TRM_DAC3 493
#define LDAC_TRM_DAC4 493

#define SYNC_TRM_DAC0 494
#define SYNC_TRM_DAC1 494
#define SYNC_TRM_DAC2 494
#define SYNC_TRM_DAC3 494
#define SYNC_TRM_DAC4 494

#define LDAC_OFF_DAC0 493
#define LDAC_OFF_DAC1 493
#define LDAC_OFF_DAC2 493
#define LDAC_OFF_DAC3 493
#define LDAC_OFF_DAC4 493

#define SYNC_OFF_DAC0 494
#define SYNC_OFF_DAC1 494
#define SYNC_OFF_DAC2 494
#define SYNC_OFF_DAC3 494
#define SYNC_OFF_DAC4 494

/* Prototype -----------------------------------------------------------------*/

/* Base functions */

/* GPIO init functions */
void MX_GPIO_Init(void);
void HAL_GPIO_PinOut_Init(int gpio_pin);

/* GPIO state functions */
void HAL_GPIO_WritePin(int gpio_port, int gpio_pin, int value);

#endif /* __HAL_GPIO_H__ */
