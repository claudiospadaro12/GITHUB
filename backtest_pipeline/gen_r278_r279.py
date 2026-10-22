import re
WT='/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/lavoro_wt/backtest_pipeline/prove/'
src=open(WT+'R277a_pre5_filtro_ON_NASDAQ_NASUSD.txt',encoding='ascii',newline='').read().replace('\r\n','\n')
body=src[src.index('@SIMBOLO'):]
NOT_DOW=['InpMinBreakoutRangeATR','InpRunnerTP_R','InpSRProximityPts','InpSRRoundInterval','InpSRUsePrevDay','InpSRUseRoundNumbers','InpUseSRFilter','InpUseVolRegime','InpVolAtrPeriod','InpVolHighOffMult','InpVolHighPct','InpVolHighSizeMult','InpVolHighSlMult','InpVolLookback','InpVolLowOffMult','InpVolLowPct','InpVolLowSlMult']
def sub(b,o,n):
    assert b.count(o)==1,(o,b.count(o)); return b.replace(o,n)
def dowify(b):
    b=sub(b,'@SIMBOLO  NASUSD','@SIMBOLO  U30USD')
    for k in NOT_DOW:
        b,n=re.subn(r'^%s=.*\n'%k,'',b,flags=re.M); assert n==1,k
    return b
