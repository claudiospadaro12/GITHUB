#!/usr/bin/env python3
# Genera MECCANICAMENTE le toppe "chiusura per TICKET" per la famiglia Apertura.
# NON tocca mql5/: legge da git (o da HEAD), scrive copie nello scratchpad e
# produce i diff unificati. Se un ancoraggio non si trova ESATTAMENTE una volta,
# il file viene RIFIUTATO e non si produce nessun diff (meglio niente che una
# toppa applicata al punto sbagliato).
import subprocess, sys, os, difflib

SCR = "/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad"

FUNZIONE = '''
//+------------------------------------------------------------------+
//| TOPPA HEDGE-SAFE (19/09/2026) -- chiude TUTTE e SOLE le NOSTRE    |
//| posizioni, PER TICKET.                                            |
//|                                                                   |
//| IL DIFETTO CHE CURA:                                              |
//|   gTrade.PositionClose(_Symbol), su conto HEDGING, chiude la      |
//|   posizione PIU' VECCHIA del simbolo, DI CHIUNQUE SIA. La guardia |
//|   SelectMyPosition() qui sopra era gia' hedge-safe: e' l'AZIONE   |
//|   che non lo era. Il mezzo fix e' PEGGIO del bug intero, perche'  |
//|   l'EA trova la PROPRIA posizione, decide di chiuderla, e chiude  |
//|   quella DEL VICINO.                                              |
//|                                                                   |
//|   E non ne chiudeva UNA: le chiudeva A CATENA. I due punti di     |
//|   chiamata girano a OGNI TICK (il controllo dell'ora sta PRIMA    |
//|   dello switch e non ha guardia di stato). Finche' la NOSTRA      |
//|   esiste, la guardia resta vera e la chiusura per simbolo         |
//|   riparte: un vicino per tick, dal piu' vecchio in giu', finche'  |
//|   la nostra non diventa la piu' vecchia.                          |
//|                                                                   |
//| PERCHE' I TICKET SI FOTOGRAFANO PRIMA E SI CHIUDONO DOPO:         |
//|   un while(SelectMyPosition()) sarebbe un ciclo su una lettura    |
//|   che il terminale aggiorna in modo ASINCRONO -> ciclo infinito   |
//|   e doppia chiusura. La lista si legge UNA volta sola.            |
//|   Stesso schema gia' in campo in ABTG_ORB_Ottimizzato v1.04       |
//|   (ChiudiPosizioniMie): non c'e' niente da inventare.             |
//|                                                                   |
//| Se non abbiamo NIENTE non parte NESSUNA chiamata: la funzione     |
//| resta muta invece di ritentare all'infinito.                      |
//| Ritorna quante ne ha chiuse.                                      |
//+------------------------------------------------------------------+
int ChiudiMiePosizioni(const string motivo)
  {
   ulong miei[];
   int   q = 0;
   for(int _i = PositionsTotal()-1; _i >= 0; _i--)
     {
      ulong _tk = PositionGetTicket(_i);
      if(_tk > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == InpMagic)
        { ArrayResize(miei, q+1); miei[q] = _tk; q++; }
     }
   int chiuse = 0;
   for(int _k = 0; _k < q; _k++)
     {
      ResetLastError();
      if(gTrade.PositionClose(miei[_k]))
        {
         chiuse++;
         ABTGLog(StringFormat("%s: chiusa la posizione #%I64u.", motivo, miei[_k]));
        }
      else
         ABTGLog(StringFormat("%s: PositionClose(#%I64u) FALLITA, retcode %u (%s), err=%d. Riprovo al prossimo tick.",
                              motivo, miei[_k], gTrade.ResultRetcode(),
                              gTrade.ResultRetcodeDescription(), GetLastError()));
     }
   return(chiuse);
  }
'''.strip('\n').split('\n')

ANCORA_FUNZ = "bool HasOpenPosition() { return(SelectMyPosition()); }"

SITO_A_OLD = "      if(SelectMyPosition()) gTrade.PositionClose(_Symbol);"
SITO_A_NEW = '      ChiudiMiePosizioni("blackout notizie");   // TOPPA 19/09: per TICKET, non per simbolo'

