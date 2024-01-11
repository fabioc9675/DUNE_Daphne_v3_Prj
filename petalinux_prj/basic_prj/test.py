# test.py
import ctypes
import time

# Cargar la biblioteca compartida
my_library = ctypes.CDLL('./libmylibrary.so')

# Declarar el tipo de los argumentos y del resultado de la función HAL_Spi_ReadWrite
#my_library.HAL_Spi_ReadWrite.argtypes = [ctypes.POINTER(ctypes.c_int), ctypes.POINTER(ctypes.c_int), ctypes.c_int]
my_library.HAL_Spi_ReadWrite.restype = ctypes.c_int

tx_buf = (ctypes.c_char * 4)('A'.encode('utf-8'),2,3,4)
rx_buf = (ctypes.c_char * 4)()

status = my_library.HAL_Spi_ReadWrite(ctypes.byref(tx_buf), ctypes.byref(rx_buf), 4)

if status == 0:
    print("Operación realizada correctamente.")
    print("Datos recibidos:", list(rx_buf))
else:
    print("Error:", status)

tx_buf = (ctypes.c_char * 4)('F'.encode('utf-8'),9,8,7)
rx_buf = (ctypes.c_char * 4)()

status = my_library.HAL_Spi_ReadWrite(ctypes.byref(tx_buf), ctypes.byref(rx_buf), 4)

if status == 0:
    print("Operación realizada correctamente.")
    print("Datos recibidos:", list(rx_buf))
else:
    print("Error:", status)


# Declarar el tipo de los argumentos y del resultado de la función sum
my_library.sum.argtypes = [ctypes.c_int, ctypes.c_int]
my_library.sum.restype = ctypes.c_int

# Llamar a la función de suma
result = my_library.sum(5, 7)
print("Suma desde C:", result)

# Llamar a la otra función desde C
my_library.my_function()

# turn on gpio
my_library.gpio_chip_on()
time.sleep(1)
my_library.gpio_chip_off()

