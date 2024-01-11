/*
 * hal_spi_emul.c
 *
 *  Created on: Mar 10, 2021
 *      Author: Fabian Castano
 */

/* Includes ------------------------------------------------------------------*/
#include "hal_spi_emul.h"

/* Handle --------------------------------------------------------------------*/
/* SPI Emulation Handle */
SPI_Emul_HandleTypeDef SpiEmulHandle;
static SPI_Emul_HandleTypeDef *hspi_emul;

/* Extern Handle -------------------------------------------------------------*/

extern LPTIM_HandleTypeDef hlptim2;
extern DMA_HandleTypeDef hdma_bdma_generator0;

/* Variables -----------------------------------------------------------------*/
#define timHandle hlptim2
#define dmaTxHandle hdma_bdma_generator0

/* Buffer used for transmission */
#if defined ( __GNUC__ )
static uint32_t __attribute__((section (".buffers"), used)) pBuffer_Tx[4
		* (TX_BUFFER_SIZE)];

#endif

uint32_t bit_time = 0;
uint32_t bit_pulse = 0;

/* Prototypes ----------------------------------------------------------------*/

/* Private Generic function prototypes ---------------------------------------*/
static void SPI_Emul_SetConfig(SPI_Emul_HandleTypeDef *spi);
static void SPI_Emul_DMAError(DMA_HandleTypeDef *hdma);
//static void SPI_Emul_EnableRessources(SPI_Emul_HandleTypeDef *hspi);
static void SPI_Emul_DMATransmitCplt(DMA_HandleTypeDef *hdma);

/* Functions -----------------------------------------------------------------*/

/* SPI_Emul init function */
void MX_SPI_Emul_Init(void) {

	SpiEmulHandle.Init.Mode = SPI_EMUL_MODE_MASTER;
	SpiEmulHandle.Init.DataSize = SPI_EMUL_DATASIZE_8BIT;
	SpiEmulHandle.Init.CLKPolarity = SPI_EMUL_POLARITY_HIGH;
	SpiEmulHandle.Init.CLKPhase = SPI_EMUL_PHASE_2EDGE;
	SpiEmulHandle.Init.SPI_Clk = 2000000;

	/*Initialize SPI Emulation pin number for Clk TX */
	SpiEmulHandle.Init.ClkPinNumber = SPI_EMUL_Clk_PIN;
	SpiEmulHandle.Init.TxPinNumber = SPI_EMUL_TX_PIN;

	SpiEmulHandle.ClkPortName = SPI_EMUL_Clk_PORT;
	SpiEmulHandle.TxPortName = SPI_EMUL_TX_PORT;
	SpiEmulHandle.ClkPinNumber = SpiEmulHandle.Init.ClkPinNumber;
	SpiEmulHandle.TxPinNumber = SpiEmulHandle.Init.TxPinNumber;

	// initialization of SPI Emul state
	if (HAL_SPI_Emul_Init(&SpiEmulHandle) != HAL_OK) {
		Error_Handler();
	}
}

/**
 * @brief  Initializes the SPI Emulation according to the specified parameters
 *         in the SPI_Emul_InitTypeDef and create the associated handle.
 * @param  hspi: pointer to a SPI_HandleTypeDef structure that contains
 *         the configuration information for SPI module.
 * @retval HAL status
 */
HAL_StatusTypeDef HAL_SPI_Emul_Init(SPI_Emul_HandleTypeDef *hspi) {
	/* Check the SPI handle allocation */
	if (hspi == NULL) {
		return HAL_ERROR;
	}

	/* Get Structure for spi emul Handle */
	hspi_emul = hspi;

	/* Set the TIM state */
	hspi->State = HAL_SPI_EMUL_STATE_BUSY;

	/* Set the SPI Emulation Communication parameters */
	SPI_Emul_SetConfig(hspi);

	/* Initialize the SPI Emulation state */
	hspi->ErrorCode = HAL_SPI_EMUL_ERROR_NONE;
	hspi->State = HAL_SPI_EMUL_STATE_READY;

	return HAL_OK;
}

/**
 * @brief  Configures the SPI Emulation peripheral.
 + Enable clock for ALL peripheral Timer, GPIO
 + DMA 2 Configuration channel, Stream, Mode? Priority, ...
 + Configuration SPI Emulation CR registre software
 * @param  hspi: SPI Emulation handle
 * @retval None
 */
static void SPI_Emul_SetConfig(SPI_Emul_HandleTypeDef *hspi) {

	/* Init Bit Time */
	if ((HAL_RCC_GetSysClockFreq() / HAL_RCC_GetPCLK2Freq() == 1)) {
		bit_time = ((uint32_t) ((HAL_RCC_GetSysClockFreq()
				/ (hspi->Init.SPI_Clk * 4)) - 1));
		bit_pulse = bit_time / 2;
	} else {
		bit_time = ((uint32_t) (((HAL_RCC_GetPCLK2Freq() * 2)
				/ (hspi->Init.SPI_Clk * 4)) - 1));
		bit_pulse = bit_time / 2;
	}

	/* Configuration of DMA ISR functions */
	HAL_DMA_RegisterCallback(&dmaTxHandle, HAL_DMA_XFER_ERROR_CB_ID,
			SPI_Emul_DMAError);
	HAL_DMA_RegisterCallback(&dmaTxHandle, HAL_DMA_XFER_CPLT_CB_ID,
			SPI_Emul_DMATransmitCplt);

	/* DMA Mux initialization */
	if (HAL_DMAEx_EnableMuxRequestGenerator(&dmaTxHandle) != HAL_OK) {
		Error_Handler();
	}

	/* Configure idle state of CLK pin */
	if (hspi->Init.CLKPolarity == SPI_EMUL_POLARITY_HIGH) {
		HAL_GPIO_WritePin(hspi->ClkPortName, hspi->ClkPinNumber, HIGH);
	}

}

