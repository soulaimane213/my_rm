#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>



void check_flag( int *v_flag , int *r_flag , int *i_flag , char **av , int *i){

	int j =0;
	
	while(av[j] != NULL) {


		if(  strcmp(av[j] , "-i") == 0 ) {

			*i_flag = 1;
			
			(*i)++;

		}else if(strcmp(av[j] , "-v") == 0){
			
			*v_flag =1;
			(*i)++;

		}else if(strcmp(av[j] , "-r") == 0) {
			
			*r_flag =1;
			(*i)++;
		}

		j++;

	}

}


void delete_files(char *path , int i_flag , int v_flag){


	char response[2];

	if(i_flag == 1) {
		printf("hey do you wana really remove this file: %s\n" , path);
	
		scanf("%s" , response);

		if(response[0] == 'y' || response[0] == 'Y') {
			unlink(path);
		
			if(v_flag == 1) {
				printf("'%s' deleted!\n" , path);
				return;
			}


		}else {
			return;
		}
	}else {

		unlink(path);
		if(v_flag == 1) {
			printf("'%s' deleted!\n" , path);
			return;
		}



	}



}


void delete_directories( char *path , int r_flag , int i_flag , int v_flag)  {


	if(r_flag == 0) {
		printf("you need -r flag!!!!");
		return;
	}
	
	struct stat st;

	
	if(lstat(path , &st) == -1){
		printf("there is a probleme on this element %s\n" ,path);	
	}
	


	if(S_ISREG(st.st_mode)) {
		delete_files( path ,  i_flag , v_flag);	
		return ;
	}



	// syntax DIR *opendir(const char *dirname);

	DIR *d = opendir(path);
	struct dirent *e;
	
	while( (e = readdir(d)) != NULL) {

		if(strcmp(e->d_name, ".") == 0 || strcmp(e->d_name , "..") == 0){
			continue;
		}
		
		char new_path[1024];
		sprintf(new_path ,"%s/%s" , path , e->d_name); //root/file1.txt
		delete_directories(new_path , r_flag , i_flag , v_flag);
	}

	char response[2];

	if(i_flag == 1) {
		printf("hey do you wana really remove this directory: %s\n" , path);
	
		scanf("%s" , response);

		if(response[0] == 'y' || response[0] == 'Y') {
			rmdir(path);
		
			if(v_flag == 1) {
				printf("'%s' deleted!\n" , path);
				return;
			}


		}else {
			return;
		}
	}else {

		rmdir(path);
		if(v_flag == 1) {
			printf("we deleted this folder %s" , path);
			return;
		}

	}
	

}




int main( int ac , char **av) {



	int r_flag =0;
	int v_flag =0;
	int i_flag =0;
	int i =1 ;
	struct stat st;


	if(ac < 2) {
		printf("the usage: rm <file1> <file2> ..!");
		return 0;
	}


	check_flag( &v_flag , &r_flag , &i_flag , av  , &i);


	while(av[i]!= NULL) {


		
		if(lstat(av[i] , &st) == -1){
			printf("there is a probleme on this element %s\n" ,av[i]);	
		}
	
		if(S_ISDIR(st.st_mode)) {
			delete_directories(av[i] , r_flag , i_flag , v_flag);	
		}
	
		if(S_ISREG(st.st_mode)) {
			delete_files( av[i] ,  i_flag , v_flag);	

		}





		i++;
	}











}
