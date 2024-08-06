#line 1 "C:/Users/Abdulrahman Hossam/Desktop/New folder/code/MyProject.c"
#line 25 "C:/Users/Abdulrahman Hossam/Desktop/New folder/code/MyProject.c"
int flag0=0;int flag=0;int flag1=0;int flag2=0;int state =  5 ;int timer_count = 0;int slow_counter = 0;

void display_time(int x,int street) {
 int remaining_time = x - slow_counter;
 int units = remaining_time % 10;
 int tens = remaining_time / 10;
 if(street== 0 ) {
 portc.b4=0;
 portc.b5=0;
 portc = units;
 porta=tens; }
 else if(street== 1 ) {
 portb.b6=1;
 portb.b7=1;
 portd = units;
 porte=tens;
 }
 }

void interrupt() {
 if (TMR0IF_BIT==1) {
 if(portd. RD6 ==1&&slow_counter>= 3 ) {
 TMR0IF_BIT = 0;
 portc.b4=1;
 portc.b5=1;
 portb.b6=0;
 portb.b7=0; }
 else{
 timer_count++;
 TMR0IF_BIT = 0;
 if (timer_count % 25 == 0) {
 slow_counter++;
 }
 }
 }
 }

void display_traffic_light(int street, int color) {
 if (street ==  0 ) {
 if (color ==  2 ) {
 portb. RB0  = 1;
 portb. RB1  = 0;
 portb. RB2  = 0;
 }
 else if (color ==  4 ) {
 portb. RB0  = 0;
 portb. RB1  = 1;
 portb. RB2  = 0;
 }
 else if (color ==  3 ) {
 portb. RB0  = 0;
 portb. RB1  = 0;
 portb. RB2  = 1;
 }
 }
 else if (street ==  1 ) {
 if (color ==  2 ) {
 portb. RB3  = 1;
 portb. RB4  = 0;
 portb. RB5  = 0;
 }
 else if (color ==  4 ) {
 portb. RB3  = 0;
 portb. RB4  = 1;
 portb. RB5  = 0;
 }
 else if (color ==  3 ) {
 portb. RB3  = 0;
 portb. RB4  = 0;
 portb. RB5  = 1;
 }
 }
 }

void automatic_mode() {
 switch (state) {
 case  5 :
 display_traffic_light( 0 ,  2 );
 display_time( 15 , 0 );
 if(slow_counter< 12 ){
 display_time( 12 , 1 );
 display_traffic_light( 1 ,  3 );
 }
 else{
 display_time( 12 + 3 , 1 );
 display_traffic_light( 1 ,  4 );}
 if (slow_counter >=  15 ) {
 slow_counter=0;
 timer_count = 0;
 state =  8 ;
 }
 break;
 case  8 :
 display_traffic_light( 1 ,  2 );
 display_time( 23 , 1 );
 if (slow_counter< 20 ) {
 display_traffic_light( 0 ,  3 );
 display_time( 20 , 0 );
 }
 else{
 display_traffic_light( 0 ,  4 );
 display_time( 20 + 3 , 0 );
 }
 if (slow_counter >= 23 ) {
 slow_counter=0;
 timer_count = 0;
 state =  5 ;
 }
 break;
 }
 }

void manual_mode() {
if(portd. RD7 == 0 ){
 flag1=1;
 if(flag2==1){
 flag2=0;
 slow_counter=0;
 timer_count=0;
 }
 display_traffic_light( 0 ,  3 );
 if(slow_counter< 3 ) {
 display_traffic_light( 1 ,  4 );
 display_time( 3 , 1 );
 portc.b4=1;
 portc.b5=1;
 }
 else{
 display_traffic_light( 1 ,  2 );
 }
 }
else if(portd. RD7 == 1 ){
 flag2=1;
 if(flag1==1){
 flag1=0;
 slow_counter=0;
 timer_count=0;
 }
 display_traffic_light( 1 ,  3 );

 if(slow_counter< 3 ) {
 display_traffic_light( 0 ,  4 );
 display_time( 3 , 0 );
 portb.b6=0;
 portb.b7=0;
 }
 else{
 display_traffic_light( 0 ,  2 );
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
 OPTION_REG=0b10000111;
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
 else {
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