/**
 * @brief  Transmit and Receive an amount of data in no-blocking mode with DMA
 * @param  hspi: pointer to a SPI_Emul_HandleTypeDef structure that contains
 *                the configuration information for SPI module.
 * @param  pTxData: pointer to transmission data buffer
 * @param  pRxData: pointer to reception data buffer
 * @param  Size: amount of data to be sent
 * @retval HAL status
 */

HAL_StatusTypeDef HAL_SPI_Emul_TransmitReceive_DMA(SPI_Emul_HandleTypeDef *hspi,
		uint8_t *pTxData, uint16_t Size) {

	uint32_t bitmask = 0;
	uint32_t clkmask = 0;
	uint16_t dataCount = (Size * 2) + 1;
	uint32_t tmpstate = 0;
	tmpstate = hspi->State;

	if (tmpstate == HAL_SPI_EMUL_STATE_READY) {
		if ((pTxData == NULL) || (Size == 0)) {
			return HAL_ERROR;
		}

		/* Configure communication */
		hspi->ErrorCode = HAL_SPI_EMUL_ERROR_NONE;

		hspi->TxXferSize = Size;
		hspi->pTxBuffPtr = pTxData;

		/* Get the Pin Number */
		bitmask = (uint32_t) hspi->TxPinNumber;
		clkmask = (uint32_t) hspi->ClkPinNumber;

		/* Charge the data into buffer tx */
		pBuffer_Tx[0] = (bitmask << 16) | (clkmask); // data before init transmission

		// configure data to write into register
		for (int i = 1; i < dataCount; i++) {
			if (i % 2 == 1) {
				pBuffer_Tx[i] = clkmask << 16;
				if (*pTxData == HIGH) {
					pBuffer_Tx[i] |= bitmask;
				} else {
					pBuffer_Tx[i] |= bitmask << 16;
				}
			} else {
				pBuffer_Tx[i] = clkmask;
				if (*pTxData == HIGH) {
					pBuffer_Tx[i] |= bitmask;
				} else {
					pBuffer_Tx[i] |= bitmask << 16;
				}
				pTxData++;
			}
		}

		/* Initiate spi emul resources */
		HAL_DMA_Start_IT(&dmaTxHandle, (uint32_t) pBuffer_Tx,
				(uint32_t) &((hspi_emul->ClkPortName)->BSRR), dataCount);

		/* Start the timer */
		if (HAL_LPTIM_PWM_Start(&timHandle, bit_time, bit_pulse) != HAL_OK) {
			Error_Handler();
		}

		hspi->State = HAL_SPI_EMUL_STATE_BUSY_TX;

		return HAL_OK;
	} else {
		return HAL_BUSY;
	}
}

/* @brief  This function is executed in case of error of Transfer occurrence.
 * @param  hdma : DMA Handle
 * @retval None
 */
static void SPI_Emul_DMAError(DMA_HandleTypeDef *hdma) {
	/* SPI Emulation frame error occurred */
//	__HAL_SPI_EMUL_SET_FLAG(hspi_emul, SPI_EMUL_FLAG_FE);
//
//	hspi_emul->ErrorCode |= HAL_SPI_EMUL_ERROR_FE;
//
//	HAL_SPI_Emul_ErrorCallback(hspi_emul);
	__NOP();
}

/**
 * @brief  This function is executed in case of Transfer Complete.
 * @param  hdma: DMA handle
 * @retval None
 */
static void SPI_Emul_DMATransmitCplt(DMA_HandleTypeDef *hdma) {
//	((DMA_Stream_TypeDef*)hdma->Instance)->CR &=  ~DMA_SxCR_EN;

	HAL_DMA_Abort(hdma);
	HAL_LPTIM_PWM_Stop(&timHandle);
	HAL_SPI_Emul_TxCpltCallback(hspi_emul);

	hspi_emul->State = HAL_SPI_EMUL_STATE_READY;
}

/* @brief  Initializes the SPI Emulation Transfer Complete.
 * @param  hspi: SPI Emulation Handle
 * @retval None
 */
__weak void HAL_SPI_Emul_TxCpltCallback(SPI_Emul_HandleTypeDef *hspi) {
	/* NOTE : This function Should not be modified, when the callback is needed,
	 the HAL_SPI_Emul_TransferComplete could be implemented in the user file
	 */
}

/************************ (C) COPYRIGHT GIBIC Tech-Hub *****END OF FILE****/

