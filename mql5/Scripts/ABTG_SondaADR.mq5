//+------------------------------------------------------------------+
//|                                             ABTG_SondaADR.mq5    |
//|                                                                  |
//|  RISPONDE A UNA DOMANDA SOLA, e la risponde coi dati:            |
//|  QUANTO PESA non sapere quale indicatore sia la "Volatilita'     |
//|  Media Giornaliera - ImpPeriods: 50" del corso Point Break?      |
//|                                                                  |
//|  PERCHE' ESISTE (proposta P-PB1, 21/08/2026):                    |
//|  il PIANO DI TRADING di Christian Bertacchi (slide 20, punto 3)  |
//|  prescrive un PAVIMENTO DI VOLATILITA' sullo stop:               |
//|     SL = max( spike +- 10/15 pip , ADR(50) + 10/15 pip )         |
//|  Ma NON dice quale indicatore calcola quell'ADR. Se lo           |
//|  definiamo noi, non e' piu' la loro regola (regola di casa).     |
//|  Prima di chiederlo a Claudio e restare fermi, si MISURA         |
//|  quanto cambia il numero fra definizioni tutte ragionevoli:      |
//|  se la forchetta e' piu' STRETTA della discrezionalita' che il   |
//|  corso stesso si concede (il buffer "10/15 pip" = 5 pip di       |
//|  scelta libera), allora il prerequisito NON e' piu' bloccante    |
//|  e basta DICHIARARE quale definizione usiamo.                    |
//|                                                                  |
//|  LE SETTE DEFINIZIONI MESSE A CONFRONTO (tutte legittime):       |
//|   V1 media(High-Low) su 50 D1 CHIUSE      <- la piu' comune      |
//|   V2 media(True Range) su 50 D1           <- include i gap       |
//|   V3 media(High-Low) su 50 D1 SENZA le barre della DOMENICA      |
//|      (sul forex il broker apre la domenica sera: quella barra    |
//|       e' lunga 1-2 ore e tira la media in basso)                 |
//|   V4 MEDIANA(High-Low) su 50 D1           <- robusta agli spike  |
//|   V5 ATR(50) di Wilder su D1              <- media smorzata      |
//|   V6 media(High-Low) su 50 barre del TF DEL GRAFICO              |
//|      (l'errore classico: su H12 sono 25 giorni, non 50)          |
//|   V7 come V1 ma INCLUDENDO la barra di oggi in formazione        |
//|   + V8 media(High-Low) su 20 D1: NON e' una definizione diversa, |
//|     e' un PERIODO diverso. Serve solo per confronto di scala.    |
//|                                                                  |
//|  LA TARATURA (il pezzo che puo' CHIUDERE la domanda):            |
//|  le slide stampano due letture vere dell'indicatore del corso:   |
//|     AUDUSD 57.02 pips (slide 4, grafico H12)                     |
//|     GBPUSD 83.73 pips (slide 20, grafico Daily)                  |
//|  entrambe di circa meta' giugno 2025. Lo script cerca            |
//|  all'indietro se e in quale giorno una delle definizioni         |
//|  riproduce quei numeri. Se una sola li riproduce ENTRAMBE,       |
//|  la domanda 4 a Claudio e' risposta da una MISURA.               |
//|  ATTENZIONE: il dato e' del broker di Christian, non BCM.        |
//|  Una mancata corrispondenza NON dimostra niente; una             |
//|  corrispondenza su due simboli e due TF diversi si'.             |
//|                                                                  |
//|  USO: trascina su UN grafico qualsiasi, premi OK.                |
//|  NON apre posizioni, NON tocca ordini, NON tocca nessuna         |
//|  sedia in forward: legge storico e stampa.                       |
//|  Guardare la scheda ESPERTI (non Journal).                       |
//|  Scrive anche MQL5\Files\ABTG_SondaADR.csv                       |
//|                                                                  |
//|  PREREQUISITO: lo storico D1 dei simboli va gia' scaricato       |
//|  (Strumenti -> Simboli -> Barre, oppure ABTG_HistoryDownloader). |
//|  Se un simbolo stampa "NESSUN DATO", non e' un errore dello      |
//|  script: mancano le barre.                                       |
//|                                                                  |
//|  Non compilato ne' eseguito dall'autore del codice: compilare    |
//|  in MetaEditor e leggere i numeri nel terminale.                 |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property script_show_inputs
#property strict

