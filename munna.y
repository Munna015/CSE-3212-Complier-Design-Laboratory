/*C declarations (types, variables, functions, preprocessor commands)*/

%{
	#include<stdio.h>
	# include <stdlib.h>
	# include <stdarg.h>
	# include <string.h>
	# include <math.h>
	int yylex(void);
	int check[100],int_val[1000],var_type[1000],vn=0;
	float float_val[1000];
	char char_val[1000],var_store[1000][1000],string_val[1000][1000];
	int caseD,caseV;
	
	
	int is_exist(char *str)
	{
	  for(int i=0;i<vn;i++)
	  {
	  if(strcmp(str,var_store[i])==0)
	  {
	   return i;
	   }
	   
	   }
	   return -1;
	 }
	void store(char *str)
	{
	strcpy(var_store[vn],str);
	}
	
	
%}
/* Bison declarations (grammar symbols, operator precedence decl., attribute data type) */
%error-verbose

   %union{
  int intVal;
  char* variable;
  char* strVal;
  float floatVal;
  char charVal;
}

 %token MBEGIN INTEGER FLOAT CHAR STRING END COLON SEMICOLON ASSIGN COMMA  FORWARD_ARROW SHOW 
 %token BACKWARD_ARROW TAKE PLUS SUB MULT DIV MOD OTB CTB POW SIN COS TAN LOG LOG10 OP CP 
 %token LESS_THAN GREATER_THAN LESS_EQUAL GREATER_EQUAL IF ELSE_IF ELSE EQUAL NOT_EQUAL 
 %token FOR IN FOR_INC FOR_DEC EVEN_ODD FACTORIAL SUM GCD LCM SWITCH AND OR
 %token DEFAULT WHILE OSB CSB IMPORT
 
 %token<intVal>INT_VAL
 %token<floatVal>FLOAT_VAL
 %token<charVal>CHAR_VAL
 %token<variable>VARIABLE
 %token<strVal>STRING_VAL
 %token<strVal>HEADER
 %type<intVal>cdeclare 
 %type<floatVal>expression number cstatements condition  statements built_func
 


 %nonassoc IFX
 %nonassoc ELSE
 %left OR
 %left AND
 %left EQUAL NOT_EQUAL
 %left LESS_THAN LESS_EQUAL GREATER_THAN GREATER_EQUAL 
 %left PLUS SUB 
 %left MULT DIV MOD
 %right POW 
 
/* grammar rules go here */

%%

program:header MBEGIN COLON cstatements END   {printf("\n\t\t\t\t\tCompilation Done Succesfully!!!\n");}
       ;
	   
header   :  /* empty */
            |header IMPORT head
            ;

head     : HEADER { 
                printf("\n\t\t\t\tHeader File Included\n");
            }
            ;
cstatements:/* Empty */           {}
           |SEMICOLON                       {printf("\n\t\t\t\tEmpty statement\n");}
		   |cstatements cdeclare SEMICOLON  
		   |cstatements statements
		   |cstatements condition    { 
												if($2) 
												{  
													printf("\n\t\t\t\tValue of Expression in Valid Condition: %f\n",$2); 
												}
												else
												{
												   printf("\n\t\t\t\tCondition false\n");
												}
									}
		   |cstatements loop
           |cstatements switch_case
           |cstatements built_func	SEMICOLON   
		   |cstatements while	  
		   
		  
		   ;
cdeclare:INTEGER int_id {}
       	|FLOAT float_id {}
        |CHAR char_id {}
        |STRING string_id {}		
        ;
int_id:int_id1 COMMA int_id
  |int_id1
  ;
int_id1:VARIABLE        {
                            int pos=is_exist($1);
                            if(pos!=-1)
							{
							   printf("\n\t\t\t\tCompilation error-> %s is redeclared \n",$1);
							}
						    else
							{
							var_type[vn]=0;
							store($1);
							printf("\n\t\t\t\t%s is declared successfully\n",$1);
							vn++;
						    }
						}
    |VARIABLE ASSIGN expression {   int pos=is_exist($1);
									if(pos!=-1)
									{
									   printf("\n\t\t\t\tCompilation error-> %s is redeclared \n",$1);
									}
								    else
									{
									var_type[vn]=0;
							        store($1);
									int_val[vn]=$3;
									printf("\n\t\t\t\t%s is declared and assigned by %d successfully\n",$1,(int)($3));
									vn++;
						            }
						    
						        }
    
	;

float_id:float_id1 COMMA float_id 
  |float_id1
  ;
