#include <stdio.h>
#define LENGTH 1052

int main() {
    int registers[LENGTH], i, jump;
    int cur_pos = 0, count = 0;
    FILE *fp = fopen("input", "r");
    
    for(i=0;i<LENGTH;i++) {
        fscanf(fp, "%d", &registers[i]);
    }
    
    while(cur_pos >= 0 && cur_pos < LENGTH) {
        jump = registers[cur_pos];
        
        if(jump >= 3) {
            registers[cur_pos]--;
        } else {
            registers[cur_pos]++;
        }

        cur_pos += jump;
        count++;
    }

    printf("%d\n", count);

    return 0;
}