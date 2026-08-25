//+------------------------------------------------------------------+
//|                                            ABTG_ChiudiSedie.mq5  |
//|                                                                  |
//|  SPEGNIMENTO PULITO DELLE SEDIE REVOCATE                          |
//|  (chiude le POSIZIONI e cancella i PENDENTI di una lista di       |
//|   MAGIC, e NIENT'ALTRO)                                           |
//|                                                                  |
//|  PERCHE' ESISTE (serata del 24/08/2026)                          |
//|  La revisione firmata "A+b" ha spento 4 sedie. Lo spegnimento e'  |
//|  stato fatto a mano, grafico per grafico: una posizione e'        |
//|  rimasta ORFANA (sedia staccata, posizione ancora viva) e si e'   |
//|  chiusa da sola quando ha preso lo SL. E' finita bene PER         |
//|  FORTUNA, e la fortuna non e' una procedura. Da qui in avanti lo  |
//|  spegnimento di una sedia ha un attrezzo suo.                     |
//|                                                                  |
//|  LE DUE SICURE (servono TUTTE E DUE per toccare qualcosa)         |
//|    1) InpMagics deve essere NON VUOTO;                            |
//|    2) InpEseguiDavvero deve essere true.                          |
//|  Con anche una sola delle due chiusa lo script fa CENSIMENTO:     |
//|  stampa tutte le posizioni e tutti i pendenti raggruppati per     |
//|  magic e NON TOCCA NIENTE. E' il default: si lancia la prima      |
//|  volta cosi', si legge l'elenco, e solo dopo si scrivono i magic. |
//|                                                                  |
//|  E UNA TERZA, che non era nella richiesta ma serve:               |
//|    3) InpChiediConferma (default true) mostra una finestra con    |
//|       conto, numeri ed elenco dei magic PRIMA di toccare.         |
//|  Motivo: MT5 SI RICORDA i valori dell'ultimo lancio nella         |
//|  finestra dei parametri di uno script. Al secondo lancio          |
//|  InpEseguiDavvero e' ancora true e i magic vecchi sono ancora     |
//|  li': chi rilancia per censire altri magic li chiuderebbe.        |
//|  Se la finestra non si puo' mostrare, la risposta NON e' si'.     |
//|                                                                  |
//|  COSA NON FA, e non e' una dimenticanza                           |
//|    - NON tocca i magic che non sono nella lista: mai, per         |
//|      nessun motivo, nemmeno se il simbolo e' lo stesso;           |
//|    - NON tocca le operazioni MANUALI (magic 0) a meno che lo      |
//|      "0" non sia scritto esplicitamente nella lista;              |
//|    - NON apre niente, NON modifica SL/TP, NON stacca EA dai       |
//|      grafici (staccare l'EA resta un gesto a mano: questo         |
//|      attrezzo chiude quello che l'EA ha lasciato aperto);         |
//|    - NON aspetta l'apertura del mercato: se un simbolo e'         |
//|      chiuso lo dice e TIRA DRITTO con gli altri. Nessun ciclo     |
//|      infinito, nessuna attesa muta.                               |
//|                                                                  |
//|  USO                                                              |
//|    1) trascina lo script su un grafico QUALSIASI (il simbolo del  |
//|       grafico non conta: legge posizioni e ordini del CONTO);     |
//|    2) primo lancio: lascia tutto com'e' e premi OK -> leggi       |
//|       l'elenco nella scheda ESPERTI;                              |
//|    3) secondo lancio: scrivi i magic in InpMagics e metti         |
//|       InpEseguiDavvero = true.                                    |
//|    Serve la spunta "Consenti trading algoritmico" nella finestra  |
//|    dello script: senza, lo script lo dice e si ferma.             |
//|                                                                  |
//|  Referto: scheda Esperti + MQL5\Files\ABTG_ChiudiSedie_report.txt |
//|  (ASCII, una riga per ticket, con retcode: si rilegge dopo).      |
//|                                                                  |
//|  NON COMPILATO NE' ESEGUITO DA CHI LO HA SCRITTO: questo          |
//|  ambiente non ha MetaEditor. La compilazione la fa la riga di     |
//|  lancio (righe/RIGA_CHIUDISEDIE_DA_MANDARE.md), e finche' quella  |
//|  non torna verde il file e' una BOZZA.                            |
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.00"
#property script_show_inputs

// unica dipendenza: la libreria STANDARD di MetaTrader 5, presente in
// ogni installazione. Nessun include di casa da installare a parte.
#include <Trade\Trade.mqh>

#define MARCATORE "ABTG_ChiudiSedie v1.00 - due sicure"

