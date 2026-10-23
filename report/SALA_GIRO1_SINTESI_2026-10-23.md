# Sala del consiglio, giro 1 (aperture sugli indici): SINTESI per la decisione (23/10/2026)
**Perimetro:** DAX Apertura 770101, Dow Apertura 770202, Nasdaq Apertura 770250 (e 770260 per il parziale), MaxMin DAX short 770411, ORB Ottimizzato 770611. **Natura:** diagnosi + sonde + 8 round a tick sul PC di backtest. **Nessun EA, set, sedia, taglia o conto e' stato cambiato; nessuna variante promossa.** Non e' stato rivalutato il rischio ne' proposto nessun lotto (decisioni di Claudio).
Etichette: **VERIFICATO** = ricontrollato da me sul codice o sui CSV; **MISURATO** = round a tick con criteri scritti prima; **DICHIARATO** = detto da un revisore, non ricontrollato; **INFERITO** = deduzione. Dettagli e fonti nei report elencati in fondo.

## 1. Cosa e' emerso, in dieci righe
1. **Il codice che gira sul piccolo non e' quello che analizziamo:** `.ex5` di agosto (06-18/08) compilati da sorgenti con `PositionClose(_Symbol)` (VERIFICATO sul Dow, commit 6074126d righe 585 e 1890). Su hedging chiude la posizione piu' vecchia del simbolo, di chiunque. Nessun backtest ha mai misurato quel binario. **Prima di ogni altra cosa: F7 su DAX, Dow, Nasdaq.**
2. **Orologio:** DAX e MaxMin cambiano dal **26/10**, Dow, ORB e Nasdaq dal **02/11**. Con le ore invariate armano un'ora prima della cash; per Dow, ORB e Nasdaq anche la chiusura cade in un'ora sbagliata (due leve, non una).
3. **Nessun Guardian sul piccolo**; dove il codice lo chiama e' fail-open senza le variabili del canale.
4. **Due filtri si spengono in silenzio:** il filtro S&P del MaxMin e il gate EMA del Nasdaq 770250 (VERIFICATO sul codice). Nessun log: dal vivo non si controllano.
5. **Il forward del piccolo non permette nessun giudizio:** solo 3 sedie su 42 hanno >= 30 posizioni. Correzione mia: il "DAX PF 0,41" era 17 posizioni del vecchio breakout ritirato + 16 retest (+175, PF 13,5).
6. **Correzione mia:** R283-R285 hanno misurato la regola di **Emiliano**, non la cella ORB in campo.
7. **Nessuna delle novita'/pezzi misurati risulta distinguibile con le soglie scritte prima** (Piano A, filtro 17-38, barra 14:30, pareggio): vedi tabella.
8. **Il trailing del DAX cambia segno fra IS e OOS** (firma di regime): con un solo regime non si decide.
9. **Il parziale non e' un difetto generale:** su 4 celle il segno cambia (Nasdaq 770260 peggiora senza parziale).
10. **Il merito misurabile e' quasi nullo ovunque** (poche operazioni, un solo regime toro, code concentrate): il giro serve a togliere difetti e a dire cosa non ha prova, non a trovare profitto.

