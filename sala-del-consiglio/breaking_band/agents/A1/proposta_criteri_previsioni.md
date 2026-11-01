# Proposta di criteri di accettazione e previsioni (A1, R005) — DA CONGELARE CON HASH DA C0 PRIMA DEL RUN
Stato: PROPOSTA. Non e congelata finche C0 non registra lo sha256 (in events.jsonl e nel rapporto). Nessun risultato visto. Coerente con specifica_v1.md e disegno_test_v1.md; N e potenza da A5, pareggio da A3.

## Parte A — Criteri di validita del test (se falliscono, i numeri NON si presentano come risultato)
Tutte le voci [B] della checklist_accettazione_C0.md di A7 (V01-V14, V16, V20 + prerequisiti) e i controlli A6: CK-13 placebo, CK-14 pattern piantati (compresa la sequenza mediana->banda impulso scartata in CONT), CK-16 reimplementazione indipendente del nucleo. Esito ammesso del test: VERIFICATO LOCALMENTE / NON VERIFICATO. Un NON VERIFICATO vieta qualsiasi verdetto sul vantaggio.

## Parte B — Verdetto sull'ipotesi primaria H-P (H1, CONT U INV, 4 periodi)
Definizioni: `N` = trade eseguiti; `m` = media di R netto per trade; `IC90` = bootstrap a blocchi settimanali (10.000 replicati); `p_B1` = frazione di estrazioni della linea di base B1 con media >= `m` (disegno sez. 4); `eps = 0,10 R` (vantaggio economicamente rilevante: nei dati geometrici A5 PF 1,15 = +0,06 R, PF 1,30 = +0,12 R per trade).
| Verdetto | Condizioni (tutte) | Cosa autorizza a dire | Cosa NON dice |
|---|---|---|---|
| **INCONCLUSIVO** | `N < 30`, oppure test NON VERIFICATO | "Questa traduzione e troppo rara sull'oro (o il test non e affidabile) per concludere"; si applica il rimedio di disegno sez. 9 | Non dice "non funziona" |
| **INDIZIO DI VANTAGGIO** (mai "dimostrato") | `N >= 30`; `m > 0`; `p_B1 <= 0,05`; `PF netto >= 1,15`; leave-one-period-out: `m > 0` togliendo ciascun periodo; `m > 0` con spread x1,5 | Un'evidenza da confermare fuori campione (anni non visti, regole identiche) prima di qualsiasi altro passo; PRELIMINARE se `N < 100`, PIENO se `N >= 100` | Non dice "la strategia funziona", ne EA, ne FTMO, ne EURUSD |
| **NESSUN VANTAGGIO RILEVANTE** | `N >= 30`; limite superiore IC90 di `m` `< +eps` | Esclude (con ~90%) un vantaggio >= 0,10 R/trade per questa traduzione su oro H1; PRELIMINARE se `N < 100` | Non esclude PF 1,05-1,15 (richiederebbe ~1300 trade, A5); non riguarda la versione discrezionale |
| **NON DIMOSTRATO** | `N >= 30` e nessuna delle precedenti | Il risultato non distingue dal caso/geometria; si riportano IC e potenza | — |
Note: (1) se `p_B1 <= 0,05` ma il resto non vale, il verdetto e NON DIMOSTRATO con nota. (2) Se `m > 0` ma `p_B1 > 0,05`: "redditizio ma non attribuibile al pattern (geometria/deriva)". (3) Unica ipotesi, alpha = 0,05 una coda, nessuna correzione perche una sola; le altre celle sono esplorative e non possono promuovere il verdetto. (4) Soglie derivate, non ottimizzate: `p_B1` e per costruzione adattivo a `N` (non richiede PF irraggiungibili con N piccoli).

