# PRV_DAXAP_03a / 03b (770411, InpPlaceMin: il minuto di piazzamento): lettura del 02/10/2026 notte
Fonte: `backtest_pipeline/risultati_archivio/ROUND_DAXAP03_20261002_0004/` (PC di backtest DESKTOP-H4D7CAJ, 00:04-00:07, 3 minuti, driver con RIPROVA, **zero gambe morte: nessuna riprova scattata**, 4 gambe su 4 partite, STATO 03a=OK 03b=OK, pin `d949f705`). Criteri letti dai file prova al pin, scritti PRIMA dei numeri.

## Numeri (deal = Trades; 14 posizioni OOS per costruzione)
| file / cella (ora BCM) | IS Trades / Profit / PF / DD% | OOS Trades / Profit / PF / DD% |
|---|---|---|
| 03a 07:59 (viva) | 20 / 4.766,96 / 1,87803 / 3,0977 | 21 / 6.143,38 / 2,15985 / 1,9213 |
| 03a 08:00 = 03b +0 | 22 / 5.422,69 / 2,00248 / 2,5877 | 21 / 5.277,40 / 1,82721 / 3,1624 |
| 03a 08:01 | 18 / 5.664,73 / 2,34163 / 3,1948 | 18 / 5.197,49 / 1,98528 / 2,2961 |
| 03b +5 (08:05) | 13 / 5.067,92 / 2,59928 / 2,2910 | 18 / 934,37 / 1,12961 / 2,9112 |
| 03b +10 (08:10) | 13 / 6.428,36 / 4,03428 / 1,7862 | 15 / -3.490,88 / 0,56774 / 4,9583 |
| 03b +15 (08:15) | 8 / 3.677,72 / 4,65749 / 1,6410 | 9 / -4.028,81 / 0,32491 / 4,7451 |

## Cancelli
- **G0 (cella viva 07:59 = ancora R246i)**: IS 20 / 4.766,96 / 1,87803 / 3,0977 e OOS 21 / 6.143,38 / 2,15985 / 1,9213: **identica al centesimo. PASSA.**
- **G2 (03a cella 60 = 03b cella 0)**: IS 22 / 5.422,69 / 2,00248 / 2,5877 e OOS 21 / 5.277,40 / 1,82721 / 3,1624 in tutti e due i file: **identiche al centesimo. PASSA** (due file, due job, stesso risultato: determinismo del banco).
- **S1 / P0 (il pin e' arrivato)**: 03a, colonna InpPlaceMin 59/60/61 con InpPlaceHour=7, Profit(60) != Profit(59) in entrambe le gambe; 03b, colonna 0/5/10/15 con InpPlaceHour=8, Profit(15) != Profit(0): **PASSA**. 0/5/10 non sono identiche: il ritardo morde.
- **R1 (DD > 5,00% = incompatibile col 2,00%)**: massimo 4,9583 (03b +10 OOS): **non violato**, ma a 4 centesimi dalla soglia.

## 03a: quanto conta il minuto PRIMA della cash [lettura scritta prima]
- Attesa: |Trades(60) - Trades(59)| <= 3 deal in tutte e due le gambe. **Osservato: IS 2, OOS 0. TIENE.** Il contro-esempio (>= 25% del campione, >= 5 deal) **non scatta**.
- Lettura ammessa: "il SALDO in deal non si muove". NON si legge "il campione e' lo stesso": OOS ha Trades identici (21 e 21) e Profit diverso (6.143 contro 5.277); IS +2 deal e +656. Il segno del Profit si capovolge fra IS (+14%) e OOS (-14%): **nessuna direzione**.
- Monotonia Trades(61) <= Trades(60) <= Trades(59): rotta in IS (22 > 20), tenuta in OOS: si RIPORTA e si spiega (giornate non annidate, sell stop sopra il bid rifiutato): esito legittimo, non annulla il file.
- Il numero di fill alle 07:59 resta [NON MISURABILE] (per-trade senza ora d'ingresso).

## 03b: il ritardo vero (+5/+10/+15) [confronto pulito +10 contro +0]
- Attesa: Trades non crescente col ritardo e Trades OOS(+10) fra 0,40 e 1,00 x Trades OOS(+0): OOS 21 -> 18 -> 15 -> 9 e 15/21 = **0,71: TIENE**. IS 22 -> 13 -> 13 -> 8 (-41% gia' a +5).
- **H-FILTRO** (DD OOS(+10) <= 0,90 x DD OOS(+0) e PF OOS(+10) >= PF OOS(+0)): DD 4,96 contro 3,16 (sale), PF 0,568 contro 1,827 (scende): **NON TIENE**.
- **H-TAGLIO** (PF OOS(+10) <= 0,85 x PF OOS(+0) = 1,553): 0,568: **la soglia scatta in OOS**.
- **IS e OOS discordano**: in IS il ritardo fa salire il PF (2,00 -> 2,60 -> 4,03 -> 4,66) e scendere il DD (2,59 -> 1,64): firma di H-FILTRO; in OOS il PF crolla sotto 1 e il profitto diventa negativo (-3.491 a +10, -4.029 a +15). **Segni opposti nelle due gamba = rumore o regime, non un risultato.** La +15 si riporta e non si attribuisce (alle 08:15 l'ATR contiene la barra d'apertura).
- Con ~14 posizioni OOS nessuna delle due ipotesi e' confermabile: lettura ammessa "NON MISURABILE SUL MERITO; DIREZIONE DEL CONTEGGIO E DD LETTI".

## Cosa si puo' dire (e cosa no)
1. **La CODA dei fill precoci esiste**: ritardare di soli 5 minuti toglie 9 dei 22 deal IS (41%) e 3 dei 21 OOS. **Il valore del file e' questo**, non il PF.
2. **Il minuto prima della cash non e' la causa**: spostare il piazzamento di un minuto attraverso l'apertura (07:59 -> 08:00 -> 08:01) muove il conteggio di 0-3 deal e il profitto in segni opposti: **nessun argomento per spostare l'orario**. (Questo non spiega lo stop del 01/10: un evento, ancora non distinguibile.)
3. **Ritardare di 5-10 minuti: non c'e' un caso per farlo.** Il verdetto OOS sarebbe devastante (PF 0,57), ma IS dice il contrario, su 13-15 deal. Tutto sospeso, e nessuna cella e' promuovibile (A10).
4. Nessun preset, nessuna sedia, nessuna taglia cambiano. Il default 07:59 BCM resta.

## Limiti dichiarati
Un solo regime (rialzo, crollo di aprile 2025 nell'IS); inverno ~60% dei giorni IS e ~40% OOS: le celle d'inverno sono in pre-mercato (la risposta "relativa alla cash" e' diluita; la casella d+1 non e' misurata); il salto della barra H1 SPXUSD alle 08:00 e' [PROBABILE, NON VERIFICATO]; la cella che ha scritto il per-trade non e' identificabile (classe 455); il driver con la riprova non ha avuto occasione di riprovare (determinismo del secondo tentativo ancora non misurato).
