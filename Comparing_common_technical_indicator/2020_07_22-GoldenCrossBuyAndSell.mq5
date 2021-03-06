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

double currentMA100 = 0;
double currentMA50 = 0;
double prevMA50 = 0;
double prevMA100 = 0;
int MovingAverageDef = 0;

void OnTick() {
  
   SymbolInfoTick(Symbol() ,Latest_Price);
  
   newBars = iBars("#USSPX500",PERIOD_W1); //PERIOD_MN1
   int newBarsDay = iBars("#USSPX500",PERIOD_D1);
   
   if(newBars > currentBars){
      real_balance += weekly_income;
      Print("real_balance: ", real_balance, " profit:", AccountInfoDouble(ACCOUNT_PROFIT), " Total position: ", Latest_Price.ask * total_position);
   } //End of bars
   
   if(newBarsDay > currentBarsDay){
      
      double movingAverageArray50[];
         
      MovingAverageDef = iMA(_Symbol,PERIOD_D1,50,0,MODE_EMA,PRICE_CLOSE);
      
      ArraySetAsSeries(movingAverageArray50,true);
      CopyBuffer(MovingAverageDef,0,0,3,movingAverageArray50);
      
      currentMA50 = movingAverageArray50[0];
      //prevMA50 = movingAverageArray50[1];      
      
      
      double movingAverageArray100[];
         
      MovingAverageDef = iMA(_Symbol,PERIOD_D1,200,0,MODE_EMA,PRICE_CLOSE);
      
      ArraySetAsSeries(movingAverageArray100,true);
      CopyBuffer(MovingAverageDef,0,0,3,movingAverageArray100);
      
      currentMA100 = movingAverageArray100[0];  
      //prevMA100 = movingAverageArray100[1];
      
      //Define golden cross:
      if(real_balance > (Latest_Price.ask + Latest_Price.ask * total_position)){         
         //if 50MA crossed over the 100MA
         int buy_ammount = (real_balance - (Latest_Price.ask * total_position))  / Latest_Price.ask;
         
         if(prevMA100 > prevMA50){
            if(currentMA100 < currentMA50){
               trade.Buy(buy_ammount,"#USSPX500",Latest_Price.ask,NULL,NULL,NULL);
               total_position += buy_ammount;
            }
         }
      }
      
      if(prevMA100 < prevMA50){
         if(currentMA100 > currentMA50){
            trade.Sell(total_position,"#USSPX500",Latest_Price.bid,NULL,NULL,NULL);
            total_position = 0;
         }
      }
      
      
      prevMA100 = currentMA100;
      prevMA50 = currentMA50;
      
      
   } //End bars day
   
   
   currentBars = iBars("#USSPX500",PERIOD_W1);
   currentBarsDay = iBars("#USSPX500",PERIOD_D1);
  

   Comment("real_balance: ", real_balance, "\n",
   "total_position: ", Latest_Price.ask * total_position, "\n",
   "profit: ", AccountInfoDouble(ACCOUNT_PROFIT), "\n",
   "prevMA 100 ", prevMA100, " prevMA50 ", prevMA50, "\n",
   "currentMA 100 ", currentMA100, " currentMA50 ", currentMA50
   );

 } //End on_tick

//+------------------------------------------------------------------+