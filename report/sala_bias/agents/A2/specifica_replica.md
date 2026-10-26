# Specifica formale della replica "MULTI TF BIAS" (A2, SALA-BIAS-001, 26/10/2026)

**Dichiarazione:** questa e una RICOSTRUZIONE dalla guida e dagli input; le formule esatte del prodotto NON sono note. La replica NON coincide numericamente con l'originale. Tag di provenienza: **[G]** dichiarato dalla guida, **[SS]** dagli screenshot degli input, **[T]** scelta mia (elencata come SCELTA Sxx nella sezione 9, con alternativa scartata e sensibilita).

## 0. Convenzioni e dati
- Per ogni timeframe TF in {W1,D1,H4,H1,M15} si usano SOLO le barre di quel TF [G]. Solo barre chiuse [G][SS]: indice `k=0` = ultima barra chiusa (shift 1 di MT5), `k=1` la precedente, ecc. Nessuna barra in formazione. Barre OHLC + tick volume `V`.
- "Valutazione alla barra b" = stessa funzione applicata alla serie traslata (k=0 diventa la barra b). Serve per Δ, BOS/CHoCH e Bias Alert. Niente stato nascosto: tutto e ricalcolabile dallo storico (no repaint) [G].
- `clip(x)=max(-1,min(1,x))` (saturazione lineare) [T S01]. `sgn` con `sgn(0)=0`.
- EMA(n): alpha=2/(n+1), semina = SMA delle prime n barre disponibili (buffer = tutto lo storico, max 5000 barre), valida solo se barre disponibili >= 2n [T S17]. RSI(14) e ATR(14): smoothing di Wilder (RMA) [SS: periodi; T: Wilder]. MACD(12,26,9): `M=EMA12-EMA26` sul close, `Sg=EMA9(M)`, `Hh=M-Sg` [SS].
- `A` = ATR(14) alla barra k=0 del TF; unita di misura di ogni distanza di prezzo [SS: "ATR 14 solo normalizzazione"; T S02]. Se `A<=0` il componente e N/A.
- Parametri letti [SS]: EMA 20/50/200, RSI 14, MACD 12/26/9, ATR 14, pendenza EMA `Ns=5` barre, lookback struttura `L=150`, swing `sw=3` barre per lato, price action `Np=8` candele, volume e price action attivi, pesi componenti 30/25/20/15/10, pesi TF 30/25/20/15/10, soglia NEUTRAL `theta=15`, `Nb=6` candele / `Dmin=20` punti / `Cmin=2` conferme su 4, closed-bars=true, aggiornamento 60 s (ricalcolo anche a ogni nuova barra del TF).
- Un componente e **N/A** se mancano dati (storico insufficiente, volumi tutti 0). Non si inventa nulla [G]: il componente esce dalla media e i pesi rimasti si rinormalizzano a 100 [T S10]. Se tutti i componenti sono N/A, il TF mostra N/A e non entra nell'Overall.

