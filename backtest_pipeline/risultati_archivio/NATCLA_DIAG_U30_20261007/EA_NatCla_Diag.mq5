//+------------------------------------------------------------------+
//|                                             EA_NatCla_Diag.mq5   |
//|                                                                  |
//|  DIAGNOSI di CaricaDati() di EA_NatCla v1.04 (r.1262-1280).      |
//|  NON e' un EA di trading: SOLA LETTURA. Nessun ordine, nessuna   |
//|  CTrade, nessun file, nessuna rete, nessuna DLL. Gira SOLO nel   |
//|  tester (fuori dal tester OnInit rifiuta di partire).            |
//|                                                                  |
//|  PERCHE' ESISTE (report/NATCLA_F0_PILOTA_LETTURA_2026-10-07.md   |
//|  par. 3): nel pilota F0 U30USD AUDIO_H1 e M2_H1 sono KO. L'EA e' |
//|  rimasto vivo per tutta la finestra 2024.09.26-2026.06.30 (9946  |
//|  barre H1, 990 righe IMBUTO) ma CaricaDati() ha reso false a     |
//|  OGNI barra: zero CONTA, nessuna riga VERIFICA ADX. QUALE delle  |
//|  quattro condizioni cade e' [NON MISURATO]:                      |
//|    r.1266  n < NC_BARRE_MIN (300)                                |
//|    r.1267  BarsCalculated(hEma200/hAtrN/hAdx) < n+1              |
//|    r.1270  CopyRates(_Symbol,gTF,1,n,r) != n                     |
//|    r.1274-1276 CopyBuffer(hEma200/hAtrN/hAdx,0,1,n,..) != n      |
//|  Il lotto C (10 indici x 6 configurazioni) e' fermo finche' non  |
//|  si sa.                                                          |
//|                                                                  |
//|  COME MISURA, a ogni NUOVA barra del TF (stesso test di OnTick   |
//|  di EA_NatCla r.1247-1249):                                      |
//|   (A) LA CATENA (NCD_Catena): le STESSE chiamate di CaricaDati,  |
//|       nello STESSO ordine e con lo STESSO corto circuito: dice   |
//|       quale condizione avrebbe fatto rendere false all'EA.       |
//|       Il collaudo compila in C++ il corpo VERO di CaricaDati e   |
//|       questa catena contro gli stessi stub e pretende la stessa  |
//|       sequenza di chiamate, argomento per argomento.             |
//|   (B) LE VERIFICHE SEPARATE (NCD_Completa, InpVerificheSeparate):|
//|       fa le chiamate che la catena NON ha raggiunto, cosi' ogni  |
//|       condizione si conta da sola (quante volte cade).           |
//|       ATTENZIONE: le chiamate in piu' NON esistono nell'EA. Se   |
//|       nel tester un CopyBuffer facesse calcolare un indicatore   |
//|       che altrimenti resta fermo, (B) potrebbe "guarire" la      |
//|       catena delle barre DOPO. Per questo (classe 1171) il       |
//|       driver gira nello STESSO giro anche (e) U30USD e (f) D30EUR|
//|       con InpVerificheSeparate=false: SOLO la catena, cioe'      |
//|       EA_NatCla alla lettera. Con false le uniche chiamate in    |
//|       piu' sono SeriesInfoInteger x3 alla PRIMA barra nuova      |
//|       (proprieta' della serie, nessun buffer di indicatore) e,   |
//|       a test finito, quelle di OnDeinit.                         |
//|  Registra i primi valori (barra 1), gli ultimi, i massimi, la    |
//|  prima barra in cui TUTTE passano, e le transizioni del motivo.  |
//|  A OnDeinit stampa UNA riga "[NatCla-DIAG] RIASSUNTO k=v k=v.."  |
//|  (valori senza spazi, chiude con fine=1): la legge il driver     |
//|  backtest_pipeline/righe/NATCLA_DIAG_U30.ps1.                    |
//|                                                                  |
//|  HANDLE: creati con le STESSE chiamate di EA_NatCla OnInit       |
//|  r.1199-1209 (anche quelli che CaricaDati non usa: EMA14, EMA89, |
//|  e EMA9/EMA21/Bollinger con InpLogContesto), perche' nel tester  |
//|  anche il NUMERO di indicatori vivi potrebbe contare. Il         |
//|  collaudo confronta il blocco col sorgente dell'EA, a testo.     |
//|                                                                  |
//|  NON compilato qui (nessun MetaEditor in questo ambiente): la    |
//|  prima compilazione la fa il driver sul PC di backtest.          |
//+------------------------------------------------------------------+
#property copyright "Ea Nat&Cla - progetto Claudio (ABTG) - DIAGNOSI, sola lettura"
#property description "Diagnosi di CaricaDati() di EA_NatCla v1.04: quale delle 4 condizioni cade. Nessun ordine, nessun file. Solo tester."
#property version   "1.00"
#property strict

