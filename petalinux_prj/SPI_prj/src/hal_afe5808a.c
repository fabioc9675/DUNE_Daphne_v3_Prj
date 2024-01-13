/**
 ******************************************************************************
 * @file    hal_afe5808a.c
 * @author  Fabian Castano
 * @brief   This file contains all the function prototypes for
 *          the hal_afe5808a.c file
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include "hal_afe5808a.h"

/* Handle --------------------------------------------------------------------*/
AFE_HandleTypeDef hafe0;
AFE_HandleTypeDef hafe1;
AFE_HandleTypeDef hafe2;
AFE_HandleTypeDef hafe3;
AFE_HandleTypeDef hafe4;

/* Extern Handle -------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/

/* TypeDef ------------------------------------------------------------------*/

/* Prototype -----------------------------------------------------------------*/

/* AFE0 init function */
void MX_AFE0_Init(void)
{

    hafe0.SPI_handle = &hafe0spi;
    // hafe0.CS_Port = AFE0_SEN_GPIO_Port;
    // hafe0.CS_Pin = AFE0_SEN_Pin;
    // hafe0.PDN_Port = AFE_PDN_P_GPIO_Port;
    // hafe0.PDN_Pin = AFE_PDN_P_Pin;
    // hafe0.RST_Port = AFE_RST_P_GPIO_Port;
    // hafe0.RST_Pin = AFE_RST_P_Pin;

    // // Instantiation  of Trim and Offset DACs
    // hafe0.AD_DACTrim = &hdac_trimAfe0;
    // hafe0.AD_DACOffset = &hdac_offsAfe0;

    // // initialization of SPI CS state
    // HAL_GPIO_WritePin(hafe0.CS_Port, hafe0.CS_Pin, CLR_CS);
    // HAL_GPIO_WritePin(hafe0.PDN_Port, hafe0.PDN_Pin, LOW_STATE);
    // HAL_GPIO_WritePin(hafe0.RST_Port, hafe0.RST_Pin, LOW_STATE);
}

/* AFE1 init function */
void MX_AFE1_Init(void)
{

    hafe1.SPI_handle = &hafe1spi;
    // hafe1.CS_Port = AFE1_SEN_GPIO_Port;
    // hafe1.CS_Pin = AFE1_SEN_Pin;
    // hafe1.PDN_Port = AFE_PDN_P_GPIO_Port;
    // hafe1.PDN_Pin = AFE_PDN_P_Pin;
    // hafe1.RST_Port = AFE_RST_P_GPIO_Port;
    // hafe1.RST_Pin = AFE_RST_P_Pin;

    // // Instantiation  of Trim and Offset DACs
    // hafe1.AD_DACTrim = &hdac_trimAfe1;
    // hafe1.AD_DACOffset = &hdac_offsAfe1;

    // // initialization of SPI CS state
    // HAL_GPIO_WritePin(hafe1.CS_Port, hafe1.CS_Pin, CLR_CS);
    // HAL_GPIO_WritePin(hafe1.PDN_Port, hafe1.PDN_Pin, LOW_STATE);
    // HAL_GPIO_WritePin(hafe1.RST_Port, hafe1.RST_Pin, LOW_STATE);
}

/* AFE2 init function */
void MX_AFE2_Init(void)
{

    hafe2.SPI_handle = &hafe2spi;
    // hafe2.CS_Port = AFE2_SEN_GPIO_Port;
    // hafe2.CS_Pin = AFE2_SEN_Pin;
    // hafe2.PDN_Port = AFE_PDN_P_GPIO_Port;
    // hafe2.PDN_Pin = AFE_PDN_P_Pin;
    // hafe2.RST_Port = AFE_RST_P_GPIO_Port;
    // hafe2.RST_Pin = AFE_RST_P_Pin;

    // // Instantiation  of Trim and Offset DACs
    // hafe2.AD_DACTrim = &hdac_trimAfe2;
    // hafe2.AD_DACOffset = &hdac_offsAfe2;

    // // initialization of SPI CS state
    // HAL_GPIO_WritePin(hafe2.CS_Port, hafe2.CS_Pin, CLR_CS);
    // HAL_GPIO_WritePin(hafe2.PDN_Port, hafe2.PDN_Pin, LOW_STATE);
    // HAL_GPIO_WritePin(hafe2.RST_Port, hafe2.RST_Pin, LOW_STATE);
}

