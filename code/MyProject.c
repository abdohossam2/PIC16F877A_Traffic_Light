#define WEST 0 
#define SOUTH 1
#define RED 2
#define GREEN 3
#define YELLOW 4
#define WEST_RED 5
#define SOUTH_RED 8

#define MANUAL_SWITCH RD6
#define STREET_SWITCH RD7
#define RED_WEST RB0
#define YELLOW_WEST RB1
#define GREEN_WEST RB2
#define RED_SOUTH RB3
#define YELLOW_SOUTH RB4
#define GREEN_SOUTH RB5

#define WEST_RED_TIME 15  // 15 seconds
#define WEST_YELLOW_TIME 3  // 3 seconds
#define WEST_GREEN_TIME 20 // 20 seconds
#define SOUTH_RED_TIME 23  // 23 seconds
#define SOUTH_YELLOW_TIME 3  // 3 seconds
#define SOUTH_GREEN_TIME 12  // 12 seconds

int flag0=0;int flag=0;int flag1=0;int flag2=0;int state = WEST_RED;int timer_count = 0;int slow_counter = 0;

void display_time(int x,int street) {
  int remaining_time = x - slow_counter;
  int units = remaining_time % 10;
  int tens = remaining_time / 10;
  if(street==WEST)   {
      portc.b4=0;
      portc.b5=0;
      portc = units;
      porta=tens;         }
  else if(street==SOUTH) {
      portb.b6=1;
      portb.b7=1;
      portd = units;
      porte=tens;
                          }
                                     }

void interrupt() {
    if (TMR0IF_BIT==1) {
        if(portd.MANUAL_SWITCH==1&&slow_counter>=WEST_YELLOW_TIME) {
            TMR0IF_BIT = 0;
            portc.b4=1;
            portc.b5=1;
            portb.b6=0;
            portb.b7=0;                                            }
        else{
            timer_count++;    //OCCUR EVERY 32.678 MS
            TMR0IF_BIT = 0;
            if (timer_count % 25 == 0) {                 //must be 31
                 slow_counter++;   // occur every 1 second
                                        }
            }
                        }
                 }
                 
void display_traffic_light(int street, int color) {
    if (street == WEST) {
        if (color == RED) {
            portb.RED_WEST = 1;
            portb.YELLOW_WEST = 0;
            portb.GREEN_WEST = 0;
                           }
         else if (color == YELLOW) {
            portb.RED_WEST = 0;
            portb.YELLOW_WEST = 1;
            portb.GREEN_WEST = 0;
                                     }
         else if (color == GREEN) {
            portb.RED_WEST = 0;
            portb.YELLOW_WEST = 0;
            portb.GREEN_WEST = 1;
                                   }
                         }
    else if (street == SOUTH) {
              if (color == RED) {
            portb.RED_SOUTH = 1;
            portb.YELLOW_SOUTH = 0;
            portb.GREEN_SOUTH = 0;
                                 }
        else if (color == YELLOW) {
            portb.RED_SOUTH = 0;
            portb.YELLOW_SOUTH = 1;
            portb.GREEN_SOUTH = 0;
                                    }
         else if (color == GREEN) {
            portb.RED_SOUTH = 0;
            portb.YELLOW_SOUTH = 0;
            portb.GREEN_SOUTH = 1;
                                    }
                                 }
                                                   }

void automatic_mode() {
    switch (state) {
        case WEST_RED:
            display_traffic_light(WEST, RED);
            display_time(WEST_RED_TIME,WEST);
            if(slow_counter<SOUTH_GREEN_TIME){
            display_time(SOUTH_GREEN_TIME,SOUTH);
            display_traffic_light(SOUTH, GREEN);
                                              }
            else{
            display_time(SOUTH_GREEN_TIME+SOUTH_YELLOW_TIME,SOUTH);
            display_traffic_light(SOUTH, YELLOW);}
            if (slow_counter >= WEST_RED_TIME) {
                slow_counter=0;
                timer_count = 0;
                state = SOUTH_RED;
                                                }
            break;
        case SOUTH_RED:
            display_traffic_light(SOUTH, RED);
            display_time(SOUTH_RED_TIME,SOUTH);
            if (slow_counter<WEST_GREEN_TIME) {
            display_traffic_light(WEST, GREEN);
            display_time(WEST_GREEN_TIME,WEST);
                                               }
            else{
            display_traffic_light(WEST, YELLOW);
            display_time(WEST_GREEN_TIME+WEST_YELLOW_TIME,WEST);
                }
            if (slow_counter >=SOUTH_RED_TIME) {
                slow_counter=0;
                timer_count = 0;
                state = WEST_RED;
                                                }
            break;
                    }
                       }

void manual_mode() {
if(portd.STREET_SWITCH==WEST){
           flag1=1;
           if(flag2==1){
            flag2=0;
            slow_counter=0;
            timer_count=0;
                       }
     display_traffic_light(WEST, GREEN);
     if(slow_counter<SOUTH_YELLOW_TIME) {    // not <= as when slow counter reach 3 go to else not when reach 4 second
         display_traffic_light(SOUTH, YELLOW);
         display_time(SOUTH_YELLOW_TIME,SOUTH);
         portc.b4=1;
         portc.b5=1;
                                          }
     else{
     display_traffic_light(SOUTH, RED);
         }
                              }
else if(portd.STREET_SWITCH==SOUTH){
     flag2=1;
     if(flag1==1){
            flag1=0;
            slow_counter=0;
            timer_count=0;
                  }
     display_traffic_light(SOUTH, GREEN);

     if(slow_counter<WEST_YELLOW_TIME) {    // not <= as when slow counter reach 3 go to else not when reach 4 second
         display_traffic_light(WEST, YELLOW);
         display_time(WEST_YELLOW_TIME,WEST);
         portb.b6=0;
         portb.b7=0;
                                        }
     else{
         display_traffic_light(WEST, RED);
          }
                                    }
                    }

void main() {
     adcon1=7;
     trisa=0b00000000;
     trise=0b000;
     PORTA=0;
     GIE_BIT=1;
     TMR0IE_BIT=1;
     OPTION_REG=0b10000111;  //pres is 256
     TMR0=0;
     TRISC = 0b00000000;
     PORTC=0;
     TRISB = 0b00000000;
     trisd=0b11000000;
      while(1) {
        if (portd.B6==1) {
        flag=1;
        if(flag0==1){
            flag0=0;
            slow_counter=0;
            timer_count=0;
            }
            manual_mode();
                          }
        else   {
        flag0=1;
            if(flag==1){
            flag=0;
            slow_counter=0;
            timer_count=0;
                        }
            automatic_mode();
                 }
               }
             }