//--- INPUT ----------------------------------------------------------
input string InpMagics        = "";     // Magic da spegnere (es. "770611,250604"). VUOTO = solo censimento
input bool   InpEseguiDavvero = false;  // false = NON tocca niente (seconda sicura)
input long   InpContoAtteso   = 0;      // 0 = nessun controllo; altrimenti deve coincidere col login
input bool   InpChiediConferma= true;   // finestra di conferma con l'elenco prima di toccare (terza sicura)
input int    InpTentativi     = 3;      // tentativi per ticket sui rifiuti temporanei (requote, prezzo cambiato)
input int    InpAttesaMs      = 700;    // pausa fra un tentativo e l'altro (ms)
input int    InpSlippagePunti = 50;     // deviazione massima consentita in punti

//--- STATO ----------------------------------------------------------
CTrade   gTrade;
string   gReport[];      // il referto si accumula qui e si scrive in fondo
long     gLista[];       // i magic autorizzati, gia' parsati
int      gChiuse   = 0;
int      gCancell  = 0;
int      gFalliti  = 0;
int      gSparite  = 0;  // spariti da soli fra il censimento e l'azione (SL/TP)
int      gMercatoChiuso = 0;

//+------------------------------------------------------------------+
//| Registra una riga: a schermo (scheda Esperti) E nel referto       |
//+------------------------------------------------------------------+
void Reg(string s)
  {
   Print(s);
   int n=ArraySize(gReport);
   ArrayResize(gReport,n+1);
   gReport[n]=s;
  }

