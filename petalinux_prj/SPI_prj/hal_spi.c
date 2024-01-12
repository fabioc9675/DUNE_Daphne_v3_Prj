/**
 ******************************************************************************
 * @file    hal_spi.c
 * @author  Fabian Castano
 * @brief   This file contains all the function prototypes for
 *          the spi.c file
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include "hal_spi.h"

/* Variables -----------------------------------------------------------------*/
SPI_HandleTypeDef hspi3;
SPI_HandleTypeDef hspi4;

/* Variables -----------------------------------------------------------------*/
#define SPI_DEVICE_3_0 "/dev/spidev3.0"
#define SPI_DEVICE_4_0 "/dev/spidev4.0"


/* Prototype -----------------------------------------------------------------*/

/* SPI init functions */
int MX_SPI3_Init(void)
{
	hspi3.spi_trx.bits_per_word = 0;
	hspi3.spi_trx.speed_hz = 1000000;
	hspi3.spi_trx.delay_usecs = 0;
	hspi3.SPI_Device = SPI_DEVICE_3_0;

	// open SPI device
	(void)HAL_SPI_OPEN(&hspi3);

	return (HAL_OK);
}

/* SPI init functions */
int MX_SPI4_Init(void)
{
	hspi4.spi_trx.bits_per_word = 0;
	hspi4.spi_trx.speed_hz = 1000000;
	hspi4.spi_trx.delay_usecs = 0;
	hspi4.SPI_Device = SPI_DEVICE_4_0;

	// open SPI device
	(void)HAL_SPI_OPEN(&hspi4);

	return (HAL_OK);
}

/* SPI Stop functions */
int MX_SPI3_Deinit(void)
{

	// close SPI device
	(void)HAL_SPI_CLOSE(&hspi3);
	printf("Cerrado exitosamente\n");

	return (HAL_OK);
}

/* SPI Stop functions */
int MX_SPI4_Deinit(void)
{

	// close SPI device
	(void)HAL_SPI_CLOSE(&hspi4);
	printf("Cerrado exitosamente\n");

	return (HAL_OK);
}

/* *****************************************************************************
 * ** TRANSMIT RECEIVE FUNCTION
 * *****************************************************************************/

/* Transmit and Receive function */
int HAL_SPI_TransmitReceive(SPI_HandleTypeDef *hspi, uint8_t *dataW, uint8_t *dataR, uint8_t dataSize, uint16_t Timeout)
{
	hspi->spi_trx.tx_buf = (unsigned long)dataW;
	hspi->spi_trx.rx_buf = (unsigned long)dataR;
	hspi->spi_trx.len = dataSize;

	// Transmit and receive data from buffer
	hspi->fileReturn = ioctl(hspi->fileDevice, SPI_IOC_MESSAGE(1), &(hspi->spi_trx));
	if (hspi->fileReturn != 0) 
	{
		printf("SPI transfer returned %d...\r\n", hspi->fileReturn);
	}

	return(HAL_OK);
}

/* *****************************************************************************
 * ** BASE FUNCTIONS
 * *****************************************************************************/

/* SPI open function */
int HAL_SPI_OPEN(SPI_HandleTypeDef *hspi)
{

	// open SPI device
	hspi->fileDevice = open(hspi->SPI_Device, O_RDWR);
	if (hspi->fileDevice < 0)
	{
		printf("Could not open the SPI device...\r\n");
		return (HAL_ERROR);
	}

	// Configure SPI mode
	hspi->fileReturn = ioctl(hspi->fileDevice, SPI_IOC_RD_MODE32, &(hspi->spi_state));
	if (hspi->fileReturn != 0)
	{
		printf("Could not read SPI mode...\r\n");
		close(hspi->fileDevice);
		return (HAL_ERROR);
	}
	hspi->spi_state |= SPI_MODE_0; // CPHA = 0; CPOL = 0;
	hspi->fileReturn = ioctl(hspi->fileDevice, SPI_IOC_WR_MODE32, &(hspi->spi_state));
	if (hspi->fileReturn != 0)
	{
		printf("Could not write SPI mode...\r\n");
		close(hspi->fileDevice);
		return (HAL_ERROR);
	}

	// Configure SPI Speed
	hspi->fileReturn = ioctl(hspi->fileDevice, SPI_IOC_RD_MAX_SPEED_HZ, &(hspi->spi_state));
	if (hspi->fileReturn != 0)
	{
		printf("Could not read the SPI max speed...\r\n");
		close(hspi->fileDevice);
		return (HAL_ERROR);
	}
	hspi->spi_state = 10000000;
	hspi->fileReturn = ioctl(hspi->fileDevice, SPI_IOC_WR_MAX_SPEED_HZ, &(hspi->spi_state));
	if (hspi->fileReturn != 0)
	{
		printf("Could not write the SPI max speed...\r\n");
		close(hspi->fileDevice);
		return (HAL_ERROR);
	}

	printf("Configurado exitosamente\n");

	// Configuration OK
	return (HAL_OK);
}

/* SPI close function */
int HAL_SPI_CLOSE(SPI_HandleTypeDef *hspi)
{
	// Close the SPI device
	close(hspi->fileDevice);

	// Configuration OK
	return (HAL_OK);
}

/* SPI AFE operation config ***************************************************/
