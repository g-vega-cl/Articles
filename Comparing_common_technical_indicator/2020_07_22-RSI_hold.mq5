//+------------------------------------------------------------------+
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
#include<Trade\Trade.mqh>
CTrade trade;
MqlTick Latest_Price;

int currentBars = 0;
int newBars = 0;
int currentBarsDay = 0;

int weekly_income = 200;
double real_balance = 3000;

int total_position = 0;

double currentRSI = 0;
double prevRSI = 0;
int RSIDef = 0;

void OnTick() {
  
   SymbolInfoTick(Symbol() ,Latest_Price);
  
   newBars = iBars("#USSPX500",PERIOD_W1); //PERIOD_MN1
   int newBarsDay = iBars("#USSPX500",PERIOD_D1);
   
   if(newBars > currentBars){
      real_balance += weekly_income;
      Print("real_balance: ", real_balance, " profit:", AccountInfoDouble(ACCOUNT_PROFIT), " Total position: ", Latest_Price.ask * total_position);
   } //End of bars
   
   if(newBarsDay > currentBarsDay){
      
      double RSIArray[];
         
      RSIDef = iRSI(_Symbol,PERIOD_D1,14,PRICE_CLOSE);
      
      ArraySetAsSeries(RSIArray,true);
      CopyBuffer(RSIDef,0,0,3,RSIArray);
      
      currentRSI = RSIArray[0];
      //prevMA50 = movingAverageArray50[1];      
      
      //Define golden cross:
      if(real_balance > (Latest_Price.ask + Latest_Price.ask * total_position)){         
         //if 50MA crossed over the 100MA
         int buy_ammount = (real_balance - (Latest_Price.ask * total_position))  / Latest_Price.ask;
         
         if(currentRSI > 30){
            if(prevRSI < 30){
               trade.Buy(buy_ammount,"#USSPX500",Latest_Price.ask,NULL,NULL,NULL);
               total_position += buy_ammount;      
            }
         }
                  
      }
      
      
      prevRSI = currentRSI;
      
      
   } //End bars day
   
   
   currentBars = iBars("#USSPX500",PERIOD_W1);
   currentBarsDay = iBars("#USSPX500",PERIOD_D1);
  

   Comment("real_balance: ", real_balance, "\n",
   "total_position: ", Latest_Price.ask * total_position, "\n",
   "profit: ", AccountInfoDouble(ACCOUNT_PROFIT), "\n",
   "prevRSI", prevRSI, " currentRSI ", currentRSI, "\n"
   );

 } //End on_tick

//+------------------------------------------------------------------+