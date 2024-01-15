#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/gpio.h>

#define GPIO_CHIP_PATH "/dev/gpiochip3"  // Ajusta esto según tu configuración

int gpio_chip_on() {
    int fd, ret;
    struct gpiochip_info chip_info;
    struct gpiohandle_request req;

    // Abre el archivo del chip GPIO
    fd = open(GPIO_CHIP_PATH, 0);
    if (fd < 0) {
        perror("Error al abrir el chip GPIO");
        return -1;
    }

    // Obtiene información sobre el chip GPIO
    ret = ioctl(fd, GPIO_GET_CHIPINFO_IOCTL, &chip_info);
    if (ret < 0) {
        perror("Error al obtener información del chip GPIO");
        close(fd);
        return -1;
    }

    printf("Chip GPIO: %s, línea máxima: %u\n", chip_info.name, chip_info.lines);

    // Configura la solicitud para el pin GPIO específico que deseas usar
    req.lineoffsets[0] = 7;  // Ajusta esto según tu configuración
    req.lineoffsets[1] = 5;  // Ajusta esto según tu configuración
    req.lines = 2;
    req.flags = GPIOHANDLE_REQUEST_OUTPUT;  // Puedes cambiar esto según tus necesidades

    // Envía la solicitud
    ret = ioctl(fd, GPIO_GET_LINEHANDLE_IOCTL, &req);
    if (ret < 0) {
        perror("Error al obtener el controlador del pin GPIO");
        close(fd);
        return -1;
    }

    // Realiza operaciones GPIO, por ejemplo, establecer el estado del pin
    struct gpiohandle_data data;
    data.values[0] = 1;  // Establece el estado del pin a alto
    data.values[1] = 1;  // Establece el estado del pin a alto
    ret = ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);

    if (ret < 0) {
        perror("Error al establecer el valor del pin GPIO");
    }

    // Cierra el controlador del pin GPIO
    close(req.fd);

    // Cierra el archivo del chip GPIO
    close(fd);

    return 0;
}

int gpio_chip_off() {
    int fd, ret;
    struct gpiochip_info chip_info;
    struct gpiohandle_request req;

    // Abre el archivo del chip GPIO
    fd = open(GPIO_CHIP_PATH, 0);
    if (fd < 0) {
        perror("Error al abrir el chip GPIO");
        return -1;
    }

    // Obtiene información sobre el chip GPIO
    ret = ioctl(fd, GPIO_GET_CHIPINFO_IOCTL, &chip_info);
    if (ret < 0) {
        perror("Error al obtener información del chip GPIO");
        close(fd);
        return -1;
    }

    printf("Chip GPIO: %s, línea máxima: %u\n", chip_info.name, chip_info.lines);

    // Configura la solicitud para el pin GPIO específico que deseas usar
    req.lineoffsets[0] = 7;  // Ajusta esto según tu configuración
    req.lineoffsets[1] = 5;  // Ajusta esto según tu configuración
    req.lines = 2;
    req.flags = GPIOHANDLE_REQUEST_OUTPUT;  // Puedes cambiar esto según tus necesidades

    // Envía la solicitud
    ret = ioctl(fd, GPIO_GET_LINEHANDLE_IOCTL, &req);
    if (ret < 0) {
        perror("Error al obtener el controlador del pin GPIO");
        close(fd);
        return -1;
    }

    // Realiza operaciones GPIO, por ejemplo, establecer el estado del pin
    struct gpiohandle_data data;
    data.values[0] = 0;  // Establece el estado del pin a alto
    data.values[1] = 0;  // Establece el estado del pin a alto
    ret = ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);

    if (ret < 0) {
        perror("Error al establecer el valor del pin GPIO");
    }

    // Cierra el controlador del pin GPIO
    close(req.fd);

    // Cierra el archivo del chip GPIO
    close(fd);

    return 0;
}