# -*- coding: ascii -*-
# RIMAPPATURA OROLOGIO BCM -> FTMO, delta +2 (19/09/2026, ora estiva).
# Cambia SOLO gli input orari elencati per sedia. Tutto il resto e' copiato
# byte per byte. Verifica automatica a valle: ogni riga non-commento che
# differisce deve stare nell'elenco autorizzato.
import os, re, sys, difflib, hashlib
R="/home/user/GITHUB"
DELTA=2
DEST=os.path.join(R,"mql5/Presets/FTMO")
os.makedirs(DEST,exist_ok=True)

# sedia -> (originale, file FTMO, EA, simbolo/TF, [input orari da spostare], note)
SEDIE=[
 ("770101","mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set",
  "ABTG_DAX_Apertura_EU_770101_FTMO.set","ABTG_DAX_Apertura_EU","DAX M5",
  ["InpSessionHour","InpCloseHour"],
  ["Apertura DAX. 08:00 BCM = 09:00 IT = 10:00 FTMO. Chiusura 17:30 -> 19:30.",
   "Nessuno scavalco di mezzanotte: apertura (10:00) < chiusura (19:30)."]),
 ("770411","mql5/Presets/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set",
  "ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set","ABTG_MaxMinNotte_DAX_Short_Ottimizzato","D30EUR M15",
  ["InpBoxStartHour","InpBoxEndHour","InpPlaceHour","InpEntryCutoffHour","InpCloseHour"],
  ["IL BOX NOTTURNO CAMBIA GIORNO, E VA DETTO.",
   "  BCM : box da 23:00 del giorno PRIMA fino a 04:59 di oggi (scavalla).",
   "  FTMO: box da 01:00 a 06:59 DELLO STESSO GIORNO (NON scavalla piu').",
   "  E' LO STESSO ISTANTE REALE: BCM=UTC+1 -> 22:00-03:59 UTC;",
   "  FTMO=UTC+3 -> le stesse 22:00-03:59 UTC si leggono 01:00-06:59.",
   "CONTROLLATO NEL SORGENTE, non assunto: ComputeBox() r.203-206 fa",
   "  'if(tStart>=tEnd) tStart-=86400'. Con 23>=4 il ramo SCATTA (box di ieri);",
   "  con 1<6 il ramo NON scatta (box di oggi). In tutti e due i casi la",
   "  finestra coperta e' la stessa. Il ramo dello scavalco non serve piu',",
   "  e la sua assenza e' CORRETTA, non una dimenticanza.",
   "Piazzamento 07:59 -> 09:59, cutoff 08:30 -> 10:30, flat 17:30 -> 19:30:",
   "  tutti nello stesso giorno, ordine preservato (box < place < cutoff < close)."]),
 ("770202","mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set",
  "ABTG_Dow_Apertura_US_770202_FTMO.set","ABTG_Dow_Apertura_US","U30USD M5",
  ["InpSessionHour","InpCloseHour"],
  ["Apertura Wall Street. 14:30 BCM = 15:30 IT = 16:30 FTMO. Flat 17:30 -> 19:30.",
   "RILIEVO CHE L'ORA NON RISOLVE -- leggere prima di accendere:",
   "  questa sedia ha InpUseEmaFilter=true su InpFilterTF=16388 (H4).",
   "  La GRIGLIA delle candele H4 e' ancorata alla mezzanotte del SERVER:",
   "    BCM  (UTC+1) -> H4 aperte alle 23,03,07,11,15,19 UTC",
   "    FTMO (UTC+3) -> H4 aperte alle 21,01,05,09,13,17 UTC",
   "  Sono griglie DIVERSE (2h di sfasamento su un passo di 4h), quindi la",
   "  EMA(50) su H4 NON vale gli stessi numeri del backtest. Non e' un input",
   "  orario e NON l'ho toccato: va misurato o firmato, non aggiustato."]),
 ("771531","mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set",
  "ABTG_EMA200_771531_FTMO.set","ABTG_EMA200","U30USD H1",
  ["InpCutoffHour","InpFridayCloseHour"],
  ["QUESTA SEDIA NON HA ORARI ATTIVI: i due input spostati sono INERTI oggi.",
   "  InpUseCutoff=false  -> InpCutoffHour non viene mai letto (EA r.449).",
   "  InpFridayClose=false -> InpFridayCloseHour non viene mai letto (r.279).",
   "Li rimappo lo stesso (19->21, 20->22) per non lasciare in giro un valore",
   "in ora BCM che diventerebbe sbagliato il giorno in cui qualcuno accende",
   "l'interruttore. Uno zombie in ora vecchia e' il modo classico di sbagliare.",
   "InpTF=16385 (H1): la griglia H1 e' IDENTICA fra i due server (lo",
   "sfasamento di 2h e' multiplo del passo), quindi l'indicatore non cambia."]),
 ("770511","mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_SuperWave_DOW_H1_Ottimizzato_770511.set",
  "ABTG_SuperWave_DOW_H1_770511_FTMO.set","ABTG_SuperWave_DOW_H1_Ottimizzato","U30USD H1",
  [],
  ["NESSUN INPUT ORARIO SPOSTATO, E MI FERMO QUI INVECE DI SOMMARE.",
   "  InpUseTimeWindow=false -> la finestra non viene mai valutata (EA r.315).",
   "  InpStartHour=0 / InpEndHour=24 NON sono un orario: sono 'tutto il",
   "  giorno', ed e' invariante per fuso. Sommare +2 darebbe 2 e 26:",
   "  26 non e' un'ora valida e 2-26 sarebbe una finestra INVENTATA,",
   "  piu' stretta dell'originale. Quindi: si lascia 0 e 24.",
   "InpTF=16385 (H1): griglia identica fra BCM e FTMO."]),
 ("770402","mql5/Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set",
  "ABTG_MaxMinNotte_ORO_770402_FTMO.set","ABTG_MaxMinNotte","XAUUSD",
  ["InpBoxStartHour","InpBoxEndHour","InpPlaceHour","InpEntryCutoffHour","InpCloseHour"],
  ["Stesso caso di 770411, stesso codice (ABTG_MaxMinNotte.mq5 r.305-306).",
   "  BCM : box 23:00 (ieri) -> 04:59 (oggi), scavalla la mezzanotte.",
   "  FTMO: box 01:00 -> 06:59, stesso giorno. Stesso istante reale.",
   "Piazzamento 07:00 -> 09:00, cutoff 08:30 -> 10:30, flat 17:30 -> 19:30.",
   "InpMgmtTF=16386 (H2): la griglia H2 e' IDENTICA fra i due server",
   "  (sfasamento 2h = esattamente un passo H2), quindi EMA200 e ATR",
   "  di gestione leggono le stesse candele. Verificato, non assunto."]),
 ("770260","mql5/Presets/ABTG_Nasdaq_Apertura_US_RETEST_770260.set",
  "ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set","ABTG_Nasdaq_Apertura_US","NASUSD M5",
  ["InpSessionHour","InpCloseHour"],
  ["Apertura Nasdaq. 14:30 BCM = 15:30 IT = 16:30 FTMO. Flat 17:30 -> 19:30.",
   "L'originale BCM e' nato oggi dalla riga Pass=8 del CSV del round:",
   "  vedi l'intestazione di ABTG_Nasdaq_Apertura_US_RETEST_770260.set.",
   "InpFilterTF=16388 (H4) c'e' anche qui MA InpUseEmaFilter=false:",
   "  INERTE, quindi il problema di griglia H4 di 770202 NON tocca questa."]),
 ("771202","mql5/Presets/ABTG_PostNews_FOMC_EURUSD.set",
  "ABTG_PostNews_FOMC_EURUSD_771202_FTMO.set","ABTG_PostNews","EURUSD",
  ["InpActionHour","InpExpiryHour","InpFridayCloseHour"],
  ["FOMC. Azione 19:40 BCM = 20:40 IT = 21:40 FTMO; scadenza 20:45 -> 22:45.",
   "  Lo statement FOMC e' alle 14:00 New York = 18:00 UTC d'estate: la sedia",
   "  agisce 40 minuti dopo, prima e dopo la rimappatura.",
   "Venerdi 21:50 -> 23:50 FTMO. NON scavalla: su un server UTC+3 la settimana",
   "  chiude a 23:59 del venerdi (21:00 UTC), quindi il margine resta di 10",
   "  minuti esatti come su BCM (21:50 contro chiusura 22:00). Controllato",
   "  contro EA r.460-461, che pretende day_of_week==5.",
   "IL CALENDARIO NEWS NON VA TOCCATO, e il motivo e' nel sorgente:",
   "  NewsToday() (r.263-277) confronta SOLO anno/mese/giorno, non l'ora,",
   "  e il file e' UTC puro (costruisci_news_postnews.py r.34). Gli eventi",
   "  di questa famiglia stanno fra le 12:15 e le 20:00 UTC = 15:15-23:00",
   "  FTMO: stesso giorno di calendario. InpNewsShiftMinutes resta 0."]),
 ("771204","mql5/Presets/ABTG_PostNews_ECB_EURUSD.set",
  "ABTG_PostNews_ECB_EURUSD_771204_FTMO.set","ABTG_PostNews","EURUSD",
  ["InpActionHour","InpExpiryHour","InpFridayCloseHour"],
  ["BCE. Azione 14:00 BCM = 15:00 IT = 16:00 FTMO; scadenza 17:15 -> 19:15.",
   "  La decisione BCE e' alle 14:15 IT: la sedia arma 15 minuti prima e",
   "  lavora la reazione. Rapporto invariato dopo la rimappatura.",
   "Venerdi 21:50 -> 23:50 FTMO (vedi nota su 771202).",
   "Calendario news: invariato, stessa ragione di 771202."]),
 ("771203","mql5/Presets/ABTG_PostNews_NFP_USDJPY.set",
  "ABTG_PostNews_NFP_USDJPY_771203_FTMO.set","ABTG_PostNews","USDJPY",
  ["InpActionHour","InpExpiryHour","InpFridayCloseHour"],
  ["NFP. Azione 13:45 BCM = 14:45 IT = 15:45 FTMO; scadenza 16:59 -> 18:59.",
   "  Il dato esce alle 14:30 BCM (08:30 New York = 12:30 UTC d'estate):",
   "  la sedia arma 45 minuti prima, come prima.",
   "ATTENZIONE, QUESTA E' L'UNICA CHE OPERA DI VENERDI: la chiusura del",
   "  venerdi passa a 23:50 FTMO, che e' l'ultimo quarto d'ora prima della",
   "  chiusura settimanale di un server UTC+3. E' lo stesso istante reale",
   "  della 21:50 BCM. Se FTMO chiudesse il venerdi PRIMA delle 23:50",
   "  server, questa riga diventerebbe muta: VERIFICA A TERMINALE ACCESO.",
   "Calendario news: invariato, stessa ragione di 771202."]),
]