input string InpSimboli        = "GBPUSD,AUDUSD,EURUSD,AUDCAD"; // simboli, separati da virgola
input int    InpPeriodi        = 50;          // periodi dell'ADR (corso: ImpPeriods 50)
input int    InpGiorniStoria   = 500;         // su quanti giorni misurare la FORCHETTA
input double InpBufferPip      = 12.5;        // buffer del corso: 10/15 pip -> centro 12,5
input ENUM_TIMEFRAMES InpTF_V6 = PERIOD_H12;  // TF per la variante V6 (slide 4 e' un H12)
input string InpCercaValori    = "GBPUSD=83.73,AUDUSD=57.02"; // letture stampate sulle slide
input double InpTolleranzaPip  = 0.05;        // tolleranza della taratura, in pip
input int    InpFinestraRicerca= 400;         // quante barre indietro cercare quelle letture
input double InpSogliaVerde    = 5.0;         // forchetta mediana sotto cui l'ambiguita' NON blocca
input double InpSogliaRossa    = 15.0;        // forchetta oltre cui l'ambiguita' resta bloccante

//--- etichette delle varianti, usate ovunque: l'ordine NON si cambia
string gNomi[8] =
  {
   "V1 media(H-L) 50 D1 chiuse",
   "V2 media(TrueRange) 50 D1",
   "V3 media(H-L) 50 D1 senza domeniche",
   "V4 MEDIANA(H-L) 50 D1",
   "V5 ATR(50) Wilder D1",
   "V6 media(H-L) 50 barre del TF scelto",
   "V7 media(H-L) 50 D1 con la barra di oggi",
   "V8 media(H-L) 20 D1 (periodo diverso)"
  };

//+------------------------------------------------------------------+
//| Il pip come lo intende il corso: 4 decimali sul forex, cioe'     |
//| 10 punti sui broker a 5 cifre. Sui simboli senza pip vero        |
//| (indici, metalli) restituisce il punto e lo si dichiara.         |
//+------------------------------------------------------------------+
double PipSize(string sym)
  {
   int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   double punto  = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(punto <= 0.0) return(0.0);
   if(digits == 3 || digits == 5) return(punto * 10.0);
   return(punto);
  }

//+------------------------------------------------------------------+
//| V1 - media dei range su P barre CHIUSE, a partire da off.        |
//| off = 0 e' "adesso": le barre chiuse sono gli indici 1..P.       |
//+------------------------------------------------------------------+
double MediaHL(MqlRates &r[], int got, int off, int P, double pip)
  {
   if(pip <= 0.0 || P <= 0) return(0.0);
   if(got < off + P + 1)    return(0.0);
   double somma = 0.0;
   for(int i = 1 + off; i <= P + off; i++) somma += (r[i].high - r[i].low);
   return(somma / P / pip);
  }

//+------------------------------------------------------------------+
//| V7 - come V1 ma la barra 0 (oggi, ancora in formazione) CONTA.   |
//| E' una scelta d'implementazione plausibile, non un errore: per   |
//| questo entra nella forchetta invece di essere scartata.          |
//+------------------------------------------------------------------+
double MediaHL_ConOggi(MqlRates &r[], int got, int off, int P, double pip)
  {
   if(pip <= 0.0 || P <= 0) return(0.0);
   if(got < off + P)        return(0.0);
   double somma = 0.0;
   for(int i = off; i <= P - 1 + off; i++) somma += (r[i].high - r[i].low);
   return(somma / P / pip);
  }