SITO_B_OLD = [
 "   if(InpCloseAtEnd && SelectMyPosition())",
 "     {",
 "      gTrade.PositionClose(_Symbol);",
 '      ABTGLog("fine sessione: posizione chiusa.");',
 "     }",
]
SITO_B_NEW = [
 "   // TOPPA 19/09: per TICKET, non per simbolo. ChiudiMiePosizioni() ha gia'",
 "   // dentro la guardia (se non abbiamo niente non chiama niente) e chiude",
 "   // ENTRAMBE le nostre quando il whipsaw ha riempito tutti e due i lati.",
 "   if(InpCloseAtEnd)",
 '      ChiudiMiePosizioni("fine sessione");',
]

def sorgente(rev, path):
    if rev == "HEAD-lavorativo":
        return open(path, encoding="utf-8", errors="strict").read().split("\n")
    out = subprocess.run(["git","show",f"{rev}:{path}"],capture_output=True,text=True,check=True)
    return out.stdout.split("\n")

def applica(L, etichetta):
    L = list(L)
    err = []
    # --- sito B (blocco), prima: e' piu' lungo e piu' specifico
    idx = [i for i in range(len(L)-len(SITO_B_OLD)+1) if L[i:i+len(SITO_B_OLD)] == SITO_B_OLD]
    if len(idx) != 1: err.append(f"SITO B trovato {len(idx)} volte (atteso 1)")
    else:
        i = idx[0]; L[i:i+len(SITO_B_OLD)] = SITO_B_NEW
    # --- sito A (una riga)
    idx = [i for i,l in enumerate(L) if l == SITO_A_OLD]
    if len(idx) != 1: err.append(f"SITO A trovato {len(idx)} volte (atteso 1)")
    else:
        L[idx[0]] = SITO_A_NEW
    # --- funzione nuova, ancorata a HasOpenPosition
    idx = [i for i,l in enumerate(L) if l == ANCORA_FUNZ]
    if len(idx) != 1: err.append(f"ANCORA funzione trovata {len(idx)} volte (atteso 1)")
    else:
        i = idx[0]; L[i+1:i+1] = [""] + FUNZIONE
    if err:
        print(f"  [RIFIUTATO] {etichetta}: " + " ; ".join(err)); return None
    # --- contro-verifica: NESSUNA scrittura per simbolo deve restare
    resid = [ (n+1,l) for n,l in enumerate(L)
              if ("PositionClose(_Symbol" in l or "PositionModify(_Symbol" in l
                  or "PositionClosePartial(_Symbol" in l) and not l.strip().startswith("//") ]
    if resid:
        print(f"  [RIFIUTATO] {etichetta}: restano scritture per simbolo: {resid}"); return None
    return L

BERSAGLI = [
 ("ABTG_Nasdaq_Apertura_US", "3af47ed9",        "binario IN CAMPO sul piccolo 50503392 + base dei .set 770260/770261"),
 ("ABTG_Nasdaq_Apertura_US", "HEAD-lavorativo", "HEAD del repo (v1.02, WIP: vedi avvertenza nel referto)"),
 ("ABTG_DAX_Apertura_EU",    "3af47ed9",        "binario IN CAMPO sul piccolo 50503392 (v1.00, 2133 righe)"),
 ("ABTG_DAX_Apertura_EU",    "d83c1960",        "binario IN CAMPO sul 100k 50504263 (v1.01, 2361 righe)"),
 ("ABTG_DAX_Apertura_EU",    "HEAD-lavorativo", "binario IN CAMPO sul REALE 10105439 (v1.01, 2368 righe) = HEAD"),
 ("ABTG_Dow_Apertura_US",    "3af47ed9",        "binario IN CAMPO sul piccolo 50503392 (v1.00, 2065 righe)"),
 ("ABTG_Dow_Apertura_US",    "HEAD-lavorativo", "binario IN CAMPO sul 100k 50504263 (v1.01, 2148 righe) = HEAD"),
 ("ABTG_Nasdaq_Apertura_US_Ottimizzato", "HEAD-lavorativo", "NON in campo (nessun grafico): toppa pronta, non urgente"),
 ("ABTG_DAX_Apertura_EU_Ottimizzato",    "HEAD-lavorativo", "NON in campo (nessun grafico): toppa pronta, non urgente"),
 ("ABTG_Apertura_3Ingressi", "HEAD-lavorativo", "NON in campo"),
 ("ABTG_Apertura_Marco",     "HEAD-lavorativo", "NON in campo (RITIRATO 06/08)"),
]

