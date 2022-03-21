#include<stdio.h>
#include<stdlib.h>

void printd(int number){
	int aux = number%10;
	if(number > 10)printd(number/10);
	printf("%c", aux+48);
}

int main(int argc, char **argv){
	printd(354);
	return 0;
}