float_id1:VARIABLE      {
                            int pos=is_exist($1);
                            if(pos!=-1)
							{
							   printf("\n\t\t\t\tCompilation error-> %s is redeclared \n",$1);
							}
						    else
						    {
							var_type[vn]=1;
							store($1);
							printf("\n\t\t\t\t%s is declared successfully\n",$1);
							vn++;
						    }
						}
    |VARIABLE ASSIGN expression {   int pos=is_exist($1);
									if(pos!=-1)
									{
									   printf("\n\t\t\t\tCompilation error-> %s is redeclared \n",$1);
									}
								    else
									{
									var_type[vn]=1;
							        store($1);
									float_val[vn]=$3;
									printf("\n\t\t\t\t%s is declared and assigned by %f successfully\n",$1,$3);
									vn++;
						            }
						    
						        }
    
	;
	
char_id:char_id1 COMMA char_id 
  |char_id1
  ;
char_id1:VARIABLE      {
                            int pos=is_exist($1);
                            if(pos!=-1)
							{
							   printf("\n\t\t\t\tCompilation error-> %s is redeclared \n",$1);
							}
						    else{
							var_type[vn]=2;
							store($1);
							printf("\n\t\t\t\t%s is declared successfully\n",$1);
							vn++;
						   }
						}
    |VARIABLE ASSIGN expression {   int pos=is_exist($1);
									if(pos!=-1)
									{
									   printf("\n\t\t\t\tCompilation error-> %s is redeclared \n",$1);
									}
								    else{
									var_type[vn]=2;
							        store($1);
									char_val[vn]=$3;
									printf("\n\t\t\t\t%s is declared and assigned by %c successfully\n",$1,(char)($3));
									vn++;
						            }
						    
						        }
    
	;
string_id:string_id1 COMMA string_id 
  |string_id1
  ;
string_id1:VARIABLE      {
                            int pos=is_exist($1);
                            if(pos!=-1)
							{
							   printf("\n\t\t\t\tCompilation error-> %s is redeclared \n",$1);
							}
						    else{
							var_type[vn]=3;
							store($1);
							printf("\n\t\t\t\t%s is declared successfully\n",$1);
							vn++;
						   }
						}
    |VARIABLE ASSIGN STRING_VAL{   int pos=is_exist($1);
									if(pos!=-1)
									{
									   printf("\n\t\t\t\tCompilation error-> %s is redeclared \n",$1);
									}
								    else{
									var_type[vn]=3;
									//printf("%s",$3);
							        store($1);
									strcpy(string_val[vn],$3);
									printf("\n\t\t\t\t%s is declared and assigned by %s successfully\n",$1,$3);
									vn++;
						            }
						    
						        }

    
	;

statements:SHOW FORWARD_ARROW VARIABLE SEMICOLON       {   
                                                            int pos=is_exist($3);
															if(pos != -1) 
															{
																 if(var_type[pos]==0)
																    printf("\n\t\t\t\tValue of %s is: %d\n",$3,int_val[pos]);
                                                                 else if(var_type[pos]==1)
																    printf("\n\t\t\t\tValue of %s is: %f\n",$3,float_val[pos]);	
                                                                 else if(var_type[pos]==2)
																    printf("\n\t\t\t\tValue of %s is: %c\n",$3,char_val[pos]);
                                                                  else if(var_type[pos]==3)
																    printf("\n\t\t\t\tValue of %s is: %s\n",$3,string_val[pos]);																		
															}
															else
															{
															
																printf("\n\t\t\t\tCompilation error-> %s was not declared\n",$3);
														    }

														}
		   |SHOW FORWARD_ARROW STRING_VAL  SEMICOLON   { 
                                                         printf("\n\t\t\t\t%s\n",$3);
													   }
		   |SHOW FORWARD_ARROW   SEMICOLON             { 
                                                         printf("\n");
													   }
		   |TAKE BACKWARD_ARROW VARIABLE SEMICOLON      {
														//printf("Enter the value for %c\n",$3+97);
											            int pos=is_exist($3);
														if(pos != -1) 
														{ 
															printf("\n\t\t\t\tValue taken from user for %s\n",$3);
															if(var_type[pos]==0)
															{
															int a;
															scanf("%d",&a);
															int_val[pos] = a;
															}
															else if(var_type[pos]==1)
															{
															float b;
															scanf("%f",&b);
															//printf("%f\n",b);
															float_val[pos] = b;
															}
															else if(var_type[pos]==2)
															{
															char c;
															scanf("%c",&c);
															//printf("%c\n",c);
															char_val[pos] = c;
															}
														}
														else
														{
															printf("\n\t\t\t\tCompilation error-> %s was not declared\n",$3);
														}
														}
													
		  |VARIABLE ASSIGN expression SEMICOLON	    {
                                                            int pos=is_exist($1);		  
															if(pos != -1)
															{
																if(var_type[pos]==0)
																{
																	  int_val[pos]=$3;
									                                  printf("\n\t\t\t\t%s is assigned by %d successfully\n",$1,(int)($3)); 
															    }
                                                                else if(var_type[pos]==1)
																{
																     float_val[pos]=$3;
									                                 printf("\n\t\t\t\t%s is assigned by %f successfully\n",$1,$3);
																}
																else if(var_type[pos]==2)
																{
																     char_val[pos]=$3;
									                                 printf("\n\t\t\t\t%s is assigned by %c successfully\n",$1,(char)($3));
																}
															}
															else
															{
															  printf("\n\t\tCompilation error-> %s was not declared\n",$1);
                                                            }
		  											}
		  |VARIABLE ASSIGN STRING_VAL SEMICOLON	        {
                                                            int pos=is_exist($1);		  
															if(pos != -1)
															{
																
																     strcpy(string_val[pos],$3);
									                                 printf("\n\t\t\t\t%s is assigned by %s successfully\n",$1,$3);
															}
															else
															{
															  printf("\n\t\tCompilation error-> %s was not declared\n",$1);
                                                            }
		  											    }
		  |expression SEMICOLON {}
		  ;