#define NCD_VER "1.00"

//==================================================================
//  ENUM e INPUT (nomi e valori COPIATI da EA_NatCla, cosi' la .ini
//  del driver usa le stesse chiavi del file prova F0)
//==================================================================
enum ENUM_NC_ADXTIPO
  {
   NC_ADX_MT5=0,    // iADX di MT5 (specifica par. 2.1)
   NC_ADX_WILDER=1  // iADXWilder (asse: conteggio della specifica par. 5.4)
  };

input ENUM_TIMEFRAMES InpTF              = PERIOD_H1;   // TF del segnale (EA_NatCla: CURRENT = H1 in AUDIO/EMA200). Sotto H1 = rifiutato come nell'EA
input int             InpEmaLentaPeriodo = 200;         // = EA_NatCla (file prova F0 r.157)
input int             InpEmaTp1          = 14;          // = EA_NatCla (r.158): handle creato e mai letto, come nell'EA
input int             InpEmaTp2          = 89;          // = EA_NatCla (r.159): handle creato e mai letto, come nell'EA
input bool            InpLogContesto     = true;        // = EA_NatCla (r.160): crea anche EMA9/EMA21/Bollinger, come nell'EA
input int             InpAtrNormPeriodo  = 14;          // = EA_NatCla (r.161)
input int             InpAdxPeriodo      = 14;          // = EA_NatCla (r.176)
input ENUM_NC_ADXTIPO InpAdxTipo         = NC_ADX_MT5;  // = EA_NatCla (r.178)
input bool            InpVerificheSeparate = true;      // (B) fa anche le chiamate che la catena non raggiunge. false = SOLO la catena, identica all'EA
input int             InpMaxEventi       = 20;          // righe [NatCla-DIAG-EV] al massimo (transizioni del motivo)

//==================================================================
//  BLOCCO PURO (compilato anche in C++ dal collaudo)
//==================================================================
//@@NCD_PURE_BEGIN
#define NC_BARRE     1500   // COPIA di EA_NatCla.mq5 r.322 (il collaudo lo confronta)
#define NC_BARRE_MIN 300    // COPIA di EA_NatCla.mq5 r.323 (il collaudo lo confronta)
#define NCD_OK  0           // CaricaDati renderebbe true
#define NCD_N   1           // r.1266 n < NC_BARRE_MIN
#define NCD_BC  2           // r.1267 BarsCalculated < n+1
#define NCD_CR  3           // r.1270 CopyRates != n
#define NCD_CB  4           // r.1274-1276 CopyBuffer != n
#define NCD_NC  (-999)      // sentinella: chiamata NON fatta (diversa dal -1 di errore di MT5)

//--- la finestra di CaricaDati (r.1265): n = barre-2, al massimo NC_BARRE
int NCD_Finestra(const int barre)
  {
   return (barre-2<NC_BARRE) ? barre-2 : NC_BARRE;
  }

//--- una condizione BarsCalculated cade (r.1267)
bool NCD_CadeBC(const int n,const int bc)
  {
   return (bc<n+1);
  }

//--- una copia (CopyRates/CopyBuffer) cade (r.1270, r.1274-1276)
bool NCD_CadeCopia(const int n,const int got)
  {
   return (got!=n);
  }

//--- il PRIMO motivo nell'ordine di CaricaDati, dai valori osservati (tutti)
int NCD_PrimoMotivo(const int n,const int bcE,const int bcA,const int bcX,const int cr,const int cbE,const int cbA,const int cbX)
  {
   if(n<NC_BARRE_MIN) return NCD_N;
   if(NCD_CadeBC(n,bcE) || NCD_CadeBC(n,bcA) || NCD_CadeBC(n,bcX)) return NCD_BC;
   if(NCD_CadeCopia(n,cr)) return NCD_CR;
   if(NCD_CadeCopia(n,cbE) || NCD_CadeCopia(n,cbA) || NCD_CadeCopia(n,cbX)) return NCD_CB;
   return NCD_OK;
  }
