# The Gold Reaper 5.4 -- luglio 2026 nel nostro tester (lettura del 16/10/2026)

Fonte: report del tester mandato da Claudio (`risultati_archivio/GOLDREAPER_TESTER_20261016_LUGLIO/report_luglio_GoldReaper_5.4_default.xlsx`) + grafico saldo/equita'. **Manca lo zip (REFERTO, MANIFEST, SHA256 del .ex5, durata): il giro e' conforme solo in parte, un mese = descrittivo.** Attese e criteri: `THE_GOLD_REAPER_ATTESE_2026-10-16.md`, scritti prima dei numeri.

## Conformita' [LETTO nel report]
XAUUSD H1, 2026.07.01-2026.08.01, **100% ticks reali**, deposito 5.000 EUR, leva 1:100, BCM Markets (Build 6230). Input = **default dell'EA** (il set di Claudio NON e' stato imposto): MaxAllowedDD=30, PropFirmMaxDailyDD=0, OnlyUp=true, TradeFrequency=5, Risk=1234 (e' il default, non un valore del set), StartLots=0,01, UseWeightedLots=true, FridayStopHour=25, nove strategie accese, NFP filter acceso. **I nomi degli input della 5.4 coincidono con quelli del .set di Claudio**: la seconda variante si puo' imporre. Differenze set-contro-default: TradeFrequency 2/5, MaxAllowedDD 9/30, PropFirmMaxDailyDD 4/0, OnlyUp 0/true.

## Risultati [LETTO]
Netto **-66,83 EUR (-1,3%)**, PF 0,60, 33 operazioni (66 affari), 17 vincenti (51,5%), media vincita 5,85 / media perdita -10,35, max 8 perdite di fila (-76,92). DD equita' massima **223,24 (4,35%)**, DD saldo 163,36 (3,21%). Commissioni totali -1,46 EUR (0,02 EUR per 0,01 lotti a lato: valore del tester, NON la commissione reale BCM [da avere per iscritto]), swap 0. Tenuta media 34 min, massima 6h55.

## Ricostruzione dalle operazioni [DERIVATO, abbinamento in->out per volume e profitto: somma 33 operazioni = -66,83 esatta]
- Strategie che hanno aperto: **solo ST4-ST8** (ST1-ST3, ordini da 0,02-0,04 lotti a livelli lontani, non sono mai scattate). Per strategia: ST4 4 op -54,21 (lotto 0,02), ST5 7 op +4,41, ST6 6 op +6,98, ST7 7 op -47,08, ST8 9 op +23,07.
- Lotti d'ingresso eseguiti: 0,01 x29, 0,02 x4 (tutti ST4): rapporto 2,0, fisso per strategia, non cresce dopo le perdite.
- Aperture in 8 giorni su ~22; piu' di meta' a ridosso di aperture di sessione (14:xx server 11, 10:xx 5, 15:xx 5, 20:xx 4, 01:xx 4). Fino al 13/7 saldo +94; poi perdite quasi ogni giorno attivo fino al 29/7.
- Il 29/7 alle 20:15:00 **quattro posizioni chiuse insieme** a -12,6/-14,2 (causa non letta: filtro news del EA? uscita a tempo? [NON VERIFICATO]). Il 2/7 alle 13:50 tutti gli ordini pendenti sono stati cancellati insieme: e' il giorno dell'NFP (rilasciato giovedi' per la festivita' del 3/7 [INFERITO, calendario non controllato]); quindi il filtro NFP **sembra agire anche nel tester**, ma l'orario (13:50) non quadra con un NFP delle 13:30 server UTC+1 [da chiarire].

## Ipotesi (un mese, giro non ancora conforme del tutto: descrittivo)
- H1 (positivo in 2 mesi su 3): luglio **negativo**; si decide con agosto e settembre.
- H2' (DD <= 14%): 4,35% **non smentita**.
- H3' (rapporto lotti <= 2): 2,0 **non smentita** (al limite).
- H4/H6 (giorno <= -200 EUR): peggior giorno circa -80 EUR (29/7, equita'), **non smentita**; con PropFirmMaxDailyDD=0 (default).
- H5 (win rate 65-80%): 51,5% **fuori banda** (33 operazioni, un mese: descrittivo; la banda dichiarata da terzi era 71-78% su v4.6 a 8 strategie).
- Meno di 150 operazioni totali: il merito NON si giudica, il rischio si'.
