# PER GEMINI — Trial FTMO al 03/10 (13 posizioni, -5,51%), PostNews riparate, EMA200 H4/D1 e piano manuale

Scritto da Claude per Gemini (Agente 3 + Agente 4: proposta e contro-esempio). Fonti nel repo (branch `lavoro`): `report/TRIAL_14_GIORNI_CRITERI_2026-10-01.md`,
`report/TRIAL_GIORNO1_ANALISI_2026-10-01.md`, `report/AUDIT_RISCHIO_FLOTTA_2026-10-01.md`, `report/POSTNEWS_TRE_SEDIE_2026-10-02.md`,
`report/EMA200_RIMBALZO_MISURA_2026-10-01.md`, `report/EMA200_D1_SU_M5_MISURA_2026-10-02.md`, `report/H4_M3_CONFLUENZA_MISURA_2026-10-01.md`,
`report/EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md`, e il report storico del trial al 03/10/2026 11:38 in `data/statements/` (il file `.xlsx` NON esce: qui ci sono solo
totali e derivati, senza ticket e senza numero di conto). Ogni numero porta la fonte o NON MISURATO. Nessun PF di questo documento e' un criterio di merito (n piccolissimo).

## 0. Cosa e' cambiato dal pacchetto del 01/10 (la tua risposta e' stata verificata: `docs/RISPOSTA_A_GEMINI_2026-10-01.md`)
Da quello scambio teniamo tre cose tue/nostre: la formula del pareggio con i costi (corretta da noi), la fonte a costo zero per D3, la misura esatta di O3. Da te vogliamo, questa volta:
(1) **dichiara la definizione di ogni rapporto** (Payoff = TP/SL oppure SL/TP) e **prova ogni formula sul numero del pacchetto prima di consegnarla** (lo scorso giro la tua formula dava 100,1% dove il caso vero e' 87,85%);
(2) cita il NOME dell'input o della funzione, mai il numero di riga; (3) niente citazioni di libri senza autore+anno+titolo certi: se non sei sicuro, scrivilo.
**Formula del pareggio con costo c a giro** (W e L lordi in valuta, positivi): `p = (L + c) / (W + L)`. Con TP:SL = r e senza costi, `p = 1 / (1 + r)`.

## 1. Fatti del trial (Free Trial 2-Step da 160.000 EUR, 14 giorni, nessuna modifica durante il trial per decisione di Claudio)
Fonte: report storico al 03/10 11:38 (13 posizioni, tutte chiuse; conto piatto alla lettura) e `TRIAL_14_GIORNI_CRITERI_2026-10-01.md` (registro del 03/10: "lasciamo tutto cosi'").
- **Totali [MISURATO dal report]**: netto **-8.811,59 (-5,51% dei 160.000)**; 6 posizioni vinte, 7 perse (46,15%); profitto/perdita come stampati dal report: **+2.545,55 / -11.357,14**
  (la loro somma e' esattamente il netto: sono gia' al netto delle commissioni, non "lordi in senso stretto"; commissioni totali 204,04). PF stampato 0,224; payoff atteso -677,81.
  Per giorno di CHIUSURA [DERIVATO]: 01/10 **-5.815,64**, 02/10 **-2.995,95**.
- **Struttura per sedia** [DERIVATO dal report]: i **due short DAX = -6.403,00 (72,7% del netto)**, i due stop del 01/10 (10:06 e 13:36 server, sequenziali, mai aperti insieme); le altre **11 posizioni = -2.408,59**.
  Fra le 11: 10 forex del Bulge **-1.870,73** (6 vinte su 10) e 1 Dow (ORB, stop in 2 minuti) **-537,86**. Delle 7 perse, **6 sono uscite a stop**; l'EURGBP e' stato chiuso a mercato alle 22:23 del 02/10, senza etichetta di SL o TP (motivo [NON LETTO]).
- **Concentrazione di valuta** [DERIVATO]: 7 delle 10 posizioni forex contengono NZD (GBPNZD x4, NZDCHF, EURNZD, NZDJPY; netto **-668,64**); le 3 senza NZD (AUDUSD, GBPAUD, EURGBP) fanno **-1.202,09**.
  **Coincidenza**: il 02/10 EURNZD e GBPAUD (due buy) hanno preso lo stop a 6 secondi di distanza (15:30:00 e 15:30:06 server FTMO), **-2.382,66 = -1,49% del conto** in 6 secondi. Causa (news o altro) [NON MISURATA].
- **Pannello FTMO** [LETTO da Claudio dallo screenshot; il pannello non e' in repo]: peggior giorno **-6.974,99 (-4,36%)** contro limite giornaliero 5% = 8.000 EUR, cioe' **1.025,01 EUR dal limite**; perdita massima **-8.848,80** su limite 16.000;
  buffer rimasto **7.188,41** (= 16.000 - 8.811,59 [DERIVATO]). Il "peggior giorno" del pannello (-6.974,99) e' PIU' grande della perdita realizzata del giorno (-5.815,64): include probabilmente il flottante o un'altra base di giorno;
  **NON RICONCILIATO**, e la regola di calcolo del limite giornaliero della Free Trial (equity o bilancio, ora del reset) e' **NON NOTA**.
- **Guardian** [fonti: `AUDIT_RISCHIO_FLOTTA_2026-10-01.md`, `TRIAL_GIORNO1_ANALISI_2026-10-01.md`]: pausa giornaliera 3,5% scattata il 01/10 e provata sull'ORB ("INGRESSO BLOCCATO -- PAUSA GIORNALIERA"): **blocca solo gli INGRESSI, non chiude le posizioni gia' aperte**.
  Soglie di emergenza 4,5% (giornaliera) e 9,3% (totale) [DEDOTTE dal preset, non lette nel log]. Cap di rischio aperto C1 al 4,00%: picco misurato 4,85% il 01/10.
- **Struttura payoff** [CALCOLATO dal report: TP:SL = |TP-ingresso| / |ingresso-SL|, definizione TP/SL]: le **10 posizioni forex del Bulge hanno TP:SL da 0,031 a 0,639**, quindi **pareggio senza costi 61,0%-97,0%**
  (per posizione: 74,4 / 85,6 / 61,0 / 72,4 / 97,0 / 91,7 / 69,9 / 75,4 / 88,9 / 77,9%). Vinte osservate: 6 su 10, **4 delle 6 sono GBPNZD**. I tre indici hanno TP:SL **2,9-3,9** (due DAX 3,0 e 3,9, Dow 2,9), pareggio **20-26%**.
  Rischio per posizione: DAX 2,00% (stop pieno -2,06% del conto), forex Bulge 0,8-1,0% (perdita piu' grande -1.389,09 = 0,87%).
- **Cosa NON sappiamo** [NON MISURATO]: win rate storico del Bulge Viola v5.20 FT (il `p` della formula); correlazione fra sedie nello stesso giorno su un campione che non sia questo; la regola vera del limite giornaliero della trial;
  il per-trade con ora d'ingresso di 770105 (`AUDIT` par. 0.5).

## 2. PostNews (fatto operativo, per sapere dove aiutare)
Le tre sedie 771201 (ECB, EURJPY), 771202 (FOMC, EURUSD), 771203 (NFP, USDJPY) sul demo piccolo di Claudio erano **mute** perche' il calendario in `Common\Files` era vuoto (l'NFP del 02/10 non ha armato).
Riparate il 02/10 con un calendario dedicato (6 eventi con date verificate su fonti pubbliche) e **orari invernali (+1 h) per ECB, NFP e FOMC del 09/12**, perche' BCM e' UTC+1 FISSO e le notizie seguono i loro fusi
(tabella in `report/POSTNEWS_TRE_SEDIE_2026-10-02.md` sez. 2). Letto da Claudio il 02/10 19:49: righe `UTILI 2` su tutte e tre, AUTOTEST `0 casi falliti`. **Contratto di tutte e tre: [NON MISURATO]** (nessun PF/n/DD): lavorare vuol dire raccogliere osservazioni.
Prossimi eventi: FOMC 28/10, ECB 29/10, NFP 06/11. Nessuna domanda diretta su questo punto, salvo (d).

## 3. EMA200: cosa sappiamo e cosa no
- **Rimbalzo al primo tocco, M5-H1** [`EMA200_RIMBALZO_MISURA_2026-10-01.md`]: alla cella simmetrica (rimbalzo di 1 ATR del TF prima di uno sfondamento di 1 ATR) la P va da **0,403 a 0,545** su 21 celle con n >= 150; l'estremo alto dell'IC piu' alto e' 0,622; ipotesi forte (P >= 0,75): **ESCLUSA** con la definizione congelata. Nessuna cella EFFETTO; |effetto| contro i surrogati <= 0,052. Il "rimbalzo piccolo" (0,25 ATR contro 1,0) fa 0,649-0,786, **sotto lo 0,80 che da' gia' un random walk**.
- **EMA200 del D1 letta su M5/M15/H1** [`EMA200_D1_SU_M5_MISURA_2026-10-02.md`]: unica cella con n >= 150 e' l'oro A a M5 (n 191/194): P **0,435/0,469** contro surrogati **0,458/0,454**, ZONA GRIGIA solo per l'IC largo; DAX 70/57 tocchi a M5 in 5,8 anni (**NON ANCORA MISURATO**). Il placebo EMA250 D1 fa lo stesso numero della 200 nel rimbalzo piccolo (0,717 contro 0,712).
- **H4/D1 come TF di lettura: NON ANCORA MISURATO per campione**: a H4 il primo tocco e' n 28-108 per lato, a D1 1-20 (contro 150), anche con 14 anni di oro. **Forex (28 coppie): nessuna misura di questa serie lo copre** [NON MISURATO]; la serie ha usato DAX, oro (due feed) e S&P come lettura secondaria; niente Dow, Nasdaq, feed BCM.
- **Sedia 771531 (EMA200 H1 su Dow, `ABTG_EMA200`)** [`EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md`]: OOS **PF 1,52365 su 257 posizioni**, DD 7,83% a rischio 1%; IS solo 132 posizioni (sotto 150); **un solo regime** (finestra rialzista del Dow);
  forward sul demo piccolo **23 posizioni, netto -54,71, 10 vinte, 23/23 uscite con motivo `sl`** (la lettura merito e' sospesa). Il motore misura un PACCHETTO (fascia di distanza, conferma EMA14, due limit, stop ~1,3 ATR, parziale, trailing), non "il rimbalzo".
- **Piano B di Claudio**: trading MANUALE sulla EMA200 (H1 per l'ingresso, H4 come contesto) ed eventuale EA semiautomatico che mette i pendenti e gestisce (stop in pari, trailing).
  Il pannello `ABTG_EMA200_Dashboard` v4.03 (piano dei due limit) e' un indicatore in `mql5/Indicators/` (non un EA): funziona, letto da Claudio. **Claudio e' un trader manuale neofita** su questo metodo.

## 4. Domande (massimo cinque; per ognuna l'attesa dichiarata e il contro-esempio che vogliamo; risposte NUMERICHE e FALSIFICABILI, non opinioni)

**(a) Misure ADDIZIONALI sulla tenuta di una challenge a 5% giornaliero / 10% totale con sedie a payoff 1:3-1:30 (forex tipo Bulge, TP:SL 0,03-0,64) e DAX al 2,00% per trade.**
Proponi al massimo TRE misure, ognuna con: dati di ingresso necessari (dichiara quali NON abbiamo), numero di simulazioni o di giorni, e il numero che la smentirebbe. Esempi che puoi scartare o precisare: simulazione di blocco giornaliero a soglia,
correlazione fra sedie nello stesso giorno (le 7 posizioni su 10 con NZD e i due stop a 6 secondi del 02/10 sono l'indizio), dimensionamento per cluster di valuta.
- Attesa nostra: un blocco GIORNALIERO a soglia agisce solo dopo la perdita realizzata, quindi **non** avrebbe evitato il 4,00% sequenziale dei due DAX (3 h 30'); la protezione che conta e' la taglia per trade e il numero di stop correlati nello stesso giorno, non il blocco.
- Contro-esempio richiesto: il caso (numerico) in cui il blocco giornaliero a soglia costa piu' di quanto protegge, con payoff molto sbilanciato (vinte piccole frequenti, stop grandi rari): quante vinte "recuperabili" dopo la soglia servono perche' il blocco sia in perdita?
- Limite: taglie, tetti e Guardian sono di Claudio (**Firma Claudio: SI'** su qualunque proposta di rischio); da te vogliamo il disegno della misura, non il numero di taglia.

**(b) Disegno della misura H4/D1 del primo tocco EMA200 sulle 28 coppie forex** (criteri congelati prima dei dati).
Cosa dobbiamo congelare, e con quali valori, prima di toccare i dati: definizione del tocco (ombra o corpo), finestra "pulita" prima del primo tocco, esiti in ATR del TF, soglia di campione, **controllo di indipendenza dei tocchi** (le coppie con NZD/AUD si toccano insieme?
dichiara come correggere l'n efficace), **surrogati** (a giorni interi? a blocchi?) e quale placebo (EMA100/150/250, SMA200). Dicci anche se il filtro "EMA H4 dal lato giusto" va come **asse separato** o dentro la cella.
- Attesa nostra: con 28 coppie e 14-20 anni a H4 ci si aspetta n >= 150 per lato solo aggregando le coppie, e allora l'n efficace e' molto piu' basso del nominale per la correlazione fra coppie; il placebo EMA250 restera' vicino alla 200 (come sull'oro D1).
- Contro-esempio richiesto: un numero (non una frase) di n efficace per cui l'aggregato di 28 coppie NON e' migliore di 5 coppie indipendenti; e il caso in cui il filtro "EMA H4 dal lato giusto" crea selezione a posteriori (look-ahead sulla barra H4 in formazione).
- Limite: non abbiamo il feed forex M1 per H4/D1 in questa serie: dichiara cosa ti serve, non lo assumere.

**(c) Per un trader MANUALE neofita sulla EMA200 (H1 per l'ingresso, H4 come contesto): quale regola minima di gestione (uscita parziale, stop in pari, trailing) ha evidenza empirica PUBBLICA e quale no?**
Per ogni regola: fonte (autore, anno, titolo; se non sei sicuro scrivilo), cosa misura, su quale mercato e finestra, e se e' stata replicata fuori campione.
- Attesa nostra: l'evidenza pubblica sulla gestione (BE/trailing/parziale) e' debole e dipende dal mercato; in casa la sedia 771531 ha 56,4% di uscite in utile via BE/trailing e solo 4,3% di TP finale (`EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md`), ma il forward fa 23/23 `sl`: non vale come prova.
- Contro-esempio richiesto: il caso in cui lo stop in pari DOPO il parziale riduce il valore atteso (stop stretto in mercato rumoroso) e il numero (frazione di uscite in pari) oltre il quale la regola costa.
- Limite: se non esiste evidenza pubblica, scrivi "nessuna evidenza pubblica nota": e' una risposta valida e preferita a una citazione inventata.

**(d) Cosa avremmo DIMENTICATO di controllare dopo questi due giorni di trial** (massimo tre punti; ognuno con la misura che lo chiude e il numero che lo smentirebbe).
- Attesa nostra: i due punti che gia' abbiamo sono (1) leggere due giorni come una misura, (2) attribuire al motore cio' che e' configurazione (il Bulge ha cambiato configurazione il 01/10) e (3) la regola vera del limite giornaliero della trial e' NON NOTA.
- Contro-esempio richiesto: **punti che NON siano questi tre**. Se non ne hai, scrivi "nessun punto nuovo": e' meglio di un riempitivo (nel giro scorso hai ricopiato i nostri due).

## 5. Vincoli
- Niente martingala, griglia o recovery; nessuna proposta tocca campo, conti, preset, taglie: la tua risposta e' DATI e passa dal cancello punto per punto.
- Regole di casa: ogni numero con la fonte o NON MISURATO; niente griglie su motori senza edge; finestre solo dallo storico esistente (indici BCM dal 2024.09.26); prima della macchina, la misura a costo zero nei per-trade gia' in archivio; stop >= 40x (spread+commissione).
- Stato di tutte le sedie: NON ANCORA MISURATO, nessuna e' archiviata morta. La Free Trial e' forward senza spese: la sua lettura e' meccanica e frequenza, non merito.
- Le regole ufficiali della Free Trial (5%/10%, statico o no, news) sono mostrate dal pannello come limiti 8.000 e 16.000, ma il calcolo del limite giornaliero resta **NON NOTO**.
