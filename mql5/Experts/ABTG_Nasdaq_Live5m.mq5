//+------------------------------------------------------------------+
//|                                     ABTG_Nasdaq_Live5m.mq5        |
//|                                                                  |
//|  EA "NASDAQ LIVE 5m" - variante basata sulla LIVE del 17/07/26   |
//|  (strategia apertura Nasdaq di E. Monza).                        |
//|                                                                  |
//|  DIFFERENZE rispetto a ABTG_Nasdaq_Apertura_US:                 |
//|   - candela TRIGGER = i 5 minuti PRIMA dell'apertura            |
//|     (15:25-15:30 IT), non la candela H1 precedente             |
//|     -> RANGE_PREV con finestra 5 minuti                        |
//|   - ordini a 7 punti indice oltre max/min (buffer 700)         |
//|   - FILTRO ampiezza candela: opera solo se e' tra 17 e 40      |
//|     punti indice (1700-4000), come da live                     |
//|   - stesso rischio %, parziale + stop in pari + trailing        |
//|                                                                  |
//|  ⚠️ NON include l'hedging "Piano B/C" della live (aggiunta di    |
//|     size in perdita): e' la parte che causa i grossi drawdown.  |
//|                                                                  |
//|  ⚠️ Orari in ORA SERVER. Nessun EA garantisce profitti.         |
//|     TESTA SU DEMO. Da far girare su un grafico SEPARATO dal     |
//|     primo EA Nasdaq (magic number diverso).                     |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

//--- DEFAULT specifici (motore ABTG_ApertureCore)
#define ABTG_DEF_NAME         "Nasdaq Live 5m"
#define ABTG_DEF_MAGIC        770203        // diverso dagli altri Nasdaq (770201/770202)
#define ABTG_DEF_SESSION_HOUR 14            // 15:30 IT = 14:30 server (BCM) - ADATTA AL TUO BROKER!
#define ABTG_DEF_SESSION_MIN  30
#define ABTG_DEF_RANGE_MODE   1             // 1 = finestra PRIMA dell'apertura...
#define ABTG_DEF_PREVWIN      5             // ...di 5 minuti = candela 15:25-15:30
#define ABTG_DEF_BUFFER       700           // 7 punti indice oltre max/min (live)
#define ABTG_DEF_MINRANGE     1700          // candela >= 17 punti indice (live)
#define ABTG_DEF_MAXRANGE     4000          // candela <= 40 punti indice (live)
#define ABTG_DEF_CLOSE_HOUR   20            // flat prima della chiusura USA (server)
#define ABTG_DEF_CLOSE_MIN    45
#define ABTG_DEF_TRAIL_MODE   1             // trailing base candela precedente (M1)
#define ABTG_DEF_USE_GAPFILL  false

#include <ABTG/ABTG_ApertureCore.mqh>

//+------------------------------------------------------------------+
int  OnInit()                         { return ABTG_OnInit();  }
void OnDeinit(const int reason)       { ABTG_OnDeinit(reason); }
void OnTick()                         { ABTG_OnTick();         }
//+------------------------------------------------------------------+
