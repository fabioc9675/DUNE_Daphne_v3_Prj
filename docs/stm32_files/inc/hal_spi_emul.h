/*
 * hal_spi_emul.h
 *
 *  Created on: Mar 10, 2021
 *      Author: Fabian Castano
 */

#ifndef INC_HAL_SPI_EMUL_H_
#define INC_HAL_SPI_EMUL_H_

#ifdef __cplusplus
extern "C"
{
#endif

/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Defines -------------------------------------------------------------------*/

/** Pin definition */
#define SPI_EMUL_Clk_PIN  DAC_SCLK_Pin
#define SPI_EMUL_TX_PIN  DAC_DIN_Pin
#define SPI_EMUL_Clk_PORT  DAC_SCLK_GPIO_Port
#define SPI_EMUL_TX_PORT  DAC_DIN_GPIO_Port

/** SPI_Emul_mode */
#define SPI_EMUL_MODE_SLAVE                 ((uint8_t)0x01)
#define SPI_EMUL_MODE_MASTER                ((uint8_t)0x02)

/** SPI_Emul_data_size */
#define SPI_EMUL_DATASIZE_8BIT               ((uint32_t)0x00000008)
#define SPI_EMUL_DATASIZE_16BIT              ((uint32_t)0x00000010)
#define SPI_EMUL_DATASIZE_32BIT              ((uint32_t)0x00000020)

/** SPI_Emul_Clock_Polarity */
#define SPI_EMUL_POLARITY_LOW                ((uint32_t)0x00000001)
#define SPI_EMUL_POLARITY_HIGH               ((uint32_t)0x00000002)

/** SPI_Emul_Clock_Phase */
#define SPI_EMUL_PHASE_1EDGE                 ((uint32_t)0x00000001)
#define SPI_EMUL_PHASE_2EDGE                 ((uint32_t)0x00000002)

/** SPI DMA Data size */
#define TX_BUFFER_SIZE        				 ((uint8_t)0x50)

#define HIGH            		1
#define LOW          	 		0

/* Variables -----------------------------------------------------------------*/

/* Typedef -------------------------------------------------------------------*/

/**
 * @brief  HAL SPI Emulation State structure definition
 */
typedef enum {
	HAL_SPI_EMUL_STATE_RESET = 0x00, /*!< SPI not yet initialized or disabled */
	HAL_SPI_EMUL_STATE_READY = 0x01, /*!< SPI initialized and ready for use */
	HAL_SPI_EMUL_STATE_BUSY = 0x02, /*!< SPI process is ongoing */
	HAL_SPI_EMUL_STATE_BUSY_TX = 0x12, /*!< Data Transmission process is ongoing */
	HAL_SPI_EMUL_STATE_BUSY_RX = 0x22, /*!< Data Reception process is ongoing */
	HAL_SPI_EMUL_STATE_BUSY_TX_RX = 0x32, /*!< Data Transmission and Reception process is ongoing */
	HAL_SPI_EMUL_STATE_ERROR = 0x03 /*!< SPI error state */
} HAL_SPI_Emul_StateTypeDef;

/**
 * @brief  HAL SPI Emulation Error Code structure definition
 */
typedef enum {
	HAL_SPI_EMUL_ERROR_NONE = 0x00, /*!< No error            */
	HAL_SPI_EMUL_ERROR_FE = 0x01, /*!< frame error         */
	HAL_SPI_EMUL_ERROR_RE = 0x02, /*!< receiver error      */
	HAL_SPI_EMUL_ERROR_TE = 0x04 /*!< transfer error      */
} HAL_SPI_Emul_ErrorTypeDef;

/**
 * @brief  SPI Emulation Configuration Structure definition
 */
typedef struct {
	uint32_t Mode; /*!< Specifies the SPI operating mode.
	 This parameter can be a value of @ref SPI_Emul_mode */

	uint32_t DataSize; /*!< Specifies the SPI data size.
	 This parameter can be a value of @ref SPI_Emul_data_size */

	uint32_t CLKPolarity; /*!< Specifies the serial clock steady state.
	 This parameter can be a value of @ref SPI_Emul_Clock_Polarity */

	uint32_t CLKPhase; /*!< Specifies the clock active edge for the bit capture.
	 This parameter can be a value of @ref SPI_Emul_Clock_Phase */

	uint32_t SPI_Clk; /*!< Specifies the SPI Clock Frequency which will be
	 used in transmission and reception.
	 This parameter must be a number between Min_Data = 500000 and Max_Data = 10000000
	 @note The communication clock is derived from the master
	 clock. The slave clock does not need to be set */

	uint32_t TxPinNumber; /*!< Specifies the number of Transmitter Pin.
	 This parameter can be a value of @ref GPIO_pins_define */

	uint32_t ClkPinNumber; /*!< Specifies the number of Clock Pin.
	 This parameter can be a value of @ref GPIO_pins_define */

} SPI_Emul_InitTypeDef;

/**
 * @brief  SPI Emulation handle Structure definition
 */
typedef struct __SPI_Emul_HandleTypeDef {
//	SPI_TypeDef Instance; /* Instance for SPI Emulation register */
//
	SPI_Emul_InitTypeDef Init; /* SPI Emulation communication parameters */

	__IO uint8_t *pTxBuffPtr; /* Pointer to SPI Emulation Tx transfer Buffer */

	__IO uint16_t TxXferSize; /* SPI Emulation Tx transfer size */

	GPIO_TypeDef *TxPortName; /* SPI Emulation Tx port name */

	GPIO_TypeDef *ClkPortName; /* SPI Emulation Clock port name */

	uint32_t TxPinNumber; /* SPI Emulation Tx pin number */

	uint32_t ClkPinNumber; /* SPI Emulation Clock pin number */

	__IO HAL_SPI_Emul_StateTypeDef State; /* SPI Emulation communication state */

	__IO HAL_SPI_Emul_ErrorTypeDef ErrorCode; /* SPI Emulation Error code */
} SPI_Emul_HandleTypeDef;

/* Extern Handle -------------------------------------------------------------*/
extern SPI_Emul_HandleTypeDef SpiEmulHandle;

/* Prototypes ----------------------------------------------------------------*/

/* Functions prototypes */
void MX_SPI_Emul_Init(void);
void HAL_SPI_Emul_TxCpltCallback(SPI_Emul_HandleTypeDef *hspi);

HAL_StatusTypeDef HAL_SPI_Emul_Init(SPI_Emul_HandleTypeDef *hspi);
HAL_StatusTypeDef HAL_SPI_Emul_TransmitReceive_DMA(SPI_Emul_HandleTypeDef *hspi,
		uint8_t *pTxData, uint16_t Size);

#ifdef __cplusplus
}
#endif

#endif /* INC_HAL_SPI_EMUL_H_ */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
