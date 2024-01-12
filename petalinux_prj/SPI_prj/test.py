# test.py
import ctypes
import time

# Cargar la biblioteca compartida
my_library = ctypes.CDLL('./afe5808_lib.so')

# Declarar el tipo de los argumentos y del resultado de la función HAL_Spi_ReadWrite
#my_library.HAL_Spi_ReadWrite.argtypes = [ctypes.POINTER(ctypes.c_int), ctypes.POINTER(ctypes.c_int), ctypes.c_int]
#my_library.HAL_Spi_ReadWrite.restype = ctypes.c_int


my_library.MX_SPI3_Init()
my_library.MX_SPI4_Init()