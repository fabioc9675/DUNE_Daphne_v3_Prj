# test.py
import ctypes

# Cargar la biblioteca compartida
my_library = ctypes.CDLL('./libmylibrary.so')

# Declarar el tipo de los argumentos y del resultado de la función sum
my_library.sum.argtypes = [ctypes.c_int, ctypes.c_int]
my_library.sum.restype = ctypes.c_int

# Llamar a la función de suma
result = my_library.sum(5, 7)
print("Suma desde C:", result)

# Llamar a la otra función desde C
my_library.my_function()