//@@NCD_PURE_END

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF=PERIOD_H1;
int hEma200=INVALID_HANDLE, hEma14=INVALID_HANDLE, hEma89=INVALID_HANDLE;
int hEma9=INVALID_HANDLE, hEma21=INVALID_HANDLE, hAtrN=INVALID_HANDLE, hAdx=INVALID_HANDLE, hBands=INVALID_HANDLE;
double gEma[], gAtrN[], gAdx[];
datetime gUltimaBarra=0;

//--- valori dell'ultima barra osservata (NCD_NC = chiamata non fatta). Indici 0 EMA200, 1 ATR, 2 ADX
int gcBarre=NCD_NC, gcN=NCD_NC, gcCr=NCD_NC, gcCrErr=0;
int gcBc[3];
int gcCb[3];
int gcCbErr[3];

//--- contatori
long gTick=0, gTickT0Zero=0, gNuove=0;
long gCd[5];                       // primo motivo della CATENA: 0 OK, 1 N, 2 BC, 3 CR, 4 CB
long gCadeN=0, gCadeBC=0, gCadeCR=0, gCadeCB=0, gCopiaSaltata=0, gIncoerenze=0;
long gCadeBCk[3];
long gCadeCBk[3];
datetime gPrima=0, gUltima=0, gPrimoOk=0;
int gPrimoOkBarre=-1;
int gMaxBarre=-1;
int gMinBc[3];
int gMaxBc[3];
int gMotivoPrec=-1;
int gEventi=0;
string gI0="", gU="", gOk="";      // istantanee: prima barra, ultima barra, prima barra con tutto OK
long gI0First=0, gI0TFirst=0, gI0Count=0;

//==================================================================
//  LA CATENA: stesse chiamate, stesso ordine, stesso corto circuito di
//  CaricaDati (r.1264-1276). Il collaudo lo dimostra compilando in C++
//  il corpo vero di CaricaDati e questo, contro gli stessi stub.
//==================================================================
//@@NCD_CATENA_BEGIN
int NCD_Catena()
  {
   gcBarre=NCD_NC; gcN=NCD_NC; gcCr=NCD_NC; gcCrErr=0;
   for(int k=0;k<3;k++){ gcBc[k]=NCD_NC; gcCb[k]=NCD_NC; gcCbErr[k]=0; }
   int barre=Bars(_Symbol,gTF);
   gcBarre=barre;
   int n=NCD_Finestra(barre);
   gcN=n;
   if(n<NC_BARRE_MIN) return NCD_N;
   gcBc[0]=BarsCalculated(hEma200);
   if(NCD_CadeBC(n,gcBc[0])) return NCD_BC;
   gcBc[1]=BarsCalculated(hAtrN);
   if(NCD_CadeBC(n,gcBc[1])) return NCD_BC;
   gcBc[2]=BarsCalculated(hAdx);
   if(NCD_CadeBC(n,gcBc[2])) return NCD_BC;
   MqlRates r[];
   ArraySetAsSeries(r,false);
   ResetLastError();
   gcCr=CopyRates(_Symbol,gTF,1,n,r);
   gcCrErr=GetLastError();
   if(NCD_CadeCopia(n,gcCr)) return NCD_CR;
   ArraySetAsSeries(gEma,false); ArraySetAsSeries(gAtrN,false); ArraySetAsSeries(gAdx,false);
   ResetLastError();
   gcCb[0]=CopyBuffer(hEma200,0,1,n,gEma);
   gcCbErr[0]=GetLastError();
   if(NCD_CadeCopia(n,gcCb[0])) return NCD_CB;
   ResetLastError();
   gcCb[1]=CopyBuffer(hAtrN,0,1,n,gAtrN);
   gcCbErr[1]=GetLastError();
   if(NCD_CadeCopia(n,gcCb[1])) return NCD_CB;
   ResetLastError();
   gcCb[2]=CopyBuffer(hAdx,0,1,n,gAdx);
   gcCbErr[2]=GetLastError();
   if(NCD_CadeCopia(n,gcCb[2])) return NCD_CB;
   return NCD_OK;
  }

