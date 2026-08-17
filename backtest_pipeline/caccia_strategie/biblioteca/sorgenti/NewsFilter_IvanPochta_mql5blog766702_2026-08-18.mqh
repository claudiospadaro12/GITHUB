//+------------------------------------------------------------------+
//| NewsFilter.mqh (MT5)                                             |
//| Economic Calendar based News Filter                              |
//| - Manual currencies list: "USD,EUR"                              |
//| - Importance dropdown                                            |
//| - Cache refresh every N seconds                                  |
//| - Optional debug on chart + Journal                              |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Ivan Pochta"
#ifndef __NEWSFILTER_MQH__
#define __NEWSFILTER_MQH__

//=========================== INPUTS ================================

input group "<< === News Filter === >>";  // > > > > > > > >

enum NEWS_IMPORTANCE_MODE
{
   NEWS_IMP_HIGH_ONLY = 0,      // High only (red)
   NEWS_IMP_MEDIUM_AND_HIGH,    // Medium + High
   NEWS_IMP_ALL                 // Low + Medium + High
};

input bool                 UseNewsFilter       = true;               // Enable News Filter
input NEWS_IMPORTANCE_MODE NewsImportance      = NEWS_IMP_HIGH_ONLY;  // News importance
input string               NewsCurrencies      = "USD,EUR";           // Currencies to block
input int                  NewsMinutesBefore   = 60;                 // Minutes BEFORE news to block
input int                  NewsMinutesAfter    = 60;                 // Minutes AFTER news to block
input bool                 NewsDebug           = false;              // Debug: show status on chart + Journal
input int                  NewsRefreshSeconds  = 3600;               // Cache refresh (sec)

//=========================== STATE =================================

static datetime NF_nextRefresh     = 0;   // TimeCurrent() based
static datetime NF_blockStart      = 0;   // server time
static datetime NF_blockEnd        = 0;   // server time
static string   NF_blockReason     = "";
static bool     NF_haveBlockWindow = false;

// debug state
static bool     NF_prevBlocked     = false;
static datetime NF_prevDbgMinute   = 0;

//=========================== HELPERS ===============================

string NF_ToUpperTrim(string s)
{
   StringTrimLeft(s);
   StringTrimRight(s);
   StringToUpper(s); // MT5
   return s;
}

int NF_SplitCSV(const string csv, string &arr[])
{
   ArrayResize(arr, 0);

   string s = csv;
   StringReplace(s, ";", ",");     // MT5: modifies s by ref, returns int
   StringReplace(s, " ", "");

   if(StringLen(s) == 0)
      return 0;

   string tmp[];
   int n = StringSplit(s, ',', tmp);
   if(n <= 0)
      return 0;

   for(int i=0;i<n;i++)
   {
      string t = NF_ToUpperTrim(tmp[i]);
      if(StringLen(t) > 0)
      {
         int k = ArraySize(arr);
         ArrayResize(arr, k+1);
         arr[k] = t;
      }
   }
   return ArraySize(arr);
}

ENUM_CALENDAR_EVENT_IMPORTANCE NF_MinImportanceFromMode(NEWS_IMPORTANCE_MODE m)
{
   switch(m)
   {
      case NEWS_IMP_HIGH_ONLY:         return CALENDAR_IMPORTANCE_HIGH;
      case NEWS_IMP_MEDIUM_AND_HIGH:   return CALENDAR_IMPORTANCE_MODERATE;
      case NEWS_IMP_ALL:               return CALENDAR_IMPORTANCE_LOW;
   }
   return CALENDAR_IMPORTANCE_HIGH;
}

//=========================== CACHE =================================

