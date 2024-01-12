/**
 ******************************************************************************
 * @file    hal_spi.h
 * @author  Fabian Castano
 * @brief   This file contains all the function prototypes for
 *          the spi.c file
 ******************************************************************************
 */

#ifndef __HAL_SPI_H__
#define __HAL_SPI_H__

/* Includes ------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <linux/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>

/* Variables -----------------------------------------------------------------*/

/* TypeDef ------------------------------------------------------------------*/
#define HAL_OK 0
#define HAL_ERROR 1

#define LOW_STATE 0
#define HIGH_STATE 1

#define SET_CS LOW_STATE
#define CLR_CS HIGH_STATE

/* TYPEDEF HAL_AFE Register Map --------------------------------------------------*/
/**
 * @brief  AFE5808A handle Structure definition
 */
typedef struct __SPI_HandleTypeDef
{
	char *SPI_Device; /*!< SPI Handle type def */

	struct spi_ioc_transfer spi_trx; /*!< PORT Handle type def */

	int fileDevice; /*!< PORT Handle type def */

	int fileReturn; /*!< PORT Handle type def */

	uint32_t spi_state; /*!< PORT Handle type def */

} SPI_HandleTypeDef;

/* Prototype -----------------------------------------------------------------*/

/* Base functions */
int HAL_SPI_OPEN(SPI_HandleTypeDef *hspi);
int HAL_SPI_CLOSE(SPI_HandleTypeDef *hspi);

/* SPI init functions */
int MX_SPI3_Init(void);
int MX_SPI4_Init(void);

/* SPI close functions */
int MX_SPI3_Deinit(void);
int MX_SPI4_Deinit(void);

/* SPI AFE operation config ***************************************************/
void MX_SPI_AFE_OP_Config(SPI_HandleTypeDef *hspi);

#endif /* __HAL_SPI_H__ */