## 2. I round e le sonde (tutti con criteri e attese scritti PRIMA dei numeri)
| Cosa | Esito |
|---|---|
| **R283** ORB v1.01/Emiliano: compila, G0 = cella viva al centesimo; regola Nasdaq IS 1,186 / OOS 1,147, regola Dow IS 0,777 / OOS 1,110 | impianto OK; Dow cambia segno IS/OOS |
| **R284** una novita' alla volta (Piano A, filtro 17-38, barra 14:30) | nessuna distinguibile; la barra 14:30 non pesa |
| **R285** Piano A del Dow a pezzi (trailing sospeso, parziale, pareggio) | nessuno distinguibile |
| **R286** Nasdaq 770250 gate acceso/spento | con gate IS 1,253 (57 deal) / OOS 0,955 (47); senza IS 1,359 (131) / OOS 0,940 (256): DESCRITTIVO; la misura storica (104 operazioni) si riproduce; il gate toglie ~73% delle operazioni e tiene il DD OOS a 1,94% contro 5,21% |
| **R287** ORB orologio (ora fissa contro ora solare automatica) | G0 OK; S1 formale FALLITO per un mio criterio mal posto; inverno 46 contro 32 posizioni; **senza gen-feb 2026 indistinguibili (PF 1,08 contro 1,09)**, tutta la differenza viene da gen-feb |
| **R288** DAX gestione a pezzi | G0 OK; trailing IS +0,267 / OOS -0,371 (misto); pareggio inerte; senza parziale +0,057 / +0,094 (sotto soglia); **senza le 10 migliori il PF OOS e' 1,007** |
| **R289** parziale congiunto (Dow, 770260, 770250 + DAX) | **MISTO**: 2 celle su 4 concordi; il Nasdaq 770260 peggiora senza parziale (DD IS 7,3 -> 12,4%) |
| **Sonda S1** filtro S&P del MaxMin | nessun difetto riproducibile (20/20); non assolve il live |
| **Sonda S2** barra 14:45 dell'ORB | estende il range in 28,6% dei giorni (mediana 8,2%), limite superiore |
| **Sonda S3b** barra della sera nel box del MaxMin | cambia il box in 24,7% dei giorni (lunedi' 53,1% contro 17,5%) |
| **Sonda S4** festivi nei per-trade OOS | Dow: 5 giorni di chiusura USA -1106; 3 mezze sessioni +3475 (28/11 e 24/12 = 51% del netto OOS); ORB: 2 chiusure -2239, 2 mezze +5195 |
Errori miei dichiarati: S3 (criterio "contaminato" sempre vero), S1 di R287 (lotto che segue il saldo), secondo magic sbagliato di R285 (solo per-trade persi), tre attese sbagliate in piu' round. Le soglie 0,10 sono arbitrarie e non calibrate sul rumore.

## 3. Stato per EA
| EA | Difetti confermati | Prove | Non misurato |
|---|---|---|---|
| **DAX Apertura 770101** | binario vecchio; parziale al ~0,57R dichiarato dal revisore, non a 1R; `gBrokeHigh` prima del Guardian (DICHIARATO) | IS 1,126 / OOS 1,397 (175/270 deal); concentrazione forte (senza 10 migliori 1,007); forward 100k retest PF 3,00 su 17 pos. | festivi, orso, binario in campo |
| **Dow Apertura 770202** | binario vecchio (VERIFICATO); intestazione che descrive il default, non la sedia | IS 1,222 (74 deal) / OOS 1,270 (130); orologio R246 sospeso | ribasso, festivi (5 chiusure -1106), fill del limite |
| **Nasdaq 770250** | gate fail-open silenzioso (VERIFICATO); binario vecchio; lotto minimo 0,1 contro rischio 0,35 sul piccolo (DICHIARATO) | tick 104 op. riprodotte; gate non decide nel toro; OHLC orso/crollo ~97% del netto | orso a tick; lotti al deposito reale |
| **MaxMin DAX short 770411** | filtro S&P fail-open silenzioso, `InpOneTradePerDay` inutilizzato, box = barra della sera + 00:00-04:59 (VERIFICATI) | IS 1,921 / OOS 2,192 su 20/21 deal; 14 posizioni OOS | filtro S&P dal vivo; nessuna modifica puo' avere merito misurabile |
| **ORB 770611** | `TryPlace` senza controllo duplicati (VERIFICATO); TP 1,5 x range; magic condiviso con l'argento (solo statistica) | R283a IS 1,247 / OOS 1,678; inverno senza gen-feb indistinguibile fra i due orologi | orario d'inverno reale, costo in dato macro |

## 4. Decisioni di Claudio (nell'ordine in cui bloccano)
1. **F7 sul piccolo** per DAX, Dow, Nasdaq (scheda Trade vuota, fuori sessione; l'ORB e' gia' v1.04 del 03/09).
2. **Orologio `cash` o `prima`**, da decidere **prima del 26/10** per DAX e MaxMin e **prima del 02/11** per Dow, ORB e Nasdaq. Cosa dicono i dati: ORB (R287) nessun vantaggio ad andare a ora solare fuori da gen-feb 2026; DAX e Dow nei documenti precedenti (R246, tick, un solo regime) avevano fatto meglio armando un'ora prima in inverno, causa non provata; il MaxMin ha un solo inverno (16-17 posizioni). **Nessuna di queste e' una prova.**
3. **Quali varianti aprire** (EA nuovi, magic diverso, flag spento = originale al centesimo; mai in sostituzione): log del bias S&P nel MaxMin; log del gate e anti-duplicato nell'ORB; log del bias nel Nasdaq. Sono correzioni di visibilita', non di parametri.
4. **ORB:** resta com'e' (Ottimizzato in campo, Emiliano come variante parallela magic 770631)?
5. **Guardian sul piccolo:** assente; la decisione e' di Claudio.

## 5. Cosa NON si deve fare con questi dati
Cambiare soglie o orari "per migliorare" sul solo regime 2024-26; togliere il parziale o il trailing da una sedia; leggere il forward del piccolo come prova; promuovere l'Emiliano; toccare i set in campo senza una variante parallela.

## 6. Indice dei report del giro
`SALA_GIRO1_APERTURE_INDICI` (diagnosi), `INVENTARIO_PICCOLO_SALA` (con le correzioni), `SONDE_SENZA_MACCHINA_CRITERI`, `SONDE_S4_RISULTATI_E_ISTRUZIONI_S1_S3`, `SONDE_S1_S3_RISULTATI`, `SONDE_S3B_CRITERI`, `SONDE_S3B_RISULTATI`, `R283_ORB_EMILIANO_RISULTATI`, `R284_ORB_EMILIANO_BRACCI_RISULTATI`, `R285_ORB_EMILIANO_DOW_PIANOA_RISULTATI`, `R286_NASDAQ770250_GATE_RISULTATI`, `R287_ORB_OROLOGIO_RISULTATI`, `R288_DAX_GESTIONE_RISULTATI`, `R289_PARZIALE_CONGIUNTO_RISULTATI`; CSV in `backtest_pipeline/risultati_archivio/` e `risultati_sonde_2026-10-23/`.

## 7. Limiti della sintesi
Cinque revisori in sola lettura e 12 punti ricontrollati da me (il resto e' DICHIARATO); un solo regime toro nel feed BCM; soglie arbitrarie; il binario in campo non e' stato misurato da nessun round; il forward si ferma al 22/10.