# ---------------- DOW (R278) ----------------
HD='''#  EA: ABTG_Dow_Apertura_US
# ==========================================================================
#  %(titolo)s
#  U30USD M5 -- TICK REALI -- deposito 80000 -- rischio 2,00 -- FINESTRA B 2024.09.26 -> 2026.06.30, taglio 0.40 (come R277)
#  magic gemelli %(m1)s / %(m2)s (vergini: zero occorrenze nel repo, git grep -w del 22/10/2026)
#  Scritto il 22/10/2026. Attese, soglie e contro-esempi CONGELATI PRIMA dei numeri, dentro questo file.
#  Origine: webinar di Emiliano del 22/10 (report/ANALISI_LIVE_EMILIANO_2026-10-22_WEBINAR_LEZIONE4.md): "questa strategia funziona sul Nasdaq e
#  sull'US30; da domani passate all'US30". [DICHIARATO DA LUI, osservazione di due giorni, non verificata.] Per il Dow NON ha detto le soglie del filtro.
#  Gira SOLO sul PC di backtest DESKTOP-H4D7CAJ: NON sul VPS, NON sul banco C:\\MT5_Backtest (50504400), NON su nessun terminale di conto.
#  QUESTO FILE NON CONTIENE E NON AUTORIZZA NESSUNA RIGA DI LANCIO. Non promuove niente. Non tocca taglie, preset, sedie, forward.
#  Deposito (80000) e modello (4 = tick reali) li passa la riga di lancio.
# ==========================================================================
#  0. LA DOMANDA: la regola di Emiliano (candela di 5 minuti PRIMA dell'apertura, 14:25-14:30 server, ordini pendenti BUY STOP / SELL STOP, stop
#  all'estremo opposto, filtro sull'ampiezza della candela) funziona anche sul Dow (U30USD)? Stessa cella di R277a/b cambiando SOLO simbolo ed EA
#  (ABTG_Dow_Apertura_US, stesso motore d'apertura; il filtro EMA H4 di default del Dow e SPENTO come in R277).
#  Digits=2: 1 punto indice = 100 punti MT5 (misurato, report/APERTURE_DOW_MAPPA_2026-10-03.md). Il Dow vale circa il doppio del Nasdaq (circa 44.000
#  contro circa 22.000 nel 2025): le soglie 17-38 della regola sul Nasdaq sono PROBABILMENTE strette per il Dow.
#   - %(cella)s
#  CELLE: R278a (buffer 10 punti, filtro 17-38 come dichiarato per il Nasdaq), R278b (buffer 10, filtro SPENTO = controllo), R278c (buffer 20, filtro
#  34-76 = le stesse soglie scalate per il rapporto di prezzo Dow/Nasdaq circa 2: [DERIVATO, e una nostra ipotesi, non di Emiliano]).
#  ORARI: apertura cash 14:30 server (UTC+1 fisso, USA in ora legale). D'INVERNO (3/11/2025-6/3/2026 nell'OOS, 4/11/2024-7/3/2025 nell'IS) l'apertura
#  e alle 15:30 server: i mesi invernali di QUESTO file guardano la candela un'ora PRIMA dell'apertura. Si legge anche la divisione per stagione
#  (r278_giudizio.py, esplorativa) ma il verdetto congelato e quello globale. La versione invernale del Dow e un'altra riga.
# ==========================================================================
#  1. COSA SI LEGGE (CSV IS e OOS per file: Profit, Profit Factor, Equity DD %%, Trades) e il cancello G1 (due gemelle identiche).
#  CRITERI CONGELATI (r278_giudizio.py, scritto prima di aprire gli zip):
#   FILTRO UTILE (R278a contro R278b; R278c contro R278b) se e solo se, in IS E in OOS: PF_acceso - PF_spento >= 0,10 E DD_acceso <= 1,10 x DD_spento
#   E Trades_acceso >= 0,40 x Trades_spento. Altrimenti "NON DIMOSTRATO".
#   "PASSA" (cella singola, soglia di casa per le aperture del Dow): PF >= 1,10 in IS E in OOS E Trades >= 150 in IS E in OOS. Il DD si legge sempre
#   (a rischio 2%% nessuna cella d'apertura del Dow stava sotto il 10%%, R263). Con Trades < 150 non c'e' verdetto di merito.
#  ATTESE (dichiarate ORA, fiducia bassa):
#   D1. G1 (gemelle identiche) in tutti e 3 i file: 90%%.
#   D2. Trades_acceso / Trades_spento di R278a < 0,40 (filtro 17-38 troppo stretto per il Dow): 70%%. Di R278c fra 0,35 e 0,80: 50%%.
#   D3. PF del file SPENTO R278b fra 0,85 e 1,15 in IS e in OOS (breakout cieco): 65%%.
#   D4. FILTRO UTILE: R278c contro R278b 25%%; R278a contro R278b 15%%.
#   D5. Nessuna cella PASSA (PF >= 1,10 con n >= 150 in IS e in OOS): 75%%.
#  LIMITI: un solo percorso storico (2024-2026), una sola cella d'uscita, una sola finestra; l'orologio invernale non e allineato (vedi sopra); soglie
#  di R278c inventate da noi; non e la sedia 770202 ne' nessun preset vivo; non e un test del consiglio "da domani l'US30".
# ==========================================================================

'''
dow=[('R278a_pre5_dow_filtro1738_DOW_U30USD.txt','R278a','R278a -- DOW, regola di Emiliano: candela 5 minuti PRIMA dell\'apertura (14:25-14:30 server), buffer 10 punti, FILTRO 17-38 ACCESO','InpBufferPoints=1000, filtro InpMinRangePts=1700 / InpMaxRangePts=3800 (17,00-38,00 punti indice)',('798811','798861'),('799011','799061'),{'InpMinRangePts=1700||1700||0||1700||N':None}),
     ('R278b_pre5_dow_filtro_OFF_DOW_U30USD.txt','R278b','R278b -- DOW, regola di Emiliano: candela 5 minuti PRIMA dell\'apertura (14:25-14:30 server), buffer 10 punti, FILTRO SPENTO (controllo)','InpBufferPoints=1000, filtro SPENTO: InpMinRangePts=0, InpMaxRangePts=0',('798811','798861'),('799021','799071'),{'InpMinRangePts=1700||1700||0||1700||N':'InpMinRangePts=0||0||0||0||N','InpMaxRangePts=3800||3800||0||3800||N':'InpMaxRangePts=0||0||0||0||N'}),
     ('R278c_pre5_dow_filtro3476_DOW_U30USD.txt','R278c','R278c -- DOW, regola di Emiliano: candela 5 minuti PRIMA dell\'apertura (14:25-14:30 server), buffer 20 punti, FILTRO 34-76 ACCESO (soglie scalate x2)','InpBufferPoints=2000, filtro InpMinRangePts=3400 / InpMaxRangePts=7600 (34,00-76,00 punti indice, scalato per il rapporto di prezzo circa 2)',('798811','798861'),('799031','799081'),{'InpMinRangePts=1700||1700||0||1700||N':'InpMinRangePts=3400||3400||0||3400||N','InpMaxRangePts=3800||3800||0||3800||N':'InpMaxRangePts=7600||7600||0||7600||N','InpBufferPoints=1000||1000||0||1000||N':'InpBufferPoints=2000||2000||0||2000||N'})]