//+------------------------------------------------------------------+
//| V2 - media del True Range: include il salto fra chiusura di ieri |
//| e apertura di oggi. Su un forex 24/5 il gap e' minimo, sui       |
//| simboli che dormono cambia parecchio: per questo si misura.      |
//+------------------------------------------------------------------+
double MediaTR(MqlRates &r[], int got, int off, int P, double pip)
  {
   if(pip <= 0.0 || P <= 0) return(0.0);
   if(got < off + P + 2)    return(0.0);
   double somma = 0.0;
   for(int i = 1 + off; i <= P + off; i++)
     {
      double cPrec = r[i + 1].close;
      double alto  = MathMax(r[i].high, cPrec);
      double basso = MathMin(r[i].low,  cPrec);
      somma += (alto - basso);
     }
   return(somma / P / pip);
  }

//+------------------------------------------------------------------+
//| V3 - la stessa media SENZA le barre della domenica.              |
//| Sul forex BCM il mercato riapre la domenica sera: quella "barra  |
//| giornaliera" dura un paio d'ore e vale una frazione di un        |
//| giorno vero. Se il broker di Christian le esclude e noi no       |
//| (o viceversa), il pavimento dello stop cambia di parecchio.      |
//| Restituisce anche quante domeniche ha saltato.                   |
//+------------------------------------------------------------------+
double MediaHL_NoDomenica(MqlRates &r[], int got, int off, int P, double pip, int &domeniche)
  {
   domeniche = 0;
   if(pip <= 0.0 || P <= 0) return(0.0);
   double somma = 0.0;
   int    presi = 0;
   MqlDateTime t;
   for(int i = 1 + off; i < got && presi < P; i++)
     {
      TimeToStruct(r[i].time, t);
      if(t.day_of_week == 0) { domeniche++; continue; }
      somma += (r[i].high - r[i].low);
      presi++;
     }
   if(presi < P) return(0.0);
   return(somma / P / pip);
  }

//+------------------------------------------------------------------+
//| V4 - mediana dei range. E' la definizione piu' robusta: un       |
//| singolo giorno di panico non la sposta. Proprio per questo puo'  |
//| dare un pavimento molto piu' basso della media.                  |
//+------------------------------------------------------------------+
double MedianaHL(MqlRates &r[], int got, int off, int P, double pip)
  {
   if(pip <= 0.0 || P <= 0) return(0.0);
   if(got < off + P + 1)    return(0.0);
   double v[];
   ArrayResize(v, P);
   for(int i = 0; i < P; i++) v[i] = (r[1 + off + i].high - r[1 + off + i].low);
   ArraySort(v);
   double med = (P % 2 == 1) ? v[P / 2] : (v[P / 2 - 1] + v[P / 2]) / 2.0;
   return(med / pip);
  }

//+------------------------------------------------------------------+
//| V5 - ATR di Wilder a P periodi su D1, calcolato a mano per non   |
//| dipendere da un handle indicatore (in uno script l'handle puo'   |
//| non essere pronto e restituire zeri silenziosi).                 |
//| Seme = media dei primi P True Range, poi smorzamento classico.   |
//+------------------------------------------------------------------+
double ATRWilder(MqlRates &r[], int got, int off, int P, double pip)
  {
   if(pip <= 0.0 || P <= 1) return(0.0);
   int primo = got - 2;                 // la barra piu' VECCHIA che ha un "ieri"
   if(primo - P + 1 < 1 + off) return(0.0);

   double somma = 0.0;
   for(int i = primo; i > primo - P; i--)
     {
      double cPrec = r[i + 1].close;
      somma += (MathMax(r[i].high, cPrec) - MathMin(r[i].low, cPrec));
     }
   double atr = somma / P;

   for(int i = primo - P; i >= 1 + off; i--)
     {
      double cPrec = r[i + 1].close;
      double tr    = MathMax(r[i].high, cPrec) - MathMin(r[i].low, cPrec);
      atr = (atr * (P - 1) + tr) / P;
     }
   return(atr / pip);
  }

