# 🔬 REFERTO ROUND 12 — la geometria dell'"ORB filtrato" (Fazen), misurata

_Girato l'08/08/2026 sera sul laboratorio `ABTG_ORB_Ottimizzato`, tick reali, M5,
NASUSD. Geometria dell'articolo: OR 15' (14:30→14:45 server), pendenti STOP, TP a
multipli del range, USCITA FORZATA alle 16:00 server (le 11:00 ET dell'articolo),
niente parziale/BE/trailing. Il lancio è stato allargato rispetto al file prova:
**48 celle** = 4 modi stop × TP 1,0/1,5/2,0× × EMA200 on/off × volume on/off.
File: `risultati_prove/ABTG_ORB_Ottimizzato/*_r12.csv`._

## Il verdetto in una riga

**Fuori campione TUTTE e 48 le celle sono negative** — dalla migliore (−999,25)
alla peggiore (−6.707,84, DD 77%). La geometria dell'articolo è la peggiore mai
misurata sul Nasdaq: il taglio a tempo alle 16:00, senza gestione (né BE né
trailing), ammazza i vincitori e incassa le perdite intere.

- La cella ESATTA dell'articolo (stop a metà range, TP 1,5×): IS −1.306,55 ·
  **OOS −1.862,30**. Con l'EMA200: IS −299,40 · OOS comunque rossa.
- Il tasso di successo 68–72% dichiarato dalla fonte (23 trade, con retest e
  VWAP che qui non esistono) non trova NULLA di simile su 30 mesi e 126–267
  trade per cella.

## DODICESIMO ribaltamento IS→OOS

In campione c'erano celle seducenti: ATR/TP 2×/EMA200 **+1.437,85** (PF 1,15),
ATR/TP 1,0/EMA200 +1.218,77. Fuori campione le stesse celle fanno **−1.705,09**
e −1.383,32. Scegliere dall'IS avrebbe comprato l'ennesima trappola.
Rilevatore storico: 20,4 trade/mese IS contro 21,0 OOS — finestre sane.

## Scoperta di meccanica (rilevatore righe identiche, di nuovo a segno)

**24 coppie volume ON≡OFF identiche al centesimo.** Causa trovata nel codice:
`VolumeOK()` è consultato SOLO nell'ingresso a chiusura confermata
(`TryCloseConfirmEntry`); con i pendenti STOP (`TryPlace`) il ramo non gira.
Non è un bug — il filtro valuta "la candela di rottura", che esiste solo in
modalità chiusura confermata — ma è un PERIMETRO da scrivere: **il filtro
volume vale solo con `InpUseCloseConfirm=1`** (in R8/R9 infatti lavorava e
si vedeva). Le prove future con pendenti non devono spazzolarlo.

## Conseguenze

- Geometria Fazen sul NASUSD: **chiusa**. L'uscita a tempo secca è dannosa
  su questo mercato; se mai si riproverà un taglio orario, andrà con la
  gestione attiva (BE/trailing), non al posto della gestione.
- Il quadro Nasdaq sale a **100+ celle a tick reali senza un edge**.
- Restano in batteria: **R10 (oro)** e **R13 (edgeful: target 50%, stop pieno,
  tetto 0,8%)** — l'ultima ha ora un'ipoteca in più, perché condivide con R12
  la finestra 15' (ma non l'uscita a tempo secca, che qui è la principale
  indiziata del massacro).

## Dove sono i numeri

`backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/*_r12.csv`.
