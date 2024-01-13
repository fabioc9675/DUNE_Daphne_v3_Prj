# test.py
import ctypes
import time

# Cargar la biblioteca compartida
my_library = ctypes.CDLL('./afe5808a_lib.so')

my_library.MX_SPI3_Init() # Initialize the SPI driver
my_library.MX_AFE0_Init() # Initialize the AFE0

# Send the configuration sequence for AFE 0
my_library.HAL_AFE_InitialConfig(my_library.hafe0)