condition:IF expression COLON OP statements CP {
                                                   if($2) 
													{
														$$ = $5;
													}
													else
													{
														$$ = 0;
													}
                                                 }
      |IF expression COLON OP statements CP ELSE COLON OP statements CP {
																			if($2)
																			{
																				$$ =$5;
																			}
																			else
																			{
																				$$ =$10;
																			}
																		}
	 |IF expression COLON OP statements CP ELSE_IF expression COLON OP statements CP ELSE COLON OP statements CP {
																														if($2)
																														{
																															$$ = $5;
																														}
																														else if($8)
																														{
																															$$ = $11;
																														}
																														else
																														{
																														  $$ = $16;
																														}
																													}
      																																	
	
	  | IF expression COLON OP condition CP ELSE COLON OP condition CP 
																		{
																			if($2)
																			{ 
																			$$ = $5;
																			}
																			else
																			{
																			$$ = $10; 
																			}
																		}   
      ;

loop:FOR VARIABLE IN OTB number COMMA number COMMA number FOR_INC CTB COLON OP statements CP  {     int pos=is_exist($2);
																									if(pos != -1)
																									{
																									float a,b,c,i;
																									a=$5;
																									b = $7;
																									c=$9;
																									int j=0;
																									printf("\n\t\t\t\t\tFOR loop starts executing\n\n");
																										
																									for(i=a; i <= b; i+=c)
																										{
																											j++;
																											 printf("\n\t\t\t\tIteration number within for loop: %d  Value of expression: %f\n",j,$14);
																										}
																										
																									    printf("\n\t\t\t\t\tFOR loop executed succesfully\n");
																										if(var_type[pos]==0)
																										int_val[pos]=i;
																										else if(var_type[pos]==1)
																										float_val[pos]=i;
																										else if(var_type[pos]==2)
																										char_val[pos]=i;
																									}
																									else
																									  printf("\n\t\t\t\tCompilation error-> %s was not declared\n",$2);	
																							  }
     |FOR VARIABLE IN OTB number COMMA number COMMA number FOR_DEC CTB COLON OP statements CP  {  
	                                                                                             int pos=is_exist($2);
																									if(pos != -1)
																									{
																									float a,b,c,i;
																									a=$5;
																									b = $7;
																									c=$9;
																									int j=0;
																									printf("\n\t\t\t\t\tFOR loop starts executing\n\n");
																										
																									for(i=a; i>= b; i-=c)
																										{
																											j++;
																										    printf("\n\t\t\t\tIteration number within for loop= %d  Value of expression: %f\n",j,$14);
																										}
																										
																									    printf("\n\t\t\t\t\tFOR loop executed succesfully\n");
																										if(var_type[pos]==0)
																										int_val[pos]=i;
																										else if(var_type[pos]==1)
																										float_val[pos]=i;
																										else if(var_type[pos]==2)
																										char_val[pos]=i;
																									}
																									else
																									  printf("\n\t\t\t\tCompilation error-> %s was not declared\n",$2);
																							  }
         	     	  
     ;