//+------------------------------------------------------------------+
//| Parsing della lista dei magic.                                    |
//| Accetta virgole, punti e virgola e spazi: "770611, 250604" e      |
//| "770611;250604" e "770611 250604" sono la stessa cosa. Un token   |
//| non numerico NON viene ignorato in silenzio: fa fallire tutto,    |
//| perche' un magic scritto male vorrebbe dire "sedia non spenta"    |
//| con lo script che dichiara di aver finito.                        |
//+------------------------------------------------------------------+
bool ParsaMagics(const string testo,long &fuori[],string &errore)
  {
   ArrayResize(fuori,0);
   errore="";
   string s=testo;
   StringReplace(s,";",",");
   StringReplace(s," ",",");
   StringReplace(s,"\t",",");
   StringReplace(s,"\r",",");
   StringReplace(s,"\n",",");
   string pezzi[];
   int np=StringSplit(s,',',pezzi);
   for(int i=0;i<np;i++)
     {
      string t=pezzi[i];
      StringTrimLeft(t);
      StringTrimRight(t);
      if(StringLen(t)==0) continue;
      // solo cifre: niente segni, niente decimali, niente lettere
      for(int c=0;c<StringLen(t);c++)
        {
         ushort ch=StringGetCharacter(t,c);
         if(ch<'0' || ch>'9')
           {
            errore="magic non valido nella lista: \""+t+"\" (ammesse solo cifre)";
            ArrayResize(fuori,0);
            return(false);
           }
        }
      long v=(long)StringToInteger(t);
      // niente doppioni: due volte lo stesso magic non e' un errore, ma
      // sporcherebbe il conteggio delle righe del referto
      bool gia=false;
      for(int k=0;k<ArraySize(fuori);k++) if(fuori[k]==v) gia=true;
      if(gia) continue;
      int n=ArraySize(fuori);
      ArrayResize(fuori,n+1);
      fuori[n]=v;
     }
   if(ArraySize(fuori)==0)
     {
      errore="la lista non contiene nessun magic leggibile";
      return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Numero di tentativi, con il pavimento a 1.                        |
//| Sta in una funzione e non in un MathMax sparso perche' il valore  |
//| finisce sia nel ciclo sia nei messaggi: due posti, un numero.     |
//+------------------------------------------------------------------+
int Tentativi()
  {
   if(InpTentativi<1) return(1);
   return(InpTentativi);
  }

//+------------------------------------------------------------------+
//| Il magic e' fra quelli autorizzati?                               |
//+------------------------------------------------------------------+
bool InLista(const long magic)
  {
   for(int i=0;i<ArraySize(gLista);i++) if(gLista[i]==magic) return(true);
   return(false);
  }

//+------------------------------------------------------------------+
//| Nomi leggibili dei tipi                                           |
//+------------------------------------------------------------------+
string NomeTipoPos(const long t)
  {
   if(t==POSITION_TYPE_BUY)  return("BUY");
   if(t==POSITION_TYPE_SELL) return("SELL");
   return("?");
  }

string NomeTipoOrd(const long t)
  {
   switch((int)t)
     {
      case ORDER_TYPE_BUY_STOP:        return("BUY STOP");
      case ORDER_TYPE_SELL_STOP:       return("SELL STOP");
      case ORDER_TYPE_BUY_LIMIT:       return("BUY LIMIT");
      case ORDER_TYPE_SELL_LIMIT:      return("SELL LIMIT");
      case ORDER_TYPE_BUY_STOP_LIMIT:  return("BUY STOPLIMIT");
      case ORDER_TYPE_SELL_STOP_LIMIT: return("SELL STOPLIMIT");
      case ORDER_TYPE_BUY:             return("BUY (a mercato)");
      case ORDER_TYPE_SELL:            return("SELL (a mercato)");
     }
   return("tipo "+IntegerToString((int)t));
  }

//+------------------------------------------------------------------+
//| Il retcode merita un altro tentativo?                             |
//| Sono i rifiuti TEMPORANEI: il prezzo si e' mosso, il server ha    |
//| avuto un singhiozzo. Tutto il resto (mercato chiuso, trading      |
//| disabilitato, volume non valido) non migliora riprovando: si      |
//| registra il motivo e si passa al ticket successivo.               |
//+------------------------------------------------------------------+
bool ValeLaPenaRiprovare(const uint rc)
  {
   if(rc==TRADE_RETCODE_REQUOTE)          return(true);   // 10004
   if(rc==TRADE_RETCODE_PRICE_CHANGED)    return(true);   // 10020
   if(rc==TRADE_RETCODE_PRICE_OFF)        return(true);   // 10021
   if(rc==TRADE_RETCODE_TIMEOUT)          return(true);   // 10008
   if(rc==TRADE_RETCODE_CONNECTION)       return(true);   // 10031
   if(rc==TRADE_RETCODE_TOO_MANY_REQUESTS)return(true);   // 10024
   if(rc==TRADE_RETCODE_REJECT)           return(true);   // 10006
   return(false);
  }

//+------------------------------------------------------------------+
//| Mercato chiuso / trading spento su quel simbolo?                  |
//| Non e' un fallimento dello script: e' una condizione del mondo.   |
//+------------------------------------------------------------------+
bool EMercatoChiuso(const uint rc)
  {
   if(rc==TRADE_RETCODE_MARKET_CLOSED)  return(true);     // 10018
   if(rc==TRADE_RETCODE_TRADE_DISABLED) return(true);     // 10017
   return(false);
  }

//+------------------------------------------------------------------+
//| Il simbolo e' in uno stato che vieta l'operazione, PRIMA di       |
//| mandare qualcosa al server? (risparmia un giro e da' un motivo    |
//| leggibile invece di un retcode)                                   |
//+------------------------------------------------------------------+
bool SimboloBloccato(const string sym,string &motivo)
  {
   motivo="";
   long tm=0;
   if(!SymbolInfoInteger(sym,SYMBOL_TRADE_MODE,tm)) return(false); // nel dubbio si prova
   if(tm==SYMBOL_TRADE_MODE_DISABLED)
     {
      motivo="trading DISABILITATO sul simbolo";
      return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Aggiunge un simbolo a un elenco "A,B,C" senza doppioni.           |
//| Il confronto e' fra token INTERI, non StringFind sulla stringa:   |
//| "USD" dentro "XAUUSD" avrebbe fatto sparire un simbolo dalla      |
//| lista, ed e' la classe di difetto "il conteggio che mente".       |
//+------------------------------------------------------------------+
void AggiungiSimbolo(string &elenco,const string sym)
  {
   if(StringLen(sym)==0) return;
   if(StringFind(","+elenco+",",","+sym+",")>=0) return;
   if(StringLen(elenco)>0) elenco+=",";
   elenco+=sym;
  }

//+------------------------------------------------------------------+
//| CENSIMENTO: elenca TUTTO quello che c'e' sul conto, per magic.    |
//| Gira SEMPRE, anche in modalita' esecuzione: e' la fotografia di   |
//| partenza, e senza di quella il referto non si rilegge.            |
//+------------------------------------------------------------------+
void Censimento(const bool listaAttiva)
  {
   Reg("--- CENSIMENTO: cosa c'e' sul conto adesso ---");

   int np=PositionsTotal();
   int no=OrdersTotal();
   Reg(StringFormat("posizioni aperte: %d    ordini pendenti: %d",np,no));
   Reg("");

   if(np==0 && no==0)
     {
      Reg("  NIENTE DA ELENCARE: nessuna posizione e nessun pendente.");
      Reg("");
      return;
     }

   Reg(StringFormat("  %-8s %-14s %-10s %-16s %10s %12s %12s  %s",
                    "dove","magic","ticket","tipo","volume","prezzo","P/L","simbolo / commento"));
   Reg("  ------------------------------------------------------------------------------------------------");

   for(int i=0;i<np;i++)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      string sym  = PositionGetString(POSITION_SYMBOL);
      long   mg   = PositionGetInteger(POSITION_MAGIC);
      long   tp   = PositionGetInteger(POSITION_TYPE);
      double vol  = PositionGetDouble(POSITION_VOLUME);
      double prz  = PositionGetDouble(POSITION_PRICE_OPEN);
      double pl   = PositionGetDouble(POSITION_PROFIT);
      string comm = PositionGetString(POSITION_COMMENT);
      int    dg   = (int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
      string flag = "";
      if(listaAttiva) flag = (InLista(mg) ? "  <== IN LISTA" : "");
      Reg(StringFormat("  %-8s %-14s %-10s %-16s %10s %12s %12s  %s%s",
                       "POSIZ.", IntegerToString(mg), IntegerToString((long)tk),
                       NomeTipoPos(tp), DoubleToString(vol,2), DoubleToString(prz,dg),
                       DoubleToString(pl,2), sym+" "+comm, flag));
     }

   for(int j=0;j<no;j++)
     {
      ulong tk=OrderGetTicket(j);
      if(tk==0) continue;
      string sym  = OrderGetString(ORDER_SYMBOL);
      long   mg   = OrderGetInteger(ORDER_MAGIC);
      long   tp   = OrderGetInteger(ORDER_TYPE);
      double vol  = OrderGetDouble(ORDER_VOLUME_CURRENT);
      double prz  = OrderGetDouble(ORDER_PRICE_OPEN);
      string comm = OrderGetString(ORDER_COMMENT);
      int    dg   = (int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
      string flag = "";
      if(listaAttiva) flag = (InLista(mg) ? "  <== IN LISTA" : "");
      Reg(StringFormat("  %-8s %-14s %-10s %-16s %10s %12s %12s  %s%s",
                       "PENDEN.", IntegerToString(mg), IntegerToString((long)tk),
                       NomeTipoOrd(tp), DoubleToString(vol,2), DoubleToString(prz,dg),
                       "n/d", sym+" "+comm, flag));
     }
   Reg("");

   //--- riepilogo per magic: e' la riga che si copia nella lista -----
   Reg("--- RIEPILOGO PER MAGIC (e' da qui che si copiano i numeri) ---");
   long  visti[];
   ArrayResize(visti,0);
   for(int i=0;i<np;i++)
     {
      if(PositionGetTicket(i)==0) continue;
      long mg=PositionGetInteger(POSITION_MAGIC);
      bool gia=false;
      for(int k=0;k<ArraySize(visti);k++) if(visti[k]==mg) gia=true;
      if(gia) continue;
      int n=ArraySize(visti); ArrayResize(visti,n+1); visti[n]=mg;
     }
   for(int j=0;j<no;j++)
     {
      if(OrderGetTicket(j)==0) continue;
      long mg=OrderGetInteger(ORDER_MAGIC);
      bool gia=false;
      for(int k=0;k<ArraySize(visti);k++) if(visti[k]==mg) gia=true;
      if(gia) continue;
      int n=ArraySize(visti); ArrayResize(visti,n+1); visti[n]=mg;
     }

   for(int k=0;k<ArraySize(visti);k++)
     {
      long mg=visti[k];
      int  cp=0, co=0;
      string simboli="";
      for(int i=0;i<np;i++)
        {
         if(PositionGetTicket(i)==0) continue;
         if(PositionGetInteger(POSITION_MAGIC)!=mg) continue;
         cp++;
         AggiungiSimbolo(simboli,PositionGetString(POSITION_SYMBOL));
        }
      for(int j=0;j<no;j++)
        {
         if(OrderGetTicket(j)==0) continue;
         if(OrderGetInteger(ORDER_MAGIC)!=mg) continue;
         co++;
         AggiungiSimbolo(simboli,OrderGetString(ORDER_SYMBOL));
        }
      string nota="";
      if(mg==0) nota="   <-- MANUALE (magic 0): si tocca SOLO se scrivi 0 nella lista";
      if(listaAttiva && InLista(mg)) nota+="   <== IN LISTA";
      Reg(StringFormat("  magic %-12s posizioni %2d   pendenti %2d   [%s]%s",
                       IntegerToString(mg),cp,co,simboli,nota));
     }
   Reg("");
  }

//+------------------------------------------------------------------+
//| CHIUSURA DI UNA POSIZIONE, con i tentativi                        |
//+------------------------------------------------------------------+
void ChiudiPosizione(const ulong tk)
  {
   if(!PositionSelectByTicket(tk))
     {
      gSparite++;
      Reg(StringFormat("  POSIZ.  #%-10s  SPARITA PRIMA DELL'AZIONE (SL/TP o chiusa altrove): niente da fare",
                       IntegerToString((long)tk)));
      return;
     }
   string sym = PositionGetString(POSITION_SYMBOL);
   long   mg  = PositionGetInteger(POSITION_MAGIC);
   double vol = PositionGetDouble(POSITION_VOLUME);

   // la guardia si ripete QUI, sul dato appena riletto: fra il censimento
   // e adesso l'indice puo' essere cambiato, il ticket no.
   if(!InLista(mg))
     {
      Reg(StringFormat("  POSIZ.  #%-10s  SALTATA: magic %s NON e' in lista (guardia)",
                       IntegerToString((long)tk),IntegerToString(mg)));
      return;
     }

   string motivo="";
   if(SimboloBloccato(sym,motivo))
     {
      gMercatoChiuso++;
      Reg(StringFormat("  POSIZ.  #%-10s  %-10s  MERCATO CHIUSO, rilancia piu' tardi  (%s)",
                       IntegerToString((long)tk),sym,motivo));
      return;
     }

   gTrade.SetDeviationInPoints((ulong)(InpSlippagePunti<0 ? 0 : InpSlippagePunti));
   gTrade.SetTypeFillingBySymbol(sym);

   for(int tentativo=1;tentativo<=Tentativi();tentativo++)
     {
      bool ok = gTrade.PositionClose(tk);
      uint rc = gTrade.ResultRetcode();
      string desc = gTrade.ResultRetcodeDescription();

      if(ok && (rc==TRADE_RETCODE_DONE || rc==TRADE_RETCODE_DONE_PARTIAL || rc==TRADE_RETCODE_PLACED))
        {
         gChiuse++;
         Reg(StringFormat("  POSIZ.  #%-10s  %-10s  magic %-10s vol %s  CHIUSA  (rc=%u %s, tentativo %d)",
                          IntegerToString((long)tk),sym,IntegerToString(mg),
                          DoubleToString(vol,2),rc,desc,tentativo));
         return;
        }

      // il server puo' aver chiuso lui nel frattempo: non e' un fallimento
      if(!PositionSelectByTicket(tk))
        {
         gSparite++;
         Reg(StringFormat("  POSIZ.  #%-10s  %-10s  SPARITA durante il tentativo %d (rc=%u %s): niente da fare",
                          IntegerToString((long)tk),sym,tentativo,rc,desc));
         return;
        }

      if(EMercatoChiuso(rc))
        {
         gMercatoChiuso++;
         Reg(StringFormat("  POSIZ.  #%-10s  %-10s  MERCATO CHIUSO, rilancia piu' tardi  (rc=%u %s)",
                          IntegerToString((long)tk),sym,rc,desc));
         return;
        }

      if(!ValeLaPenaRiprovare(rc))
        {
         gFalliti++;
         Reg(StringFormat("  POSIZ.  #%-10s  %-10s  FALLITA, non si riprova  (rc=%u %s)",
                          IntegerToString((long)tk),sym,rc,desc));
         return;
        }

      Reg(StringFormat("  POSIZ.  #%-10s  %-10s  rifiuto temporaneo (rc=%u %s) - tentativo %d di %d",
                       IntegerToString((long)tk),sym,rc,desc,tentativo,Tentativi()));
      Sleep(InpAttesaMs<0 ? 0 : InpAttesaMs);
     }

   gFalliti++;
   Reg(StringFormat("  POSIZ.  #%-10s  %-10s  FALLITA dopo %d tentativi (ultimo rc=%u %s)",
                    IntegerToString((long)tk),sym,Tentativi(),
                    gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription()));
  }

//+------------------------------------------------------------------+
//| CANCELLAZIONE DI UN PENDENTE, con i tentativi                     |
//+------------------------------------------------------------------+
void CancellaPendente(const ulong tk)
  {
   if(!OrderSelect(tk))
     {
      gSparite++;
      Reg(StringFormat("  PENDEN. #%-10s  SPARITO PRIMA DELL'AZIONE (scattato o cancellato): niente da fare",
                       IntegerToString((long)tk)));
      return;
     }
   string sym = OrderGetString(ORDER_SYMBOL);
   long   mg  = OrderGetInteger(ORDER_MAGIC);

   if(!InLista(mg))
     {
      Reg(StringFormat("  PENDEN. #%-10s  SALTATO: magic %s NON e' in lista (guardia)",
                       IntegerToString((long)tk),IntegerToString(mg)));
      return;
     }

   string motivo="";
   if(SimboloBloccato(sym,motivo))
     {
      gMercatoChiuso++;
      Reg(StringFormat("  PENDEN. #%-10s  %-10s  MERCATO CHIUSO, rilancia piu' tardi  (%s)",
                       IntegerToString((long)tk),sym,motivo));
      return;
     }

   for(int tentativo=1;tentativo<=Tentativi();tentativo++)
     {
      bool ok = gTrade.OrderDelete(tk);
      uint rc = gTrade.ResultRetcode();
      string desc = gTrade.ResultRetcodeDescription();

      if(ok && (rc==TRADE_RETCODE_DONE || rc==TRADE_RETCODE_PLACED))
        {
         gCancell++;
         Reg(StringFormat("  PENDEN. #%-10s  %-10s  magic %-10s  CANCELLATO  (rc=%u %s, tentativo %d)",
                          IntegerToString((long)tk),sym,IntegerToString(mg),rc,desc,tentativo));
         return;
        }

      if(!OrderSelect(tk))
        {
         gSparite++;
         Reg(StringFormat("  PENDEN. #%-10s  %-10s  SPARITO durante il tentativo %d (rc=%u %s): niente da fare",
                          IntegerToString((long)tk),sym,tentativo,rc,desc));
         return;
        }

      if(EMercatoChiuso(rc))
        {
         gMercatoChiuso++;
         Reg(StringFormat("  PENDEN. #%-10s  %-10s  MERCATO CHIUSO, rilancia piu' tardi  (rc=%u %s)",
                          IntegerToString((long)tk),sym,rc,desc));
         return;
        }

      if(!ValeLaPenaRiprovare(rc))
        {
         gFalliti++;
         Reg(StringFormat("  PENDEN. #%-10s  %-10s  FALLITO, non si riprova  (rc=%u %s)",
                          IntegerToString((long)tk),sym,rc,desc));
         return;
        }

      Reg(StringFormat("  PENDEN. #%-10s  %-10s  rifiuto temporaneo (rc=%u %s) - tentativo %d di %d",
                       IntegerToString((long)tk),sym,rc,desc,tentativo,Tentativi()));
      Sleep(InpAttesaMs<0 ? 0 : InpAttesaMs);
     }

   gFalliti++;
   Reg(StringFormat("  PENDEN. #%-10s  %-10s  FALLITO dopo %d tentativi (ultimo rc=%u %s)",
                    IntegerToString((long)tk),sym,Tentativi(),
                    gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription()));
  }

//+------------------------------------------------------------------+
//| Il referto su file. Si scrive SEMPRE, anche a corsa fallita:      |
//| un attrezzo che tocca il conto e non lascia traccia non serve.    |
//| ASCII (FILE_ANSI) perche' il referto lo si apre col Blocco note   |
//| di Windows e ci si copia dentro il verbale.                       |
//+------------------------------------------------------------------+
void ScriviReport()
  {
   string nome="ABTG_ChiudiSedie_report.txt";
   int h=FileOpen(nome,FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(h==INVALID_HANDLE)
     {
      PrintFormat("ATTENZIONE: non sono riuscito a scrivere MQL5\\Files\\%s (errore %d). Il referto resta solo nella scheda Esperti.",
                  nome,GetLastError());
      return;
     }
   for(int i=0;i<ArraySize(gReport);i++) FileWrite(h,gReport[i]);
   FileClose(h);
   PrintFormat("Referto scritto in MQL5\\Files\\%s (%d righe). Cartella dati: File -> Apri cartella dati.",
               nome,ArraySize(gReport));
  }

//+------------------------------------------------------------------+
//| OnStart                                                           |
//+------------------------------------------------------------------+
void OnStart()
  {
   ArrayResize(gReport,0);

   Reg("==================================================================");
   Reg("  " + MARCATORE);
   Reg("  data       : " + TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS) + "  (ora LOCALE del PC)");
   Reg("  ora server : " + TimeToString(TimeTradeServer(),TIME_DATE|TIME_SECONDS));
   Reg(StringFormat("  conto      : %s  %s  (%s, %s)",
                    IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)),
                    AccountInfoString(ACCOUNT_SERVER),
                    (AccountInfoInteger(ACCOUNT_TRADE_MODE)==ACCOUNT_TRADE_MODE_DEMO ? "DEMO" : "!! CONTO NON DEMO !!"),
                    (AccountInfoInteger(ACCOUNT_MARGIN_MODE)==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING ? "HEDGING" : "NETTING")));
   Reg("==================================================================");
   Reg("");

   //--- SICURA ZERO: e' il terminale giusto? (0 = controllo spento) ---
   if(InpContoAtteso!=0 && InpContoAtteso!=AccountInfoInteger(ACCOUNT_LOGIN))
     {
      Reg(StringFormat("STOP: InpContoAtteso vale %s ma questo terminale e' sul conto %s.",
                       IntegerToString(InpContoAtteso),IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))));
      Reg("     Non tocco niente: o hai lanciato sul terminale sbagliato, o il numero e' sbagliato.");
      ScriviReport();
      return;
     }

   //--- PRIMA SICURA: la lista ---------------------------------------
   string testo=InpMagics;
   StringTrimLeft(testo);
   StringTrimRight(testo);
   bool listaOk=false;
   string errore="";
   if(StringLen(testo)>0)
     {
      listaOk=ParsaMagics(testo,gLista,errore);
      if(!listaOk)
        {
         Reg("STOP: la lista dei magic non si legge -> " + errore);
         Reg("     Esempio di lista buona:  770611,250604   (o \"770611 250604\")");
         Reg("     NON TOCCO NIENTE.");
         Censimento(false);
         ScriviReport();
         return;
        }
      string el="";
      for(int i=0;i<ArraySize(gLista);i++) el+=(StringLen(el)>0?", ":"")+IntegerToString(gLista[i]);
      Reg("magic in lista (" + IntegerToString(ArraySize(gLista)) + "): " + el);
      if(InLista(0))
        {
         // regola dichiarata = regola con il suo if (checklist punto 67)
         Reg("!! ATTENZIONE: lo 0 e' NELLA LISTA. Verranno toccate anche le");
         Reg("   operazioni MANUALI e quelle di EA senza magic. Era voluto?");
        }
     }
   else
     {
      Reg("InpMagics e' VUOTO -> MODALITA' CENSIMENTO (default sicuro).");
      Reg("Leggi l'elenco qui sotto, poi rilancia con i magic e InpEseguiDavvero=true.");
     }
   Reg("");

   //--- il censimento gira SEMPRE -------------------------------------
   Censimento(listaOk);

   //--- SECONDA SICURA: l'interruttore --------------------------------
   if(!listaOk || !InpEseguiDavvero)
     {
      Reg("------------------------------------------------------------------");
      Reg("NON HO TOCCATO NIENTE. Servono TUTTE E DUE le sicure:");
      Reg(StringFormat("  1) InpMagics non vuoto ......... %s",(listaOk?"OK":"MANCA")));
      Reg(StringFormat("  2) InpEseguiDavvero = true ..... %s",(InpEseguiDavvero?"OK":"MANCA")));
      Reg("------------------------------------------------------------------");
      ScriviReport();
      return;
     }

   //--- i permessi: senza, si fallirebbe ticket per ticket ------------
   if(!MQLInfoInteger(MQL_TRADE_ALLOWED))
     {
      Reg("STOP: il trading algoritmico NON e' consentito a questo script.");
      Reg("     Rilancialo e METTI LA SPUNTA 'Consenti trading algoritmico'");
      Reg("     nella finestra dei parametri (scheda Comune).");
      ScriviReport();
      return;
     }
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
     {
      Reg("STOP: il TERMINALE ha il trading algoritmico spento (pulsante in alto).");
      Reg("     Accendilo, poi rilancia.");
      ScriviReport();
      return;
     }
   if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))
     {
      Reg("STOP: il CONTO non ha il trading abilitato (investor password? conto in sola lettura?).");
      ScriviReport();
      return;
     }

   //--- ESECUZIONE -----------------------------------------------------
   Reg("==================================================================");
   Reg("  ESECUZIONE: le due sicure sono aperte. Da qui in poi si TOCCA.");
   Reg("==================================================================");

   gTrade.SetExpertMagicNumber(0);   // il magic del REQUEST non c'entra: si chiude per ticket
   gTrade.SetAsyncMode(false);       // sincrono: serve il retcode vero, riga per riga
   gTrade.SetDeviationInPoints((ulong)(InpSlippagePunti<0 ? 0 : InpSlippagePunti));

   // I ticket si raccolgono PRIMA e si agisce DOPO: chiudere mentre si
   // scorre PositionsTotal() fa saltare elementi, perche' gli indici si
   // rinumerano a ogni chiusura. Il ticket invece non cambia mai.
   ulong posTk[];  ArrayResize(posTk,0);
   ulong ordTk[];  ArrayResize(ordTk,0);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(!InLista(PositionGetInteger(POSITION_MAGIC))) continue;
      int n=ArraySize(posTk); ArrayResize(posTk,n+1); posTk[n]=tk;
     }
   for(int j=OrdersTotal()-1;j>=0;j--)
     {
      ulong tk=OrderGetTicket(j);
      if(tk==0) continue;
      if(!InLista(OrderGetInteger(ORDER_MAGIC))) continue;
      int n=ArraySize(ordTk); ArrayResize(ordTk,n+1); ordTk[n]=tk;
     }

   Reg(StringFormat("da trattare: %d posizioni e %d pendenti (tutto il resto NON viene toccato)",
                    ArraySize(posTk),ArraySize(ordTk)));
   Reg("");

   if(ArraySize(posTk)==0 && ArraySize(ordTk)==0)
     {
      Reg("  NIENTE DA FARE: nessuna posizione e nessun pendente con quei magic.");
      Reg("  (se te ne aspettavi: controlla i numeri nel riepilogo per magic qui sopra)");
     }

   //--- TERZA SICURA: la conferma a schermo ----------------------------
   //  Serve perche' MT5 SI RICORDA i valori usati l'ultima volta nella
   //  finestra di uno script: al lancio successivo InpEseguiDavvero e'
   //  ancora TRUE e i magic vecchi sono ancora scritti. Chi rilancia per
   //  fare un semplice censimento su altri magic chiuderebbe invece di
   //  elencare. E' lo stesso meccanismo del punto 25 della checklist (il
   //  preset che non spegne l'input nuovo), qui applicato alla memoria
   //  della finestra dei parametri.
   //  Se la finestra non si puo' mostrare, la risposta non e' "si'": si
   //  ferma. Un attrezzo che tocca il conto sbaglia SEMPRE dalla parte
   //  del non fare.
   if(InpChiediConferma && (ArraySize(posTk)>0 || ArraySize(ordTk)>0))
     {
      string el="";
      for(int i=0;i<ArraySize(gLista);i++) el+=(StringLen(el)>0?", ":"")+IntegerToString(gLista[i]);
      string msg = StringFormat("CONTO %s\n\nSto per CHIUDERE %d posizioni e CANCELLARE %d ordini pendenti\ndei magic: %s\n\nProcedo?",
                                IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)),
                                ArraySize(posTk),ArraySize(ordTk),el);
      int risp = MessageBox(msg,"ABTG_ChiudiSedie - CONFERMA",MB_YESNO|MB_ICONWARNING);
      if(risp!=IDYES)
        {
         Reg("ANNULLATO dalla finestra di conferma: NON ho toccato niente.");
         Reg("(per saltare la conferma, InpChiediConferma=false -- ma allora la");
         Reg(" sola sicura che resta e' quello che c'e' scritto negli input)");
         ScriviReport();
         return;
        }
      Reg("conferma data a schermo: si procede.");
     }

   for(int i=0;i<ArraySize(posTk);i++) ChiudiPosizione(posTk[i]);
   for(int j=0;j<ArraySize(ordTk);j++) CancellaPendente(ordTk[j]);

   //--- RIEPILOGO -------------------------------------------------------
   Reg("");
   Reg("==================================================================");
   Reg("  RIEPILOGO");
   Reg(StringFormat("    posizioni CHIUSE ................ %d", gChiuse));
   Reg(StringFormat("    pendenti CANCELLATI ............. %d", gCancell));
   Reg(StringFormat("    gia' spariti da soli (SL/TP) .... %d", gSparite));
   Reg(StringFormat("    fermi per MERCATO CHIUSO ........ %d", gMercatoChiuso));
   Reg(StringFormat("    FALLITI .......................... %d", gFalliti));
   Reg("==================================================================");

   if(gMercatoChiuso>0)
     Reg("  -> ci sono simboli col mercato chiuso: RILANCIA lo script a mercato aperto.");
   if(gFalliti>0)
     Reg("  -> ci sono FALLITI: leggi i retcode riga per riga qui sopra prima di rilanciare.");

   //--- la fotografia DOPO: e' l'unica prova che il lavoro e' finito ----
   Reg("");
   Reg("--- CONTROLLO FINALE: cosa resta dei magic in lista ---");
   int restaP=0, restaO=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      if(PositionGetTicket(i)==0) continue;
      if(InLista(PositionGetInteger(POSITION_MAGIC))) restaP++;
     }
   for(int j=OrdersTotal()-1;j>=0;j--)
     {
      if(OrderGetTicket(j)==0) continue;
      if(InLista(OrderGetInteger(ORDER_MAGIC))) restaO++;
     }
   Reg(StringFormat("    restano %d posizioni e %d pendenti con quei magic.",restaP,restaO));
   if(restaP==0 && restaO==0)
     Reg("    ESITO: PULITO. Le sedie in lista non hanno piu' niente di aperto.");
   else
     Reg("    ESITO: NON PULITO. Qualcosa e' rimasto: NON dichiarare chiusa la revisione.");

   ScriviReport();
  }
//+------------------------------------------------------------------+
