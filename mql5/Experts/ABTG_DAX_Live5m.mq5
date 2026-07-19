//+------------------------------------------------------------------+
//|                                       ABTG_DAX_Live5m.mq5         |
//|                                                                  |
//|  EA "DAX LIVE 5m" - variante che applica al DAX la logica della  |
//|  live di E. Monza (candela 5 minuti pre-apertura).              |
//|                                                                  |
//|  DIFFERENZE rispetto a ABTG_DAX_Apertura_EU:                    |
//|   - candela TRIGGER = i 5 minuti PRIMA dell'apertura            |
//|     (08:55-09:00 IT) invece del range dei primi 15 minuti      |
//|   - ordini a 7 punti indice oltre max/min (buffer 700)         |
//|                                                                  |
//|  Il filtro ampiezza candela (17-40) qui e' DISATTIVO di default |
//|  perche' quei valori erano tarati sul Nasdaq: se vuoi, imposta  |
//|  InpMinRangePts / InpMaxRangePts sui valori del DAX dopo aver   |
//|  osservato le sue candele di pre-apertura.                     |
//|                                                                  |
//|  ⚠️ Orari in ORA SERVER. TESTA SU DEMO. Grafico SEPARATO dal    |
//|     primo EA DAX (magic number diverso).                        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

//--- DEFAULT specifici (motore ABTG_ApertureCore)
#define ABTG_DEF_NAME         "DAX Live 5m"
#define ABTG_DEF_MAGIC        770103        // diverso dal primo DAX (770101)
#define ABTG_DEF_SESSION_HOUR 8             // 09:00 IT = 08:00 server (BCM) - ADATTA AL TUO BROKER!
#define ABTG_DEF_SESSION_MIN  0
#define ABTG_DEF_RANGE_MODE   1             // 1 = finestra PRIMA dell'apertura...
#define ABTG_DEF_PREVWIN      5             // ...di 5 minuti = candela 08:55-09:00
#define ABTG_DEF_BUFFER       700           // 7 punti indice oltre max/min
#define ABTG_DEF_MINRANGE     0             // filtro ampiezza OFF (taralo sul DAX se vuoi)
#define ABTG_DEF_MAXRANGE     0
#define ABTG_DEF_CLOSE_HOUR   17            // flat pomeriggio (server)
#define ABTG_DEF_CLOSE_MIN    30
#define ABTG_DEF_TRAIL_MODE   1             // trailing base candela precedente
#define ABTG_DEF_USE_GAPFILL  false

#include <ABTG/ABTG_ApertureCore.mqh>

//+------------------------------------------------------------------+
int  OnInit()                         { return ABTG_OnInit();  }
void OnDeinit(const int reason)       { ABTG_OnDeinit(reason); }
void OnTick()                         { ABTG_OnTick();         }
//+------------------------------------------------------------------+
