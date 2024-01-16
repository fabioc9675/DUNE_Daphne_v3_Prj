#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

// Función para cambiar el estado de la línea de Chip Select

void config_cs(int gpio_pin) {
    char buffer[256];
    int fd;

    // Configurar el pin GPIO como salida
    snprintf(buffer, sizeof(buffer), "/sys/class/gpio/gpio%d/direction", gpio_pin);
    printf("%s\n", buffer);
    fd = open(buffer, O_WRONLY);
    write(fd, "out", 3);
    close(fd);
    
    return;
}

void set_cs(int gpio_pin, int value) {
    char buffer[256];
    int fd;

    // // Configurar el pin GPIO como salida
    // snprintf(buffer, sizeof(buffer), "/sys/class/gpio/gpio%d/direction", gpio_pin);
    // fd = open(buffer, O_WRONLY);
    // write(fd, "out", 3);
    // close(fd);

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
