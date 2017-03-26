#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>

int main(int argc, char ** argv)
{
	char* args[7];
	char t[5];
	args[0]="amixer";
	args[1]="-D";
	args[2]="pulse";
	args[3]="sset";
	args[4]="Master";
	sprintf(t,"%d%c",atoi(argv[1]),37);
	printf("%s\n",t);
	args[5]=t;
	if(argv[1][0]=='m')
	args[5]="mute";
	else if(argv[1][0]=='u')
	args[5]="unmute";
	args[6]=NULL;
	execvp(args[0],args);
}
