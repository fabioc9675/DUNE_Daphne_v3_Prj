/**
 ******************************************************************************
 * @file    hal_gpio.c
 * @author  Fabian Castano
 * @brief   This file contains all the function prototypes for
 *          the hal_gpio.c file
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include "hal_gpio.h"

/* Handle --------------------------------------------------------------------*/

/* Registers -----------------------------------------------------------------*/

/* Variables -----------------------------------------------------------------*/

/* Prototype -----------------------------------------------------------------*/

/* GPIO init functions */
void MX_GPIO_Init(void)
{

    // AFE Pins
    HAL_GPIO_PinOut_Init(PDN_AFE0);
    HAL_GPIO_PinOut_Init(PDN_AFE1);
    HAL_GPIO_PinOut_Init(PDN_AFE2);
    HAL_GPIO_PinOut_Init(PDN_AFE3);
    HAL_GPIO_PinOut_Init(PDN_AFE4);

    HAL_GPIO_PinOut_Init(RST_AFE0);
    HAL_GPIO_PinOut_Init(RST_AFE1);
    HAL_GPIO_PinOut_Init(RST_AFE2);
    HAL_GPIO_PinOut_Init(RST_AFE3);
    HAL_GPIO_PinOut_Init(RST_AFE4);

    HAL_GPIO_PinOut_Init(SEN_AFE0);
    HAL_GPIO_PinOut_Init(SEN_AFE1);
    HAL_GPIO_PinOut_Init(SEN_AFE2);
    HAL_GPIO_PinOut_Init(SEN_AFE3);
    HAL_GPIO_PinOut_Init(SEN_AFE4);

    // DAC Pins
    HAL_GPIO_PinOut_Init(LDAC_BIAS);
    HAL_GPIO_PinOut_Init(SYNC_BIAS);

    HAL_GPIO_PinOut_Init(LDAC_TRM_DAC0);
    HAL_GPIO_PinOut_Init(LDAC_TRM_DAC1);
    HAL_GPIO_PinOut_Init(LDAC_TRM_DAC2);
    HAL_GPIO_PinOut_Init(LDAC_TRM_DAC3);
    HAL_GPIO_PinOut_Init(LDAC_TRM_DAC4);

    HAL_GPIO_PinOut_Init(SYNC_TRM_DAC0);
    HAL_GPIO_PinOut_Init(SYNC_TRM_DAC1);
    HAL_GPIO_PinOut_Init(SYNC_TRM_DAC2);
    HAL_GPIO_PinOut_Init(SYNC_TRM_DAC3);
    HAL_GPIO_PinOut_Init(SYNC_TRM_DAC4);

    HAL_GPIO_PinOut_Init(LDAC_OFF_DAC0);
    HAL_GPIO_PinOut_Init(LDAC_OFF_DAC1);
    HAL_GPIO_PinOut_Init(LDAC_OFF_DAC2);
    HAL_GPIO_PinOut_Init(LDAC_OFF_DAC3);
    HAL_GPIO_PinOut_Init(LDAC_OFF_DAC4);

    HAL_GPIO_PinOut_Init(SYNC_OFF_DAC0);
    HAL_GPIO_PinOut_Init(SYNC_OFF_DAC1);
    HAL_GPIO_PinOut_Init(SYNC_OFF_DAC2);
    HAL_GPIO_PinOut_Init(SYNC_OFF_DAC3);
    HAL_GPIO_PinOut_Init(SYNC_OFF_DAC4);

    return;
}

/* GPIO init functions */
void HAL_GPIO_PinOut_Init(int gpio_pin)
{
    char buffer[256];
    int fd;

    // Configurar el pin GPIO como salida
    snprintf(buffer, sizeof(buffer), "/sys/class/gpio/gpio%d/direction", gpio_pin);
    // printf("%s\n", buffer);
    fd = open(buffer, O_WRONLY);
    write(fd, "out", 3);
    close(fd);

    return;
}

/* GPIO state functions */
void HAL_GPIO_WritePin(int gpio_port, int gpio_pin, int value)
{
    char buffer[256];
    int fd;

    // Establecer el valor del pin GPIO
    snprintf(buffer, sizeof(buffer), "/sys/class/gpio/gpio%d/value", gpio_pin);
    printf("%s\n", buffer);
    fd = open(buffer, O_WRONLY);
    if (value)
        write(fd, "1", 1);
    else
        write(fd, "0", 1);
    close(fd);

    return;
}