built_func:EVEN_ODD expression     {
                                    int num=(int)$2;
                                    if(num%2==0)
									printf("\n\t\t\t\t%d is an even number\n",num);
									else
									printf("\n\t\t\t\t%d is an odd number\n",num);
								   }
									
		   |FACTORIAL expression   {
                                    int num=(int)$2;
									int fact=1;
                                    for(int i=1;i<=num;i++)
									{
									   fact*=i;
									}
									printf("\n\t\t\t\tThe factorial of %d is: %d\n",num,fact);
								   }
		   |SUM expression       {
                                    int num=(int)$2;
									int sum=(num*(num+1))/2;
									printf("\n\t\t\t\tThe summation of first %d integer number is: %d\n",num,sum);
								 }
								   
		   |GCD OTB expression COMMA expression CTB      {
															int a=(int)$3;
															int b=(int)$5;
															int l,s;
															if(a<b)
															{
															 l=b;
															 s=a;
															}
															else
															{
															 l=a;
															 s=b;
															}
															while(s)
															{
															   int tmp=l%s;
															   l=s;
															   s=tmp;
															   
															}
															printf("\n\t\t\t\tThe GCD of %d and %d is: %d\n",a,b,l);
														   }
           |LCM OTB expression COMMA expression CTB      {
															int a=(int)$3;
															int b=(int)$5;
															int l,s;
															if(a<b)
															{
															 l=b;
															 s=a;
															}
															 else
															{
															 l=a;
															 s=b;
															}
															while(s)
															{
															   int tmp=l%s;
															   l=s;
															   s=tmp;
															   
															}
															int lcm=(a*b)/l;
															printf("\n\t\t\t\tThe LCM of %d and %d is: %d\n",a,b,lcm);
														   }
		    | SIN expression 			{
		                                   float x = $2;
	                                       float val = 3.1416/ 180;
                                           float res = sin(x*val);
										   int y=x;
										   printf("\n\t\t\t\tValue of sin[%d degree] is %f\n",y,res);
							               $$ = res;
										}

		   | COS expression 			{
		                                 float x = $2;
	                                     float val = 3.1416/ 180;
                                         float res = cos(x*val);
										 int y=x;
										 printf("\n\t\t\t\tValue of cos[%d degree] is %f\n",y,res);
							             $$ = res;
										}

		   | TAN expression 			{
		                                 float x = $2;
	                                     float val = 3.1416/ 180;
                                         float res = tan(x*val);
										 int y=x;
										 printf("\n\t\t\t\tValue of tan[%d degree] is %f\n",y,res);
							             $$ = res;
										}

		   | LOG10 expression 			{
		                                 float x = $2;             
										 float res=(log(x*1.0)/log(10.0));
										 int y=x;
										 printf("\n\t\t\t\tValue of Log10(%d) is %f\n",y,res);
										 $$=res;
		                                
										}
		   | LOG expression 			{
		                                 float x = $2;
										 float res=log(x);
										 int y=x;
										 printf("\n\t\t\t\tValue of Log(%d) is %f\n",y,res);
										 $$=res;
										}
			;		
switch_case:SWITCH OTB valueofcase CTB COLON OP casestatement CP  {
											
																  printf("\n\t\t\t\t\tSwitch case executed succesfully\n");

                                                                  }
																  
valueofcase:INT_VAL{
                     caseD=0;
					 caseV=$1;
					}
casestatement:case
             |case default_rule
			 ;
case:
    |case case_rule
    ;

case_rule:OTB INT_VAL CTB expression  SEMICOLON  {
													if(caseV==$2)
													{
													printf("\n\t\t\t\tCase No : %d is activated and  expression value :%f \n",$2,$4);
													caseD=1;
													}
												}
        ;

default_rule:OTB DEFAULT CTB expression  SEMICOLON  {
                                                     if(caseD==0)
													 {
													 printf("\n\t\t\t\tDefault case activated and expression value : %d\n",$4);
													 }
													 
													}	
			;
			
