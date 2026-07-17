//+------------------------------------------------------------------+
//|                                    ABTG_DAX_Apertura_EU.mq5       |
//|                                                                  |
//|  EA "APERTURA EUROPEA" (DAX / D30EUR) - MetaTrader 5             |
//|                                                                  |
//|  Basato sul piano di trading "Apertura Europea":                |
//|   - il DAX apre alle 09:00 (ora italiana): breakout del range   |
//|     di apertura con ordini pendenti sopra il max / sotto il min |
//|   - OCO, parziale al 1o obiettivo, stop in pari, trailing stop  |
//|   - rischio in % del capitale, filtri EMA/Supertrend/correlaz.  |
//|                                                                  |
//|  ⚠️ Gli ORARI sono quelli del SERVER del broker (quelli sul      |
//|     grafico): imposta InpSessionHour cosi' che coincida con     |
//|     l'apertura reale del DAX sul TUO grafico (spesso 10:00 su    |
//|     broker GMT+2, 09:00 su broker GMT+3, ecc.).                  |
//|                                                                  |
//|  ⚠️ Nessun EA garantisce profitti. TESTA SU DEMO prima.          |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

//--- DEFAULT specifici per il DAX (usati dal motore ABTG_ApertureCore)
#define ABTG_DEF_NAME         "DAX Apertura EU"
#define ABTG_DEF_MAGIC        770101
#define ABTG_DEF_SESSION_HOUR 9      // apertura DAX (server) - ADATTA AL TUO BROKER!
#define ABTG_DEF_SESSION_MIN  0
#define ABTG_DEF_RANGE_MIN    15     // range dei primi 15 minuti
#define ABTG_DEF_CLOSE_HOUR   17     // flat a fine mattinata/pomeriggio (server)
#define ABTG_DEF_CLOSE_MIN    30
#define ABTG_DEF_USE_GAPFILL  false  // sul DAX di default breakout, non gap fill

#include <ABTG/ABTG_ApertureCore.mqh>

//+------------------------------------------------------------------+
int  OnInit()                         { return ABTG_OnInit();  }
void OnDeinit(const int reason)       { ABTG_OnDeinit(reason); }
void OnTick()                         { ABTG_OnTick();         }
//+------------------------------------------------------------------+