for nome,tag,tit,cella,mo,m,mod in dow:
    b=dowify(body)
    for o,n in mod.items():
        if n is not None: b=sub(b,o,n)
    b=sub(b,'InpMagic=798811||798811||50||798861||Y','InpMagic=%s||%s||50||%s||Y'%(m[0],m[0],m[1]))
    txt=HD%dict(titolo=tit,cella=cella,m1=m[0],m2=m[1])+b
    assert all(ord(c)<128 for c in txt),nome
    open(WT+nome,'w',encoding='ascii',newline='').write(txt); print(nome,len(txt))
# ---------------- INVERNO NASDAQ (R279) ----------------
HI='''#  EA: ABTG_Nasdaq_Apertura_US
# ==========================================================================
#  %(titolo)s
#  NASUSD M5 -- TICK REALI -- deposito 80000 -- rischio 2,00 -- FINESTRA INVERNALE %(win)s, @FRAZIONEIS 0.001 (quasi tutta la finestra nella gamba OOS)
#  magic gemelli %(m1)s / %(m2)s (vergini: zero occorrenze nel repo, git grep -w del 22/10/2026)
#  Scritto il 22/10/2026. Attese, soglie e contro-esempi CONGELATI PRIMA dei numeri, dentro questo file.
#  Origine: R277 (report/R277_EMILIANO_NASDAQ_LETTURA_2026-10-22.md): il test usava sempre le 14:30 server, giusto d'estate USA e un'ora PRIMA
#  dell'apertura d'inverno. Qui si misura la STESSA regola con l'orologio GIUSTO d'inverno.
#  Gira SOLO sul PC di backtest DESKTOP-H4D7CAJ: NON sul VPS, NON sul banco C:\\MT5_Backtest (50504400), NON su nessun terminale di conto.
#  QUESTO FILE NON CONTIENE E NON AUTORIZZA NESSUNA RIGA DI LANCIO. Non promuove niente. Non tocca taglie, preset, sedie, forward.
#  Deposito (80000) e modello (4 = tick reali) li passa la riga di lancio.
# ==========================================================================
#  0. LA DOMANDA: la regola di Emiliano (candela 5 minuti PRIMA dell'apertura, pendenti a 10 punti, filtro 17-38) funziona anche d'INVERNO se
#  l'orologio e quello giusto? Server BCM = UTC+1 fisso, USA in ora solare (apertura 9:30 New York = 14:30 UTC) => apertura cash alle 15:30 SERVER:
#  InpSessionHour=15, InpSessionMin=30 (candela 15:25-15:30, ordini alle 15:30). Il flat passa da 17:30 a 18:30 (InpCloseHour=18, InpCloseMin=30)
#  per tenere la stessa durata della sessione (3 ore dall'apertura). Tutto il resto = R277a/b.
#   - %(cella)s
#  FINESTRE: invernali = USA in ora solare E server fisso UTC+1. W1 2024.11.04-2025.03.07 (USA solare dal 3/11/2024; ora legale dal 9/3/2025),
#  W2 2025.11.03-2026.03.06 (solare dal 2/11/2025; legale dal 8/3/2026). Quattro file: W1/W2 x filtro ACCESO/SPENTO.
#  Con @FRAZIONEIS 0.001 la gamba IS e una scheggia: il CSV _IS puo essere VUOTO (rc 2 della riga, gia visto in R276b): si legge l'_OOS, che e
#  la finestra intera. Il per-trade e della gamba OOS.
# ==========================================================================
#  1. COSA SI LEGGE (CSV _OOS di ogni file: Profit, Profit Factor, Equity DD %%, Trades) e il cancello G1 (due gemelle identiche).
#  CRITERI CONGELATI (r279_giudizio.py, scritto prima di aprire gli zip), a livello di FINESTRA (W1 e W2 al posto di IS e OOS):
#   FILTRO UTILE d'inverno se e solo se, in W1 E in W2: PF_acceso - PF_spento >= 0,10 E DD_acceso <= 1,10 x DD_spento E Trades_acceso >= 0,40 x
#   Trades_spento. Altrimenti "NON DIMOSTRATO". Trades < 150 per gamba: nessun verdetto di merito (soglia S-N): e ATTESO che qui valga per tutte.
#   Confronto di ORIENTAMENTO con l'estate (R277, mesi allineati, solo OOS): PRE acceso 95 posizioni PF 1,48; PRE spento 184 posizioni PF 1,11.
#  ATTESE (dichiarate ORA, fiducia bassa: campioni piccoli, 4-5 mesi per finestra):
#   W1. G1 (gemelle identiche) in tutti e 4 i file: 90%%.
#   W2. Trades_acceso < 150 in W1 e in W2 (nessun verdetto di merito): 90%%.
#   W3. PF del file SPENTO fra 0,85 e 1,15 in entrambe le finestre: 55%%.
#   W4. PF_acceso > PF_spento (di qualsiasi margine) in entrambe le finestre: 60%%.
#   W5. FILTRO UTILE d'inverno (criterio sopra) in entrambe: 20%%.
#   W6. PF acceso, messe insieme W1 e W2 dal per-trade (esplorativo): maggiore di 1,0: 55%%.
#  LIMITI: otto mesi in tutto, due inverni, un solo percorso storico; il fatto che l'ora "giusta" sia 15:30 e un ragionamento sull'orologio, non una
#  misura sul tick; soglie 17-38 prese da una frase di Emiliano; non e la sedia 770260 ne' il preset vivo.
# ==========================================================================

'''
inv=[('R279a_inverno_W1_filtro_ON_NASDAQ_NASUSD.txt','R279a','R279a -- INVERNO W1, regola di Emiliano con apertura 15:30 server, FILTRO 17-38 ACCESO','2024.11.04 -> 2025.03.07','InpSessionHour=15, InpSessionMin=30, InpCloseHour=18, InpCloseMin=30; filtro 1700/3800',('2024.11.04','2025.03.07'),('798911','798961'),True),
     ('R279b_inverno_W1_filtro_OFF_NASDAQ_NASUSD.txt','R279b','R279b -- INVERNO W1, regola di Emiliano con apertura 15:30 server, FILTRO SPENTO (controllo)','2024.11.04 -> 2025.03.07','InpSessionHour=15, InpSessionMin=30, InpCloseHour=18, InpCloseMin=30; filtro spento',('2024.11.04','2025.03.07'),('798921','798971'),False),
     ('R279c_inverno_W2_filtro_ON_NASDAQ_NASUSD.txt','R279c','R279c -- INVERNO W2, regola di Emiliano con apertura 15:30 server, FILTRO 17-38 ACCESO','2025.11.03 -> 2026.03.06','InpSessionHour=15, InpSessionMin=30, InpCloseHour=18, InpCloseMin=30; filtro 1700/3800',('2025.11.03','2026.03.06'),('798931','798981'),True),
     ('R279d_inverno_W2_filtro_OFF_NASDAQ_NASUSD.txt','R279d','R279d -- INVERNO W2, regola di Emiliano con apertura 15:30 server, FILTRO SPENTO (controllo)','2025.11.03 -> 2026.03.06','InpSessionHour=15, InpSessionMin=30, InpCloseHour=18, InpCloseMin=30; filtro spento',('2025.11.03','2026.03.06'),('798941','798991'),False)]