while:WHILE OTB VARIABLE LESS_EQUAL number CTB OSB number FOR_INC CSB COLON OP statements CP
																								{ 
																								   int pos=is_exist($3);
																								   if(pos != -1)
																									{
																									float a,b,c;
																									if(var_type[pos]==0)
																									   a=int_val[pos];
																									else if(var_type[pos]==1)
																									   a=float_val[pos];
																									else if(var_type[pos]==2)
																									 a=char_val[pos];
																									 b = $5;
																									 c=$8;
																									if(a < b)
																									{
																										int i=1;
																										printf("\n\t\t\t\t\tWhile loop starts executing!\n");
																										while(a <= b)
																										{
																											//printf("%f",a);
																											printf("\n\t\t\t\tIteration number within while loop:%d and value of expression: %f\n",i,$13);
																											a += c;
																											i++;
																											if(a > b) break;
																										}
																										printf("\n\t\t\t\t\tWhile loop  executed successfully!\n");
																										if(var_type[pos]==0)
																										int_val[pos]=a;
																										else if(var_type[pos]==1)
																										float_val[pos]=a;
																										else if(var_type[pos]==2)
																										char_val[pos]=a;
																									}
																									else
																									{
																									printf("\n\t\t\t\tThe condition within while loop is false");
																									}
																									
																									}
																									else
																									{
																										 printf("\n\t\t\t\tCompilation error-> %s is not declared\n",$3);
																									}
																								}
	    |WHILE OTB VARIABLE GREATER_EQUAL number CTB OSB number FOR_DEC CSB COLON OP statements CP
																								{
																								   int pos=is_exist($3);
																									if(pos != -1){
																									float a,b,c;
																									if(var_type[pos]==0)
																									   a=int_val[pos];
																									else if(var_type[pos]==1)
																									   a=float_val[pos];
																									else if(var_type[pos]==2)
																									 a=char_val[pos];
																									 b = $5;
																									 c=$8;
																									if(a >= b)
																									{
																										int i=1;
																										printf("\n\t\t\t\t\tWhile loop starts executing!\n");
																										while(a >= b)
																										{
																											//printf("%f",a);
																											printf("\n\t\t\t\tIteration number within while loop:%d and value of expression: %f\n",i,$13);
																											a -= c;
																											i++;
																											if(a < b) break;
																										}
																										printf("\n\t\t\t\t\tWhile loop executed successfully!\n");
																										if(var_type[pos]==0)
																										int_val[pos]=a;
																										else if(var_type[pos]==1)
																										float_val[pos]=a;
																										else if(var_type[pos]==2)
																										char_val[pos]=a;
																									}
																									else
																									{
																									printf("\n\t\t\t\tThe condition within while loop is false");
																									}
																									
																									}
																									else
																									{
																										 printf("\n\t\t\t\tCompilation error-> %s is not declared\n",$3);
																									}
																								}
	
	;
expression: number{ $$ = $1;  
                   //printf("%f\n",$1);
                  }
		   |VARIABLE   {   int pos=is_exist($1);
						   if(pos != -1)
						   {
							   if(var_type[pos]==0)
							   {
								$$ = int_val[pos];
							   }
							   else if(var_type[pos]==1)
							   {
								$$ = float_val[pos];
							   }
							   else if(var_type[pos]==2)
							   {
								$$ = char_val[pos];
							   }
						   }
						   else
						   {
						   printf("\n\t\t\t\tCompilation error-> %s was not declared\n",$1);
						   }
						}
		   |expression PLUS expression   { $$ = $1 + $3; }
		   |expression SUB  expression   { $$ = $1 - $3; }
		   |expression MULT expression   { $$ = $1 * $3; }
	       |expression LESS_THAN expression	{ $$ = $1 < $3; }
	       |expression GREATER_THAN expression	{ $$ = $1 > $3; }
           |expression LESS_EQUAL expression	{ $$ = $1 <= $3; }
	       |expression GREATER_EQUAL expression	{ $$ = $1 >= $3; }	
           |expression EQUAL expression	{ $$ = $1 == $3; }
           |expression NOT_EQUAL expression	{ $$ = $1 != $3; }
           |expression AND expression	{ $$ = $1 && $3; }
           |expression OR expression	{ $$ = $1 || $3; }								 
           |expression DIV expression  {
									     if($3)
										 {
										   $$ = $1 / $3;
										 }
										 else
										 {
										 $$ = 0;
										 printf("\n\t\t\t\tError!! divided by 0\n");
										 }
										}
				
		 
		   
			|expression MOD expression  {
		                                 int x=$1;
										 int y=$3;
									     if(y)
										 {
										   $$ =x%y ;
										 }
										 else
										 {
										 $$ = 0;
										 printf("\n\t\t\t\tError!! divided by 0\n");
										 }
										}											
           |OTB expression CTB   {$$=$2}
		  
		   | expression POW expression	{ $$ = pow($1 , $3);}
		   
		   

          ;	
		  

number:INT_VAL {$$=$1;}
      |FLOAT_VAL {$$=$1;
	              //printf("%f\n",$1);
				 }
	  |CHAR_VAL  {$$=$1;}
	
	  ;
      	  
%%


int yywrap(){
return 1;
}
int yyerror(char *s)
{
fprintf(stderr,"%s\n",s);
}
int main()
{
freopen("input.txt","r",stdin);
yyparse();
}