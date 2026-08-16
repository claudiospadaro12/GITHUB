//+------------------------------------------------------------------+
//|                                        ABTG_SondaSessione.mq5    |
//|                                                                  |
//|  RISPONDE A UNA DOMANDA SOLA, e la risponde coi dati:            |
//|  il simbolo ha davvero un GAP fra la chiusura di ieri e          |
//|  l'apertura di oggi, oppure quota quasi 24 ore e quello che      |
//|  chiamiamo "gap" e' il MOVIMENTO NOTTURNO?                       |
//|                                                                  |
//|  Nasce da R61/R62 (GAPFILL Nasdaq): la tesi dell'EA e' "il gap   |
//|  di apertura si chiude", ma il gap e' calcolato su barre D1      |
//|  (ABTG_Nasdaq_Apertura_US.mq5:1425-1429) e su un CFD 24/5 fra    |
//|  chiusura D1 e apertura D1 non c'e' un vuoto di prezzo.          |
//|  Se il vuoto non c'e', i NUMERI restano validi ma il NOME della  |
//|  strategia e' sbagliato -- e va cambiato prima del forward.      |
//|                                                                  |
//|  USO: trascina su UN grafico qualsiasi, premi OK.                |
//|  NON apre posizioni, NON tocca ordini: legge e stampa.           |
//|  Guardare la scheda ESPERTI (non Journal).                       |
//|  Scrive anche MQL5\Files\ABTG_SondaSessione.csv                  |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string InpSimboli   = "NASUSD,D30EUR,225JPY";  // simboli da sondare, separati da virgola
input string InpDataInizio = "2024.09.26";           // da quando (inizio storico BCM misurato)
input int    InpMaxGiorni  = 40;                     // quanti giorni elencare nel dettaglio

//+------------------------------------------------------------------+
//| L'istogramma delle barre M1 per ora del server.                  |
//| E' la riga che decide: se TUTTE le 24 ore hanno barre, il        |
//| simbolo non dorme e il "gap" e' un'altra cosa.                   |
//+------------------------------------------------------------------+
void IstogrammaOre(string sym, datetime da)
  {
   MqlRates r[];
   int got = CopyRates(sym, PERIOD_M1, da, TimeCurrent(), r);
   if(got <= 0)
     { PrintFormat("  %-10s M1: NESSUN DATO (scarica prima lo storico)", sym); return; }

   long conta[24]; ArrayInitialize(conta, 0);
   for(int i = 0; i < got; i++)
     {
      MqlDateTime t; TimeToStruct(r[i].time, t);
      conta[t.hour]++;
     }

   long tot = 0, ore_vive = 0, ora_max = 0;
   for(int h = 0; h < 24; h++)
     { tot += conta[h]; if(conta[h] > 0) ore_vive++; if(conta[h] > conta[ora_max]) ora_max = h; }

   PrintFormat("  %-10s M1: %d barre dal %s -- ORE CON BARRE: %d su 24",
               sym, got, TimeToString(r[0].time, TIME_DATE), (int)ore_vive);

   //--- l'istogramma, in una riga per ora, con la percentuale sul massimo
   for(int h = 0; h < 24; h++)
     {
      int larghezza = (conta[ora_max] > 0) ? (int)((conta[h] * 40) / conta[ora_max]) : 0;
      string barra = ""; for(int k = 0; k < larghezza; k++) barra += "#";
      PrintFormat("     %02d:00 server | %6d |%s", h, (int)conta[h], barra);
     }

   //--- IL VERDETTO, che e' il motivo per cui lo script esiste
   if(ore_vive >= 23)
      PrintFormat("  >>> %s QUOTA QUASI 24 ORE (%d ore su 24). Fra chiusura D1 e apertura D1"
                  " NON c'e' un vuoto di prezzo: quello che l'EA chiama GAP e' il MOVIMENTO"
                  " NOTTURNO. La tesi 'il gap si chiude' va RINOMINATA.", sym, (int)ore_vive);
   else if(ore_vive <= 18)
      PrintFormat("  >>> %s ha una PAUSA VERA (%d ore su 24 con barre): il gap esiste come"
                  " vuoto di prezzo, e la tesi dell'EA regge come e' scritta.", sym, (int)ore_vive);
   else
      PrintFormat("  >>> %s: caso INTERMEDIO (%d ore su 24). Guardare quali ore sono vuote"
                  " nell'istogramma qui sopra prima di concludere.", sym, (int)ore_vive);
  }

