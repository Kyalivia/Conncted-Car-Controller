#include "test.h"

// navgation 
extern FATFS fs;
extern FIL fil;


/* TEMPERATURE TEST */

/* FAN TEST */


/* MP3 TEST */
void mp3PlayTest()
{
	mp3Play(2);
	HAL_Delay(2000);
	mp3Play(5);
	HAL_Delay(2000);
	mp3Play(8);
	HAL_Delay(2000);
}

void mp3ControlTest()
{
	mp3Previous();
	HAL_Delay(2000);
	mp3Previous();
	HAL_Delay(2000);
	mp3Next();
	HAL_Delay(2000);
	
	mp3Stop();
	HAL_Delay(2000);
	mp3Play(5); // Stopped -> 5 is fake value to fit in function
	HAL_Delay(2000);

	mp3DecreaseVolume();
	HAL_Delay(2000);
	mp3IncreaseVolume();
	HAL_Delay(2000);
}

/* LCD TEST */
/* lcd output test */
void lcdOutputTest()
{
	lcdClearDisplay();
	lcdSetCursor(0, 0);
	lcdSendString("Hello World!");
}


/* NAVIAGATION(SD) TEST */
/* sd card test - read city.txt */
void navSdReadTest()
{
	char buffer[100];
	if (f_open(&fil, "city.txt", FA_READ) == FR_OK)
	{
		while(f_gets(buffer, sizeof(buffer), &fil))
		{
			lcdClearDisplay();
			lcdSetCursor(0, 0);
			lcdSendString(buffer);
			HAL_Delay(1000);
		}
		f_close(&fil);
	}
}


/* find Location in sd test */
void navFindLocationTest()
{
	// O
	findLocation("seoul");
	HAL_Delay(1000);
	// X
	findLocation("jej");
	HAL_Delay(1000);
	// O
	findLocation("busan");
	HAL_Delay(1000);
}


/* check key input and find test */
void navCommandTest()
{
	// O - seoul
	handleNavCommand('1');handleNavCommand('s');handleNavCommand('e');handleNavCommand('o');handleNavCommand('u');handleNavCommand('l'); handleNavCommand('0');
	HAL_Delay(1000);
	// X - jej
	handleNavCommand('1');handleNavCommand('j');handleNavCommand('e');handleNavCommand('j');handleNavCommand('0');
	HAL_Delay(1000);
	// O - busan
	handleNavCommand('1');handleNavCommand('b');handleNavCommand('u');handleNavCommand('s');handleNavCommand('a');handleNavCommand('n'); handleNavCommand('0');
	HAL_Delay(1000);
}
