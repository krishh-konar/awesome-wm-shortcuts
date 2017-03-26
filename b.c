#include<unistd.h>
#include<stdio.h>

int main(int argc, char ** argv)
{
	int b=atoi(argv[1]);
	b=(int)(4882*(float)b/100);
	printf("%d\n",b);
	FILE *fp;
	fp=fopen("/sys/class/backlight/intel_backlight/brightness","w");
	fprintf(fp,"%d",b);
	fclose(fp);
}