# Sedie che hanno DUE originali in repo. La scelta della base NON e' neutra:
# le due famiglie differiscono sul RISCHIO, che e' territorio di Claudio.
GEMELLO={m:[
 "; ATTENZIONE, QUESTA SEDIA HA **DUE** ORIGINALI IN REPO E IO HO SCELTO:",
 ";   base usata ..: mql5/Presets/...%s  -> InpRiskPercent=0.65, InpUsaGuardian=true"%a,
 ";   NON usata ...: mql5/Presets/sedie_piccolo/recupero2/...  -> InpRiskPercent=1.0",
 ";                  e SENZA la riga InpUsaGuardian.",
 ";   PERCHE': 0,65% e' la taglia firmata di casa e il cap C1 (3,25% = 5 x 0,65)",
 ";   e' tarato su quella; la famiglia recupero2 e' quella del DEMO PICCOLO",
 ";   50503392. Su un 100k FTMO con perdita giornaliera al 5%, 1,0% per",
 ";   operazione x 5 posizioni aperte = il limite giornaliero in un colpo solo.",
 ";   *** E' UN PARAMETRO DI RISCHIO: LA SCELTA VA CONFERMATA DA CLAUDIO. ***",
 ";   Se la firma dicesse recupero2, questo file si rigenera in 10 secondi con",
 ";   backtest_pipeline/rimappa_preset_ftmo.py cambiando il percorso di partenza."
 ] for m,a in [("770101","ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set"),
               ("770411","ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set"),
               ("770202","ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set"),
               ("771531","ABTG_EMA200_U30USD_H1_771531_VIVA.set")]}