/* AFE3 init function */
void MX_AFE3_Init(void)
{

    hafe3.SPI_handle = &hafe3spi;
    // hafe3.CS_Port = AFE3_SEN_GPIO_Port;
    // hafe3.CS_Pin = AFE3_SEN_Pin;
    // hafe3.PDN_Port = AFE_PDN_P_GPIO_Port;
    // hafe3.PDN_Pin = AFE_PDN_P_Pin;
    // hafe3.RST_Port = AFE_RST_P_GPIO_Port;
    // hafe3.RST_Pin = AFE_RST_P_Pin;

    // // Instantiation  of Trim and Offset DACs
    // hafe3.AD_DACTrim = &hdac_trimAfe3;
    // hafe3.AD_DACOffset = &hdac_offsAfe3;

    // // initialization of SPI CS state
    // HAL_GPIO_WritePin(hafe3.CS_Port, hafe3.CS_Pin, CLR_CS);
    // HAL_GPIO_WritePin(hafe3.PDN_Port, hafe3.PDN_Pin, LOW_STATE);
    // HAL_GPIO_WritePin(hafe3.RST_Port, hafe3.RST_Pin, LOW_STATE);
}

/* AFE4 init function */
void MX_AFE4_Init(void)
{

    hafe4.SPI_handle = &hafe4spi;
    // hafe4.CS_Port = AFE4_SEN_GPIO_Port;
    // hafe4.CS_Pin = AFE4_SEN_Pin;
    // hafe4.PDN_Port = AFE_PDN_P_GPIO_Port;
    // hafe4.PDN_Pin = AFE_PDN_P_Pin;
    // hafe4.RST_Port = AFE_RST_P_GPIO_Port;
    // hafe4.RST_Pin = AFE_RST_P_Pin;

    // // Instantiation  of Trim and Offset DACs
    // hafe4.AD_DACTrim = &hdac_trimAfe4;
    // hafe4.AD_DACOffset = &hdac_offsAfe4;

    // // initialization of SPI CS state
    // HAL_GPIO_WritePin(hafe4.CS_Port, hafe4.CS_Pin, CLR_CS);
    // HAL_GPIO_WritePin(hafe4.PDN_Port, hafe4.PDN_Pin, LOW_STATE);
    // HAL_GPIO_WritePin(hafe4.RST_Port, hafe4.RST_Pin, LOW_STATE);
}

/* Base functions */
/**
 * @brief  SPI Read Write Register AFE.
 * @param  hspi pointer to a SPI_HandleTypeDef structure that contains
 *               the configuration information for SPI module.
 * @param  pTxData pointer to transmission data buffer
 * @param  pRxData pointer to reception data buffer
 * @param  Size amount of data to be sent and received
 * @param  Timeout Timeout duration
 * @retval HAL status
 */
HAL_AFEStatusTypeDef HAL_AFEReadWriteRegister(AFE_HandleTypeDef *hafe,
                                              uint8_t regAddr, uint16_t *regDataW, uint16_t *regDataR,
                                              uint32_t Timeout)
{
    HAL_AFEStatusTypeDef errorcode = HAL_AFE_OK;

    uint8_t dataSize = 3;

    uint8_t dataW[dataSize];
    uint8_t dataR[dataSize];

    // Configure SPI
    errorcode = MX_SPI_AFE_OP_Config(hafe->SPI_handle);

    // decompose data
    dataW[0] = regAddr;
    dataW[1] = ((*regDataW) >> 8) & 0xFF;
    dataW[2] = (*regDataW) & 0xFF;

    // Activate device
    // Write data to the register
    (void)HAL_SPI_TransmitReceive(hafe->SPI_handle, dataW, dataR, dataSize, Timeout);
    // Deactivate device

    // Compose data
    *regDataR = (dataR[1] << 8) | dataR[2];

    return errorcode;
}

/**
 * @brief  Write data information into register.
 * @param  hspi pointer to a SPI_HandleTypeDef structure that contains
 *               the configuration information for SPI module.
 * @param  pTxData pointer to transmission data buffer
 * @param  pRxData pointer to reception data buffer
 * @param  Size amount of data to be sent and received
 * @param  Timeout Timeout duration
 * @retval HAL status
 *
 */