//--- (B) le chiamate che la catena NON ha raggiunto, e SOLO quelle (una copia con n<1 non si puo' chiedere)
void NCD_Completa()
  {
   if(gcBc[0]==NCD_NC) gcBc[0]=BarsCalculated(hEma200);
   if(gcBc[1]==NCD_NC) gcBc[1]=BarsCalculated(hAtrN);
   if(gcBc[2]==NCD_NC) gcBc[2]=BarsCalculated(hAdx);
   if(gcN<1) return;
   if(gcCr==NCD_NC)
     {
      MqlRates r[];
      ArraySetAsSeries(r,false);
      ResetLastError();
      gcCr=CopyRates(_Symbol,gTF,1,gcN,r);
      gcCrErr=GetLastError();
     }
   if(gcCb[0]==NCD_NC){ ResetLastError(); gcCb[0]=CopyBuffer(hEma200,0,1,gcN,gEma); gcCbErr[0]=GetLastError(); }
   if(gcCb[1]==NCD_NC){ ResetLastError(); gcCb[1]=CopyBuffer(hAtrN,0,1,gcN,gAtrN); gcCbErr[1]=GetLastError(); }
   if(gcCb[2]==NCD_NC){ ResetLastError(); gcCb[2]=CopyBuffer(hAdx,0,1,gcN,gAdx); gcCbErr[2]=GetLastError(); }
  }
//@@NCD_CATENA_END

//==================================================================
//  FORMATO (valori senza spazi: la riga si legge con k=v)
//==================================================================
string TS(const datetime t)
  {
   if(t==0) return "mai";
   string s=TimeToString(t,TIME_DATE|TIME_MINUTES);
   StringReplace(s," ","_");
   return s;
  }

string V(const int v)
  {
   if(v==NCD_NC) return "nc";
   return IntegerToString(v);
  }

string NomeMotivo(const int m)
  {
   if(m<0) return "inizio";
   if(m==NCD_OK) return "OK";
   if(m==NCD_N)  return "N";
   if(m==NCD_BC) return "BC";
   if(m==NCD_CR) return "CR";
   if(m==NCD_CB) return "CB";
   return "?";
  }

