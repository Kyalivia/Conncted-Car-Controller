#include "navigation.h"

extern FATFS fs;
extern FIL fil;


int checkSD(char *input)
{	
	char buffer[100];
	char str1[100];
	char str2[100];
	char city[20];
	int lat, lon;
	char lat_dir, lon_dir;
	
	if (f_open(&fil, "city.txt", FA_READ) == FR_OK)
	{
		while(f_gets(buffer, sizeof(buffer), &fil))
		{
			// check city line
			sscanf(buffer, "%[^,], %d%c, %d%c", city, &lat, &lat_dir, &lon, &lon_dir);
			// find input city
			if(strcmp(input, city) == 0)
			{
				// return (1);
				lcdClearDisplay();
				// To: seoul
				lcdSetCursor(0, 0);
				sprintf(str1, "To: %s", city);
				lcdSendString(str1);
				// 37N, 126E  
				lcdSetCursor(1, 0);
				sprintf(str2, "%d%c, %d%c", lat, lat_dir, lon, lon_dir);
				lcdSendString(str2);
				HAL_Delay(1000);
				return(1);
			}
		}
		f_close(&fil);
	}
	return (0);
}

void findLocation(char *input)
{
	if (!checkSD(input))
	{
		lcdClearDisplay();
		lcdSetCursor(0, 0);
		lcdSendString("Not Found");
	}
}


	