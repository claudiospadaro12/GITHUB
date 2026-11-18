# Cosa abbiamo davvero oggi (una pagina, 18/11/2026)
Sintesi di misure GIA FATTE (fonti: `QUADRO_UNICO_EA_E_GEMINI_2026-11-18.md`, `CLASSIFICA_FORWARD_DEMO_2026-11-18.csv`, `PUNTELARRY_*`, `CRITERI_LUNA_GMT_2026-11-18.md`). Nessun consiglio su lotti, taglie, prop o acquisti: decide Claudio.

## 1. Candidati con evidenza (tester, fuori campione)
| EA | Mercato | Evidenza | Cosa manca | Test che lo chiude |
|---|---|---|---|---|
| Goldbot One | oro | 8/8 anni 2005-12 positivi + 4 anni a 80k; tick 2025 -6% | solo oro; vantaggio legato alla tendenza 2015-24 (2025-26: +45 e +150 EUR su FTMO) | forward demo 2026 sul set scelto |
| Stability Pro low | forex | 12/12 anni positivi, DD max 18,6%; tick -14% | giro D a 80k, flottante non simulato | 1 giro a 80k, forward |
| Luna AI (4DD) | forex | netto > 0 in tutte le 6 passate orario, PF 1,05-2,96 | **dipende dall'ora esatta** (offset sbagliato: PF 1,1-1,3); tick -83% | verifica offset GMT sul conto; test a tick |
| Daytrade Pro / Apex / GTP / Reaper / Phantom | forex+oro | positivi con limiti | tutti stessa famiglia Wim (rischio fornitore non misurato); Apex a griglia, Daytrade non diversifica senza oro | risposta FTMO su strategie correlate |
| **PunteLarry (nostro)** | oro | PF 1,43 / 1,66 / 1,28 (3 finestre), tick reali PF 1,44 (= M1), ~15 op./anno | t < 1,3 per finestra (p ~ 0,06 combinato); EURUSD 0/3; modalita 1-2 non reggono | forward demo piccolo; piu storia/altro mercato |

## 2. Forward demo (unica prova veramente fuori campione, da 20/07/2026)
Solo EA con >= 18 operazioni: **SuperWave Dow H1** 23 op., +541 EUR, PF 9,7; **Nasdaq Apertura US** 21 op., +250, PF 3,7; ORB Nasdaq 20 op., +352, PF 1,85; MaxMin Oro 18 op., +147, PF 1,83; DAX Live 5m 19 op., +411, PF 1,41. In perdita: DAX Apertura EU RETEST 29 op., -83, PF 0,78. **Limiti:** 3-4 mesi, campioni piccoli, PF gonfiato da poche code, lotti diversi; SuperWave appartiene alla famiglia Supertrend che nel tester sull'oro fuori campione non regge (0/4).

## 3. Chiuso (misurato, nessun candidato)
Breakout D1 oro e Nasdaq, fade falso breakout, orari fissi, moduli lezioni Nasdaq, ORB 30' su Nasdaq/SPX/oro/EURUSD, MAX-MIN DAX (esecuzione realistica), Bitcoin, Bulge (varianti), modalita 1-2 di PunteLarry.

## 4. Tre cose che spostano di piu
1. **Rischio fornitore:** quasi tutto e Wim/WSC. Domanda a FTMO senza risposta (mail pronta, non inviata).
2. **Forward demo ordinato:** 3-4 EA tenuti 3 mesi senza toccarli e confrontati con la classifica (la prova che il tester non da).
3. **ORB di Emiliano:** regole scritte non ancora in mano (PDF corso / sito).

## 5. Lettura onesta
Abbiamo 2-3 EA con evidenza decente (Goldbot One, Stability Pro, in parte Luna), 1 indizio nostro (PunteLarry) e alcuni segnali nel forward demo. **Non abbiamo ancora un portafoglio di 6-7 scorrelati provati.** Quello che resta e misura, non scoperta.
