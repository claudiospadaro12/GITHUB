# 🔧 LE MANOPOLE INERTI — R223 (23/09/2026)

> **La domanda.** Claudio, dal cellulare: *«Troviamo parametri migliorativi x i nostri EA.»*
> Zero minuti macchina: si lavora sui CSV già in repo.
> **La miniera dichiarata**: le manopole che abbiamo girato *senza che mordessero* —
> spazio di ricerca pagato in tempo macchina e mai esplorato.
>
> 🛑 **SOLA LETTURA.** Nessun round lanciato, nessuna riga consegnata, niente VPS,
> nessun preset toccato, nessuna sedia accesa o spenta, nessuna taglia proposta.
> Conto reale `10105439` mai nominato in un comando.
> 🔴 Niente qui dentro è un verdetto: sono misure d'archivio. Dicono **dove** guardare.

---

# 0️⃣ 🎯 LE SEI RIGHE CHE CONTANO

1. 🟢 **LA NOTIZIA MIGLIORE È CHE IL DEFAULT VINCE, E L'HO MISURATO.** La famiglia di
   manopole che sembrava la più promettente — il **trailing** delle tre sedie d'apertura —
   era già stata misurata, e la configurazione **VIVA** (`InpTrailMode=1`, PREVBAR su M5)
   sta **in cima** a tutto ciò che l'archivio contiene. Sul Dow: PF **1,371** DD **5,32%**
   contro 1,247 del trailing ATR. Sul Nasdaq, sulla cella viva RETEST, il trailing fisso
   col valore del preset dà PF **0,658 IS / 0,804 OOS**. 👉 **Non c'è un round da fare lì:
   c'è una risposta, ed è «va bene così».** §4.1
2. 🥇 **L'UNICA CASELLA VUOTA CHE VALE DAVVERO HA UN NOME: l'INTERA FAMIGLIA D'USCITA
   DELLA SEDIA `770511` (SuperWave DOW H1), che sta operando la challenge ADESSO.**
   `InpTrailOnST` · `InpExitOnFlip` · `InpFirstFraction` · `InpUsePending` ·
   `InpPendingPips` · `InpPendingExpiryBars`: **zero CSV, zero file prova, zero misure**,
   e **tutte e sei accese nel preset vivo**. §4.2
3. 💰 **E il conto è già pronto: ci sono SETTE file prova su quella sedia, scritti, passati
   dai cancelli, e MAI LANCIATI.** Costano **56 passate ≈ 4,7 minuti** di tester in tutto.
   👉 **Non serve scrivere nulla di nuovo: serve lanciare quello che c'è.** §5
4. 🔴 **IL NUMERO DELLE «874» ERA UN PROXY, E VA CORRETTO IN DUE MODI.** Oggi il conto
   omologo è **924 CSV** (non 874) — ma quel numero **non misura** «manopole che non
   facevano niente»: misura CSV con esiti ripetuti. La misura vera, a livello di gruppo
   *ceteris paribus*, è **1.048 gruppi inerti su 43.671 vivi = 2,40%**. §2
5. 🔴 **IL «247» DEL CENSIMENTO DELL'11/09 È SBAGLIATO DUE VOLTE**: era già stato corretto
   in casa a 236 la notte stessa, e **oggi vale 221**. E il suo **ordinamento per valore
   non regge più**: le sue prime tre voci sono su sedie che **non stanno giocando la
   challenge**, partita il 21/09 — dieci giorni dopo quel referto. §1
6. ⚠️ **HO TROVATO DUE DIFETTI NEGLI STRUMENTI DI CASA, e uno avrebbe falsato questo
   stesso referto**: `manopole_inerti_v2.py` rigirato oggi legge **19.660 CSV invece di
   2.208** (8,9×, gli otto worktree degli agenti), e l'attribuzione via magic manda
   **8 CSV / 323 passate del Dow sotto il motore Nasdaq**. Tutti e due misurati, tutti e
   due dichiarati, e le classi sono scritte. §7

---

# 1️⃣ 🔍 LA VERIFICA CHE MI ERA CHIESTA PER PRIMA: le «247 manopole d'uscita mai provate»

**Il mandato diceva: verificarlo, non rifarlo.** Verificato, ed è **sbagliato due volte**.

## 1.1 Il numero

`report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` **lo corregge già da solo, in testa**,
nella sezione `0. ERRATA`: il `247` era un **limite superiore**, non una misura, perché
l'attribuzione `ea_of()` mancava 668 CSV su 2.087. Corretto quella notte a **236**.

Rigirato oggi lo strumento di casa (`python3 backtest_pipeline/censimento_uscite.py`,
23/09/2026, HEAD `740f6b88`):

| misura | 11/09 mattina | 11/09 notte | **oggi 23/09** |
|---|---:|---:|---:|
| CSV con colonne `Inp*` | 2.087 | 2.087 | **2.212** |
| coppie sedia × manopola d'uscita | 333 | 333 | **333** |
| mai mosse su quella sedia | ~~274~~ | 260 | **245** |
| di cui inerti per costruzione | 27 | 24 | **24** |
| **mai mosse E VIVE** | ~~**247**~~ | 236 | **221** |
| mai mosse in TUTTO l'archivio (coppie) | 65 | 66 | **41** |
| passate per metterle tutte ad asse | ~~2.436~~ | 2.326 | **2.144** |

👉 **Il `247` non va citato più. Il numero di oggi è `221`.**
*(Il JSON committato `CENSIMENTO_USCITE_2026-09-11.json` l'ho rigenerato per leggerlo e
**rimesso a posto con `git checkout`**: è datato 11/09 e sovrascriverlo con dati del 23/09
avrebbe falsato la sua data. Classe 378.)*

## 1.2 L'ordinamento — **e questo è il difetto che conta di più**

Quel referto ordinava le caselle «per valore/costo», e le sue prime tre erano:
`970913` SupRev NAS H1 · `970901` STREV oro · `772361` COST EURJPY.

