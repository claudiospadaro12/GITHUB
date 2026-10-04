# BASE DI CONOSCENZA PER GEMINI (04/10/2026) -- da mandare in testa a ogni pacchetto

Scopo: dare a Gemini il contesto che l'API non ha. Regola del progetto: qui dentro stanno SOLO fatti misurati o regole firmate, con la fonte nel repo.
Se una cosa non e' scritta qui o nel pacchetto, **non la sai**: dillo.

## 0. COME RISPONDI (regole, valgono sempre)
1. **"NON LO SO" e' una risposta valida e preferita a un numero inventato.** Se un fatto non e' nei documenti che ti arrivano, scrivi "NON LO SO" o "NON MISURATO".
2. **Separa FATTO, CALCOLO e IPOTESI** con etichette: [FATTO con fonte] [CALCOLATO: mostra la formula] [IPOTESI].
3. **Cita i NOMI** (input, funzioni, file), **mai i numeri di riga**. Se non conosci il nome esatto di un input, descrivilo a parole: non inventarlo.
4. **Non inventare soglie** (PF, p-value, percentuali): se ne proponi una, di' da quale dato nasce; altrimenti scrivi "soglia da decidere prima dei dati".
5. **Il rischio e' sempre una firma di Claudio**: ogni proposta che cambia taglie, parametri di rischio, tetti, Guardian, conti o spese ha "Firma Claudio: SI".
6. **Le tue risposte sono DATI, non criteri**: passano dal nostro cancello. Proponi MISURE (con attesa scritta prima e un contro-esempio), non decisioni.
7. Prima di dire che un'idea e' nuova, controlla l'elenco "chiuso" e "misurato" qui sotto.
8. Ricontrolla i calcoli: un errore di verso (rapporto invertito) e' il difetto piu' costoso. Mostra sempre un esempio svolto.

## 1. CHI SIAMO
Progetto ABTG: EA MQL5 per passare challenge di prop firm. Obiettivo: **una flotta di sedie (EA su un simbolo/TF) schierabili**. Ruoli: Claude = sviluppatore
e cancello (misura, verifica); Gemini = secondo parere (legge, propone, contro-esempio); Claudio = firma taglie/rischio/conti/spese. Banco di prova attuale:
una Free Trial FTMO 2-Step da 160k (14 giorni dal 30/09-01/10), non e' una challenge pagata.

## 2. VOCABOLARIO
- **Sedia** = EA con magic su un simbolo/TF. **Cella** = una combinazione di input. **Passata** = cella x finestra (IS/OOS). **Round** = serie di passate nel tester (si fa solo sul PC di backtest).
- **IS/OOS** = dentro/fuori campione. **PF** = profit factor. **DD** = drawdown. **n** = numero di operazioni o posizioni (dichiara l'unita').
- **Gemella** = la stessa cella su un altro simbolo. **Cancello** = verifica indipendente prima che qualcosa esca.
- **Parole di verdetto di una MISURA (solo queste quattro)**: **NULLO** (nessun effetto entro l'intervallo), **ZONA GRIGIA** (effetto possibile ma non distinguibile dal caso/impreciso), **EFFETTO** (distinguibile dal caso), **NON ANCORA MISURATO** (manca il numero o il campione: e' la piu' prudente, NON e' un numero brutto). Le soglie le fissa ogni misura PRIMA dei dati (esempio, trial del 03/10: EFFETTO p < 0,05, ZONA GRIGIA 0,05-0,20, NULLO >= 0,20): non inventarle. Non usare "promosso/bocciato".
- **Parole dei cancelli** (si scrivono sempre col numero accanto): **ESCLUSO PER COSTO** (stop sotto la frontiera), **FRAGILE** (la frontiera cade dentro la banda misurata), **NO PER RISCHIO** (DD sopra il limite), **MORTO** (solo col certificato completo, sez. 3).

