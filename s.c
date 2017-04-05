#include<unistd.h>

int main(int argc, char** argv)
{
	argv[0]="sudo";
	execvp(argv[0],argv);
}
