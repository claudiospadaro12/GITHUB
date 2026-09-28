# 📋 RESOCONTO DELLA GIORNATA — 28/09/2026 (lunedi', settima giornata di challenge FTMO)

68 commit su `lavoro` oggi (tutti pushati; HEAD `79b43f2d` alle 21:00). Il netto del giorno trade per trade
lo fa la pagella delle 23:00 (`report/giornata_2026-09-28.md`): qui c'e' il punto sul PROGETTO.

## 🤖 Cosa ha fatto la macchina da sola
- **Runner 03:30 sul VPS**: 12/12 righe di sola lettura, **0 in corsia ROUND**, perimetro sola lettura
  (`backtest_pipeline/coda/referti/REFERTO_RUNNER_20260928_033005.txt`). Il trade del weekend della 771531
  chiuso in utile (+750,82 netto; `report/NOTTE_2026-09-28.md`).
- **Caccia automatica**: sospesa dal 28/09 per la modalita' risparmio (nessun dossier nuovo; ultimi del 26/09).
- **PC di backtest** (Claudio al monitor): riga **D** (R268/R269) letta la notte, riga **A** (36 job) letta la mattina,
  riga **R255** girata 13:08-14:00 (24/24, 52 min) e letta nel pomeriggio, riga **C** (37 job) lanciata ~15:00, zip
  non ancora arrivato.

## 💶 Il conto
- **FTMO 541452707**: saldo 75.841,54 alle 03:30 (sonda; DD 5,20%); poi EA +46,18 e +83,56 (DAX apertura, 3-5 punti);
  poi 🔴 **due trade MANUALI sull'oro alle 19:25-19:46 FTMO: −2.499,5 netti** (foto dello Storico: buy 1,00 e 2,00,
  entrambi a stop). **Saldo derivato ≈ 73.470** [esatto: NON MISURATO fino alla sonda delle 03:30].
  Spazio al pavimento del Guardian (72.560) **≈ 911 EUR**; muro FTMO 72.000, spazio ≈ 1.470. Uno stop di una sedia a
  2,00% vale ≈ 1.469: **il prossimo trade che va a −911 fa scattare FlattenAll + FAILED** (`ABTG_Guardian.mq5`
  r.737-781). Nessun blocco attivo stasera (perdita del giorno ≈ 2.370 < pausa 2.800).
- Il "dry-run 100k" del vecchio mandato non e' piu' il campo: il campo e' FTMO. Reale 10105439: non toccato; il
  giornale del 25/09 (perche' il reale non ha piazzato il DAX) aspetta ancora la riga di sola lettura sul VPS.
- SlippageLogger sul reale: NON MISURATO oggi (nessuna sonda nuova letta).

## 🔬 Cosa ho deciso io (col numero)
1. **R268 oro long si legge** (G0 VERDE dopo aver trovato il falso ROSSO: `Sort-Object -Stable`, classe 903/904).
   DD a 22 anni a 0,5% = 10,30% equity: la taglia e' una firma tua, non l'ho proposta.
2. **Londra ORB e Nightly (riga A)**: sei righe per nome con PF OOS 0,70-0,97 su n 293-306 → REGISTRO_TEST come
   **NON ANCORA MISURATO** (manca l'uscita ad asse), non morto. Nota per Gemini mandata in PDF.
3. **Audit EA**: schede 770101 e 770202 complete (stress dei costi con lo slippage misurato accanto al verdetto:
   classi 905-907). Perimetro: su FTMO girano SETTE sedie, non sei.
4. **R270 (uscita DAX apertura)**: `InpTrailStartR` sul long e' una casella GIA' CHIUSA (referto di agosto: soglia 0
   vince, PF 1,415 → 1,031 rinviando l'armo) → R270a ritirato senza macchina. Riga R270b/c/d/e (TrailMode, TP1_R,
   short) PRONTA con PASS (41d96bf4): 28 passate, ~15-25 min, dopo la C.
5. **R255 letto**: lettura A NULLA per S1 (19/24 file, una uscita post-festivo USA ciascuno: classe 912); lettura B
   con S1 emendata (firmata da te alle ~15:40): **770212 BOCCIATA PER RISCHIO** (R2 OOS in fase DD 5,13-5,31% > 4,27%
   su n 46; FTMO-DOC PF 0,58/0,51) → non si schiera. stH8 (n 46, PF 2,40) e stH12 (n 39) SOSPESE con indizio. MC
   `--r255` non lanciato (sedia nulla o bocciata).
6. **Cancello**: due buchi chiusi (classe 910: il parser vero non girava sulle righe e un `#` in una stringa tagliava
   il codice a 718 byte; classe 911: per-trade letto con `,` invece di `;`). Regressione: solo la riga D cambia esito.
7. **Live di Emiliano 28/09** analizzata (volume profile; RETEST detto da lui = il nostro; ORB "15 min" non riapre il
   cancello; 6 bandiere, zero rosse piene): da questo materiale non si muove niente.
8. **Comando per Gemini** (4 agenti: lettore EA, auditor del sistema, proponente, avvocato del diavolo) consegnato in
   PDF con gli otto file chiesti. Quello che torna passa dal cancello.
9. Modello per lavoro (tua richiesta): agenti di ricerca su Sonnet, cancello/codice/misure su Opus (`CLAUDE.md`).
❌ **Errori miei di oggi, corretti prima della consegna**: file prova R270 con emoji (cancello), formato dell'asse
sbagliato in R270e (cancello), R208b proposto su una geometria diversa dal campo (trovato al confronto input per
input). Nessuno e' arrivato a te.

## ⚠️ Cosa aspetta Claudio
- 🔴 **STASERA, prima della notte**: decidere sul conto FTMO dopo i due trade manuali: congelare (Algo Trading OFF sul
  terminale `C:\FTMO`, 541452707), ridurre il rischio per operazione, o lasciare (il primo trade a −911 chiude la
  challenge per mano del Guardian). La 770511 puo' entrare stanotte (finestra 0-24). Niente altri trade a mano.
- Zip della riga C (in macchina) → poi C2 e R270.
- Firma taglia + sedia oro long FTMO (con la pausa delle sedie oro sui demo); risposta a Jonas (FTMO); orologio delle
  sedie a ora fissa entro il 25/10; riga di sola lettura del giornale del reale (25/09).

## 🎯 Domani
Sonda 03:30 (saldo esatto FTMO) → se Claudio ha congelato, verifica che nessuna sedia abbia operato; lettura dello zip C
(lettore gated + cancello), poi riga C2 se d1-d4 sono saltati, poi R270; ripresa delle schede audit (770411, 770105,
770260, 771531, 770511, Guardian) solo se Claudio lo chiede (risparmio).