def h(p):
    return hashlib.sha1(open(p,'rb').read()).hexdigest()[:12]

report=[]
tabella=[]
for magic, orig, nome, ea, simb, ore, note in SEDIE:
    po=os.path.join(R,orig); pd_=os.path.join(DEST,nome)
    righe=open(po,encoding='ascii',newline='').read().split("\n")
    # minuti appaiati: InpXxxHour -> InpXxxMin (serve solo per stampare l'ora vera)
    minuti={}
    for l in righe:
        s2=l.strip()
        if s2 and not s2.startswith(';') and '=' in s2:
            n2=s2.split('=',1)[0].strip()
            if n2.endswith('Min'): minuti[n2]=s2.split('=',1)[1].strip()
    cambi=[]
    nuove=[]
    for l in righe:
        s=l.strip()
        if s and not s.startswith(';') and '=' in s:
            n=s.split('=',1)[0].strip()
            if n in ore:
                v=int(s.split('=',1)[1].strip())
                nv=(v+DELTA)%24
                cambi.append((n,v,nv))
                nuove.append("%s=%d"%(n,nv)); continue
        nuove.append(l)
    mancanti=[o for o in ore if o not in [c[0] for c in cambi]]
    assert not mancanti, "%s: input orari dichiarati ma NON TROVATI: %s"%(magic,mancanti)
    hdr=["; ==========================================================================",
         "; %s -- SEDIA %s -- %s"%(ea,magic,simb),
         "; PRESET RIMAPPATO PER L'OROLOGIO **FTMO**. NON usarlo su BCM.",
         "; Generato il 20/09/2026 da backtest_pipeline/rimappa_preset_ftmo.py. ASCII PURO (regola 17/08).",
         "; ==========================================================================",
         ";",
         "; BERSAGLIO ....: terminale MT5 FTMO (challenge 100k 2-Step).",
         ";                 NON 50503392, NON 50504263, NON 10105439 (C:\\BCM_Reale),",
         ";                 NON 50504400 (C:\\MT5_Backtest).",
         "; ORIGINALE ....: %s"%orig,
         ";                 sha1(12) %s -- se cambia, questo file va rigenerato."%h(po),
         ";"] + GEMELLO.get(magic,[]) + [
         ";",
         "; PERCHE' +2, e da dove viene il numero",
         ";   docs/REGOLAMENTO_FTMO_2026-08.md r.130: server FTMO = GMT+2 inverno /",
         ";     GMT+3 estate, cioe' ORA ITALIANA +1.",
         ";   CLAUDE.md (regola fissa): server BCM = ORA ITALIANA -1.",
         ";   Oggi 19/09/2026 siamo in ora estiva: IT=UTC+2, BCM=UTC+1, FTMO=UTC+3.",
         ";   ==> FTMO = BCM + 2. Un preset non rimappato farebbe partire la sedia",
         ";       DUE ORE PRIMA, su un mercato che non e' quello misurato.",
         ";",
         "; COSA E' CAMBIATO -- e NIENTE ALTRO",
        ]
    if cambi:
        hdr.append(";   input                  BCM    FTMO   ora italiana")
        for n,v,nv in cambi:
            mm=minuti.get(n.replace("Hour","Min"),"00")
            hdr.append(";   %-22s %-6s %-6s %02d:%02d IT (= %02d:%02d BCM = %02d:%02d FTMO)"%(
                n,v,nv,(v+1)%24,int(mm),v,int(mm),nv,int(mm)))
    else:
        hdr.append(";   NESSUNO. Vedi le note qui sotto: non e' una dimenticanza.")
    hdr.append(";")
    hdr.append("; NOTE DI QUESTA SEDIA")
    for x in note: hdr.append(";   "+x)
    hdr += [";",
         "; CAMBIO DI ORA DI FINE OTTOBRE -- QUESTO FILE HA UNA SCADENZA",
         ";   Il DST europeo finisce DOMENICA 25 OTTOBRE 2026; quello americano",
         ";   DOMENICA 1 NOVEMBRE 2026. Se FTMO e BCM cambiano nello STESSO giorno",
         ";   (tutti e due su DST europeo) il delta resta +2 e non si tocca niente.",
         ";   Se FTMO seguisse il DST AMERICANO, fra il 25/10 e il 01/11 il delta",
         ";   diventerebbe +3 per una settimana. NON E' VERIFICABILE DA QUI:",
         ";   la misura e' UNA SOLA e va fatta a terminale FTMO acceso ->",
         ";   confrontare l'ora dell'ultima candela M1 con l'ora UTC. Va messa",
         ";   in calendario per il 25/10/2026.",
         "; --------------------------------------------------------------------------",
         ""]
    txt="\n".join(hdr)+"\n".join(nuove)
    bad=[c for c in txt if ord(c)>127]
    assert not bad, "%s: byte non-ASCII %r"%(magic,bad[:5])
    open(pd_,'w',encoding='ascii',newline='\n').write(txt)
    report.append((magic,orig,"mql5/Presets/FTMO/"+nome,cambi))
    for n,v,nv in cambi: tabella.append((magic,n,v,nv))

