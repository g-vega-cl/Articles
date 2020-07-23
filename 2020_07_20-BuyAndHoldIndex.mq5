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

int weekly_income = 200;
double real_balance = 0;

int total_position = 0;

void OnTick() {
  
   SymbolInfoTick(Symbol() ,Latest_Price);
  
   newBars = iBars("#USSPX500",PERIOD_W1); //PERIOD_MN1
  
   if(newBars > currentBars){
      real_balance += weekly_income;
      //If our balance is higher than the ask by the total position, we add.
      //We don't even check our equity, everytime we have the money for a new position, we are in.
      if(real_balance > (Latest_Price.ask + Latest_Price.ask * total_position)){
         trade.Buy(1,"#USSPX500",Latest_Price.ask,NULL,NULL,NULL);
         total_position += 1;
      }
     
     Print("real_balance: ", real_balance, " profit:", AccountInfoDouble(ACCOUNT_PROFIT), " Total position: ", Latest_Price.ask * total_position);
     
   } //End of bars
   currentBars = iBars("#USSPX500",PERIOD_W1);
  

   Comment("real_balance: ", real_balance, "\n",
   "total_position: ", Latest_Price.ask * total_position, "\n",
   "profit: ", AccountInfoDouble(ACCOUNT_PROFIT)
   );

 } //End on_tick

//+------------------------------------------------------------------+