//+------------------------------------------------------------------+
//| Le sette definizioni in un colpo solo, per un dato off.          |
//| out[] ha 8 caselle: le prime 6 + V7 + V8 (V6 va riempita fuori,  |
//| perche' vive su un'altra serie di barre).                        |
//+------------------------------------------------------------------+
void CalcolaTutte(MqlRates &r[], int got, int off, int P, double pip, double &out[])
  {
   ArrayResize(out, 8);
   ArrayInitialize(out, 0.0);
   int dom = 0;
   out[0] = MediaHL(r, got, off, P, pip);
   out[1] = MediaTR(r, got, off, P, pip);
   out[2] = MediaHL_NoDomenica(r, got, off, P, pip, dom);
   out[3] = MedianaHL(r, got, off, P, pip);
   out[4] = ATRWilder(r, got, off, P, pip);
   out[5] = 0.0;                                   // V6: riempita dal chiamante
   out[6] = MediaHL_ConOggi(r, got, off, P, pip);
   out[7] = MediaHL(r, got, off, 20, pip);
  }

//+------------------------------------------------------------------+
//| La FORCHETTA del giorno: max-min fra le definizioni che sono     |
//| davvero alternative fra loro (V1 V2 V3 V4 V5 V7).                |
//| V6 e V8 restano FUORI e il motivo va detto: V6 e' un altro       |
//| timeframe e V8 e' un altro periodo -- sono domande diverse.      |
//+------------------------------------------------------------------+
double Forchetta(double &v[], double &vmin, double &vmax)
  {
   int idx[6] = {0, 1, 2, 3, 4, 6};
   vmin =  1e18; vmax = -1e18;
   for(int k = 0; k < 6; k++)
     {
      double x = v[idx[k]];
      if(x <= 0.0) return(-1.0);                   // dato mancante: giorno da saltare
      if(x < vmin) vmin = x;
      if(x > vmax) vmax = x;
     }
   return(vmax - vmin);
  }

//+------------------------------------------------------------------+
//| La TARATURA: cerca all'indietro un giorno in cui una definizione |
//| riproduce la lettura stampata sulla slide.                       |
//+------------------------------------------------------------------+
void Taratura(string sym, double bersaglio, MqlRates &r[], int got,
              MqlRates &r6[], int got6, int P, double pip, int hFile)
  {
   PrintFormat("  TARATURA %s: cerco chi produce %.2f pip (tolleranza %.2f) negli ultimi %d giorni",
               sym, bersaglio, InpTolleranzaPip, InpFinestraRicerca);
   int trovati = 0;
   double v[];
   for(int off = 0; off < InpFinestraRicerca; off++)
     {
      CalcolaTutte(r, got, off, P, pip, v);
      for(int k = 0; k < 8; k++)
        {
         if(k == 5) continue;                      // V6 ha il suo giro, sotto
         if(v[k] <= 0.0) continue;
         if(MathAbs(v[k] - bersaglio) <= InpTolleranzaPip)
           {
            datetime quando = (off + 1 < got) ? r[off + 1].time : 0;
            PrintFormat("     >>> %s riproduce %.2f al %s (valore %.4f)",
                        gNomi[k], bersaglio, TimeToString(quando, TIME_DATE), v[k]);
            if(hFile != INVALID_HANDLE)
               FileWrite(hFile, sym, "TARATURA", gNomi[k],
                         DoubleToString(v[k], 4), TimeToString(quando, TIME_DATE),
                         DoubleToString(bersaglio, 2));
            trovati++;
           }
        }
     }
   //--- lo stesso giro sulla serie del TF scelto (V6)
   for(int off = 0; off < InpFinestraRicerca; off++)
     {
      double v6 = MediaHL(r6, got6, off, P, pip);
      if(v6 <= 0.0) continue;
      if(MathAbs(v6 - bersaglio) <= InpTolleranzaPip)
        {
         datetime quando = (off + 1 < got6) ? r6[off + 1].time : 0;
         PrintFormat("     >>> %s riproduce %.2f alla barra %s (valore %.4f)",
                     gNomi[5], bersaglio, TimeToString(quando, TIME_DATE|TIME_MINUTES), v6);
         if(hFile != INVALID_HANDLE)
            FileWrite(hFile, sym, "TARATURA", gNomi[5],
                      DoubleToString(v6, 4), TimeToString(quando, TIME_DATE|TIME_MINUTES),
                      DoubleToString(bersaglio, 2));
         trovati++;
        }
     }
   if(trovati == 0)
      PrintFormat("     nessuna definizione riproduce %.2f: il dato e' di un ALTRO broker,"
                  " la taratura non conclude (NON e' una smentita).", bersaglio);
  }

