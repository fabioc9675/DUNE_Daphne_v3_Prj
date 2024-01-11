/*
 * daphne_afe_hal.h
 *
 *  Created on: Jun 22, 2021
 *      Author: Usuario
 */

#ifndef INC_DAPHNE_AFE_HAL_H_
#define INC_DAPHNE_AFE_HAL_H_

#include "daphne_cfg.h"
#include "spi.h"
#include "usart.h"
#include "hal_afe5808a.h"
#include "hal_ad5327.h"
#include "hal_spi_emul.h"
#include "hal_afe_cfg.h"

void AFEx_config(void);
void AFEx_Init(void);

#define AFE_RST_HIGH 	HAL_GPIO_WritePin(hafe0.RST_Port, hafe0.RST_Pin, HIGH_STATE);
#define AFE_RST_LOW 	HAL_GPIO_WritePin(hafe0.RST_Port, hafe0.RST_Pin, LOW_STATE);

/* AFE TRIM OFFSET BIASSET BIASCTRL INIT Functions Library */
extern AFE_HandleTypeDef hafe0;
extern AFE_HandleTypeDef hafe1;
extern AFE_HandleTypeDef hafe2;
extern AFE_HandleTypeDef hafe3;
extern AFE_HandleTypeDef hafe4;

extern AD_HandleTypeDef hdac_biasset;

extern AD_HandleTypeDef hdac_trimAfe0;
extern AD_HandleTypeDef hdac_trimAfe1;
extern AD_HandleTypeDef hdac_trimAfe2;
extern AD_HandleTypeDef hdac_trimAfe3;
extern AD_HandleTypeDef hdac_trimAfe4;

extern AD_HandleTypeDef hdac_offsAfe0;
extern AD_HandleTypeDef hdac_offsAfe1;
extern AD_HandleTypeDef hdac_offsAfe2;
extern AD_HandleTypeDef hdac_offsAfe3;
extern AD_HandleTypeDef hdac_offsAfe4;

extern void MX_AFE0_Init(void);
extern void MX_AFE1_Init(void);
extern void MX_AFE2_Init(void);
extern void MX_AFE3_Init(void);
extern void MX_AFE4_Init(void);

/*AFE Test prototype Functions */
extern HAL_AFEStatusTypeDef HAL_AFE_RampTest(AFE_HandleTypeDef *hafe);
/* AFE Sync test configuration */
extern HAL_AFEStatusTypeDef HAL_AFE_SyncTest(AFE_HandleTypeDef *hafe);
/* AFE Skew test configuration */
extern HAL_AFEStatusTypeDef HAL_AFE_SkewTest(AFE_HandleTypeDef *hafe);
/* AFE Custom test configuration */
extern HAL_AFEStatusTypeDef HAL_AFE_CustomTest(AFE_HandleTypeDef *hafe);
/* AFE All 1s test configuration */
extern HAL_AFEStatusTypeDef HAL_AFE_All1sTest(AFE_HandleTypeDef *hafe);
/* AFE Toggle test configuration */
extern HAL_AFEStatusTypeDef HAL_AFE_ToggleTest(AFE_HandleTypeDef *hafe);
/* AFE All 0s test configuration */
extern HAL_AFEStatusTypeDef HAL_AFE_All0sTest(AFE_HandleTypeDef *hafe);

/*AFE SPI Read and Write Functions */
extern HAL_AFEStatusTypeDef HAL_AFEReadWriteRegister(AFE_HandleTypeDef *hafe,
		uint8_t regAddr, uint16_t *regDataW, uint16_t *regDataR,
		uint32_t Timeout);
extern HAL_AFEStatusTypeDef HAL_AFEWriteRegister(AFE_HandleTypeDef *hafe,
		uint8_t regAddr, uint16_t *regDataW);
extern HAL_AFEStatusTypeDef HAL_AFEReadRegister(AFE_HandleTypeDef *hafe,
		uint8_t regAddr, uint16_t *regDataR);

/*AFE SPI Read and Write Functions */
extern void MX_AD_DAC_BIASSET_Init(void);

extern void MX_AD_DAC_AFE0_Init(void);
extern void MX_AD_DAC_AFE1_Init(void);
extern void MX_AD_DAC_AFE2_Init(void);
extern void MX_AD_DAC_AFE3_Init(void);
extern void MX_AD_DAC_AFE4_Init(void);

extern HAL_ADStatusTypeDef HAL_DAC_TrimOffsetWriteRegister(AD_HandleTypeDef *haddac,
		uint16_t *regData1W, uint16_t *regData2W, uint32_t Timeout);
extern HAL_ADStatusTypeDef HAL_DAC_BiasSetWriteRegister(AD_HandleTypeDef *haddac,
		uint16_t *regData1W, uint16_t *regData2W, uint16_t *regData3W,
		uint32_t Timeout);

extern HAL_ADStatusTypeDef HAL_DAC1TrimOffset_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);
extern HAL_ADStatusTypeDef HAL_DAC2TrimOffset_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);
/* **** Set data value in DAC output ********************************************/
extern HAL_ADStatusTypeDef HAL_DAC1TrimOffset_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);
extern HAL_ADStatusTypeDef HAL_DAC2TrimOffset_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);

/*DAC SPI Read and Write Functions */
extern HAL_ADStatusTypeDef HAL_DAC1BiasSet_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);
extern HAL_ADStatusTypeDef HAL_DAC2BiasSet_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);
extern HAL_ADStatusTypeDef HAL_DAC3BiasSet_ModifyParam(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t gain, uint16_t buffer, uint16_t value);

extern HAL_ADStatusTypeDef HAL_DAC1BiasSet_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);
extern HAL_ADStatusTypeDef HAL_DAC2BiasSet_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);
extern HAL_ADStatusTypeDef HAL_DAC3BiasSet_SetValue(AD_HandleTypeDef *haddac,
		uint16_t channel, uint16_t value);

/* AFE TRIM OFFSET BIASSET BIASCTRL END Functions Library */

#endif /* INC_DAPHNE_AFE_HAL_H_ */
