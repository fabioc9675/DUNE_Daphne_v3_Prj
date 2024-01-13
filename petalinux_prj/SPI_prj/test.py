# test.py
import ctypes
import time
from afe5808a import *

# Cargar la biblioteca compartida
my_library = ctypes.CDLL('./afe5808a_lib.so')

my_library.MX_SPI3_Init() # Initialize the SPI driver
my_library.MX_AFE0_Init() # Initialize the AFE0

# Send the configuration sequence for AFE 0
my_library.HAL_AFE_InitialConfig(my_library.hafe0)

# Accede a la instancia de la estructura (en este caso, hafe0)
hafe0 = my_library.hafe0

# Convierte la instancia a la estructura definida en Python
hafe0_py = ctypes.cast(hafe0, ctypes.POINTER(AFE_HandleTypeDef)).contents

# Cambia el valor del regitro
hafe0_py.ADCRegisterMap.REG03bits.DIGITAL_GAIN_ENABLE = 1
my_library.HAL_AFEWriteRegister(hafe0, 3, ctypes.byref(hafe0_py.ADCRegisterMap.REG03bits))

my_library.MX_SPI3_Deinit() # Initialize the SPI driver


# Accede a los campos de la estructura
print("CS Pin:", hafe0_py.SPI_handle.SPI_Device.decode("utf-8"))
# Accede a más campos según sea necesario...