#include<unistd.h>

int main()
{
	char *args[4];
	args[0]="shutdown";
	args[1]="-h";
	args[2]="now";
	args[3]=NULL;
	execvp(args[0],args);
}
