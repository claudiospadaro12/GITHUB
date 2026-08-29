# PASSO 0 OUT OF THE NOISE (P3, NASUSD M15): n=0 — BACO DI WARMUP, non motore morto

_Corsa: 29/08/2026 17:38, pin `ab8a4bc5fc2b3e5c78ca5f34889e0a9e8df316ec`,
driver `RIGA_PASSO0_OUTOFNOISE.ps1` (MARCATORE_RIGA_PASSO0_OUTOFNOISE_v1). Tick
reali (Model 4), deposito 100000, finestra 2024.09.26->2026.06.30, split 40/60
(IS 2024.09.26->2025.06.09, OOS 2025.06.10->2026.06.30). Zip agli atti:
PASSO0_OUTOFNOISE_CORSA_20260829_1738.zip._

## COSA MISURAVA
Conta-operazioni del cono di rumore orario (porting MIT di Yuri Lopukhov,
TradingView `gJeM3LZ5`) su NASUSD M15, 3 celle (00_nudo bilaterale, 01_long,
02_short), magic vergini 7677xx.

## L'ESITO NUDO: ZERO TRADE OVUNQUE

| cella | n IS | n OOS | PF | note |
|---|---|---|---|---|
| 00_nudo | 0 | 0 | 0 | Flat Giorni 168(IS)/294(OOS), Flat Chiusure 0 |
| 01_long | 0 | 0 | 0 | idem |
| 02_short | 0 | 0 | 0 | idem |

- **Compilazione: OK** (77 KB) — l'EA sta in piedi come codice.
- **Autotest del nucleo: 8/8** — cono, bande, grilletto, uscita, vwap, pavimento,
  seduta, flat, stamp: la regola ragiona come la firma, su array sintetici.
- **Gemelli IDENTICI**, PROBLEMI 0, RILIEVI 0.
- **Flat Giorni 168/294** = l'EA era VIVO ogni giorno di seduta (chiudeva flat a
  fine seduta), ma non e' MAI entrato.

## LA DIAGNOSI (certa, letta nel codice — non un'opinione)

Il baco e' nel dimensionamento della copia storica del cono. `CalcCono`
(riga 570) fa:
```
int need = (InpConeDays+3)*BarrePerSeduta() + shiftEval + 5;   // = 17*28+6 = ~482
int copied = CopyRates(_Symbol, gTF, 0, need, r);
```
`BarrePerSeduta()` (riga 538) conta le barre DENTRO la finestra di seduta:
per NASUSD 14:30-21:00 = 390 min / 15 min = **28 barre**. Quindi `need` ~= 482.

MA `CopyRates(..., 0, need, r)` copia 482 barre M15 **CONSECUTIVE sul calendario**,
comprese TUTTE le barre fuori-seduta. NASUSD (indice CFD) contratta quasi 24h
-> **~92 barre M15 al giorno**. 482 barre = **~5 giorni di calendario**, non 17
sedute.

Il raccoglitore delle sedute precedenti (righe 601-631) cerca **14 sedute
storiche** alla stessa posizione oraria, ma dentro ~5 giorni ne trova solo ~4-5.
Quindi `nDays` (found) resta ~4-5, e in `OnNewBar` (riga 470):
```
if(nDays < InpConeMinDays) return;   // InpConeMinDays = 14
```
**blocca OGNI ingresso, per sempre.** Il warmup non si chiude mai. Zero trade.

Perche' l'autotest non lo vede: usa array sintetici a sedute perfette e uniformi,
mai la copia count-based su barre di calendario reali. Il baco vive SOLO sul
feed vero, ed e' proprio dove i test sintetici non arrivano.

## COSA NON DICE QUESTO RISULTATO
- NON dice "il motore non ha edge". Il cono non e' mai stato interrogato: la
  frequenza vera resta **NON MISURATA**.
- NON e' il cancello S0: non c'e' nessun take da leggere (zero trade).
- NON e' un difetto del banco ne' della riga (gate tutti passati, compilazione OK).

## CONSEGUENZA (regola §5F: il MOTORE non e' stato bocciato, la MECCANICA di
   caricamento e' rotta e si aggiusta — "POI LI SISTEMIAMO NOI")
1. FIX in `CalcCono`: dimensionare `need` sulle barre di **calendario** (giorno
   pieno ~24h), oppure copiare per **intervallo di date** ancorato a
   `InpConeDays + buffer` giorni indietro, non sul conteggio barre-di-seduta.
   Regola pratica: per un simbolo ~24h servono >= `(InpConeDays+4) * barre_giorno_pieno`.
2. Ri-verificare autotest 8/8 dopo il fix.
3. RILANCIARE il PASSO 0 a un pin nuovo: solo allora la frequenza (e poi il
   cancello S0) diventano leggibili.

Il verdetto sul motore P3 resta **SOSPESO in attesa del ri-conteggio**: prima
si conta, poi si giudica.

---

## AGGIORNAMENTO 29/08 ore 23:02 — v1.01 (need corretto) DA' ANCORA ZERO

Rilanciato a pin `65df62c` con `BarrePerGiornoPieno()` in `CalcCono`/
`CalcVwapSessione` (`need=(14+4)*~96` barre = ~18 giorni pieni, abbondante).
Compilazione OK (78 KB), Flat Giorni 294 (gira ogni giorno), autotest non letto
(percorso log cambiato, RILIEVO), **ma Trades ANCORA 0 su tutte e 3 le celle.**

**Conseguenza onesta: il baco del `need` era reale ma NON era la causa dello
zero.** Il blocco e' un ALTRO cancello in `OnNewBar` (cono non affidabile /
warmup nDays<14 per il matcher delle sedute ragged / pos / grilletto che non
scatta). L'EA NON ha contatori per-cancello, quindi la causa non e' leggibile
dai CSV. **Prossimo passo: instrumentare `OnNewBar` con un contatore per ogni
early-return, esposto come colonne nel CSV di OnTester** (nessun cambio di
logica), poi UNA corsa diagnostica dice esattamente quale gate mangia ogni
barra. Il verdetto P3 resta sospeso finche' il motore non entra.
