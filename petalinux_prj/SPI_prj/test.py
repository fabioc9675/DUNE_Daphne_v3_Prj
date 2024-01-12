# test.py
import ctypes
import time

# Cargar la biblioteca compartida
my_library = ctypes.CDLL('./afe5808_lib.so')

# Declarar el tipo de los argumentos y del resultado de la función HAL_Spi_ReadWrite
#my_library.HAL_Spi_ReadWrite.argtypes = [ctypes.POINTER(ctypes.c_int), ctypes.POINTER(ctypes.c_int), ctypes.c_int]
#my_library.HAL_Spi_ReadWrite.restype = ctypes.c_int

tx_buf = (ctypes.c_char * 4)('A'.encode('utf-8'),2,3,4)
rx_buf = (ctypes.c_char * 4)()

my_library.MX_SPI3_Init()
# my_library.SPI3_TransmitReceive(ctypes.byref(tx_buf), ctypes.byref(rx_buf), 4)
my_library.MX_SPI3_Deinit()