//+------------------------------------------------------------------+
//| Il bersaglio dichiarato per un simbolo, o 0 se non c'e'.         |
//+------------------------------------------------------------------+
double BersaglioDi(string sym)
  {
   string pezzi[];
   int n = StringSplit(InpCercaValori, ',', pezzi);
   for(int i = 0; i < n; i++)
     {
      string uno[];
      if(StringSplit(pezzi[i], '=', uno) != 2) continue;
      StringTrimLeft(uno[0]); StringTrimRight(uno[0]);
      StringTrimLeft(uno[1]); StringTrimRight(uno[1]);
      if(uno[0] == sym) return(StringToDouble(uno[1]));
     }
   return(0.0);
  }

//+------------------------------------------------------------------+
//| Il lavoro su un simbolo: fotografia di oggi + forchetta storica. |
//+------------------------------------------------------------------+
void SondaSimbolo(string sym, int hFile)
  {
   double pip = PipSize(sym);
   int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   if(pip <= 0.0) { PrintFormat("  %-10s: point a zero, simbolo non pronto", sym); return; }

   MqlRates r[];  ArraySetAsSeries(r, true);
   MqlRates r6[]; ArraySetAsSeries(r6, true);
   int quanti = InpPeriodi + InpGiorniStoria + InpFinestraRicerca + 10;
   int got  = CopyRates(sym, PERIOD_D1, 0, quanti, r);
   int got6 = CopyRates(sym, InpTF_V6,  0, quanti, r6);
   if(got < InpPeriodi + 2)
     { PrintFormat("  %-10s: NESSUN DATO D1 sufficiente (%d barre). Scarica lo storico.", sym, got); return; }

   PrintFormat("  %-10s  digits=%d  pip=%.5f  barre D1=%d  barre %s=%d",
               sym, digits, pip, got, EnumToString(InpTF_V6), got6);
   if(digits != 3 && digits != 5)
      PrintFormat("     ATTENZIONE: %s non ha un pip da forex. I numeri qui sotto sono in PUNTI,"
                  " e il confronto col 'pavimento in pip' del corso NON si applica.", sym);

   //--- fotografia di oggi
   double v[];
   CalcolaTutte(r, got, 0, InpPeriodi, pip, v);
   v[5] = MediaHL(r6, got6, 0, InpPeriodi, pip);

   int dom = 0;
   MediaHL_NoDomenica(r, got, 0, InpPeriodi, pip, dom);
   PrintFormat("     domeniche incontrate nelle ultime %d barre D1 chiuse: %d", InpPeriodi, dom);

   for(int k = 0; k < 8; k++)
     {
      if(v[k] <= 0.0) { PrintFormat("     %-42s : dato insufficiente", gNomi[k]); continue; }
      double scarto = (v[0] > 0.0) ? (v[k] - v[0]) / v[0] * 100.0 : 0.0;
      PrintFormat("     %-42s : %8.2f pip   pavimento SL = %8.2f pip   (%+.1f%% vs V1)",
                  gNomi[k], v[k], v[k] + InpBufferPip, scarto);
      if(hFile != INVALID_HANDLE)
         FileWrite(hFile, sym, "OGGI", gNomi[k], DoubleToString(v[k], 4),
                   DoubleToString(v[k] + InpBufferPip, 4), DoubleToString(scarto, 2));
     }

   //--- la forchetta, giorno per giorno, su tutta la storia richiesta
   double forc[];
   ArrayResize(forc, 0);
   int oltre5 = 0, oltre10 = 0, oltre15 = 0, validi = 0;
   for(int off = 0; off < InpGiorniStoria; off++)
     {
      double w[]; CalcolaTutte(r, got, off, InpPeriodi, pip, w);
      double mn = 0.0, mx = 0.0;
      double f = Forchetta(w, mn, mx);
      if(f < 0.0) continue;
      int n = ArraySize(forc); ArrayResize(forc, n + 1); forc[n] = f;
      validi++;
      if(f > 5.0)  oltre5++;
      if(f > 10.0) oltre10++;
      if(f > 15.0) oltre15++;
     }

   if(validi < 30)
     { PrintFormat("     forchetta: solo %d giorni validi, troppo pochi per leggerla", validi); }
   else
     {
      ArraySort(forc);
      double mediana = forc[validi / 2];
      double p90     = forc[(int)MathFloor(validi * 0.90)];
      double peggio  = forc[validi - 1];
      PrintFormat("     FORCHETTA fra le 6 definizioni, su %d giorni:", validi);
      PrintFormat("        mediana %.2f pip | 90esimo percentile %.2f pip | peggior giorno %.2f pip",
                  mediana, p90, peggio);
      PrintFormat("        giorni oltre 5 pip: %.1f%%  |  oltre 10: %.1f%%  |  oltre 15: %.1f%%",
                  oltre5 * 100.0 / validi, oltre10 * 100.0 / validi, oltre15 * 100.0 / validi);
      if(hFile != INVALID_HANDLE)
         FileWrite(hFile, sym, "FORCHETTA", "mediana|p90|peggiore|n",
                   DoubleToString(mediana, 3), DoubleToString(p90, 3),
                   DoubleToString(peggio, 3) + "|" + IntegerToString(validi));

      //--- il verdetto, col criterio dichiarato PRIMA (referto del 21/08, BOZZA)
      if(digits == 3 || digits == 5)
        {
         if(mediana < InpSogliaVerde && p90 < 10.0)
            PrintFormat("        >>> %s: l'ambiguita' PESA MENO della discrezionalita' che il corso"
                        " stesso si concede (buffer 10/15 pip). Il prerequisito NON blocca:"
                        " basta DICHIARARE quale definizione usiamo.", sym);
         else if(p90 > InpSogliaRossa)
            PrintFormat("        >>> %s: l'ambiguita' vale piu' dell'INTERO buffer del corso."
                        " Prerequisito BLOCCANTE: senza il nome dell'indicatore non si procede.", sym);
         else
            PrintFormat("        >>> %s: zona grigia. Si procede solo dichiarando la definizione"
                        " come ASSUNZIONE NOSTRA e mettendo le due piu' distanti in A/B.", sym);
        }
     }

   //--- taratura sulle letture stampate nelle slide, se ce n'e' una per questo simbolo
   double bersaglio = BersaglioDi(sym);
   if(bersaglio > 0.0) Taratura(sym, bersaglio, r, got, r6, got6, InpPeriodi, pip, hFile);
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   string sym[];
   int n = StringSplit(InpSimboli, ',', sym);
   for(int i = 0; i < n; i++) { StringTrimLeft(sym[i]); StringTrimRight(sym[i]); }

   int h = FileOpen("ABTG_SondaADR.csv", FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
   if(h != INVALID_HANDLE)
      FileWrite(h, "Simbolo", "Sezione", "Definizione", "Valore_pip", "Pavimento_o_data", "Nota");

   Print("=== SONDA ADR: quanto pesa non sapere QUALE indicatore e' l'ADR(50) del corso? ===");
   PrintFormat("    periodi=%d  buffer=%.1f pip  storia=%d giorni  TF della V6=%s",
               InpPeriodi, InpBufferPip, InpGiorniStoria, EnumToString(InpTF_V6));
   Print("    Lo script NON decide niente: produce la forchetta. Il criterio di lettura sta");
   Print("    in risultati_archivio\\POINTBREAK_TRE_COMPONENTI_2026-08-21.md ed e' una BOZZA.");
   Print("    Nessuna posizione viene aperta, nessuna sedia in forward viene toccata.");

   for(int i = 0; i < n; i++)
     {
      if(sym[i] == "") continue;
      if(!SymbolSelect(sym[i], true))
        { PrintFormat("  %-10s: simbolo non disponibile su questo broker", sym[i]); continue; }
      Print("");
      Print("--------------------------------------------------------------");
      SondaSimbolo(sym[i], h);
     }

   if(h != INVALID_HANDLE)
     { FileClose(h); Print(""); Print("=== FINITO. Dettaglio in MQL5\\Files\\ABTG_SondaADR.csv ==="); }
  }
//+------------------------------------------------------------------+
