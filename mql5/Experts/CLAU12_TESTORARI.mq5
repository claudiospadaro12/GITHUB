//+------------------------------------------------------------------+
//| CLAU12_TESTORARI.mq5 - collaudo della libreria CLAU12_ORARI.mqh        |
//| Non apre ordini. Scrive nel giornale righe CLAU12_TIME_*.           |
//| Usare nel tester (qualsiasi simbolo/periodo breve) o su un grafico.|
//+------------------------------------------------------------------+
#property copyright "CLAU12"
#property version   "1.00"
#property strict
#include <CLAU12/CLAU12_ORARI.mqh>

int OnInit()
{
   string rep; int casi=0; int bad=CLAU12_Time_SelfTest(rep,casi);
   PrintFormat("CLAU12_TIME_SELFTEST versione %s: casi=%d falliti=%d %s",CLAU12_TIME_VERSION,casi,bad,(bad==0?"TUTTO_OK":"ERRORI"));
   if(bad>0) Print("CLAU12_TIME_ERRORI:\n"+rep);
   CLAU12_Zone srv; string nome; bool ok=CLAU12_DetectServer(srv,nome);
   PrintFormat("CLAU12_TIME_SERVER: %s riconosciuto=%s account_server=%s tester=%s",nome,(ok?"si":"no"),AccountInfoString(ACCOUNT_SERVER),(MQLInfoInteger(MQL_TESTER)?"si":"no"));
   if(ok) Print("CLAU12_TIME_LIVE: "+CLAU12_LiveCheck(srv));
   // tabella di esempio: aperture in ora del fuso di riferimento -> ora del server BCM e FTMO
   int d[7][3]={{2026,3,27},{2026,3,30},{2026,10,23},{2026,10,26},{2026,10,30},{2026,11,2},{2026,11,16}};
   for(int i=0;i<7;i++)
   {
      datetime dax_b=CLAU12_RefToServer(CLAU12_ZoneBerlin(),CLAU12_ZoneBCM(),d[i][0],d[i][1],d[i][2],9,0);
      datetime dax_f=CLAU12_RefToServer(CLAU12_ZoneBerlin(),CLAU12_ZoneFTMO(),d[i][0],d[i][1],d[i][2],9,0);
      datetime nas_b=CLAU12_RefToServer(CLAU12_ZoneNewYork(),CLAU12_ZoneBCM(),d[i][0],d[i][1],d[i][2],9,30);
      datetime nas_f=CLAU12_RefToServer(CLAU12_ZoneNewYork(),CLAU12_ZoneFTMO(),d[i][0],d[i][1],d[i][2],9,30);
      PrintFormat("CLAU12_TIME_TABELLA %04d-%02d-%02d: DAX 09:00 Berlino = BCM %s / FTMO %s ; Nasdaq 09:30 New York = BCM %s / FTMO %s",
                  d[i][0],d[i][1],d[i][2],TimeToString(dax_b,TIME_MINUTES),TimeToString(dax_f,TIME_MINUTES),TimeToString(nas_b,TIME_MINUTES),TimeToString(nas_f,TIME_MINUTES));
   }
   return INIT_SUCCEEDED;
}
void OnTick(){}
