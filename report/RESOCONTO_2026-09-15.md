# 📅 RESOCONTO DELLA GIORNATA — 15/09/2026, ore 21:00 IT

> Punto sul PROGETTO, non pagella trade-per-trade (quella arriva separata
> alle 23:00 in `report/giornata_2026-09-15.md`). Fonti: `git log`,
> `backtest_pipeline/coda/CODA.txt`, `backtest_pipeline/coda/referti/`,
> `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`, i due `RESOCONTO`
> precedenti per i numeri non rimisurati oggi.

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

**Il runner (03:30→14:12, referto `REFERTO_RUNNER_20260915_033005.txt`,
letto stamattina)**: 69 righe in coda (snapshot vecchio, pre-R153a), **62
eseguite / 0 rifiutate / 7 "fallite"** — ma di quelle 7, **solo 1 vera**
(`cemad02`, exit 2 = non misurato). Le altre 6 (`r127b/c`, `r139a/b/c`,
`R151a`) sono exit 3 = *"girato con rilievi"*, non un crash (il codice
d'uscita e' documentato in `RIGA_SOTTILE_ROUND.ps1`). **Primo collaudo di
compilazione mai riuscito** del Cycle (`R148a/R148bL/R148bS`, exit 0
tutti e tre). Nessun `REFERTO_RUNNER_20260915_2*` di un secondo giro e'
ancora arrivato — la corsa di stanotte con le righe armate oggi (R151a-
R160e) partira' col prossimo ciclo.

**Nessun dossier nuovo dalla caccia automatica oggi** (nessun file con
timestamp odierno in `backtest_pipeline/caccia_strategie/`): la Routine
gira ogni 2 giorni, non tocca oggi.

**58 commit oggi**, `CODA.txt` a **74 righe armate + 1 disarmata**
(R157a, vedi sotto).

## 💶 IL CONTO

**Dry-run 100k (50504263)**: dal CSV committato piu' fresco (`trades_100k.csv`,
14/09 — **oggi nessuna posizione chiusa sul 100k, nessun dato piu' recente
in git**): saldo realizzato **103.567,43** = **+3,57% dal via** contro il
target **+10%** → **mancano 6,43 punti**. Peggior giornata dal via:
-647,82 (-0,65%), ben sotto il pavimento FTMO giornaliero (-5%).
🔴 Numero **NON rimisurato su dati di oggi**: se il 100k ha chiuso
posizioni oggi, il valore vero e' nella pagella delle 23:00.

**SlippageLogger sul conto REALE (10105439)**: nessun dato piu' fresco
dell'ultimo citato in `report/RESOCONTO_2026-09-14.md` — **5 deal
totali**, ultimo scritto l'11/09. Campione troppo sottile per concludere
niente. Nessuna azione mia possibile: e' un gesto sul terminale.

**Conto REALE — trade CSV**: ancora **assente** dal repo (nessun
`ABTG_TradeExporter` attivo sul terminale `C:\BCM_Reale`, misurato
l'08/09 e mai cambiato da allora).

## 🔬 COSA HO DECISO IO

**Tredici → quindici sedie con manopola d'uscita mai mossa**, tutte
passate dal doppio cancello prima di finire committate:
- `R158a` (PTE U30USD, `InpAtrExitPeriod`), `R159a` (GapFill U30USD,
  `InpMaxHours`), `R160a-e` (PunteLarry, i 5 gemelli restanti su
  `InpMaxDaysHold`).

**Un difetto di misura vero, trovato e corretto DUE VOLTE prima di
armare**: il secondo cancello ha scoperto che `R158a` congelava una
soglia ("stop medio misurato") su un numero che **nessun artefatto del
round produce** (il CSV di ottimizzazione non ha quella colonna, il
per-trade non esporta SL e non viene nemmeno copiato dal VPS). Ho
**disarmato subito** `R157a` (stesso difetto, gia' in coda per stanotte)
prima che il runner lo potesse pescare. Prima correzione: chiusa la
soglia. Il cancello ha ripassato ENTRAMBI i file e trovato **altri 10
residui** (la prosa prometteva ancora il numero vietato in altri punti) +
una classe nuova (354: una sentinella d'arresto non puo' agganciarsi al
conteggio "passate", che uno strumento stampa cablato x2 anche su un file
a tranche unica — avrebbe fermato un banco SANO). Seconda correzione
applicata e committata. **Terzo giro di conferma in corso**, non ancora
armati.

**16 nuove classi di difetto** aggiunte a `CHECKLIST_RIGA_DI_LANCIO.md`
oggi (339-354): fra le piu' rilevanti, la **classe 339** ha tappato un
buco vero nel cancello di sicurezza stesso (la declassazione "raccolta
innocua" non guardava il CONTENUTO scritto da `Set-Content`/`Add-Content`,
solo il cmdlet — un payload-lanciatore ci passava con exit 0).

**Chiuso il Blocco 1 del runbook di ricompilazione** (due commit WIP
fermi da giorni, verificati riga per riga: nessuno tocca ordini/rischio/
stop). 13 sedie tornate candidabili alla ricompilazione, inclusa
`771531` (EMA200 Dow), l'unica delle 41 che passa tutti i criteri di casa
alla lettera. Tu hai confermato stamattina il Ramo A e stai ricompilando
in autonomia partendo da li'.

**Prop firm per manuale**: dispatchato e verificato un dossier
(`report/PROP_MANUALE_CONFRONTO_2026-09-15.md`) — The5ers "Summer Plan"
(~70% sconto, confermato attivo tutto settembre) come pick di prezzo,
FTMO come pick di affidabilita' (Trustpilot 4,8/46.600). Relayato in
chat con le fonti etichettate.

**Estratto conto manuale letto** (conto demo 50503635, 2 giorni, 37
trade): PF 1,41, +1.586,31€, ma rischio non capped per costruzione
(ingressi quasi sempre senza SL, esci tu a mano) — segnalato come fatto
di rischio, non giudizio di merito (campione troppo sottile).

## ⚠️ COSA ASPETTA CLAUDIO

- 🔴 **In corso da te**: la ricompilazione del piccolo 50503392 (Blocco 2
  + 3), partita da `771531`. Nessuna azione mia possibile qui.
- 🟡 **Non urgente**: `sedia_MAXMIN_ORO_770402.set` committato mostra
  ancora `InpRiskPercent=1.0` — il taglio a 0,5% del 23/08 non e' mai
  stato ricommittato sul file (classe 338, gia' segnalato ieri).
- 💶 Niente altro sul conto reale, sui parametri di rischio o sui soldi.

## 🎯 DOMANI

1. Terzo giro di conferma su R157a/R158a e secondo cancello sui 5
   PunteLarry (R160a-e) — se PASS, si armano in coda.
2. Aspettare il referto del runner con le righe di oggi (R151a-R160e,
   incluso il primo collaudo mai fatto del Cycle).
3. Continuare la mappatura delle manopole d'uscita mai provate sulle
   sedie ancora scoperte.
4. Seguire la ricompilazione del piccolo quando/se serve la verifica
   post-gesto (§4 del runbook).
