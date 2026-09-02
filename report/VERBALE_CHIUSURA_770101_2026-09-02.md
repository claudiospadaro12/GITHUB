# 📁 VERBALE DI CHIUSURA — CASO 770101 (02/09/2026)

_Chiude la diagnosi `DIAGNOSI_770101_SIZING_2026-08-31.md`. Controlli C1-C3
eseguiti da Claudio sul VPS il 02/09 mattina; FIX C4 firmato ("FIRMO C4")
ed eseguito nel repo lo stesso giorno._

## C1 — Conteggio grafici (CHIUSO)
- Lista Expert del terminale PICCOLO (50503392), 02/09 ~09:07: **UN SOLO
  grafico** con `ABTG_DAX_Apertura_EU` (D30EUR,M5). Il doppio grafico oggi
  NON esiste (coerente col censimento .chr dal 17/08).
- Uniche righe doppie legittime: **2x ABTG_PTE su GBPUSD,H1** = il duello
  771322/771332, gemelle per costruzione firmata (giudizio a 30 trade).
- I "magic doppi" del censimento (770101/770202/770411/770901/770611) sono
  spiegati: **stesso magic sui DUE terminali** (piccolo + mirror 100k,
  decisione firmata n.2 del 02/09: rinumerazione alla challenge).
- L'anomalia del 29/07 (due SELL gemelle stesso secondo) resta attribuita a
  una configurazione di PRIMA del 17/08 (doppio grafico di allora e/o la
  settimana dei RIPRISTINA), non riproducibile ne' osservabile oggi.
  Protezione futura: proposta P0 (tetto per simbolo+lato) in attesa di firma.
- Nota di censimento: sul piccolo risulta UNA sola SupertrendReversal su
  225JPY (H2); la H4 FW (770924) non e' in lista Expert — da riconciliare
  col censimento alla prossima occasione (era gia' candidata DA-DECIDERE).

## C2 — La cella della sedia viva (CHIUSO, screenshot agli atti in chat)
| input | vivo | atteso | esito |
|---|---|---|---|
| Modalita' ingresso | RETEST (rottura+ritorno con LIMIT) | RETEST | OK |
| InpRangeMinutes | 35 | 35 | OK |
| InpBufferPoints | 500 | 500 | OK |
| InpRiskPercent | 1.0 | 1.0 | OK |
| InpMagic | 770101 | 770101 | OK |
La sedia viva gira sulla CELLA VALIDATA, non sul preset velenoso.
Osservazioni a margine: (a) `Consenti short = false` (long-only) — da
incrociare col contratto; (b) l'EA ha GIA' un input "A1: tetto
posizioni+pendenti sul simbolo", oggi 0=spento → la proposta P0 puo'
riusare input esistenti su parte della flotta (censirli prima di scrivere
codice nuovo).

## C3 — La linea del tempo (CHIUSO)
Claudio, 02/09: "me lo avrai detto tu di farlo" — la correzione all'1% della
notte 17-18/08 fu eseguita da lui su indicazione dell'assistente. Tre fonti
concordi (stop pieni, rapporto mirror, censimento .chr) + la memoria.

## C4 — IL FIX (FIRMATO ED ESEGUITO, questo commit)
1. `mql5/Experts/ABTG_DAX_Apertura_EU.mq5:85`: `ABTG_DEF_RISK 2.0 -> 1.0`,
   intestazione riscritta (la vecchia PRESCRIVEVA il 2%), commento
   dell'input allineato al contratto. **Effetto forward: ZERO oggi** (i
   parametri vivono sul grafico); il prossimo RIPRISTINA atterra sull'1%.
   La trappola e' chiusa.
2. `mql5/Presets/ABTG_DAX_Apertura_EU.set` RINOMINATO in
   `ABTG_DAX_Apertura_EU_LEGACY_2pct.set`: il file col nome piu' ovvio non
   carica piu' la config vecchia negativa al rischio doppio.
3. ⚠️ COSTO DICHIARATO: ogni backtest futuro che parta dai default nudi
   dell'EA girera' all'1% (prima 2%) — profitti e DD dimezzati rispetto ai
   referti storici a default. I referti gia' scritti NON si riscrivono: chi
   confronta vecchio-vs-nuovo deve sapere che il default e' cambiato QUI.
4. FIX 3 (cintura InpRiskMaxPercent + log OnInit) e FIX 4 (censimento che
   incrocia input/contratto/realizzato): restano PROPOSTE aperte, non
   firmate oggi.

**Il caso 770101 e' CHIUSO.** Restano vive altrove: la corsia RISCHIO C3
della famiglia da ricalcolare a rischio realizzato (M27 §B3) prima di ogni
decisione di spegnimento, e la decisione RETEST-only.