# ---------- VERIFICA AUTOMATICA: solo le ore possono differire ----------
print("="*74); print("VERIFICA: ogni riga non-commento che differisce DEVE essere un input orario")
ok=True
for magic,orig,dest,cambi in report:
    a=[l for l in open(os.path.join(R,orig),encoding='ascii').read().split("\n") if l.strip() and not l.strip().startswith(';')]
    b=[l for l in open(os.path.join(R,dest),encoding='ascii').read().split("\n") if l.strip() and not l.strip().startswith(';')]
    if len(a)!=len(b):
        print("  %s FAIL: numero di righe non-commento %d -> %d"%(magic,len(a),len(b))); ok=False; continue
    diff=[(x,y) for x,y in zip(a,b) if x!=y]
    attesi=set("%s=%d|%s=%d"%(n,v,n,nv) for n,v,nv in cambi)
    fuori=[(x,y) for x,y in diff if "%s|%s"%(x.strip(),y.strip()) not in attesi]
    print("  %s  righe non-commento %d  differenze %d  fuori elenco %d  %s"%(
        magic,len(a),len(diff),len(fuori),"OK" if (not fuori and len(diff)==len(cambi)) else "FAIL"))
    if fuori:
        ok=False
        for x,y in fuori: print("     !! %r -> %r"%(x,y))
    if len(diff)!=len(cambi):
        ok=False; print("     !! attese %d differenze, trovate %d"%(len(cambi),len(diff)))
print("="*74); print("ESITO GLOBALE:", "PASS" if ok else "FAIL")
import json
json.dump({'report':[(m,o,d,c) for m,o,d,c in report]},open('/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/ftmo_report.json','w'))
sys.exit(0 if ok else 1)