//+------------------------------------------------------------------+
//| Il dettaglio giorno per giorno: quanto dista davvero l'ultima    |
//| barra di ieri dalla prima di oggi, e quanto vale il "gap".       |
//| Se il buco e' di 1-2 minuti, non e' un gap: e' continuita'.      |
//+------------------------------------------------------------------+
void DettaglioGiorni(string sym, datetime da, int maxgg, int hfile)
  {
   MqlRates d[];
   int nd = CopyRates(sym, PERIOD_D1, da, TimeCurrent(), d);
   if(nd < 2) { PrintFormat("  %-10s D1: dati insufficienti", sym); return; }

   double punto = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(punto <= 0) punto = _Point;

   PrintFormat("  %-10s DETTAGLIO (ultimi %d giorni con barre D1):", sym, maxgg);
   PrintFormat("     %-12s %10s %12s %14s %10s", "giorno", "gap(pt)", "buco(min)", "ultima barra", "prima");

   int inizio = MathMax(1, nd - maxgg);
   long buchi = 0, campioni = 0, buchi_lunghi = 0;

   for(int i = inizio; i < nd; i++)
     {
      double gap = (d[i].open - d[i-1].close) / punto;

      //--- l'ultima barra M1 PRIMA dell'apertura di oggi, e la prima DOPO
      MqlRates prima[], dopo[];
      int np = CopyRates(sym, PERIOD_M1, d[i].time - 6*3600, d[i].time - 1, prima);
      int nq = CopyRates(sym, PERIOD_M1, d[i].time, d[i].time + 3600, dopo);
      if(np <= 0 || nq <= 0) continue;

      datetime ultima = prima[np-1].time;
      datetime primad = dopo[0].time;
      long minuti = (long)((primad - ultima) / 60);

      buchi += minuti; campioni++;
      if(minuti > 5) buchi_lunghi++;

      PrintFormat("     %-12s %10.0f %12d %14s %10s",
                  TimeToString(d[i].time, TIME_DATE), gap, (int)minuti,
                  TimeToString(ultima, TIME_MINUTES), TimeToString(primad, TIME_MINUTES));

      if(hfile != INVALID_HANDLE)
         FileWrite(hfile, sym, TimeToString(d[i].time, TIME_DATE),
                   DoubleToString(gap, 0), (int)minuti,
                   TimeToString(ultima, TIME_MINUTES), TimeToString(primad, TIME_MINUTES));
     }

   if(campioni > 0)
     {
      double medio = (double)buchi / campioni;
      PrintFormat("  >>> %s: buco medio fra ultima barra di ieri e prima di oggi = %.1f minuti"
                  " (%d giorni su %d con buco > 5 min)",
                  sym, medio, (int)buchi_lunghi, (int)campioni);
      if(medio < 5.0)
         PrintFormat("  >>> %s: LA CONTINUITA' E' CONFERMATA. Il 'gap' dell'EA e' la differenza"
                     " fra due prezzi CONTRATTATI a pochi minuti di distanza, non un salto.", sym);
     }
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   datetime da = StringToTime(InpDataInizio);
   if(da <= 0) { Print("InpDataInizio non valida. Formato: 2024.09.26"); return; }

   string sym[];
   int n = StringSplit(InpSimboli, ',', sym);
   for(int i = 0; i < n; i++) { StringTrimLeft(sym[i]); StringTrimRight(sym[i]); }

   int h = FileOpen("ABTG_SondaSessione.csv", FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
   if(h != INVALID_HANDLE)
      FileWrite(h, "Simbolo", "Giorno", "Gap_punti", "Buco_minuti", "UltimaBarraIeri", "PrimaBarraOggi");

   Print("=== SONDA SESSIONE: il simbolo dorme davvero fra un giorno e l'altro? ===");
   PrintFormat("    da %s -- ora server adesso: %s",
               TimeToString(da, TIME_DATE), TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES));
   Print("    REGOLA DI CASA: ora server BCM = ora italiana - 1.");

   for(int i = 0; i < n; i++)
     {
      if(sym[i] == "") continue;
      if(!SymbolSelect(sym[i], true))
        { PrintFormat("  %-10s: simbolo non disponibile su questo broker", sym[i]); continue; }
      Print("");
      Print("--------------------------------------------------------------");
      IstogrammaOre(sym[i], da);
      Print("");
      DettaglioGiorni(sym[i], da, InpMaxGiorni, h);
     }

   if(h != INVALID_HANDLE) { FileClose(h); Print(""); Print("=== FINITO. Dettaglio in MQL5\\Files\\ABTG_SondaSessione.csv ==="); }
  }
//+------------------------------------------------------------------+