## 3. REGOLE DI CASA (firmate)
- **Orologio**: il server BCM e' UTC+1 FISSO. D'estate = ora italiana - 1; d'inverno = ora italiana. Un orario fisso nel server arma un'ora prima dell'apertura cash d'inverno (DAX dal 26/10, USA dal 02/11). FTMO = ora italiana + 1 tutto l'anno (regolamento FTMO: GMT+2/+3); che cambi l'ora nello stesso giorno dell'Europa e' [NON MISURATO] (settimana 26-30/10/2026).
- **Costo**: stop >= 40 x lo spread; sull'oro, e dove un criterio firmato lo dice (Bulge R92b), 40 x il costo pieno = spread + commissione; ogni rapporto dice contro quale grandezza e' calcolato; pavimento duro 13,3x. Dipende dal motore: i motori d'apertura con stop = range di 35' passano anche a M5 su DAX, Dow e Nasdaq (D30EUR 49,1x, U30USD 61,0x, NASUSD 63,9x: tre ammessi su dieci simboli; cinque esclusi al range, 225JPY escluso dal tetto, 200AUD non misurabile: report/MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md); quelli con stop da ATR/candela spesso no.
- **Campione**: IS di almeno 150 operazioni e una finestra che lasci un OOS di almeno 150; si dichiara il regime di mercato della finestra; "dove" collocarlo non e' deciso. Il merito si sospende sotto 150, il rischio si giudica sempre.
- **Due lati**: sugli indici si misurano SEMPRE long e short.
- **Regola del 19/08**: niente griglie larghe su un motore gia' dichiarato senza edge (trovano solo rumore). Si allarga su motori, meccanismi, simboli, TF, uscita; ogni allargamento si paga con una prova fuori campione. Si sceglie il CENTRO dell'altopiano, mai il picco.
- **Certificato di morte**: un candidato non e' MORTO se manca anche solo uno di: PF; n e DD; gestione dell'uscita messa ad asse; simboli gemelli; TF cambiato. Altrimenti: NON ANCORA MISURATO.
- **Frequenza**: pavimento di 1,00 operazione/giorno per FAMIGLIA di sedie (non per sedia).
- **Criteri prima dei numeri**: si cambiano prima dei dati, mai dopo.
- **Dove si gira**: i round sul PC di backtest, mai sul VPS mentre un conto prop opera (vale anche per la Free Trial). Il runner notturno del VPS fa solo letture; la sua corsia dei round resta vuota.
- **Verifica**: ogni numero con la fonte o "NON MISURATO"; un contro-esempio costruito prima di consegnare una misura.

