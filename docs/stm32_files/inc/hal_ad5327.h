/*
 * hal_ad5327.h
 *
 *  Created on: Mar 11, 2021
 *      Author: Fabian Castano
 */

#ifndef INC_HAL_AD5327_H_
#define INC_HAL_AD5327_H_

/* Includes ------------------------------------------------------------------*/
//#include "main.h"
#include "daphne_cfg.h"
#include "spi.h"
#include "gpio.h"
#include "hal_spi_emul.h"
#include "ad5327.h"

/* Variables -----------------------------------------------------------------*/
#define hdacspiemul				SpiEmulHandle

#define hdactrim0spi            hspi4
#define hdacoffs0spi            hspi4
#define hdactrim1spi            hspi5
#define hdacoffs1spi            hspi5
#define hdactrim2spi            hspi5
#define hdacoffs2spi            hspi5
#define hdactrim3spi            hspi6
#define hdacoffs3spi            hspi6
#define hdactrim4spi            hspi6
#define hdacoffs4spi            hspi6

/* TypeDef -------------------------------------------------------------------*/
#define SYNC_ACT 				LOW_STATE
#define SYNC_DEACT              HIGH_STATE
#define LDAC_ACT                LOW_STATE
#define LDAC_DEACT              HIGH_STATE

/* TYPEDEF HAL_AD Register Map -----------------------------------------------*/
/**
 * @brief  AD5327 handle Structure definition
 */
typedef struct __AD_HandleTypeDef {
	SPI_HandleTypeDef *SPI_handle; /*!< SPI Handle type def */

	SPI_Emul_HandleTypeDef *SPI_Emul_handle; /*!< SPI Emulation Handle type def */

	GPIO_TypeDef *Sync_Port; /*!< PORT Handle type def */

	GPIO_TypeDef *Ldac_Port; /*!< PORT Handle type def */

	uint16_t Sync_Pin; /*!< PIN Handle type def */

	uint16_t Ldac_Pin; /*!< PIN Handle type def */

	uint16_t is_DaisyChained; /*!< Variable to determine if is daisy chained */

	uint16_t is_Transmiting; /*!< Variable to determine if is transmiting */

	AD_DACRegisterMap DACRegisterMap; /*!< Register Map of DAC AD5327 */

	AD_DACRegisterMap DAC1DCRegisterMap; /*!< Register Map of DAC1 Daisy Chained AD5327 */
	AD_DACRegisterMap DAC2DCRegisterMap; /*!< Register Map of DAC2 Daisy Chained AD5327 */
	AD_DACRegisterMap DAC3DCRegisterMap; /*!< Register Map of DAC3 Daisy Chained AD5327 */

	DAC_CHVALUE DAC1_ChMemValue; /*!< Channel memory value */
	DAC_CHVALUE DAC2_ChMemValue; /*!< Channel memory value */
	DAC_CHVALUE DAC3_ChMemValue; /*!< Channel memory value */

	DAC_CHGAIN DAC1_ChMemGain; /*!< Channel memory gain */
	DAC_CHGAIN DAC2_ChMemGain; /*!< Channel memory gain */
	DAC_CHGAIN DAC3_ChMemGain; /*!< Channel memory gain */

	DAC_CHBUFFER DAC1_ChMemBuffer; /*!< Channel memory buffer */
	DAC_CHBUFFER DAC2_ChMemBuffer; /*!< Channel memory buffer */
	DAC_CHBUFFER DAC3_ChMemBuffer; /*!< Channel memory buffer */

} AD_HandleTypeDef;

/* Prototype -----------------------------------------------------------------*/
void MX_AD_DAC_BIASSET_Init(void);
void MX_AD_DAC_AFE0_Init(void);
void MX_AD_DAC_AFE1_Init(void);
void MX_AD_DAC_AFE2_Init(void);
void MX_AD_DAC_AFE3_Init(void);
void MX_AD_DAC_AFE4_Init(void);

HAL_ADStatusTypeDef HAL_DAC_TrimOffsetWriteRegister(AD_HandleTypeDef *haddac,
		uint16_t *regData1W, uint16_t *regData2W, uint32_t Timeout);
HAL_ADStatusTypeDef HAL_DAC_BiasSetWriteRegister(AD_HandleTypeDef *haddac,
		uint16_t *regData1W, uint16_t *regData2W, uint16_t *regData3W,
		uint32_t Timeout);

HAL_ADStatusTypeDef HAL_DAC1TrimOffset_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);
HAL_ADStatusTypeDef HAL_DAC2TrimOffset_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);
HAL_ADStatusTypeDef HAL_DAC1BiasSet_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);
HAL_ADStatusTypeDef HAL_DAC2BiasSet_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);
HAL_ADStatusTypeDef HAL_DAC3BiasSet_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);

/* **** Set data value in DAC output ********************************************/
HAL_ADStatusTypeDef HAL_DAC1TrimOffset_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);
HAL_ADStatusTypeDef HAL_DAC2TrimOffset_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);
HAL_ADStatusTypeDef HAL_DAC1BiasSet_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);
HAL_ADStatusTypeDef HAL_DAC2BiasSet_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);
HAL_ADStatusTypeDef HAL_DAC3BiasSet_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);

void HAL_SPI_Emul_TxCpltCallback(SPI_Emul_HandleTypeDef *hspi);

/* SPI AFE operation config ***************************************************/
void MX_SPI_DAC_OP_Config(SPI_HandleTypeDef *hspi);

#endif /* INC_HAL_AD5327_H_ */