## Parte C — Cosa deve contenere il verdetto (clausole obbligatorie, A6 E.4.5)
1. XAUUSD e fuori dallo scopo dichiarato dalla Guida (MAJOR/MINOR, D1/H4/H1/M30): H1 e M30 sono TF ammessi, M15 non lo e e non e stato testato. Esito negativo non confuta la strategia sui cross forex; esito positivo non la conferma.
2. Fonte: la Guida usata e un file "versione didattica" non confermato come "Guida Operativa 11" ufficiale; mancano Dichiarazione di Test (solo etichette) e screenshot standard.
3. Stop 3 ATR, target SMA20 e ricalcolo 3 ore provengono dalla Guida/Protocolli; le soglie "molto/ordinato" sono interpretazioni nostre (elenco in specifica sez. 8); i pattern testati sono un SOPRAINSIEME dei pattern validi secondo l'autore (congestione e rientro 80% non sono cancelli).
4. Nessun dato EURUSD; i 4 periodi sono 4 regimi; N per cella e per variante; N totale e potenza (MDE).
5. Criteri non misurabili: news, giudizio visivo.
6. Trade chiusi a fine dati, eventi stop+target nella stessa M1, target oltre l'ingresso, spread=0: quantificati.
7. Numero totale di configurazioni esaminate e che le esplorative non selezionano.
8. Le percentuali di successo della Checklist non sono "confermate/smentite" per classe se i campioni per fascia sono < 30.
9. Parole vietate: "la strategia funziona/non funziona", "validata", "pronta per EA".
10. Cosa non e misurato: slippage, commissioni, swap, drawdown/regole prop, spread FTMO.

## Parte D — Esplorative (nessuna decisione)
M30 (CONT, INV, pooled); CONT e INV separati; strati (n_prev, solidita, congestione, lato, ora); B0, B2; sensibilita Sa-Sf; placebo a blocchi. Si riportano tutte, con il numero totale, senza scegliere la migliore.

## Parte E — Confronto con la bozza V0 di C0 (letta ora; scritta prima dei numeri e mai eseguita)
| Elemento V0 | v1 | Motivo |
|---|---|---|
| Varianti H1/M15 | H1/M30 | M15 non ammesso dalla Guida |
| Congestione obbligatoria (CS/CDA) | punteggio/stratum | Prompt: sezione non valida != pattern non valido; N |
| Rientro >= 80% obbligatorio | descrittore | Guida: parametri 30-50% facoltativi; ordine = assenza di violenza |
| INV invalidata da candela > 1,0 ATR | 1,5; 1,0 come sensibilita Sb | Guida/Riassunto; filtro auto-colpente |
| sd<S50 solo come invalidazione al test | cancello `sd<S50` e `sd<=sd(-3)` | Guida + Protocolli; sensibilita Sa |
| Picco `p` = massimo di `i..i+3` | running extreme causale | evita informazione futura (A6 T02) |
| Test = prima barra; un episodio ogni 30 barre | prima barra che soddisfa tutto, un segnale per episodio, T_MAX 30 | A6 T04 |
| Chiusura forzata 150 barre | nessuna (1000), Sc=150 | Guida |
| Aggiornamento target ogni 3 barre | ogni 3 ore (H1=3, M30=6) | Guida/Protocolli |
| Criterio: PF netto H1 >= 1,15, N >= 100, 3 periodi su 4 positivi, WR >= 55%, WR cresce con la solidita | verdetto a 4 esiti su `m`, `p_B1`, IC, leave-one-out | PF >= 1,15 con N<100 e rumore (A5: P(PF>=1,30 | PF vero 1,0, N=60)=18%); "3/4 periodi" ha il 5-9% di probabilita sotto H0 e solo 21-26% sotto PF 1,15 (poco informativo); WR >= 55% e quasi certo con target a ~1,5-2 ATR (pareggio 60-68%) quindi NON e un successo; la crescita con la solidita richiede centinaia di segnali (A6 F45) -> solo esplorativa |
| Previsione B2 "WR >= 55%: 75%" | Q6 85%, dichiarata non informativa | A3 |