## 1. Market Structure (peso 30) -> `sMS in [-1,+1]` (voto = 100*sMS)
Finestra: barre k=0..L-1 (150).
1. **Swing (fractal 3+3)** [SS: 3 barre per lato; T S03]: barra j e swing high se `H[j]>H[j+m]` (m=1..3, lato passato) e `H[j]>=H[j-m]` (m=1..3, lato recente); swing low simmetrico (`L[j]<L[j+m]`, `L[j]<=L[j-m]`). Valido solo se `3<=j<=L-4` (confermato da 3 barre successive: nessun repaint).
2. Siano `SH1,SH2` gli ultimi due swing high (SH1 il piu recente) e `SL1,SL2` gli ultimi due swing low. Se ne mancano (<2 per tipo): MS = N/A.
3. **Pattern P**: HH se `SH1>SH2` altrimenti LH; HL se `SL1>SL2` altrimenti LL. `P=+1` (HH/HL), `P=-1` (LH/LL), `P=0` per i misti (HH/LL espansione, LH/HL contrazione) [G: etichette HH/HL, LH/LL; l'esempio guida mostra anche "HH/LL"; T S04].
4. **Rottura (BOS/CHoCH)** [G: "rotto in chiusura l'ultimo massimo o minimo"]: per `b=0..4` (finestra di recenza `Nr=5` [T S05]) siano `SHb, SLb` gli ultimi swing alla barra b e `Pb` il pattern alla barra b. Rottura rialzista a barra b se `C[b]>SHb` e `C[b+1]<=SHb`; ribassista se `C[b]<SLb` e `C[b+1]>=SLb` (SOLO chiusura, mai ombra). Si prende la rottura piu recente (b minimo). Tipo: **BOS** se `dir*Pb>=0` (con `dir=+1` rialzista, `-1` ribassista; pattern concorde o misto) e **CHoCH** se contraria (`dir*Pb<0`, es. rottura al rialzo con LH/LL) [G definisce BOS=rottura, CHoCH=cambio; la distinzione operativa e T S05]. `B=+1` se rottura rialzista (BOS o CHoCH), `-1` se ribassista, `0` se nessuna.
5. `sMS = 0.6*P + 0.4*B` [T S05]. Range [-1,1]. Esempi: HH/HL senza rottura = +0.6; HH/HL+BOS up = +1; LH/LL con CHoCH up = -0.2 (inversione non ancora confermata dalla struttura).
- Etichetta STRUCT: testo pattern (`HH/HL`,`LH/LL`,`HH/LL`,`LH/HL`) + `BOS▲|BOS▼|CHoCH▲|CHoCH▼` se esiste una rottura nelle ultime 5 barre [G: colonna STRUCT].

## 2. Trend EMA 20/50/200 (peso 25) -> `sTR`
Servono E20,E50,E200 (valide, vedi 0; se E200 N/A -> componente N/A [T S10]), `C=C[0]`, `A`. Sia `E_n^k` l'EMA alla barra k.
- **Posizione** (peso 0.30) [G: "prezzo sopra o sotto le medie"]: `pos = mean_n clip((C-E_n)/A)`, n in {20,50,200}.
- **Ordine** (peso 0.30) [G: "20>50>200 = rialzo"]: `ord = ( clip((E20-E50)/(0.25A)) + clip((E50-E200)/(0.25A)) + clip((E20-E200)/(0.25A)) )/3`. Ordine pieno = +1; la zona morta 0.25A evita lo sfarfallio [T S06].
- **Pendenza** (peso 0.25) [G: "inclinate o piatte"; SS: 5 barre]: `sl_n = clip( (E_n^0 - E_n^5)/(5*A) / 0.10 )`; `slope = mean(sl20,sl50,sl200)`. Saturazione a 0.10 ATR/barra (=0.5 ATR in 5 barre) [T S06].
- **Allargamento** (peso 0.15) [G: "si stanno allargando?"]: `W=(E20-E200)/A`; `ws=clip(W/3)`; `dW=(W^0-W^5)`; `e=clip(sgn(W)*dW/0.5)`; `spread = ws*(0.5+0.5*e)` (allargamento = pieno, contrazione = 0, mai di segno opposto) [T S06].
- `sTR = 0.30*pos + 0.30*ord + 0.25*slope + 0.15*spread`.

## 3. Momentum RSI+MACD (peso 20) -> `sMO`
- **RSI** [G: sopra 55 rialzista, sotto 45 ribassista; SS: 14]: `r=RSI14^0`; livello `rl = sgn(r-50)*clip((|r-50|-5)/15)` (nullo in 45..55, continuo, saturo a 70/30); direzione `rd = clip((r^0 - r^3)/8)`. `sRSI = 0.7*rl + 0.3*rd` [T S07].
- **MACD** [G: "salendo o scendendo"; SS: 12/26/9]: `sMACD = 0.4*clip(M/(0.5A)) + 0.4*clip(Hh/(0.15A)) + 0.2*clip((Hh^0-Hh^3)/(0.10A))` (linea vs zero, istogramma, variazione istogramma a 3 barre) [T S07].
- `sMO = 0.5*sRSI + 0.5*sMACD` [T S07]. Servono >= 100 barre (warm-up MACD/RSI), altrimenti N/A.

## 4. Price Action (peso 15) -> `sPA`
Finestra: ultime `Np=8` barre chiuse (k=0..7) [SS]. Per ogni barra con `R=H-L>0` (altrimenti voto 0):
`cl=2(C-L)/R-1` (chiusura vicino a massimo/minimo), `br=(C-O)/R` (corpo pieno con segno), `rj=(min(O,C)-L)/R-(H-max(O,C))/R` (ombra di rifiuto: ombra inferiore lunga = rialzista) [G: "chiudono vicino ai massimi/minimi, corpi pieni, ombre di rifiuto"].
`bk = 0.4*cl + 0.4*br + 0.2*rj`; `base = sum_k w_k*bk / sum_k w_k`, `w_k=8-k` (la piu recente pesa 8, la piu vecchia 1).
**Accelerazione** [G: "accelerazioni"]: `ratio = mean(R_0..R_3)/mean(R_4..R_7)`; `acc = clip((ratio-1)/0.5)*clip(base/0.2)` (espansione dei range nella direzione prevalente).
**Spostamento netto:** `D = clip((C[0]-C[7])/(2A))`.
`sPA = 0.60*base + 0.25*D + 0.15*acc` [T S08].

## 5. Volume tick (peso 10) -> `sVO`
[G: "solo conferma: i volumi crescono nella direzione del movimento", non decide mai da solo; SS: analisi volume attiva.] Con `V`=tick volume, N/A se `V` e 0 nelle ultime 20 barre o storico <20 [G: N/A, mai stimato].
- Bilancio direzionale su 8 barre: `Bal = sum_k w_k*sgn(C_k-O_k)*V_k / sum_k w_k*V_k` (stessi `w_k` di sez. 4; doji = 0). In [-1,1].
- Crescita volumi: `g = clip(mean(V_0..V_3)/mean(V_0..V_19), 0.5, 1.5) - 0.5` in [0,1] (volume medio=0.5, in crescita->1, in calo->0).
- `sVO = Bal*g` [T S09]. Con peso 10 non puo spostare lo score oltre 10 punti: coerente col "mai da solo".

## 6. Score del timeframe, bias, forza
- `S = 100 * sum_i w_i*s_i / sum_i w_i`, sui soli componenti disponibili, i in {MS 30, TR 25, MO 20, PA 15, VO 10} (pesi modificabili, sempre riportati a 100) [G]. `S in [-100,+100]`.
- **Bias**: `|S| < theta=15` -> NEUTRAL; altrimenti BULLISH se `S>0`, BEARISH se `S<0` [G]. Il confronto usa `S` non arrotondato [T S15].
- **Score mostrato** = `round(|S|)` (mezzo punto verso l'alto), 0..100 [G: "-75 diventa BEARISH 75/100"].
- **Forza** (parole) sullo score mostrato [G]: 0-9 MOLTO DEBOLE; 10-29 DEBOLE; 30-69 NEUTRO; 70-89 FORTE; 90-100 MOLTO FORTE. (Si applica anche a bias NEUTRAL: es. 12 -> NEUTRAL, DEBOLE.)
- **Δ** [G: "rispetto alla candela precedente"]: `dS = S(b=0) - S(b=1)` (valutato alla barra precedente); mostrato come ▲ se `dS>=+1`, ▼ se `<=-1`, altrimenti vuoto [T S16].
- **Confidenza del TF** [G: accordo fra strumenti, non una probabilita]: sia `d=sgn(S)` (se `S=0`, `d=+1`); per ogni componente disponibile `a_i = 1` se `d*s_i>=0.10`; `0.5` se `|s_i|<0.10`; `0` se `d*s_i<=-0.10`. `CONF = 100*sum_i w_i*a_i / sum_i w_i` [T S12]. Etichetta sempre "Confidence != probability". NON influenza bias ne score.

## 7. Quadro d'insieme
- **Overall** [G]: `S_all = sum_tf W_tf*S_tf / sum_tf W_tf` con `W = W1 30, D1 25, H4 20, H1 15, M15 10`, sommando solo i TF ON e con dati (TF spento o N/A -> escluso e pesi rinormalizzati) [G]. Si usa `S_tf` col segno anche se il TF e NEUTRAL [T S11]. Bias, score mostrato e forza come in sez. 6 (stessa soglia 15, stessa tabella).
- **Allineamento** [G]: su N TF attivi con dati, `nB`=# BULLISH, `nS`=# BEARISH (i NEUTRAL non compaiono). Testo: "`nB/N BULLISH – nS/N BEARISH`" omettendo il lato a zero; se entrambi 0: "0/N allineati".
- **Confidenza Overall** [G: accordo tra strumenti E timeframe]: `a_tf = 1` se bias TF concorde col bias Overall, `0.5` se TF NEUTRAL, `0` se opposto; `CONF_all = 0.5*sum W_tf*a_tf/sum W_tf + 0.5*sum W_tf*CONF_tf/sum W_tf` [T S12].
- **CONTRO-TREND per TF** [G: confronto coi TF sopra]: `H_tf` = media pesata (pesi W rinormalizzati) di `S` dei soli TF ON sopra tf; il TF e CONTRO-TREND se il suo bias e non-NEUTRAL, `|H_tf|>=theta` e `sgn(H_tf) != sgn(S_tf)`. W1 non lo e mai [T S13]. Riga HTF: `HTF (W1·D1·H4)` = bias di `S` ricombinato sui soli W1,D1,H4 attivi (stessa soglia); se un TF inferiore e CONTRO-TREND: "`<TF> = CONTRO-TREND / CORREZIONE`" [G].

## 8. Bias Alert e note [G: tre condizioni tutte vere; parametri SS: 6 candele, 20 punti, 2 conferme su 4]
Per ogni TF, usando `S(b)` per `b=0..Nb-1` (6 barre chiuse):
1. **Calo dal picco**: `bp=argmax_b |S(b)|`, `D=sgn(S(bp))`, `Pk=|S(bp)|` (se `Pk<theta` nessun alert: non c'era bias da perdere). Condizione: `Pk - D*S(0) >= Dmin=20`.
2. **Debolezza >= 2 candele chiuse**: `D*S(0) < D*S(1)` e `D*S(1) < D*S(2)` (due cali consecutivi dello score direzionale) [T S14].
3. **>= `Cmin`=2 elementi su 4 contrari**: tra struttura (MS), medie (TR), momentum (MO), price action (PA) (volume escluso) quelli con `D*s_i <= -0.10` sono `>=2` (componenti N/A non contano).
- **BIAS CHANGING**: 1+2+3 vere. Messaggio: "`<TF>: possibile passaggio da <bias precedente D> a <NEUTRAL se |S(0)|<theta, altrimenti bias opposto>`"; NOTE mostra anche "→ <nuovo bias>". La sezione Alert e visibile solo se almeno un TF e in BIAS CHANGING [G].
- **WEAKENING** (NOTE): 1+2 vere ma 3 falsa [T S14]. Il solo "una candela contraria" non attiva nulla [G].
- Colonna NOTE: CONTRO-TREND (sez. 7), WEAKENING, BIAS CHANGING, → bias; separati da spazio.

## 9. Elenco delle SCELTE (dove la guida non basta)
Sensibilita = quanto cambiano i bias per TF se si cambia scelta (B=bassa, M=media, A=alta).
- **S01** Saturazione lineare `clip`. Scartata: `tanh`. Cambia di poco le gradazioni, non i segni. **B**.
- **S02** Unita di scala = ATR14 Wilder al k=0, soglie di saturazione in multipli di A. Scartata: ATR su finestra diversa/SMA o %prezzo; guida dice solo "ATR per normalizzare". Le soglie numeriche (0.25A, 0.5A, 0.10 ATR/barra...) sono mie. **M-A** sul valore dello score, **B** sul segno.
- **S03** Swing: fractal 3+3, confermato, ties come in 1.1. Scartata: ZigZag/ATR-threshold. **B-M**.
- **S04** Pattern misto = 0. Scartata: credito parziale (es. ±0.3 secondo ultimo swing). Nota: l'esempio della guida mostra H1 "HH/LL" FORTE 76: col mio 0 il massimo per un TF misto sarebbe 70; ma l'esempio e "di fantasia" [G]. **M**.
- **S05** BOS/CHoCH: finestra recenza 5 barre, B=±1 costante, `sMS=0.6P+0.4B`, BOS vs CHoCH per concordanza col pattern a quel momento. Scartata: persistenza fino a nuova rottura / decadimento lineare / peso 50-50. MS pesa 30: **A**.
- **S06** Sotto-pesi del Trend (.30/.30/.25/.15) e scale di saturazione; spread "allargamento" come modulatore. Scartata: voto per punti discreti (+1/-1) su ogni condizione. **M-A**.
- **S07** Momentum: split 50/50 RSI-MACD, zona morta RSI 45-55 con rampa a 70/30, MACD a tre termini con scale 0.5A/0.15A/0.10A, Δ su 3 barre. Scartata: `(RSI-50)/50` lineare; MACD solo segno. **M**.
- **S08** Price action: formula a 3 termini per barra, pesi lineari decrescenti, accelerazione e spostamento netto. Scartata: media semplice, solo close-location. **M**.
- **S09** Volume: bilancio direzionale x crescita; N/A se manca. Scartata: OBV/volume vs media 20 solo. Peso 10: **B**.
- **S10** Componente N/A -> rinormalizzazione; EMA200 N/A -> Trend N/A. Scartata: Trend calcolato senza E200; voto 0. **B-M** (solo con storico corto).
- **S11** Overall usa `S` col segno anche per TF NEUTRAL. Scartata: contare 0 per i NEUTRAL (o escluderli). **B-M**.
- **S12** Confidenza = voto ponderato di concordanza dei segni (zona morta 0.10); Overall = 50% concordanza TF + 50% media CONF. Scartata: 1 - dispersione dei voti; affine a |S|. Non entra nel bias. **A sui numeri CONF, nulla sul bias**.
- **S13** Contro-trend = opposto al consenso pesato dei TF sopra con `|H|>=15`. Scartata: opposto a uno qualsiasi / al TF immediatamente superiore. **B**.
- **S14** Alert: picco = max |S| nelle ultime 6 barre; debolezza = 2 cali consecutivi; contrari = `D*s_i<=-0.10`; WEAKENING = condizioni 1+2. Scartata: debolezza = score sotto picco-20 per 2 barre; conferme = segno stretto. **M** su tempistica dell'avviso, nulla su bias.
- **S15** Soglia confrontata su `S` non arrotondato; arrotondamento half-up; bande forza sullo score mostrato. **B**.
- **S16** Δ con soglia 1 punto. **B**.
- **S17** EMA seminata con SMA, storico fino a 5000 barre, valida da 2n barre. Scartata: seme = close, 3n barre. **B** (cresce su W1 corto).

## 10. PUNTI CHE UNA DASHBOARD DAL VIVO POTREBBE CONFERMARE (cosa fotografare)
1. Stessa ora, stesso simbolo, **5 TF** + OVERALL + data/ora ultimo update; ripetere a 3-5 istanti diversi (anche su oro e indice) per avere variabilita.
2. Score di ogni TF vs mio `S` (quanto coincidono i **segni** e quanto la grandezza: rivela la scala/saturazione S02, S06-S08).
3. Mostra i singoli voti dei componenti? (se c'e un tooltip/impostazione "debug", fotografarla) altrimenti: casi limite in cui un componente domina (es. pieno trend senza rotture) per isolare S05.
4. Pattern STRUCT con valori misti ("HH/LL", "LH/HL"): che score e che bias hanno? (S04).
5. Comparsa/scomparsa e persistenza di BOS/CHoCH: per quante barre resta l'etichetta dopo la rottura (S05), con screenshot a barre consecutive.
6. Colonna CONF con score e voti noti: forma funzionale (S12); verificare se CONF alta con score basso e possibile.
7. Δ: valore a barre consecutive e soglia di visualizzazione (S16).
8. Un TF spento: nuovo Overall e prova di rinormalizzazione dei pesi (S11, sez. 7); un TF con N/A/LOADING.
9. Casi con TF NEUTRAL nell'Overall (S11) e casi di CONTRO-TREND con 2+ TF sopra discordanti (S13).
10. Alert: foto di BIAS CHANGING/WEAKENING con lo score delle ultime 6-8 barre del TF (ricostruibile da screenshot a barre consecutive) per tarare S14.
11. Volume: simbolo con tick volume vs senza (N/A) e effetto sul punteggio (S09).
12. Cambiando input (soglia NEUTRAL 15->30, pesi, EMA) lo score varia come previsto? Una foto prima/dopo.

---
## Rapporto A2 (10 righe)
1. Scritta la specifica completa per i 5 componenti, score TF, bias/forza, Overall, allineamento, confidenza, contro-trend, BOS/CHoCH e Bias Alert, tutta calcolabile da OHLC+tick volume a barre chiuse.
2. Ogni punto e etichettato [G]/[SS]/[T]; 17 scelte (S01-S17) con alternativa scartata e sensibilita.
3. Le scelte piu rischiose per la fedelta numerica: **S05** (BOS/CHoCH e peso 0.6/0.4 dentro Market Structure, peso 30), **S02/S06** (soglie ATR e sotto-pesi del Trend), **S12** (formula della confidenza, del tutto inventata).
4. Rischio medio: S04 (struttura mista = 0; l'esempio della guida con "HH/LL" a 76 suggerisce credito parziale), S07/S08 (scale RSI/MACD/price action), S14 (tempistica dell'alert).
5. I segni (BULLISH/BEARISH) dovrebbero concordare di piu dei valori assoluti: la replica va giudicata sulle direzioni, non sui punteggi.
6. Il fatto che la confidenza non entri nel bias isola il rischio di S12 dal verdetto sul valore del bias.
7. Nessun parametro e stato ottimizzato; le soglie sono scelte a priori per ragionevolezza, da congelare prima dei test.
8. N/A gestito senza stime (storico corto, volumi assenti), con rinormalizzazione.
9. Limite dichiarato: nessun controllo contro la dashboard reale; vedi lista sez. 10.
10. File: /tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/lavoro_wt/report/sala_bias/agents/A2/specifica_replica.md
