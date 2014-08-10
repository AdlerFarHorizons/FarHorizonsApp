#include <stdio.h>
#include <math.h>


int main()
{
  int i,j;
  FILE *fp;

  

  for (j=0;j<100;j++)
    {
      sleep(3);

      fp=fopen("wb9skytrack.txt","w");
      for (i=0;i<j+1;i++){
	fprintf(fp,"%lf,%lf,%d\n",41.1+0.05*cos(6.28*i/100.0),-87.7+0.05*sin(6.28*i/100.0),i*1120);
      }
      fclose(fp);

      fp=fopen("kc9ligtrack.txt","w");
      for (i=0;i<j+1;i++){
	fprintf(fp,"%lf,%lf,%d\n",41.1+0.001*i*cos(6.28*i/100.0),-87.7+0.001*i*sin(6.28*i/100.0),i*998);
      }
      fclose(fp);

      fp=fopen("kc9lhwtrack.txt","w");
      for (i=0;i<j+1;i++){
	fprintf(fp,"%lf,%lf,%d\n",41.101+0.0005*i*cos(6.28*i/100.0),-87.701+0.0015*i*sin(6.28*i/100.0),i*1200);
      }
      fclose(fp);
    }

  return 1;

}