# CANCELLO 19/09 (classe 448): il perimetro si legge dalla CONCESSIONE della firma
# 999b082d (passo 5: "ricompilazione F7 sul terminale 50503392 ... NON su -V3
# (50504263), NON su C:\\BCM_Reale (10105439), NON su C:\\MT5_Backtest"), NON per
# sottrazione della sola esclusione scritta in chiaro. Autorizzati oggi: 3.
PERIMETRO = {
 ("ABTG_Nasdaq_Apertura_US", "3af47ed9"):        "AUTORIZZATA dalla firma 999b082d -- terminale 50503392 (C:\\Program Files\\BCM Markets MT5 Terminal)",
 ("ABTG_DAX_Apertura_EU",    "3af47ed9"):        "AUTORIZZATA dalla firma 999b082d -- terminale 50503392 (C:\\Program Files\\BCM Markets MT5 Terminal)",
 ("ABTG_Dow_Apertura_US",    "3af47ed9"):        "AUTORIZZATA dalla firma 999b082d -- terminale 50503392 (C:\\Program Files\\BCM Markets MT5 Terminal)",
 ("ABTG_DAX_Apertura_EU",    "d83c1960"):        "NON AUTORIZZATA -- sarebbe il 100k 50504263 (... MT5 Terminal -V3): la firma dice NON su -V3. Serve una firma nuova.",
 ("ABTG_Dow_Apertura_US",    "HEAD-lavorativo"): "NON AUTORIZZATA -- sarebbe il 100k 50504263 (... MT5 Terminal -V3): la firma dice NON su -V3. Serve una firma nuova.",
 ("ABTG_DAX_Apertura_EU",    "HEAD-lavorativo"): "VIETATA -- e' il vintage del CONTO REALE 10105439 (C:\\BCM_Reale). La firma 999b082d NON autorizza ricompilazioni sul reale. Diff prodotto per completezza: NON si applica.",
}

os.makedirs(f"{SCR}/toppa", exist_ok=True)
ok = 0
for nome, rev, nota in BERSAGLI:
    path = f"mql5/Experts/{nome}.mq5"
    et = f"{nome} @ {rev}"
    print(f"\n=== {et}  ({nota})")
    try: L = sorgente(rev, path)
    except Exception as e:
        print(f"  [RIFIUTATO] sorgente non leggibile: {e}"); continue
    N = applica(L, et)
    if N is None: continue
    tag = rev.replace("-","_")
    # CANCELLO 19/09 (classe 446): il vintage va dopo un TAB, non dopo uno SPAZIO.
    # git apply / patch leggono il nome file fino al TAB: con lo spazio il " (rev)"
    # finisce DENTRO il nome e il diff NON si applica (verificato: 11/11 falliti).
    d = list(difflib.unified_diff(L, N, fromfile=f"a/{path}\t({rev})",
                                  tofile=f"b/{path}\t({rev} + toppa ticket)", lineterm=""))
    fn = f"{SCR}/toppa/{nome}__{tag}.diff"
    perim = PERIMETRO.get((nome, rev), "NON IN CAMPO (nessun grafico): nessuna ricompilazione da autorizzare.")
    testa = [f"# BERSAGLIO ....: {nome}.mq5 @ {rev}",
             f"# NOTA .........: {nota}",
             f"# PERIMETRO ....: {perim}",
             "# APPLICARE CON : git apply -p1 <questo file>   (dalla radice del repo)",
             ""]
    open(fn,"w",encoding="utf-8").write("\n".join(testa + d)+"\n")
    open(f"{SCR}/toppa/{nome}__{tag}.mq5","w",encoding="utf-8").write("\n".join(N))
    print(f"  [OK] {len([x for x in d if x.startswith('+') and not x.startswith('+++')])} righe aggiunte, "
          f"{len([x for x in d if x.startswith('-') and not x.startswith('---')])} tolte -> {os.path.basename(fn)}")
    ok += 1
print(f"\n=== TOPPE GENERATE: {ok}/{len(BERSAGLI)}")
