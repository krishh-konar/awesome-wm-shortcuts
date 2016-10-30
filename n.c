#include<unistd.h>

int main()
{
	char *args[3];
	args[0]="nautilus";
	args[1]="--no-desktop";
	args[2]=NULL;
	execvp(args[0],args);
}