HAL_AFEStatusTypeDef HAL_AFEWriteRegister(AFE_HandleTypeDef *hafe,
                                          uint8_t regAddr, uint16_t *regDataW)
{

    HAL_AFEStatusTypeDef errorcode = HAL_AFE_OK;

    // definition of variables to discard
    uint16_t dataR = 0;

    // Configure AFE to write operation (verify if can to omit this step)
    hafe->ADCRegisterMap.REG00bits.REGISTER_READOUT_ENABLE = WRITE_ENABLE;
    errorcode = HAL_AFEReadWriteRegister(hafe, AFE_REG00,
                                         (uint16_t *)(&hafe->ADCRegisterMap.REG00bits), &dataR, 0xFF);
    if (errorcode != HAL_AFE_OK)
    {
        return errorcode;
    }
    // write register ADDR
    errorcode = HAL_AFEReadWriteRegister(hafe, regAddr, regDataW, &dataR, 0xFF);
    if (errorcode != HAL_AFE_OK)
    {
        return errorcode;
    }

    return errorcode;
}

/**
 * @brief  Read data information from register.
 * @param  hspi pointer to a SPI_HandleTypeDef structure that contains
 *               the configuration information for SPI module.
 * @param  pTxData pointer to transmission data buffer
 * @param  pRxData pointer to reception data buffer
 * @param  Size amount of data to be sent and received
 * @param  Timeout Timeout duration
 * @retval HAL status
 */
HAL_AFEStatusTypeDef HAL_AFEReadRegister(AFE_HandleTypeDef *hafe,
                                         uint8_t regAddr, uint16_t *regDataR)
{

    HAL_AFEStatusTypeDef errorcode = HAL_AFE_OK;

    // definition of variables to discard
    uint16_t dataR = 0;
    uint16_t dataW = 0;

    // Configure AFE to read operation
    hafe->ADCRegisterMap.REG00bits.REGISTER_READOUT_ENABLE = READ_ENABLE;
    errorcode = HAL_AFEReadWriteRegister(hafe, AFE_REG00,
                                         (uint16_t *)(&hafe->ADCRegisterMap.REG00bits), &dataR, 0xFF);
    if (errorcode != HAL_AFE_OK)
    {
        return errorcode;
    }
    // read register ADDR
    errorcode = HAL_AFEReadWriteRegister(hafe, regAddr, &dataW, regDataR, 0xFF);
    if (errorcode != HAL_AFE_OK)
    {
        return errorcode;
    }
    // Configure AFE to write operation
    hafe->ADCRegisterMap.REG00bits.REGISTER_READOUT_ENABLE = WRITE_ENABLE;
    errorcode = HAL_AFEReadWriteRegister(hafe, AFE_REG00,
                                         (uint16_t *)(&hafe->ADCRegisterMap.REG00bits), &dataR, 0xFF);
    if (errorcode != HAL_AFE_OK)
    {
        return errorcode;
    }

    return errorcode;
}

/* ---------------------------------------------------------------------------------------- */
/* - SPI AFE OPERATION CONFIG ------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------- */

/* SPIx DAC operation config function */
HAL_AFEStatusTypeDef MX_SPI_AFE_OP_Config(SPI_HandleTypeDef *hspi)
{

    HAL_AFEStatusTypeDef errorcode = HAL_AFE_OK;

    // Configure SPI mode
    hspi->fileReturn = ioctl(hspi->fileDevice, SPI_IOC_RD_MODE32, &(hspi->spi_state));
    if (hspi->fileReturn != 0)
    {
        printf("Could not read SPI mode...\r\n");
        // close(hspi->fileDevice);
        errorcode = HAL_AFE_ERROR;
        return (errorcode);
    }
    hspi->spi_state |= SPI_MODE_0; // CPHA = 0; CPOL = 0;
    hspi->fileReturn = ioctl(hspi->fileDevice, SPI_IOC_WR_MODE32, &(hspi->spi_state));
    if (hspi->fileReturn != 0)
    {
        printf("Could not write SPI mode...\r\n");
        // close(hspi->fileDevice);
        errorcode = HAL_AFE_ERROR;
        return (errorcode);
    }

    return (errorcode);
}
