# test.py
import ctypes
import time
from afe5808a import *

# Cargar la biblioteca compartida
my_library = ctypes.CDLL('./afe5808a_lib.so')

# Peropheral config
my_library.MX_GPIO_Init() # Initialize the GPIO driver
my_library.MX_SPI3_Init() # Initialize the SPI driver
my_library.MX_SPI4_Init() # Initialize the SPI driver
my_library.MX_SPI5_Init() # Initialize the SPI driver
my_library.MX_SPI6_Init() # Initialize the SPI driver

# AFE Initialization
my_library.MX_AFE0_Init() # Initialize the AFE0
my_library.MX_AFE1_Init() # Initialize the AFE1
my_library.MX_AFE2_Init() # Initialize the AFE2
my_library.MX_AFE3_Init() # Initialize the AFE3
my_library.MX_AFE4_Init() # Initialize the AFE4

# DACs Initialization
my_library.MX_AD_DAC_BIASSET_Init()
my_library.MX_AD_DAC_AFE0_Init()
my_library.MX_AD_DAC_AFE1_Init()
my_library.MX_AD_DAC_AFE2_Init()
my_library.MX_AD_DAC_AFE3_Init()
my_library.MX_AD_DAC_AFE4_Init()

# Send the configuration sequence for AFE 0
my_library.HAL_AFE_InitialConfig(my_library.hafe0)
my_library.HAL_AFE_InitialConfig(my_library.hafe1)
my_library.HAL_AFE_InitialConfig(my_library.hafe2)
my_library.HAL_AFE_InitialConfig(my_library.hafe3)
my_library.HAL_AFE_InitialConfig(my_library.hafe4)

time.sleep(0.01)

# Send config for DACs
my_library.HAL_DAC1TrimOffset_SetValue(my_library.hdac_trimAfe0, 0, 20)
time.sleep(0.01)
my_library.HAL_DAC2TrimOffset_SetValue(my_library.hdac_trimAfe0, 2, 50)
time.sleep(0.01)
my_library.HAL_DAC1BiasSet_SetValue(my_library.hdac_biasset, 0, 32)
time.sleep(0.01)

# Accede a la instancia de la estructura (en este caso, hafe0)
hafe0 = my_library.hafe0

# Convierte la instancia a la estructura definida en Python
hafe0_py = ctypes.cast(hafe0, ctypes.POINTER(AFE_HandleTypeDef)).contents

# Cambia el valor del regitro
hafe0_py.ADCRegisterMap.REG03bits.DIGITAL_GAIN_ENABLE = 1
my_library.HAL_AFEWriteRegister(hafe0, 3, ctypes.byref(hafe0_py.ADCRegisterMap.REG03bits))

readData = (ctypes.c_uint16)(0)
my_library.HAL_AFEReadRegister(hafe0, 3, ctypes.byref(readData))
print("REG03bits = ", readData)

# Cerrar el SPI device
my_library.MX_SPI3_Deinit() # Initialize the SPI driver
my_library.MX_SPI4_Deinit() # Initialize the SPI driver
my_library.MX_SPI5_Deinit() # Initialize the SPI driver
my_library.MX_SPI6_Deinit() # Initialize the SPI driver

# Accede a los campos de la estructura
# print("CS Pin:", hafe0_py.SPI_handle.SPI_Device.decode("utf-8"))
# Accede a más campos según sea necesario...