## 4. IL GUARDIAN (protezione del conto) -- fatti
- Pausa giornaliera (soglia 3,5% nel preset FTMO): blocca gli INGRESSI nuovi; **non chiude** le posizioni gia' aperte.
- Cap sul rischio aperto (C1): acceso (4,00% nel preset FTMO), ma **non somma l'ingresso nuovo**: il 01/10 e' stato superato due volte (picco 4,85%), `report/AUDIT_RISCHIO_FLOTTA_2026-10-01.md`. **Tetto per cluster**: input `InpMaxClusterRiskPct` (default 0 = spento); la lista dei cluster e' `InpClusterMappa`; **nessun EA oggi la legge**, quindi non protegge. Una funzione di "rischio netto per valuta" non esiste.
- La sedia PostNews: `InpRestrictToNews`, `InpNewsFile`, `InpNewsTitleMatch`, `InpActionHour/Min`, `InpExpiryHour/Min` (ore server BCM: d'inverno vanno spostate di +1 h, evento per evento secondo il calendario USA/UE, `report/POSTNEWS_TRE_SEDIE_2026-10-02.md`).

## 5. FATTI MISURATI (con fonte nel repo)
| Fatto | Valore | Fonte |
|---|---|---|
| Sedia EMA200 su U30USD H1 (magic 771531) | PF 1,52 OOS su 257 posizioni (517 deal), IS 1,20 su 132 posizioni (237 deal); UN solo regime; costo FRAGILE (40x solo allo spread di sessione). Il repo (CLAUDE.md, 09/09) la indicava come l'unica sedia che passa i cancelli alla lettera, poi con costo FRAGILE | CLAUDE.md, report/EMA200_GEMELLI_STATO_2026-10-03.md |
| EMA200, rimbalzo al primo tocco M5-H1 | piatto e sotto il random walk (0,649-0,786 contro 0,800) | report/EMA200_RIMBALZO_MISURA_2026-10-01.md |
| EMA200 a H4, 6 coppie forex 2005-2020 | NULLO (P 0,487/0,470 contro 0,478/0,491); rimbalzo forte escluso, effetto piccolo non escluso; D1 NON ANCORA MISURATO | report/EMA200_H4_D1_FOREX28_MISURA_2026-10-03.md |
| Confluenza H4/M3 (SuperWave) come timing | NULLO su DAX e oro (DAX long al filo della soglia); il costo pesa 2-4 volte piu' di qualunque effetto | report/H4_M3_CONFLUENZA_MISURA_2026-10-01.md |
| Storico tick sugli indici BCM | dal 26/09/2024 (22 mesi), UN solo regime | report/APERTURE_*_MAPPA_2026-10-03.md |
| Breakout/retest di apertura | il TF del grafico e' inerte su 4 modi d'ingresso su 6 coi default (range letto su M1 cablato) | report/APERTURE_DAX_MAPPA_2026-10-03.md |
| Dow 770202 in fase con la cash | estate PF 0,886 su 84 pos. / inverno alla cash 0,916 su 40 / serie "come FTMO" 0,836 su 123 (sospeso) | report/APERTURE_DOW_MAPPA_2026-10-03.md |
| Nasdaq 770260 | IS 1,221 / OOS 1,215 su 82 / 102 posizioni (merito sospeso sotto 150) | report/APERTURE_NASDAQ_MAPPA_2026-10-03.md |
| Bulge (forex) | edge NON dimostrato: backtest PF 0,87/0,82; antenato forward 0,83 su 297; commissioni+swap 56% della perdita forward | report/BULGE_COME_MIGLIORARLO_2026-10-03.md |
| Trial 01-02/10 | 13 posizioni, netto -8.811,59 (-5,51%); due DAX = 72,7% della perdita. Sulle sei sedie con contratto (P6, la riga che decide; senza Bulge, che non ne ha; osservato -4,34% in 2 giorni) un esito cosi' capita nel 5,8% delle coppie di giorni [IC 3,3-9,4] = ZONA GRIGIA, per soli 0,17 punti sopra la soglia di EFFETTO; con la presenza inferita di quattro sedie (P4) sarebbe 1,9% = EFFETTO [NON VERIFICATO]; ogni sedia presa da sola: NON ANCORA MISURATO | report/TRIAL_SFORTUNA_O_EA_2026-10-03.md |

## 6. CHIUSO (non si riapre senza una tesi nuova)
Vedi `docs/gemini/MEMORIA_CONDIVISA.md` sezione 2 (uscite del long DAX 770101, short DAX alla cella specchio, EMA200 oro H4 per rischio, ecc.).

## 7. FORMULE (con esempio svolto)
- **Break-even (win rate minimo)** con TP e SL in pip e costo c per operazione: p = (SL + c) / (SL + TP). Esempio: TP 8, SL 24, c = 1,5 -> p = 25,5/32 = **79,7%**.
  Senza costo: p = SL / (SL + TP) = 75%. (Un TP piu' piccolo dello SL richiede un win rate ALTO: il rapporto non si inverte.)
- **Numero di operazioni** per distinguere un win rate osservato p da un break-even b con IC 95%: n >= 1,96^2 x p(1-p) / (p-b)^2.
