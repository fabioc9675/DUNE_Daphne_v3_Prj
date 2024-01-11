/*
 * hal_afe5808a.h
 *
 *  Created on: 4/03/2021
 *      Author: Fabian Castano
 */

#ifndef INC_HAL_AFE5808A_H_
#define INC_HAL_AFE5808A_H_

/* Includes ------------------------------------------------------------------*/
//#include "main.h"
#include "daphne_cfg.h"
#include "spi.h"
#include "gpio.h"
#include "afe5808a.h"
#include "hal_ad5327.h"

/* Variables -----------------------------------------------------------------*/
#define hafe0spi		hspi4
#define hafe1spi		hspi5
#define hafe2spi		hspi5
#define hafe3spi		hspi6
#define hafe4spi		hspi6

/* TypeDef ------------------------------------------------------------------*/
#define SET_CS   LOW_STATE
#define CLR_CS   HIGH_STATE

/* TYPEDEF HAL_AFE Register Map --------------------------------------------------*/
/**
 * @brief  AFE5808A handle Structure definition
 */
typedef struct __AFE_HandleTypeDef {
	SPI_HandleTypeDef *SPI_handle; /*!< SPI Handle type def */

	GPIO_TypeDef *CS_Port; /*!< PORT Handle type def */

	uint16_t CS_Pin; /*!< PIN Handle type def */

	GPIO_TypeDef *RST_Port; /*!< PORT Handle type def */

	uint16_t RST_Pin; /*!< PIN Handle type def */

	GPIO_TypeDef *PDN_Port; /*!< PORT Handle type def */

	uint16_t PDN_Pin; /*!< PIN Handle type def */

	AFE_ADCRegisterMap ADCRegisterMap; /*!< Register Map of ADC AFE5808A */
	AFE_VCARegisterMap VCARegisterMap; /*!< Register Map of VCA AFE5808A */

	AD_HandleTypeDef *AD_DACTrim; /*!< Struct that controls Trim DAC */
	AD_HandleTypeDef *AD_DACOffset; /*!< Struct that controls Offset DAC */

} AFE_HandleTypeDef;

/* Prototype -----------------------------------------------------------------*/

/* SPI1 init function */
void MX_AFE0_Init(void);
void MX_AFE1_Init(void);
void MX_AFE2_Init(void);
void MX_AFE3_Init(void);
void MX_AFE4_Init(void);

/* I/O operation functions  ***************************************************/
HAL_AFEStatusTypeDef HAL_AFEReadWriteRegister(AFE_HandleTypeDef *hafe,
		uint8_t regAddr, uint16_t *regDataW, uint16_t *regDataR,
		uint32_t Timeout);
HAL_AFEStatusTypeDef HAL_AFEWriteRegister(AFE_HandleTypeDef *hafe,
		uint8_t regAddr, uint16_t *regDataW);
HAL_AFEStatusTypeDef HAL_AFEReadRegister(AFE_HandleTypeDef *hafe,
		uint8_t regAddr, uint16_t *regDataR);

/* SPI AFE operation config ***************************************************/
void MX_SPI_AFE_OP_Config(SPI_HandleTypeDef *hspi);

#endif /* INC_HAL_AFE5808A_H_ */