void NF_RefreshCache()
{
   NF_haveBlockWindow = false;
   NF_blockStart      = 0;
   NF_blockEnd        = 0;
   NF_blockReason     = "";

   datetime now_server = TimeTradeServer();

   // Auto horizon: before + refresh interval + 5 minutes safety
   int horizon = NewsMinutesBefore + (NewsRefreshSeconds / 60) + 5;
   if(horizon < NewsMinutesBefore + 5) horizon = NewsMinutesBefore + 5;

   datetime from = now_server;
   datetime to   = now_server + horizon * 60;

   string cur[];
   if(NF_SplitCSV(NewsCurrencies, cur) <= 0)
      return;

   ENUM_CALENDAR_EVENT_IMPORTANCE min_imp = NF_MinImportanceFromMode(NewsImportance);

   datetime bestStart = 0;
   datetime bestEnd   = 0;
   string   bestWhy   = "";

   for(int i=0;i<ArraySize(cur);i++)
   {
      string c = cur[i];
      if(StringLen(c) == 0) continue;

      // de-duplicate
      bool dup = false;
      for(int j=0;j<i;j++)
         if(cur[j] == c) { dup = true; break; }
      if(dup) continue;

      MqlCalendarValue values[];
      if(!CalendarValueHistory(values, from, to, NULL, c))
         continue;

      for(int k=0;k<ArraySize(values);k++)
      {
         MqlCalendarEvent ev;
         if(!CalendarEventById(values[k].event_id, ev))
            continue;

         if(ev.importance < min_imp)
            continue;

         datetime t  = values[k].time;
         datetime ws = t - NewsMinutesBefore * 60;
         datetime we = t + NewsMinutesAfter  * 60;

         if(we <= now_server) continue;

         if(!NF_haveBlockWindow || ws < bestStart)
         {
            bestStart = ws;
            bestEnd   = we;
            bestWhy   = StringFormat("%s | %s | %s", c, ev.name, TimeToString(t, TIME_DATE|TIME_MINUTES));
            NF_haveBlockWindow = true;
         }
      }
   }

   if(NF_haveBlockWindow)
   {
      NF_blockStart  = bestStart;
      NF_blockEnd    = bestEnd;
      NF_blockReason = bestWhy;
   }
}

//=========================== PUBLIC API ============================

void NewsFilter_Init()
{
   NF_nextRefresh     = 0;
   NF_haveBlockWindow = false;
   NF_blockStart      = 0;
   NF_blockEnd        = 0;
   NF_blockReason     = "";

   NF_prevBlocked     = false;
   NF_prevDbgMinute   = 0;

   if(UseNewsFilter)
      NF_RefreshCache();

   int sec = NewsRefreshSeconds;
   if(sec < 10) sec = 10;
   NF_nextRefresh = TimeCurrent() + sec;
}

void NewsFilter_Deinit()
{
   Comment("");

   NF_nextRefresh     = 0;
   NF_haveBlockWindow = false;
   NF_blockStart      = 0;
   NF_blockEnd        = 0;
   NF_blockReason     = "";

   NF_prevBlocked     = false;
   NF_prevDbgMinute   = 0;
}

bool NewsFilter_Blocked(string &reason)
{
   reason = "";

   if(!UseNewsFilter)
      return false;

   datetime now_local = TimeCurrent();

   if(NF_nextRefresh == 0 || now_local >= NF_nextRefresh)
   {
      NF_RefreshCache();

      int sec = NewsRefreshSeconds;
      if(sec < 10) sec = 10;
      NF_nextRefresh = now_local + sec;
   }

   if(!NF_haveBlockWindow)
      return false;

   datetime now_server = TimeTradeServer();

   if(now_server > NF_blockEnd)
      return false;

   if(now_server >= NF_blockStart && now_server <= NF_blockEnd)
   {
      reason = NF_blockReason;
      return true;
   }

   return false;
}

void NewsFilter_DebugUpdate()
{
   if(!NewsDebug)
      return;

   string reason="";
   bool blocked = NewsFilter_Blocked(reason);

   datetime now = TimeCurrent();
   MqlDateTime tm;
   TimeToStruct(now, tm);
   datetime curMinute = (datetime)(now - tm.sec);

   if(curMinute == NF_prevDbgMinute && blocked == NF_prevBlocked)
      return;

   NF_prevDbgMinute = curMinute;

   if(blocked != NF_prevBlocked)
   {
      NF_prevBlocked = blocked;
      if(blocked) Print("NEWS FILTER: TRADING BLOCKED. ", reason);
      else        Print("NEWS FILTER: TRADING ALLOWED.");
   }

   if(blocked)
   {
      Comment("NEWS FILTER:  BLOCKED\n",
              reason, "\nWindow: ",
              TimeToString(NF_blockStart, TIME_DATE|TIME_MINUTES),
              " - ",
              TimeToString(NF_blockEnd,   TIME_DATE|TIME_MINUTES));
   }
   else
   {
      Comment("NEWS FILTER:  ALLOWED\nNext refresh: ",
              TimeToString(NF_nextRefresh, TIME_DATE|TIME_SECONDS));
   }
}

// Optional getters
datetime NewsFilter_BlockStart() { return NF_blockStart; }
datetime NewsFilter_BlockEnd()   { return NF_blockEnd;   }

#endif // __NEWSFILTER_MQH__