//+------------------------------------------------------------------+
//|                                           SeasonalityIndicator.mq5 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_plots   3

//--- plot Seasonality
#property indicator_label1  "Seasonality"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrDodgerBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

//--- plot Forecast Line
#property indicator_label2  "Forecast"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_DASH
#property indicator_width2  2

//--- plot Forecast Points
#property indicator_label3  "Forecast Points"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrOrange
#property indicator_width3  3

//--- Input parameters
enum ENUM_SEASONALITY_TYPE
{
   SEASONALITY_DAYS_OF_MONTH = 0,  // Days of month (1-31)
   SEASONALITY_DAYS_OF_WEEK = 1,   // Days of week (Mon-Sun)
   SEASONALITY_HOURS = 2           // Hours (0-23)
};

input ENUM_SEASONALITY_TYPE SeasonalityType = SEASONALITY_DAYS_OF_MONTH; // Seasonality type
input int BarsToAnalyze = 1000;                                          // Number of bars to analyze
input bool ShowPercentage = true;                                        // Show in percentage
input bool ShowPositiveOnly = false;                                     // Show only positive values
input bool ShowForecastOnChart = true;                                   // Show forecast on chart
input color ForecastColor = clrRed;                                      // Forecast line color
input color ForecastPointsColor = clrOrange;                            // Forecast points color

//--- Indicator buffers
double SeasonalityBuffer[];
double ForecastLineBuffer[];
double ForecastPointsBuffer[];

//--- Global variables
double seasonality_data[];
string period_labels[];
int periods_count;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Set indicator buffers
   SetIndexBuffer(0, SeasonalityBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, ForecastLineBuffer, INDICATOR_DATA);
   SetIndexBuffer(2, ForecastPointsBuffer, INDICATOR_DATA);
   
   //--- Configure arrows for forecast
   PlotIndexSetInteger(2, PLOT_ARROW, 159); // Up/down arrow
   
   //--- Apply colors from settings
   PlotIndexSetInteger(1, PLOT_LINE_COLOR, ForecastColor);
   PlotIndexSetInteger(2, PLOT_LINE_COLOR, ForecastPointsColor);
   
   //--- Define number of periods and labels
   switch(SeasonalityType)
   {
      case SEASONALITY_DAYS_OF_MONTH:
         periods_count = 31;
         ArrayResize(period_labels, periods_count);
         for(int i = 0; i < periods_count; i++)
            period_labels[i] = IntegerToString(i + 1);
         IndicatorSetString(INDICATOR_SHORTNAME, "Seasonality by Days of Month");
         break;
         
      case SEASONALITY_DAYS_OF_WEEK:
         periods_count = 7;
         ArrayResize(period_labels, periods_count);
         period_labels[0] = "Mon";
         period_labels[1] = "Tue";
         period_labels[2] = "Wed";
         period_labels[3] = "Thu";
         period_labels[4] = "Fri";
         period_labels[5] = "Sat";
         period_labels[6] = "Sun";
         IndicatorSetString(INDICATOR_SHORTNAME, "Seasonality by Days of Week");
         break;
         
      case SEASONALITY_HOURS:
         periods_count = 24;
         ArrayResize(period_labels, periods_count);
         for(int i = 0; i < periods_count; i++)
            period_labels[i] = IntegerToString(i) + ":00";
         IndicatorSetString(INDICATOR_SHORTNAME, "Seasonality by Hours");
         break;
   }
   
   //--- Initialize seasonality data array
   ArrayResize(seasonality_data, periods_count);
   ArrayInitialize(seasonality_data, 0.0);
   
   //--- Set display precision
   IndicatorSetInteger(INDICATOR_DIGITS, ShowPercentage ? 2 : _Digits);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator calculation function                            |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   //--- Check data sufficiency
   if(rates_total < BarsToAnalyze + 1)
      return(0);
   
   //--- Clear seasonality array
   ArrayInitialize(seasonality_data, 0.0);
   
   //--- Arrays for calculations
   double period_returns[];
   int period_counts[];
   ArrayResize(period_returns, periods_count);
   ArrayResize(period_counts, periods_count);
   ArrayInitialize(period_returns, 0.0);
   ArrayInitialize(period_counts, 0);
   
   //--- Analyze historical data
   int start_pos = MathMax(0, rates_total - BarsToAnalyze - 1);
   
   for(int i = start_pos; i < rates_total - 1; i++)
   {
      //--- Calculate return
      double return_value = 0.0;
      if(close[i] != 0)
         return_value = (close[i+1] - close[i]) / close[i];
      
      //--- Determine period based on seasonality type
      int period_index = GetPeriodIndex(time[i]);
      
      if(period_index >= 0 && period_index < periods_count)
      {
         period_returns[period_index] += return_value;
         period_counts[period_index]++;
      }
   }
   
   //--- Calculate average values
   for(int i = 0; i < periods_count; i++)
   {
      if(period_counts[i] > 0)
      {
         seasonality_data[i] = period_returns[i] / period_counts[i];
         
         //--- Convert to percentage if needed
         if(ShowPercentage)
            seasonality_data[i] *= 100.0;
            
         //--- Show only positive values if needed
         if(ShowPositiveOnly && seasonality_data[i] < 0)
            seasonality_data[i] = 0.0;
      }
   }
   
   //--- Fill indicator buffers
   for(int i = 0; i < rates_total; i++)
   {
      int period_index = GetPeriodIndex(time[i]);
      if(period_index >= 0 && period_index < periods_count)
      {
         SeasonalityBuffer[i] = seasonality_data[period_index];
         ForecastLineBuffer[i] = seasonality_data[period_index];
      }
      else
      {
         SeasonalityBuffer[i] = 0.0;
         ForecastLineBuffer[i] = 0.0;
      }
      
      // Initialize forecast points buffer
      ForecastPointsBuffer[i] = EMPTY_VALUE;
   }
   
   //--- Draw forecast on last bars
   if(ShowForecastOnChart)
      DrawForecastOnChart(rates_total, time);
   
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Function called on each tick                                     |
//+------------------------------------------------------------------+
void OnTimer()
{
   ShowStatistics();
}