for nome,tag,tit,win,cella,(d0,d1),m,on in inv:
    b=body
    b=sub(b,'@DAQUANDO 2024.09.26','@DAQUANDO %s'%d0); b=sub(b,'@FINOA    2026.06.30','@FINOA    %s'%d1); b=sub(b,'@FRAZIONEIS 0.40','@FRAZIONEIS 0.001')
    b=sub(b,'InpSessionHour=14||14||0||14||N','InpSessionHour=15||15||0||15||N')
    b=sub(b,'InpCloseHour=17||17||0||17||N','InpCloseHour=18||18||0||18||N')
    if not on:
        b=sub(b,'InpMinRangePts=1700||1700||0||1700||N','InpMinRangePts=0||0||0||0||N'); b=sub(b,'InpMaxRangePts=3800||3800||0||3800||N','InpMaxRangePts=0||0||0||0||N')
    b=sub(b,'InpMagic=798811||798811||50||798861||Y','InpMagic=%s||%s||50||%s||Y'%(m[0],m[0],m[1]))
    txt=HI%dict(titolo=tit,win=win,cella=cella,m1=m[0],m2=m[1])+b
    assert all(ord(c)<128 for c in txt),nome
    open(WT+nome,'w',encoding='ascii',newline='').write(txt); print(nome,len(txt))
