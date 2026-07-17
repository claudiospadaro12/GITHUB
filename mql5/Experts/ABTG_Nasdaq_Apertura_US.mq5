//+------------------------------------------------------------------+
//|                                 ABTG_Nasdaq_Apertura_US.mq5       |
//|                                                                  |
//|  EA "APERTURA AMERICANA" (Nasdaq / NASUSD) - MetaTrader 5        |
//|                                                                  |
//|  Basato sul piano di trading "Apertura Americana - Nasdaq":     |
//|   - apertura USA alle 15:30 (ora italiana): rottura dei         |
//|     massimi/minimi in apertura (BUY STOP / SELL STOP)           |
//|   - OCO, parziale al 1o obiettivo, stop in pari, trailing stop  |
//|   - MODALITA' GAP FILL opzionale (apertura in gap -> ritorno    |
//|     verso la chiusura precedente): imposta InpEntryMode=GAPFILL |
//|     e InpUseGapFill=true                                        |
//|                                                                  |
//|  ⚠️ Gli ORARI sono quelli del SERVER del broker (quelli sul      |
//|     grafico): imposta InpSessionHour cosi' che coincida con     |
//|     l'apertura reale del Nasdaq cash sul TUO grafico            |
//|     (spesso 16:30 su broker GMT+2, 15:30 su GMT+3, ecc.).       |
//|                                                                  |
//|  ⚠️ Nessun EA garantisce profitti. TESTA SU DEMO prima.          |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

//--- DEFAULT specifici per il Nasdaq (usati dal motore ABTG_ApertureCore)
#define ABTG_DEF_NAME         "Nasdaq Apertura US"
#define ABTG_DEF_MAGIC        770201
#define ABTG_DEF_SESSION_HOUR 15     // apertura Nasdaq cash (server) - ADATTA AL TUO BROKER!
#define ABTG_DEF_SESSION_MIN  30
#define ABTG_DEF_RANGE_MIN    15     // range dei primi 15 minuti (alta volatilita')
#define ABTG_DEF_CLOSE_HOUR   21     // flat prima della chiusura serale (server)
#define ABTG_DEF_CLOSE_MIN    45
#define ABTG_DEF_USE_GAPFILL  false  // metti true + InpEntryMode=GAPFILL per il gap fill

#include <ABTG/ABTG_ApertureCore.mqh>

//+------------------------------------------------------------------+
int  OnInit()                         { return ABTG_OnInit();  }
void OnDeinit(const int reason)       { ABTG_OnDeinit(reason); }
void OnTick()                         { ABTG_OnTick();         }
//+------------------------------------------------------------------+