## Parte F — Previsioni (probabilita; scritte PRIMA di qualunque esecuzione dei segnali sui dati reali; ricalibrate su A2/A5/A6 e sul mio ragionamento di imbuto; IPOTESI, non misure)
Base: A3 pareggio 60-68% (68% con sd<S50); A5 N attesi (centrale 57+29 con regole piu semplici; piu stretti qui); A2 stima 10-70 trade H1 totali; A6 stima P(IC PF > 1) ~ 8-12%. Il mio imbuto grezzo (bulge ~15-35 episodi/anno; CONT richiede di raggiungere la banda opposta entro 30 barre; sd<S50 dopo la bulge e lento) suggerisce N basso.
| ID | Evento | Prob. |
|---|---|---|
| Q1 | Episodi armati H1 (4 periodi, due direzioni) fra 40 e 250 / < 40 / > 250 | 75% / 15% / 10% |
| Q2 | N trade H1 pooled: < 30 / 30-99 / >= 100 | 50% / 40% / 10% |
| Q3 | Verdetto primario: INCONCLUSIVO / NON DIMOSTRATO / NESSUN VANTAGGIO RILEVANTE / INDIZIO | 50% / 32% / 15% / 3% |
| Q4 | (se N>=30) PF netto pooled H1: < 1,0 / 1,0-1,15 / 1,15-1,30 / >= 1,30 | 55% / 17% / 9% / 19% |
| Q5 | Pareggio atteso medio dei trade eseguiti fra 58% e 70% | 80% |
| Q6 | Win rate osservato >= 55% (non informativo) | 85% |
| Q7 | `WR_oss - WR0 > 0` / `>= +5 punti` (se N>=30) | 45% / 15% |
| Q8 | `p_B1 <= 0,05` / `<= 0,20` / `>= 0,80` (se N>=30) | 6% / 22% / 22% |
| Q9 | Media nulla di B1 in [-0,10 ; 0,00] R e PF di B1 in [0,80 ; 1,02] | 70% |
| Q10 | Se `m > 0`: leave-one-period-out positivo in tutti i periodi con trade | 45% |
| Q11 | Trade chiusi a FINE_DATI + uscite a mercato per target superato < 5% dei trade | 90% |
| Q12 | Eventi stop+target nella stessa M1 < 1% dei trade | 85% |
| Q13 | Segnali scartati per `TARGET_OLTRE_INGRESSO` < 5% dei segnali | 80% |
| Q14 | La regola SEQ elimina >= 1 episodio CONT / >= 20% degli episodi CONT che toccano la banda opposta | 85% / 40% |
| Q15 | Stadio di maggiore perdita relativa dopo l'armamento: CONT = tocco banda opposta | 70% |
| Q16 | INV: stadio di maggiore perdita relativa fra `sd<S50`, retest e banda piatta | 60% |
| Q17 | N della sensibilita Sa >= 2 x N primaria | 80% |
| Q18 | N M30 pooled >= 1,5 x N H1 pooled | 60% |
| Q19 | PF netto M30 < PF netto H1 | 55% |
| Q20 | Placebo: lordo medio con `|z| <= 3` per tutte le varianti al primo tentativo | 90% |
| Q21 | Trade con spread 0 sostituito in ingresso/uscita <= 1 | 90% |
| Q22 | Se `m > 0`: il periodo 2025-26 contribuisce > 50% del profitto netto | 40% |
| Q23 | 2025-26: media R dei long > media R degli short | 60% |
| Q24 | WR monotono crescente con la solidita (se almeno 3 fasce con n >= 8) | 25% |
| Q25 | INV con `n_prev>=2`: WR maggiore di `n_prev=0` / CONT con `n_prev=0`: WR maggiore di `n_prev>=1` (se n >= 10 per strato; affermazioni della Guida) | 50% / 50% |
| Q26 | Tutti i controlli [B] di A7 SUPERATI al primo ciclo | 45% |
Punteggio a posteriori (Brier) per calibrare il processo (A6 CK-40, utile).

## Parte G — Regole di non modifica
Dopo la registrazione dell'hash: nessun cambio di soglia, interpretazione, ipotesi primaria, N minimo o definizione dei verdetti. Se N e basso: INCONCLUSIVO + sez. 9 del disegno. Se un controllo [B] fallisce: si corregge il codice con registro e si rieseguono TUTTI i controlli.
