/*
 * daphne_afe_hal.c
 *
 *  Created on: Jun 20, 2021
 *      Author: Juan Vega
 */

#include "daphne_afe_hal.h"

extern AFE_HandleTypeDef hafe0;
extern AFE_HandleTypeDef hafe1;
extern AFE_HandleTypeDef hafe2;
extern AFE_HandleTypeDef hafe3;
extern AFE_HandleTypeDef hafe4;

extern SPI_Emul_HandleTypeDef SpiEmulHandle;

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

void AFEx_config(void){
	MX_AFE0_Init();
	MX_AFE1_Init();
	MX_AFE2_Init();
	MX_AFE3_Init();
	MX_AFE4_Init();
}

void AFEx_Init(void){

	MX_SPI_Emul_Init();
	MX_AD_DAC_BIASSET_Init();
	MX_AD_DAC_AFE0_Init();
	MX_AD_DAC_AFE1_Init();
	MX_AD_DAC_AFE2_Init();
	MX_AD_DAC_AFE3_Init();
	MX_AD_DAC_AFE4_Init();

	// Load AFE Initial Configuration
	HAL_AFE_InitialConfig(&hafe0);
	HAL_AFE_InitialConfig(&hafe1);
	HAL_AFE_InitialConfig(&hafe2);
	HAL_AFE_InitialConfig(&hafe3);
	HAL_AFE_InitialConfig(&hafe4);

}

