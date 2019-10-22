/*
 * test_board
 *
 * main.c
 *
 */


#include "system.h"
#include "unistd.h"
#include "stdio.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_spi.h"

#include "sdram_test.h"

void init_g_sen();

int main()
{
	unsigned char wdata[1];
	unsigned char rdata[2];
	unsigned char led_out = 0x18;

	alt_8 x_value = 0;			// create buffer for filtering
	alt_8 x_value_1 = 0;
	alt_8 x_value_2 = 0;
	alt_8 x_value_3 = 0;
	alt_8 x_value_4 = 0;
	alt_8 x_value_5 = 0;

	alt_8 mode;
	alt_8 n_mode = 0x00;

	test_sdram();				//SDRAM memory test

	init_g_sen();
	wdata[0]=0xC0 | 0x28;		// read y-register and increment

	printf("\n\n================== LED sequences ==================\n");
	printf("Toggle between following LED sequences by pressing\n");
	printf("the user button:\n\n");
	printf("1. Spirit level\n");
	printf("2. Case statement sequence\n");
	printf("3. Shift register sequence\n");
	printf("4. Knightrider sequence\n");
	printf("5. Pulse-width modulation sequence\n");
	printf("\nCurrent LED sequence:\n");

	while (1)
	{
		mode = IORD_ALTERA_AVALON_PIO_DATA(PIO_MODE_BASE);

		if (mode != n_mode)
		{
			switch(mode)
			{
			case 0x01: printf("Mode = %d => Spirit level\n", mode); break;
			case 0x02: printf("Mode = %d => Case statement sequence\n", mode); break;
			case 0x03: printf("Mode = %d => Shift register sequence\n", mode); break;
			case 0x04: printf("Mode = %d => Knightrider sequence\n", mode); break;
			case 0x05: printf("Mode = %d => Pulse-width modulation sequence\n", mode); break;
			default: printf("Error: Select mode failed\n"); break;
			}
			n_mode = mode;
		}

		if(mode == 0x01)
		{
			// read y-axis data from g-sensor
			alt_avalon_spi_command (SPI_G_SENSOR_BASE, 0, 1, wdata, 2, rdata, 0);

			// calculate average
			x_value_5 = x_value_4;
			x_value_4 = x_value_3;
			x_value_3 = x_value_2;
			x_value_2 = x_value_1;
			x_value_1 = rdata[1];

			x_value = (x_value_1 + x_value_2 + x_value_3 + x_value_4 + x_value_5) / 5;

			// determine LED setting according to y-axis value
			if (x_value > -4 && x_value < 4)
				led_out = 0x18;
			if (x_value >= 4 && x_value < 8)
				led_out = 0x08;
			if (x_value >= 8 && x_value < 12)
				led_out = 0x04;
			if (x_value >= 12 && x_value < 16)
				led_out = 0x02;
			if (x_value >= 16)
				led_out = 0x01;
			if (x_value > -8 && x_value <= -4)
				led_out = 0x10;
			if (x_value > -12 && x_value <= -8)
				led_out = 0x20;
			if (x_value > -16 && x_value <= -12)
				led_out = 0x40;
			if (x_value <= -16)
				led_out = 0x80;

			// set LED
			IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, led_out);

			// wait 10 ms
			usleep(10000);
		}
	}
	return 0;
}

void init_g_sen()
{
	unsigned char wdata[3];
	unsigned char rdata[1];

	wdata[0]= 0x40 | 0x20;		// write multiple bytes with start address 0x20
	wdata[1]= 0x37;				// 25Hz mode, low power off, enable axis Z Y X
	wdata[2]= 0x00;				// all filters disabled

	alt_avalon_spi_command (SPI_G_SENSOR_BASE, 0, 3, wdata, 0, rdata, 0);

	wdata[0]= 0x40 | 0x22;		// write multiple bytes with start address 0x22
	wdata[1]= 0x00;				// all interrupts disabled
	wdata[2]= 0x00;				// continous update, little endian, 2g full scale, high resolution disabled, self test disabled, 4 wire SPI

	alt_avalon_spi_command (SPI_G_SENSOR_BASE, 0, 3, wdata, 0, rdata, 0);
}