//+------------------------------------------------------------------+
//| Function called on chart change                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   if(id == CHARTEVENT_CHART_CHANGE)
      ShowStatistics();
}

//+------------------------------------------------------------------+
//| Function for drawing forecast on chart                          |
//+------------------------------------------------------------------+
void DrawForecastOnChart(int rates_total, const datetime &time[])
{
   if(rates_total < 3)
      return;
   
   //--- Get current period and next two
   datetime current_time = time[rates_total - 1];
   int current_period = GetPeriodIndex(current_time);
   int next_period1 = GetNextPeriod(current_period);
   int next_period2 = GetNextPeriod(next_period1);
   
   //--- Calculate positions for forecast (next 2 bars)
   int forecast_pos1 = rates_total - 2;
   int forecast_pos2 = rates_total - 1;
   
   //--- Draw forecast with line
   if(next_period1 >= 0 && next_period1 < periods_count)
   {
      ForecastLineBuffer[forecast_pos1] = seasonality_data[next_period1];
      ForecastPointsBuffer[forecast_pos1] = seasonality_data[next_period1];
   }
   
   if(next_period2 >= 0 && next_period2 < periods_count)
   {
      ForecastLineBuffer[forecast_pos2] = seasonality_data[next_period2];
      ForecastPointsBuffer[forecast_pos2] = seasonality_data[next_period2];
   }
   
   //--- Connect current value with forecast
   if(rates_total >= 3)
   {
      int current_pos = rates_total - 3;
      int current_period_idx = GetPeriodIndex(time[current_pos]);
      
      if(current_period_idx >= 0 && current_period_idx < periods_count)
      {
         // Create smooth transition from current to forecast
         double current_value = seasonality_data[current_period_idx];
         double next_value = (next_period1 >= 0) ? seasonality_data[next_period1] : current_value;
         
         // Interpolation for smoothness
         ForecastLineBuffer[current_pos] = current_value;
         if(forecast_pos1 < rates_total)
            ForecastLineBuffer[forecast_pos1] = next_value;
      }
   }
}

//+------------------------------------------------------------------+
//| Function to get period index based on seasonality type          |
//+------------------------------------------------------------------+
int GetPeriodIndex(datetime bar_time)
{
   MqlDateTime dt;
   TimeToStruct(bar_time, dt);
   
   switch(SeasonalityType)
   {
      case SEASONALITY_DAYS_OF_MONTH:
         return(dt.day - 1); // 0-30 for days 1-31
         
      case SEASONALITY_DAYS_OF_WEEK:
         // Sunday = 0, Monday = 1, ... Saturday = 6
         // Convert to Monday = 0, ... Sunday = 6
         return(dt.day_of_week == 0 ? 6 : dt.day_of_week - 1);
         
      case SEASONALITY_HOURS:
         return(dt.hour); // 0-23
   }
   
   return(-1);
}

//+------------------------------------------------------------------+
//| Indicator event handling function                               |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Free arrays
   ArrayFree(seasonality_data);
   ArrayFree(period_labels);
}