//--- istantanea dei valori correnti: barre, n, BarsCalculated x3, CopyRates(valore/errore), CopyBuffer x3(valore/errore)
string Istantanea(const string pre)
  {
   string s=" "+pre+"barre="+V(gcBarre)+" "+pre+"n="+V(gcN);
   s+=" "+pre+"bc="+V(gcBc[0])+"/"+V(gcBc[1])+"/"+V(gcBc[2]);
   s+=" "+pre+"cr="+V(gcCr)+"/"+IntegerToString(gcCrErr);
   s+=" "+pre+"cb="+V(gcCb[0])+"/"+IntegerToString(gcCbErr[0])+","+V(gcCb[1])+"/"+IntegerToString(gcCbErr[1])+","+V(gcCb[2])+"/"+IntegerToString(gcCbErr[2]);
   return s;
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   //--- SOLO TESTER: e' una diagnosi, non deve finire su un grafico vivo (regola dei terminali multipli)
   if(!MQLInfoInteger(MQL_TESTER))
     { Print("[NatCla-DIAG-AVVIO] RIFIUTATO: EA_NatCla_Diag gira SOLO nello Strategy Tester (sola lettura, diagnosi)"); return(INIT_FAILED); }
   gTF=InpTF;
   if(InpTF==PERIOD_CURRENT) gTF=PERIOD_H1;
   if(PeriodSeconds(gTF)<PeriodSeconds(PERIOD_H1))
     { Print("[NatCla-DIAG-AVVIO] RIFIUTATO: TF sotto H1, come EA_NatCla"); return(INIT_PARAMETERS_INCORRECT); }
   for(int k=0;k<3;k++){ gcBc[k]=NCD_NC; gcCb[k]=NCD_NC; gcCbErr[k]=0; gCadeBCk[k]=0; gCadeCBk[k]=0; gMinBc[k]=NCD_NC; gMaxBc[k]=NCD_NC; }
   for(int m=0;m<5;m++) gCd[m]=0;

   //@@NCD_HANDLE_BEGIN
   hEma200=iMA(_Symbol,gTF,InpEmaLentaPeriodo,0,MODE_EMA,PRICE_CLOSE);
   hEma14 =iMA(_Symbol,gTF,InpEmaTp1,0,MODE_EMA,PRICE_CLOSE);
   hEma89 =iMA(_Symbol,gTF,InpEmaTp2,0,MODE_EMA,PRICE_CLOSE);
   hAtrN  =iATR(_Symbol,gTF,InpAtrNormPeriodo);
   if(InpAdxTipo==NC_ADX_WILDER) hAdx=iADXWilder(_Symbol,gTF,InpAdxPeriodo);
   else hAdx=iADX(_Symbol,gTF,InpAdxPeriodo);
   if(InpLogContesto)
     {
      hEma9 =iMA(_Symbol,gTF,9,0,MODE_EMA,PRICE_CLOSE);
      hEma21=iMA(_Symbol,gTF,21,0,MODE_EMA,PRICE_CLOSE);
      hBands=iBands(_Symbol,gTF,20,0,2.0,PRICE_CLOSE);
     }
   //@@NCD_HANDLE_END
   if(hEma200==INVALID_HANDLE || hEma14==INVALID_HANDLE || hEma89==INVALID_HANDLE || hAtrN==INVALID_HANDLE || hAdx==INVALID_HANDLE ||
      (InpLogContesto && (hEma9==INVALID_HANDLE || hEma21==INVALID_HANDLE || hBands==INVALID_HANDLE)))
     { Print("[NatCla-DIAG-AVVIO] ERRORE: creazione handle indicatori fallita (",GetLastError(),")"); return(INIT_FAILED); }
   Print("[NatCla-DIAG-AVVIO] v",NCD_VER," sym=",_Symbol," tf=",EnumToString(gTF)," ema=",IntegerToString(InpEmaLentaPeriodo),
         " atr=",IntegerToString(InpAtrNormPeriodo)," adx=",IntegerToString(InpAdxPeriodo),"/",EnumToString(InpAdxTipo),
         " contesto=",(InpLogContesto ? "si" : "no")," separate=",(InpVerificheSeparate ? "si" : "no"),
         " | SOLA LETTURA: nessun ordine, nessun file");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   string s="[NatCla-DIAG] RIASSUNTO v="+NCD_VER+" sym="+_Symbol+" tf="+EnumToString(gTF)+" adx="+EnumToString(InpAdxTipo);
   s+=" sep="+(InpVerificheSeparate ? "1" : "0")+" motivo_deinit="+IntegerToString(reason);
   s+=" tick="+IntegerToString(gTick)+" tick_t0zero="+IntegerToString(gTickT0Zero)+" nuove="+IntegerToString(gNuove);
   s+=" prima="+TS(gPrima)+" ultima="+TS(gUltima);
   s+=" cd_ok="+IntegerToString(gCd[NCD_OK])+" cd_n="+IntegerToString(gCd[NCD_N])+" cd_bc="+IntegerToString(gCd[NCD_BC]);
   s+=" cd_cr="+IntegerToString(gCd[NCD_CR])+" cd_cb="+IntegerToString(gCd[NCD_CB]);
   s+=" primo_ok="+TS(gPrimoOk)+" primo_ok_barre="+IntegerToString(gPrimoOkBarre);
   s+=" cade_n="+IntegerToString(gCadeN)+" cade_bc="+IntegerToString(gCadeBC);
   s+=" cade_bc_k="+IntegerToString(gCadeBCk[0])+"/"+IntegerToString(gCadeBCk[1])+"/"+IntegerToString(gCadeBCk[2]);
   s+=" cade_cr="+IntegerToString(gCadeCR)+" cade_cb="+IntegerToString(gCadeCB);
   s+=" cade_cb_k="+IntegerToString(gCadeCBk[0])+"/"+IntegerToString(gCadeCBk[1])+"/"+IntegerToString(gCadeCBk[2]);
   s+=" copia_saltata="+IntegerToString(gCopiaSaltata)+" incoerenze="+IntegerToString(gIncoerenze);
   s+=" max_barre="+IntegerToString(gMaxBarre);
   s+=" min_bc="+V(gMinBc[0])+"/"+V(gMinBc[1])+"/"+V(gMinBc[2])+" max_bc="+V(gMaxBc[0])+"/"+V(gMaxBc[1])+"/"+V(gMaxBc[2]);
   s+=" i0_first="+TS((datetime)gI0First)+" i0_tfirst="+TS((datetime)gI0TFirst)+" i0_count="+IntegerToString(gI0Count);
   s+=" u_first="+TS((datetime)SeriesInfoInteger(_Symbol,gTF,SERIES_FIRSTDATE))+" u_tfirst="+TS((datetime)SeriesInfoInteger(_Symbol,gTF,SERIES_TERMINAL_FIRSTDATE));
   s+=" maxbars_term="+IntegerToString(TerminalInfoInteger(TERMINAL_MAXBARS));
   if(gI0=="") gI0=" i0_barre=nc i0_n=nc i0_bc=nc/nc/nc i0_cr=nc/0 i0_cb=nc/0,nc/0,nc/0";
   if(gU=="")  gU=" u_barre=nc u_n=nc u_bc=nc/nc/nc u_cr=nc/0 u_cb=nc/0,nc/0,nc/0";
   if(gOk=="") gOk=" ok_barre=nc ok_n=nc ok_bc=nc/nc/nc ok_cr=nc/0 ok_cb=nc/0,nc/0,nc/0";
   s+=gI0+gU+gOk;
   s+=" eventi="+IntegerToString(gEventi)+" fine=1";
   Print(s);
   int hs[8]={hEma200,hEma14,hEma89,hEma9,hEma21,hAtrN,hAdx,hBands};
   for(int i=0;i<8;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
   hEma200=INVALID_HANDLE; hEma14=INVALID_HANDLE; hEma89=INVALID_HANDLE; hEma9=INVALID_HANDLE;
   hEma21=INVALID_HANDLE; hAtrN=INVALID_HANDLE; hAdx=INVALID_HANDLE; hBands=INVALID_HANDLE;
  }

void OnTick()
  {
   gTick++;
   datetime t0=iTime(_Symbol,gTF,0);
   if(t0==0) gTickT0Zero++;
   if(t0==0 || t0==gUltimaBarra) return;
   gUltimaBarra=t0;
   Osserva(t0);
  }

//==================================================================
//  UNA NUOVA BARRA: catena (A), verifiche separate (B), conti
//==================================================================
void Osserva(const datetime t0)
  {
   gNuove++;
   if(gPrima==0) gPrima=t0;
   gUltima=t0;
   int motivo=NCD_Catena();
   gCd[motivo]++;
   if(InpVerificheSeparate) NCD_Completa();
   //--- conti indipendenti: ogni condizione per conto suo, solo sui valori davvero chiesti
   if(gcN<NC_BARRE_MIN) gCadeN++;
   bool bcAny=false;
   for(int k=0;k<3;k++)
     {
      if(gcBc[k]==NCD_NC) continue;
      if(NCD_CadeBC(gcN,gcBc[k])){ gCadeBCk[k]++; bcAny=true; }
      if(gMinBc[k]==NCD_NC || gcBc[k]<gMinBc[k]) gMinBc[k]=gcBc[k];
      if(gMaxBc[k]==NCD_NC || gcBc[k]>gMaxBc[k]) gMaxBc[k]=gcBc[k];
     }
   if(bcAny) gCadeBC++;
   if(gcN<1 && InpVerificheSeparate) gCopiaSaltata++;
   if(gcCr!=NCD_NC && NCD_CadeCopia(gcN,gcCr)) gCadeCR++;
   bool cbAny=false;
   for(int k=0;k<3;k++)
     {
      if(gcCb[k]==NCD_NC) continue;
      if(NCD_CadeCopia(gcN,gcCb[k])){ gCadeCBk[k]++; cbAny=true; }
     }
   if(cbAny) gCadeCB++;
   //--- autoverifica: con TUTTI i valori chiesti, il primo motivo ricalcolato deve essere quello della catena
   if(InpVerificheSeparate && gcN>=1 && NCD_PrimoMotivo(gcN,gcBc[0],gcBc[1],gcBc[2],gcCr,gcCb[0],gcCb[1],gcCb[2])!=motivo) gIncoerenze++;
   if(gcBarre>gMaxBarre) gMaxBarre=gcBarre;
   //--- istantanee
   if(gNuove==1)
     {
      gI0=Istantanea("i0_");
      gI0First=SeriesInfoInteger(_Symbol,gTF,SERIES_FIRSTDATE);
      gI0TFirst=SeriesInfoInteger(_Symbol,gTF,SERIES_TERMINAL_FIRSTDATE);
      gI0Count=SeriesInfoInteger(_Symbol,gTF,SERIES_BARS_COUNT);
     }
   gU=Istantanea("u_");
   if(motivo==NCD_OK && gPrimoOk==0)
     {
      gPrimoOk=t0; gPrimoOkBarre=gcBarre;
      gOk=Istantanea("ok_");
     }
   //--- transizioni del motivo (anche la prima barra), al massimo InpMaxEventi righe
   if(motivo!=gMotivoPrec)
     {
      if(gEventi<InpMaxEventi)
        {
         Print("[NatCla-DIAG-EV] barra=",TS(t0)," motivo=",NomeMotivo(gMotivoPrec),"->",NomeMotivo(motivo)," nuove=",IntegerToString(gNuove),Istantanea(""));
         gEventi++;
        }
      gMotivoPrec=motivo;
     }
  }
//+------------------------------------------------------------------+
