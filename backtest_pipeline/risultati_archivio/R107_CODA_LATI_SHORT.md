# 📋 R107 — RICONTROLLO DEI LATI SHORT: Dow, DAX, Nasdaq (IN CODA)

_Richiesto da Claudio il 25/08/2026 ("Mettilo in coda. Ricontrollo short
DAX e Nasdaq e Dow"), davanti al candelone rosso dell'apertura Dow delle
14:30 che la sedia solo-LONG ha correttamente ignorato._

## La domanda
Il lato SHORT delle aperture indici ha edge OGGI? L'ultima misura (R54
"LATI DOW", inizio agosto) disse NO sul Dow e le celle vive girano
long-only (Dow E DAX, verificato nei .csv di R101 e nei controlli a
grafico del 23/08). Ma R54 ha piu' di un mese e mezzo e la finestra si e'
allungata: si rimisura.

## Perimetro proposto (da confermare nei criteri di dettaglio)
- 3 misure: lato SHORT del motore Apertura (geometria RETEST viva) su
  **U30USD**, **D30EUR**, **NASUSD** — celle gemelle di misura, magic
  vergini, MAI le vive.
- Finestre R88/R101 (IS 2024.09.26-2025.06.09, OOS 2025.06.10-2026.06.30)
  + coda 2026.07-08 se il driver la regge: confrontabilita' coi round
  precedenti.
- Tick reali. G0: il metro long delle due vive deve riprodursi (sanita').
- G1 n>=30 per cella; il verdetto short e' MISURA A SE' (non ablazione).

## ⚠️ L'onesta' scritta PRIMA dei numeri
1. La finestra e' 21 mesi di INDICI IN SALITA: il lato short parte
   svantaggiato PER REGIME. Un "niente edge short" qui non chiude la
   domanda per sempre — la chiude PER QUESTA EPOCA. Va letto con la
   spina dorsale (i periodi di discesa dentro la finestra: es. il
   crollo di febbraio-aprile 2025 c'e').
2. NASUSD: capitolo Nasdaq CHIUSO per ORB e Momentum (R97/R98, nessun
   edge). Il motore Apertura-retest short su NASUSD passa PRIMA dal
   REGISTRO_TEST (lista dei caduti, regola della seconda caccia).
3. Nessuna promozione automatica: se lo short mostrasse edge, e' una
   FIRMA di modifica contratto (o sedia nuova) con referto suo.

## Posizione in coda
Dietro: R106 (squadra da challenge, in attesa di firma) e l'installazione
attrezzi. Serve il PC di backtest (tester). Preparazione (criteri, prove,
driver, verificatore) avviata il 25/08 in background.