//+------------------------------------------------------------------+
//| Function to get text description of period                      |
//+------------------------------------------------------------------+
string GetPeriodDescription(int period_index)
{
   if(period_index >= 0 && period_index < periods_count)
      return(period_labels[period_index]);
   
   return("Unknown period");
}

//+------------------------------------------------------------------+
//| Function to get forecast for next periods                       |
//+------------------------------------------------------------------+
string GetForecast()
{
   datetime current_time = TimeCurrent();
   string forecast_text = "\n=== FORECAST ===\n";
   
   //--- Get current period and next two
   int current_period = GetPeriodIndex(current_time);
   int next_period1 = GetNextPeriod(current_period);
   int next_period2 = GetNextPeriod(next_period1);
   
   //--- Forecast for first next period
   if(next_period1 >= 0)
   {
      forecast_text += "Next period (" + period_labels[next_period1] + "): ";
      
      if(seasonality_data[next_period1] > 0)
         forecast_text += "POSITIVE ";
      else if(seasonality_data[next_period1] < 0)
         forecast_text += "NEGATIVE ";
      else
         forecast_text += "NEUTRAL ";
         
      forecast_text += DoubleToString(seasonality_data[next_period1], 3) + 
                      (ShowPercentage ? "%\n" : "\n");
   }
   
   //--- Forecast for second next period
   if(next_period2 >= 0)
   {
      forecast_text += "After next (" + period_labels[next_period2] + "): ";
      
      if(seasonality_data[next_period2] > 0)
         forecast_text += "POSITIVE ";
      else if(seasonality_data[next_period2] < 0)
         forecast_text += "NEGATIVE ";
      else
         forecast_text += "NEUTRAL ";
         
      forecast_text += DoubleToString(seasonality_data[next_period2], 3) + 
                      (ShowPercentage ? "%\n" : "\n");
   }
   
   return(forecast_text);
}

//+------------------------------------------------------------------+
//| Function to get next period                                     |
//+------------------------------------------------------------------+
int GetNextPeriod(int current_period)
{
   if(current_period < 0)
      return(-1);
   
   switch(SeasonalityType)
   {
      case SEASONALITY_DAYS_OF_MONTH:
         return((current_period + 1) % 31);
         
      case SEASONALITY_DAYS_OF_WEEK:
         return((current_period + 1) % 7);
         
      case SEASONALITY_HOURS:
         return((current_period + 1) % 24);
   }
   
   return(-1);
}

//+------------------------------------------------------------------+
//| Function to display statistics in comment                       |
//+------------------------------------------------------------------+
void ShowStatistics()
{
   string comment_text = "";
   
   switch(SeasonalityType)
   {
      case SEASONALITY_DAYS_OF_MONTH:
         comment_text = "=== SEASONALITY BY DAYS OF MONTH ===\n";
         break;
      case SEASONALITY_DAYS_OF_WEEK:
         comment_text = "=== SEASONALITY BY DAYS OF WEEK ===\n";
         break;
      case SEASONALITY_HOURS:
         comment_text = "=== SEASONALITY BY HOURS ===\n";
         break;
   }
   
   comment_text += "Analyzed bars: " + IntegerToString(BarsToAnalyze) + "\n";
   
   //--- Add forecast
   comment_text += GetForecast();
   
   //--- Find best and worst periods
   double max_value = -999999;
   double min_value = 999999;
   int max_index = -1;
   int min_index = -1;
   
   for(int i = 0; i < periods_count; i++)
   {
      if(seasonality_data[i] > max_value)
      {
         max_value = seasonality_data[i];
         max_index = i;
      }
      
      if(seasonality_data[i] < min_value)
      {
         min_value = seasonality_data[i];
         min_index = i;
      }
   }
   
   comment_text += "\n=== STATISTICS ===\n";
   
   if(max_index >= 0)
      comment_text += "Best period: " + period_labels[max_index] + 
                     " (" + DoubleToString(max_value, 3) + 
                     (ShowPercentage ? "%)" : ")") + "\n";
   
   if(min_index >= 0)
      comment_text += "Worst period: " + period_labels[min_index] + 
                     " (" + DoubleToString(min_value, 3) + 
                     (ShowPercentage ? "%)" : ")") + "\n\n";
   
   //--- Display all values
   comment_text += "=== COMPLETE STATISTICS ===\n";
   for(int i = 0; i < periods_count; i++)
   {
      comment_text += period_labels[i] + ": " + 
                     DoubleToString(seasonality_data[i], 3) + 
                     (ShowPercentage ? "%" : "") + "\n";
   }
   
   Comment(comment_text);
}