🔴 **Nessuna delle tre è fra le sei sedie che stanno operando la challenge FTMO**
(`541452707`, viva dal **21/09**, dieci giorni dopo quel referto):
`770101` · `770202` · `770260` · `770411` · `770511` · `771531`
(fonte: `report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` §1.2).

👉 **Non è che quel referto avesse torto: è che il valore si misura contro l'obiettivo, e
l'obiettivo è cambiato il 21/09.** Questo dossier riordina le caselle sulle **sei sedie
vive**, ed è l'unica differenza sostanziale rispetto all'11/09.

---

# 2️⃣ 📐 IL CONTRO-ESEMPIO, PRIMA DEI NUMERI: inerte ≠ altopiano

**Sono due cose opposte che producono lo stesso sospetto.** La soglia la dichiaro **qui,
prima di applicarla**, e poi mostro un caso di ciascun tipo trovato nei dati veri.

## 2.1 Le tre classi, dichiarate

Unità di confronto: il **gruppo *ceteris paribus*** = tutte le passate di un CSV che
differiscono **solo** per la manopola in esame. Gruppo **vivo** = almeno una passata con
**≥ 30 operazioni** (un motore muto dà esiti identici perché non c'è niente da misurare).

| classe | definizione numerica | che cosa vuol dire |
|---|---|---|
| **INERTE** | `Profit`, `Profit Factor`, `Trades`, `Equity DD %` **uguali all'arrotondamento alla 5ª cifra decimale** | la manopola **non è arrivata al motore** |
| **ALTOPIANO / influenza debole** | esiti **diversi**, ma `ΔTrades = 0` **e** `ΔPF ≤ 0,05` **e** `ΔDD ≤ 0,50 punti percentuali` | la manopola **è arrivata**, il motore non è sensibile lì |
| **MORDE** | tutto il resto | la manopola fa qualcosa di misurabile |

🔴 **Il terzo criterio (`ΔDD`) è MIO, ed è la correzione più importante che porto:** la
versione del 12/09 guardava solo PF e Trades. §7.1 mostra il caso reale in cui quella
metrica chiama «debole» una manopola che **dimezza il drawdown**.

## 2.2 🅰️ Caso INERTE, dai dati veri

`backtest_pipeline/risultati_archivio/Aperture_Trailing/NASDAQ_trailing.csv` —
`InpTrailFixedPts` con `InpTrailMode=1`, **8 passate, 1 solo esito**:

```
InpTrailFixedPts=100..800 (8 valori)  InpTrailMode=1
   profit -496,89   PF 0,95483   n 260   DD 19,2693      <- TUTTE E OTTO, cifra per cifra
```

## 2.3 🅱️ Caso MORDE, **stesso file-famiglia, stessa manopola, cambia solo la chiave**

`backtest_pipeline/risultati_archivio/DAX_Apertura/apert_DAX_M5_brk_realtick_D30EUR.csv` —
stesso `InpTrailFixedPts`, ma con `InpTrailMode=2`:

```
InpTrailFixedPts=100  InpTrailMode=2   profit -18354,63  PF 0,47954  n 441  DD 19,5744
InpTrailFixedPts=200  InpTrailMode=2   profit -17979,17  PF 0,58531  n 442  DD 18,9871
InpTrailFixedPts=400  InpTrailMode=2   profit -19535,38  PF 0,64858  n 451  DD 21,4258
InpTrailFixedPts=800  InpTrailMode=2   profit  -8263,22  PF 0,89424  n 495  DD 15,9407
                                       ΔPF = 0,41470     ΔTrades = 54
```

🟢 **La prova che la misura separa davvero le due cose:** l'unica differenza fra 🅰️ e 🅱️ è
`InpTrailMode`. Non è il motore a essere insensibile: è **la manopola che non arriva**.

## 2.4 🅲 Caso ALTOPIANO vero

`backtest_pipeline/risultati_prove/R200E/..._NASUSD_IS_R200E.csv` — coda della scala:

```
InpTrailFixedPts=14410  PF 1,02974  n 82  DD 20,0669
InpTrailFixedPts=16410  PF 1,02355  n 82  DD 20,0580
InpTrailFixedPts=18410  PF 1,04670  n 82  DD 20,0580
```

Diversi (il profit cambia di migliaia), `ΔTrades = 0`, `ΔPF = 0,023`, `ΔDD = 0,009 pp`:
**la manopola arriva, il motore lì è piatto.** È l'opposto di 🅰️, e i numeri lo dicono.

## 2.5 🅳 E il **controllo positivo**, che è la parte che di solito manca

Se la metrica del `ΔDD` funziona, deve ritrovare **da sola** la manopola di cui già
sappiamo la risposta: quella del **rischio**. La ritrova, in cima alla lista:

```
InpRiskPercent  (NASDAQ_G_rischio_FULL.csv)   ΔPF 0,00504   ΔTrades 0   DD 13,1146 -> 24,4956
InpRiskPercent  (DAX_G_rischio_FULL.csv)      ΔPF 0,00650   ΔTrades 0   DD 10,4866 -> 20,3981
```

**Raddoppiare la taglia raddoppia il DD e lascia il PF fermo** — è esattamente quello che
deve succedere. 🟢 **La metrica non è tarata su ciò che volevo trovare: ritrova per prima
la cosa che sapevamo già.**
*(🔴 `InpRiskPercent` è **firma di Claudio**: compare qui come controllo della misura, e
non entra in nessuna proposta.)*

---

# 3️⃣ 🔢 I NUMERI RIFATTI OGGI — e il «874» corretto

Strumento: `backtest_pipeline/manopole_inerti_v2.py`, rigirato oggi **con l'esclusione dei
worktree** (§7.2), su tutto il repo, HEAD `740f6b88`.

| misura | 09/09 (v1) | 12/09 (v2) | **oggi 23/09 (R223)** |
|---|---:|---:|---:|
| CSV di risultati letti | 2.069 | 2.083 | **2.208** |
| attribuiti a un EA | *(non lo faceva)* | 1.990 | **2.115** (93 non attribuibili, dichiarati) |
| passate di tester | 61.633 | 61.829 | **62.367** |
| passate con `Trades > 0` | 45.865 | 46.061 | **46.588** |
| **CSV con esiti duplicati fra le passate vive** | **874** | 881 | 🔴 **924** |
| passate vive senza esito nuovo | *(n.d.)* | 6.006 | **6.061** |

## 3.1 🔴 Perché «874 corse hanno girato con una manopola che non faceva niente» è una frase da correggere

Sono **tre** imprecisioni, e vanno separate perché portano a decisioni diverse:

1. **Non sono «corse»: sono CSV.** 924 **file** contengono almeno due passate vive con lo
   stesso esito. Le passate coinvolte sono **6.061**, su 46.588 vive (**13,0%**).
2. **«Esito ripetuto» non vuol dire «manopola inerte».** Due celle diverse possono dare lo
   stesso esito perché il filtro che le separa non tocca nessuna barra in quella finestra
   — e questo **è** un'informazione, non uno spreco.
3. **Una grossa fetta è l'asse tecnico, ed è VOLUTA.** Dei **1.862** gruppi identici,
   **814 sono su `InpMagic`**: è il **cancello G1 di determinismo**, che deve dare esiti
   identici. Contarlo come spreco è un errore di segno.

## 3.2 ✅ Il numero onesto

| misura (gruppi *ceteris paribus* vivi, `InpMagic` escluso) | valore |
|---|---:|
| gruppi vivi confrontati | **43.671** |
| **INERTI (identici cifra per cifra)** | **1.048 — 2,40%** |
| ALTOPIANO / influenza debole | 2.089 |
| MORDONO | 40.534 |

**Sulle sole sei sedie vive** (19.776 gruppi confrontati): **756 inerti · 340 altopiano ·
145 «PF piatto ma DD che si muove oltre 0,50 pp» · 18.535 che mordono.**

👉 **La correzione da mettere a verbale: «874 su 1.960» → il proxy di oggi è `924 CSV`, la
misura vera è `1.048 gruppi su 43.671 = 2,40%`, e `814` gruppi identici in più sono il
cancello di determinismo che funziona.**

---

# 4️⃣ 🏆 LA CLASSIFICA DELLE CASELLE VUOTE, PER VALORE

**Ordine = quanto avvicina una sedia schierabile**, non numerosità.
Costo in passate a **5,0 s/passata** a tick reali (calibrazione di casa, R88a: 96 passate
in 8,0 min; forbice dichiarata **2,9-33,0 s** — `report/MANOPOLE_INERTI_v2_2026-09-12.md` §4).

## 4.0 📊 Quanto è esplorata ogni sedia viva — la tavola che ordina tutto

| sedia | EA | `input` totali | **mai ad asse su QUESTO EA** | **mai ad asse in NESSUN CSV** |
|---|---|---:|---:|---:|
| `770101` | `ABTG_DAX_Apertura_EU` | 91 | 62 | **50** |
| `770202` | `ABTG_Dow_Apertura_US` | 81 | 70 → **63** ⚠️ | **41** |
| `770260` | `ABTG_Nasdaq_Apertura_US` | 98 | 63 | **56** |
| `770411` | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | 52 | **50** | **36** |
| `770511` | `ABTG_SuperWave_DOW_H1_Ottimizzato` | 45 | **40** | **30** |
| `771531` | `ABTG_EMA200` | 44 | 32 | **30** |

⚠️ Il Dow: 11 manopole ad asse secondo l'attribuzione, **18** dopo aver rimesso al Dow i
suoi 8 CSV finiti sotto il Nasdaq (§7.3). Resta **la meno esplorata delle tre aperture**
(18 contro 29 del DAX e 35 del Nasdaq).

---

## 4.1 🟢 #0 — LA CASELLA CHE SI CHIUDE SENZA LANCIARE NIENTE: il trailing delle aperture

**Era la mia candidata numero 1. L'archivio l'ha già risolta, e la risposta è: il default
va bene.** La scrivo per prima perché **un round non fatto vale quanto un round fatto**.

**Il sospetto era buono.** Nel round di gestione del 09/09 su Nasdaq
(`risultati_prove/gestione_20260909/gestione_ABTG_Nasdaq_Apertura_US_NASUSD_gestione.csv`,
48 passate) il **drawdown è governato da `InpTrailMode`** con il PF quasi fermo:

| `InpTrailMode` | DD misurato | PF |
|---|---:|---:|
| `2` FIXED | **7,16 – 7,17 %** | 0,943 – 0,945 |
| `1` PREVBAR ← **valore VIVO** | 16,87 – 17,65 % | 0,951 – 0,993 |
| `0` ATR | 24,07 – 32,09 % | 0,882 – 0,946 |

**ΔDD = 23,15 punti percentuali a ΔPF = 0,042.** Su una challenge con il muro statico al
10%, sembra l'oro.

🔴 **E invece no, per due misure che erano già in archivio.**

**(a) Quel round gira su una cella che NON è la sedia viva.** Ha
`InpEntryMode=0` (BREAKOUT) e `InpRangeMode=2`; la `770260` viva è la **RETEST**
(`InpEntryMode=2`, `InpTP1_R=0.5`). E **tutte e 48** le celle hanno **PF < 1,00**: su
quella configurazione il motore non ha edge, quindi per la regola del 19/08 lì non si
allarga niente.

**(b) Sulla cella VIVA la domanda è già stata fatta, il 21/09, e si chiama R200E.**
`risultati_prove/R200E/` — `InpTrailMode=2`, `InpEntryMode=2`, `InpTP1_R=0.5`, n 82/102,
tick reali, deposito 80.000, asse su `InpTrailFixedPts`:

```
InpTrailFixedPts=  410  <- IL VALORE DEL PRESET VIVO   PF IS 0,65823 / OOS 0,80365
InpTrailFixedPts= 6410                                 PF IS 1,14559 / OOS 0,99451
InpTrailFixedPts=10410                                 PF IS 1,09440 / OOS 1,06050
contro la sedia VIVA (InpTrailMode=1, PREVBAR):        PF IS 1,22116 / OOS 1,21546
```

👉 **Il trailing fisso non batte il PREVBAR vivo su nessuna cella misurata**, e col valore
che sta nel preset **lo distrugge**.

**(c) E sul Dow la stessa risposta, da un file di sei mesi fa.**
`risultati_archivio/Dow_Apertura/dow_trailing.csv`, 30 passate, n=329:

```
InpTrailMode=1  InpTrailTF=5 (M5) <- LA CONFIGURAZIONE VIVA   PF 1,37075  DD 5,3161   <- IL MASSIMO DEL FILE
InpTrailMode=1  InpTrailTF=2                                  PF 1,33695  DD 5,5622
InpTrailMode=0  (ATR)                                         PF 1,24670  DD 8,2207
```

🟢 **VERDETTO: `InpTrailMode` sulle tre sedie d'apertura è una casella CHIUSA, e la cella
viva è la migliore misurata. Costo del round da fare: ZERO passate.**
*(E lo dico contro il mio stesso interesse: era la voce più vistosa del censimento.)*

### 🔴 Ma da qui esce un AVVISO che vale più del round

`InpTrailFixedPts=410` e `InpTrailAtrMult=2.0` stanno **in tutti e tre** i preset vivi
delle aperture (`770101`, `770202`, `770260`) e sono **inerti** perché `InpTrailMode=1`.
Sono **numeri morti che sembrano vivi** — e il `410` è, per commento del sorgente,
*«piano DAX: 410 punti»*: un numero del DAX copiato su Nasdaq e Dow.

👉 **Chiunque domani accendesse `InpTrailMode=2` «perché il DD scende» accenderebbe insieme
un numero mai tarato, e R200E dice che il risultato è PF 0,66.** È la classe **620**.

---

## 4.2 🥇 #1 — **LA FAMIGLIA D'USCITA DELLA `770511` (SuperWave DOW H1): SEI MANOPOLE ACCESE IN CAMPO E MAI MISURATE**

🔴 **È la casella vuota più preziosa del repo, e non è nemmeno contesa.**

| manopola | valore nel preset VIVO | causa dell'assenza | CSV in archivio | file prova |
|---|---|---|---:|---|
| `InpTrailOnST` | `true` | **mai ad asse** | **0** | 0 *(l'unico esiste su un ALTRO EA)* |
| `InpExitOnFlip` | `true` | **mai ad asse** | **0** | 0 *(idem)* |
| `InpFirstFraction` | `0.3333` | **mai ad asse** | **0** | 0 *(idem)* |
| `InpUsePending` | `true` | **mai ad asse** | **0** | 0 |
| `InpPendingPips` | `20.0` | **mai ad asse** | **0** | 0 |
| `InpPendingExpiryBars` | `3` | **mai ad asse** | **0** | 0 |

*(Preset letto riga per riga: `mql5/Presets/FTMO/ABTG_SuperWave_DOW_H1_770511_FTMO.set`.)*

⚠️ **Il contro-esempio che ho dovuto costruire e che per poco non mi frega**: `grep`
trovava `InpTrailOnST` come asse in `backtest_pipeline/prove/A1_SUPREV_DOW_H1_01_trailonst.txt`,
e `InpExitOnFlip` in `..._02_exitonflip.txt`. **Sono di un EA DIVERSO**:
`ABTG_SupRev_DOW_H1_Ottimizzato` (Supertrend **Reversal**), non `SuperWave`. Stessi nomi
di manopola, motore diverso. **Senza aprire l'intestazione `# EA:` avrei scritto «già
provata» su una casella vuota.**

### 🔴 E la manopola che regge tutto il resto

`ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.428:
```
if(InpTrailOnST && SupertrendSeries(3,dir,line)){ stLine=NormalizePrice(line[1]); haveST=true; }
```
e il blocco di trailing a r.467 gira **solo** `if(haveST)`.
👉 **`InpTrailOnST` non è «un tipo di trailing»: è l'UNICO trailing che quella sedia ha.**
Spento, la posizione resta senza trailing. **E non è mai stato misurato né acceso né spento.**

### La domanda che resta aperta
> **Il Supertrend che segue lo stop, e l'uscita sul giro del Supertrend, stanno aiutando
> o stanno tagliando i trade buoni?** Oggi non lo sa nessuno, e quella sedia sta operando
> una challenge da 80.000 €.

### Il costo
**`InpExitOnFlip` 2 celle × 2 finestre = 4 passate (~20 s)** ·
**`InpTrailOnST` 4 passate (~20 s)** · **`InpFirstFraction` 3 celle = 6 passate (~30 s)**.
🔴 **Ma i file prova vanno scritti**, e va tenuto conto che `InpTrailOnST=false` toglie
**tutto** il trailing: è un asse di **rischio**, leggibile a qualunque `n`
(Emendamento B), non un asse di merito.

---

## 4.3 🥈 #2 — **LO SCAFFALE GIÀ PRONTO CHE NESSUNO HA LANCIATO: 7 file prova sulla stessa sedia `770511`**

**Non è una casella vuota: è una casella già imbustata e mai spedita.**
Cercati nei risultati per etichetta: **zero CSV per tutti e sette**.

| file prova (`backtest_pipeline/prove/`) | asse | celle | passate | costo @5,0 s |
|---|---|---:|---:|---:|
| `R173c_breakeven_superwave_U30USD.txt` | `InpBreakeven` 0/1 | 2 | 4 | 20 s |
| `R173a_tp1pct_superwave_U30USD.txt` | `InpTP1Pct` 0→75 p.25 | 4 | 8 | 40 s |
| `R173b_tp1r_superwave_U30USD.txt` | `InpTP1_R` 0,5→2,0 p.0,5 | 4 | 8 | 40 s |
| `R155a_tprr_SuperWaveDowH1_U30USD.txt` | `InpTP_RR` 2,0→4,0 p.0,5 | 5 | 10 | 50 s |
| `R191b_tprr_SUPERWAVEDOW_U30USD.txt` | `InpTP_RR` 1,5→6,0 p.0,75 | 7 | 14 | 70 s |
| `R165a_slbufferpips_superwave_U30USD.txt` | `InpSLBufferPips` 3→5003 p.1000 | 6 | 12 | 60 s |
| `R190b_tfM30_SUPERWAVEDOW_U30USD.txt` | `InpTF` M30 | enum | `[NON MISURATO]` | — |
| **TOTALE (i sei con celle certe)** | | **28** | **56** | **≈ 4,7 min** |

🟢 **L'intero scaffale d'uscita della sedia costa meno di cinque minuti di tester.**
🔴 **E va detto che è tempo già PAGATO in ore di scrittura: quei file portano dentro
l'attesa dichiarata, le soglie congelate e il contro-esempio. Buttarli sarebbe lo spreco
vero.**
⚠️ **Ancore da riverificare prima del lancio**: R173a/b/c dichiarano `-Deposito 100000`,
mentre la challenge gira a **80.000**. Il confronto **interno fra le celle** resta valido
(stesso banco per tutte), il **DD assoluto no**. Va dichiarato, non corretto a memoria.

---

## 4.4 🥉 #3 — `770411` MaxMinNotte: **la sedia dove l'inerzia NON È MISURABILE**, e questo è il referto

| misura | valore |
|---|---:|
| CSV in archivio con `InpMagic` di quella famiglia | 18 |
| manopole mai ad asse su questo EA | **50 su 52** |
| **gruppi *ceteris paribus* VIVI (≥30 operazioni)** | 🔴 **0** |

🔴 **Zero.** In tutto l'archivio non esiste un solo confronto su quella sedia che arrivi a
30 operazioni: il contratto vivo parla di **14 posizioni OOS** (21 deal) e di un `n` IS
**`[NON MISURATO]`**. 👉 **Su `770411` la domanda «quale manopola è inerte?» non ha una
risposta misurabile oggi**, e la risposta onesta è **NON ANCORA MISURATO** — non «tutto da
provare» e non «tutto provato».

**Mai ad asse e mai in nessun CSV, per nome**: `InpMaxBoxPts` · `InpSLFixedPts` ·
`InpBreakeven` · `InpTP2Pct` · `InpUseEMA200Target` · `InpEMA200Period` · `InpTPfinal_R` ·
`InpBoxStartHour/Min` · `InpBoxEndHour/Min` · `InpPlaceHour/Min` ·
`InpEntryCutoffHour/Min` · `InpCloseHour/Min` · `InpCloseAtEnd` · `InpOneTradePerDay` ·
`InpAtrPeriod` *(+ i blocchi `InpCorr*` e `InpNews*`, spenti nel preset vivo)*.

🟢 **Esiste già un file prova per la manopola giusta**:
`backtest_pipeline/prove/R214g_mgmttf_MAXMINDAX_D30EUR.txt` (asse su `InpMgmtTF`), **mai
lanciato**. Ed è la manopola giusta per la ragione del §6.2: **il TF del grafico su quella
sedia non fa niente, `InpMgmtTF` sì.**

---

## 4.5 #4 — `770202` Dow: la meno esplorata delle tre aperture

**18 manopole ad asse su 81 input.** Ma **prima di proporre un round serve una misura che
non c'è**: i suoi CSV storici (`Dow_Apertura/`, magic `770201`) sono attribuiti al motore
Nasdaq (§7.3), quindi **il registro di ciò che il Dow ha davvero provato è sporco**.

👉 **Verdetto: NON ANCORA MISURATO, e quello che manca è l'ATTRIBUZIONE, non una passata.**
Costo per chiuderla: **zero tempo macchina** — è una riparazione di `ea_of()`.

---

## 4.6 #5 — `InpLevelTF`: mai ad asse in **0 CSV su 2.208**, ancora oggi

Confermato oggi: la colonna `InpLevelTF` **non prende due valori in nessun CSV del repo**.
Il file prova esiste (`backtest_pipeline/prove/R133a_livelliTF_NASUSD.txt`, 7 celle, 14
passate, ~1,2 min) ed è **mai stato lanciato**.

⚠️ **Ma il suo bersaglio non esiste più come allora**: R133a fu scritto per la `770250`
(NASUSD **M15**, sul piccolo). La sedia Nasdaq della challenge è la **`770260`** RETEST su
**M5**, e `InpLevelTF` morde solo con `InpRangeMode=2` (PREVBAR), che nel preset vivo
`770260` **va verificato prima di spendere una passata**.
👉 **Verdetto: casella aperta, ma il file prova va RILETTO sul bersaglio nuovo, non
lanciato com'è.**

---

## 4.7 ⛔ Le caselle che NON si aprono, col numero accanto

| casella | perché no |
|---|---|
| parametri d'ingresso del ramo **FADE** delle aperture | PF **0,715** / **0,720** (n 419/430) su DAX e **0,806** (n 324) su US: motore senza edge, regola del 19/08 |
| parametri d'ingresso `doc_delay` | PF **0,707** (n 139) e **0,733** (n 87) |
| `InpMinStopPts` / `InpSkipIfTight` su `ABTG_DAX_Live5m_v2` | PF **0,922** su n=445 a tick reali, e **non è una sedia viva**. Resta leggibile solo come misura di RISCHIO |
| griglia d'ingresso sulla cella `gestione_20260909` del Nasdaq | **48 celle su 48 con PF < 1,00** |

---

# 5️⃣ 🧾 PERCHÉ NON CONSEGNO FILE PROVA NUOVI

**Ci sono già nove file prova scritti, passati dai cancelli e mai lanciati** solo sulla
famiglia SuperWave, più `R133a`, `R214g` e `R147a`. Aggiungerne altri allo stesso scaffale
non avvicina nessuna sedia: **sposta il collo di bottiglia dove già sta.**

👉 **Quello che serve a Claudio non è un file in più: è la decisione di lanciare i 56
passate (≈ 4,7 minuti) che sono già pronti.** E quella decisione è sua, insieme alla
scelta della macchina — 🔴 e per la firma del **21/09** i round **non girano più sul VPS**
finché la challenge è viva, ma **sul PC di backtest**.

---

# 6️⃣ 🧱 LE MANOPOLE **STRUTTURALMENTE INERTI**, PER NOME E CON LA RIGA

> **Questa è la sezione che esiste perché nessuno ci riprovi.** Sono passate che qualcuno
> spenderà due volte se non le scriviamo.

## 6.1 Le catene: la manopola c'è, ma un'altra la tiene spenta

| # | EA | manopola | riga del sorgente | la chiave che la apre | causa |
|---|---|---|---|---|---|
| 1 | `ABTG_Dow_Apertura_US` *(e i due cloni)* | `InpTrailFixedPts` | r.1837 / r.1850 — `if(InpTrailMode == ABTG_TRAIL_FIXED) return(bid - InpTrailFixedPts*_Point);` | `InpTrailMode = 2` | **no-op per valore** |
| 2 | `ABTG_Dow_Apertura_US` *(e i due cloni)* | `InpTrailAtrMult` | r.1839 / r.1852 — ramo di caduta, raggiunto solo con `InpTrailMode = 0` | `InpTrailMode = 0` | **no-op per valore** |
| 3 | tutti e tre i cloni Apertura | `InpTrailMode`, `InpTrailTF`, `InpTrailStartR` **e** i due qui sopra | l'intero blocco sta sotto `InpUseTrailing` | `InpUseTrailing = 1` | **irraggiungibile per struttura** |
| 4 | `ABTG_Nasdaq_Apertura_US` *(e i due cloni)* | `InpBreakevenAtTP1` | r.2195, **dentro** il cancello esterno `InpTP1_ClosePct > 0 && < 100` | `InpTP1_ClosePct` fra 1 e 99 | **irraggiungibile per struttura** *(classe 594)* |
| 5 | `ABTG_SuperWave_DOW_H1_Ottimizzato` | `InpBreakeven` | r.460, dentro `if(!beDone && risk>0 && InpTP1_R>0 && InpTP1Pct>0 && InpTP1Pct<100)` r.447 | `InpTP1_R > 0` **e** `0 < InpTP1Pct < 100` | **irraggiungibile per struttura** |
| 6 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | `InpBreakeven` | r.327, dentro lo stesso cancello a r.310 | idem | **irraggiungibile per struttura** |
| 7 | `ABTG_EMA200` | `InpBreakeven` | r.429, dentro `if(!beDone && InpTP1Pct>0 && InpTP1Pct<100)` r.410 | `0 < InpTP1Pct < 100` | **irraggiungibile per struttura** |
| 8 | `ABTG_DAX_Live5m_v2` | `InpSkipIfTight` | r.681, annidata dentro `if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)` r.678 | `InpMinStopPts > 0` **e** stop davvero stretto | **irraggiungibile per struttura** |
| 9 | `ABTG_ORB_Ottimizzato` | `InpUseVolumeFilter` | `VolumeOK()` r.533 chiamata solo da `TryCloseConfirmEntry()` r.573 | `InpUseCloseConfirm = 1` | **irraggiungibile per struttura** |

### 🅰️ La catena #4 e la #3, **visibili nei dati veri** — stesso file, `gestione_20260909` Nasdaq

```
# la #3 : con InpUseTrailing=0, i TRE valori di InpTrailMode danno lo STESSO esito
ClosePct=50 BEatR=0 UseTrailing=0 TrailMode=0   PF 0,89422  n 543  DD 38,0188
ClosePct=50 BEatR=0 UseTrailing=0 TrailMode=1   PF 0,89422  n 543  DD 38,0188
ClosePct=50 BEatR=0 UseTrailing=0 TrailMode=2   PF 0,89422  n 543  DD 38,0188

# la #4 : con InpTP1_ClosePct=0, InpBreakevenAtTP1 e' un NO-OP
ClosePct=0 BreakevenAtTP1=0 BEatR=1 UseTrailing=0 TrailMode=0   PF 0,96202  n 370  DD 30,1450
ClosePct=0 BreakevenAtTP1=1 BEatR=1 UseTrailing=0 TrailMode=0   PF 0,96202  n 370  DD 30,1450
```

🟢 **E il contro-esempio obbligatorio: nel preset VIVO nessuna delle catene 4-7 è chiusa.**
Letti uno per uno i sei `.set` di `mql5/Presets/FTMO/`: `InpTP1_ClosePct=50` (le tre
aperture), `InpTP1Pct=50` (`770411`, `770511`, `771531`). **Il breakeven in campo è
raggiungibile su tutte e sei.**
👉 **L'allarme «una protezione inerte in campo» sarebbe stato FALSO, e l'ho verificato
prima di scriverlo, non dopo.**

⚠️ **Un caso di confine che ho controllato apposta**: su `771531` il preset porta
`InpTP1_ATRmult=0.0`, e a r.411-414 con quel valore il bersaglio **non** va a zero: ripiega
sull'EMA14, che a r.395 è calcolata **sempre**, indipendentemente da `InpUseEma14Bias`.
**Catena aperta anche lì.** *(`771531` e `770101` sono il tema di un altro agente su R222:
qui la misura resta strutturale e non tocca quel lavoro.)*

## 6.2 🚫 Le manopole **STRUTTURALMENTE INERTI PER SEMPRE**: il TF del grafico

> **Nessuna chiave le apre. Girare passate su questo asse è tempo buttato.**
> Misurato contando le occorrenze di `_Period` e `PERIOD_CURRENT` nei sorgenti.

| EA | `_Period` | `PERIOD_CURRENT` | che cosa legge davvero il TF | verdetto sull'asse «TF del grafico» |
|---|---:|---:|---|---|
| `ABTG_Nightly` | **0** | **0** | `PERIOD_M1` fisso (r.183-193), `PERIOD_H1` fisso (r.120) | 🔴 **INERTE. Non esiste nessun input di TF.** |
| `ABTG_MaxMinNotte` | **0** | **0** | idem | 🔴 **INERTE** |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` *(sedia `770411`, in campo su M15)* | **0** | **0** | box da `PERIOD_M1` fisso (r.207-217); la gestione da **`InpMgmtTF`** (r.76) | 🔴 **INERTE. La manopola vera è `InpMgmtTF`.** |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` *(sedia `770511`)* | **0** | **0** | tutto da **`InpTF`** (r.52, r.259-263) | 🔴 **INERTE. La manopola vera è `InpTF`.** |
| `ABTG_EMA200` *(sedia `771531`)* | **0** | **0** | tutto da **`InpTF`** (r.49) | 🔴 **INERTE. La manopola vera è `InpTF`.** |
| `ABTG_Dow_Apertura_US` · `ABTG_Nasdaq_Apertura_US` · `ABTG_DAX_Apertura_EU` | 0 | **5 / 7 / 5** | ATR di gestione r.396, `VolumeOK()` r.2091, e r.1207 `octf = (InpOCTimeframe==PERIOD_CURRENT) ? Period() : InpOCTimeframe` | 🟠 **PARZIALE: il segnale è a orario, ma gestione e filtro volumi seguono il grafico** |

### 🧪 Il contro-esempio, perché «inerte» qui ha un confine preciso
**«Il TF del grafico non fa niente» è vero per il CODICE, non per il BANCO.** Nel tester il
TF del grafico governa anche la generazione dei tick: con **Modello 0** (solo prezzi
d'apertura) cambiare TF cambia il risultato **anche** su questi EA. L'affermazione vale
**per Modello 4 (tick reali) e Modello 1 (OHLC M1)**, che è quello che usiamo.
👉 **Scritta senza questo confine, la riga sarebbe falsa.**

### 👉 La conseguenza operativa, ed è la casella del CERTIFICATO DI MORTE
La voce *«il TF è stato cambiato almeno una volta»* per `ABTG_Nightly`, `ABTG_MaxMinNotte`,
`ABTG_SuperWave` e `ABTG_EMA200` **non si chiude cambiando il grafico**: si chiude solo
muovendo `InpTF` / `InpMgmtTF`. 🔴 **Se qualcuno l'ha segnata chiusa perché un round girava
su un TF diverso, quella casella è ancora APERTA.**

---

# 7️⃣ ⚠️ I TRE DIFETTI TROVATI PER STRADA — e uno avrebbe falsato questo referto

## 7.1 🔴 La metrica d'influenza che ignora il drawdown

**Il caso reale**, `risultati_archivio/Aperture_Trailing/DAX_trailing.csv`:

```
InpUseTrailing=0   profit -1031,93  PF 0,96145  n 440  DD 38,9586
InpUseTrailing=1   profit  -589,23  PF 0,94686  n 440  DD 18,8542
```

`ΔTrades = 0`, `ΔPF = 0,0146` → la metrica del 12/09 la classifica **«influenza debole =
conta come provata»**. 🔴 **Ma il drawdown si DIMEZZA: 38,96 % → 18,85 %.**
Per l'Emendamento B (il rischio si legge a qualunque `n`), è esattamente la dimensione che
conta di più — e con un muro FTMO al 10% è la differenza fra una sedia e un incidente.

**Misurato l'effetto della correzione**: sulle sei sedie vive, aggiungendo `ΔDD ≤ 0,50 pp`
alla definizione, **145 gruppi** escono da «debole» ed entrano in «morde». Sono **145
caselle che il censimento precedente dava per chiuse.**
Classe **619**.

*(Le prime della lista: `InpTrailMode` 23,15 pp · `InpUseTrailing` 20,82 pp ·
`InpOrder2Atr` 4,69 pp · `InpTP_RR` 2,03 pp.)*

## 7.2 🔴 La classe 378 riparata in un file e non nei fratelli

Rigirando `backtest_pipeline/manopole_inerti_v2.py` **così com'è**, oggi:

```
csv di risultati letti: 19660     <- NON e' una misura: e' 8,9x
passate totali:        560227
CSV con esiti duplicati:  8308
```

Con l'esclusione di `.claude/worktrees` (una riga):

```
csv di risultati letti:  2208
passate totali:         62367
CSV con esiti duplicati:  924
```

**19.212 dei 21.648 CSV del disco sono copie dentro gli 8 worktree degli agenti.**
La **classe 378** (16/09) descrive esattamente questo difetto — e fu riparata **solo** in
`censimento_uscite.py`. Verificato oggi, riga per riga:

| script | esclude `.claude/worktrees`? |
|---|---|
| `backtest_pipeline/censimento_uscite.py` r.187 | 🟢 **sì** |
| `backtest_pipeline/manopole_inerti_v2.py` r.129 | 🔴 **no** |
| `backtest_pipeline/manopole_inerti.py` | 🔴 **no** |
| `backtest_pipeline/censimento_pf.py` | 🔴 **no** |
| `backtest_pipeline/censimento_entrymode.py` | 🔴 **no** |

🔴 **Non ho toccato quei quattro file**: sono strumenti condivisi e una modifica in corsa
mentre altri agenti lavorano è un rischio che non vale la riga. La riparazione è **una
riga per file** e va fatta da chi li possiede. Classe **621**.
*(Il mio referto usa una copia corretta nello scratchpad, dichiarata qui.)*

## 7.3 🔴 L'attribuzione via magic contro i motori CLONI

`ea_of()` mappa il magic `770201` → `ABTG_Nasdaq_Apertura_US`. Ma **lo stesso magic
`770201` sta anche nei CSV del Dow**:

| CSV | passate | attribuito a | percorso dice |
|---|---:|---|---|
| `risultati_archivio/Dow_Apertura/dow_distanze.csv` | 48 | Nasdaq | Dow |
| `risultati_archivio/Dow_Apertura/dow_motore.csv` | 12 | Nasdaq | Dow |
| `risultati_archivio/Dow_Apertura/dow_robustezza.csv` | 10 | Nasdaq | Dow |
| `risultati_archivio/Dow_Apertura/dow_trailing.csv` | 30 | Nasdaq | Dow |
| `risultati_archivio/Dow_Apertura/dow_trailing2.csv` | 6 | Nasdaq | Dow |
| `risultati_archivio/Dow_Apertura/dow_walkforward_IS.csv` | 40 | Nasdaq | Dow |
| `risultati_archivio/Dow_Apertura/dow_walkforward_OOS.csv` | 40 | Nasdaq | Dow |
| `risultati_prove/apert_fade_realtick/apert_APERT_US_M5_fade_realtick_U30USD.csv` | 137 | Nasdaq | US generico |
| **totale** | **323** | | |

🔴 **E `dow_motore.csv` è il file che un altro referto di oggi cita come fonte dei numeri
del filtro EMA della `770202`** (`IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` §5): quel file
esiste e i suoi numeri sono buoni — è **l'attribuzione automatica** a sbagliare motore.

**Perché succede**: le tre aperture sono **cloni** con firma di colonne sovrapposta, quindi
la VIA 3 (firma) non le separa; e la VIA 1 (nome nel percorso) non scatta perché la
cartella si chiama `Dow_Apertura`, non `ABTG_Dow_Apertura_US`.

**Effetto misurato sul mio stesso referto**: le manopole **messe ad asse** sul motore Dow
passano da **11** a **18** (e quindi le **mai** messe ad asse scendono da 70 a **63**).
Classe **622**.

---

# 8️⃣ 🕳️ QUELLO CHE NON HO COPERTO, PER NOME

1. 🔴 **Le 35 sedie fuori dalle sei della challenge.** Ho ordinato le caselle contro
   l'obiettivo di oggi (`541452707`, viva dal 21/09). Le altre esistono nel censimento
   dell'11/09, ma **il loro ordinamento per valore non l'ho rifatto**: vale la §1.2 —
   quell'ordine è di prima del 21/09.
2. 🔴 **`770411`: inerzia NON MISURABILE.** Zero gruppi vivi (§4.4). Nessuna affermazione su
   quale sua manopola sia inerte è sostenuta dai dati.
3. 🔴 **Il `n` IS di `770411` e i due `n` di `770511` restano `[NON MISURATO]`** nel
   contratto di quelle sedie: non li ho ricavati io e non li ho stimati.
4. 🔴 **`R190b` (asse `InpTF` M30 su SuperWave): celle `[NON MISURATO]`** — è un enum e il
   conteggio va letto dentro il file prova, non dedotto dalla riga dell'asse.
5. 🔴 **Il costo di 5,0 s/passata è una calibrazione TRASFERITA**, misurata su U30USD M5 in
   R88a. Sulla `770511` (H1) e sulla `770411` (M15) **non è misurata**: la forbice
   dichiarata resta **2,9-33,0 s**, cioè i «4,7 minuti» del §4.3 stanno fra **2,7 e 31
   minuti**.
6. 🔴 **Non ho riverificato l'attribuzione delle altre 92 coppie EA×manopola** oltre a
   quelle in classifica: la VIA 3 può sbagliare su altri cloni come ha sbagliato sul Dow.
7. 🔴 **Non ho aperto il sorgente di tutti i 22 EA**: ho aperto quelli delle sei sedie vive
   più `ABTG_Nightly`, `ABTG_MaxMinNotte`, `ABTG_DAX_Live5m_v2`, `ABTG_ORB_Ottimizzato`.
   Ogni riga di §6 che cito **l'ho letta**; quello che non cito **non l'ho guardato**.
8. 🔴 **Non ho scritto nessun file prova nuovo** (§5), e **non ho archiviato nessun
   candidato**.

---

# 9️⃣ 🎯 E LA BUSSOLA

**Questa giornata produce ponteggio, e va detto.** Non consegna nessuna sedia nuova.

Quello che consegna è: **una casella grossa aperta con un nome** (l'uscita della `770511`,
sei manopole accese in campo e mai misurate, su una sedia che sta giocando la challenge
adesso), **uno scaffale da 56 passate già pronto e mai spedito**, **una casella grossa
CHIUSA senza spendere niente** (il trailing delle aperture: il default vince, misurato),
e **tre difetti di misura intercettati prima che diventassero un numero sbagliato in un
referto**.

🟢 **E la cosa che mi piace di più: la voce che sembrava valere di più — 23 punti di
drawdown sul trailing del Nasdaq — si è sgonfiata perché sono andato a guardare se
qualcuno l'avesse già misurata. L'avevano già misurata, il 21/09, e la risposta era «il
default va bene».** Non è un round perso: è un round **non speso**, ed è esattamente quello
che serve quando i minuti macchina sono zero.

---

*Dossier R223, 23/09/2026. Prodotto dall'agente `cercatore-parametri`.
Strumenti: `backtest_pipeline/manopole_inerti_v2.py` (con l'esclusione worktree applicata
in copia, §7.2) e `backtest_pipeline/censimento_uscite.py`. Sorgenti letti riga per riga
in `mql5/Experts/`, preset letti in `mql5/Presets/FTMO/`.
Nessun round lanciato, nessuna riga consegnata, nessun candidato archiviato.*
