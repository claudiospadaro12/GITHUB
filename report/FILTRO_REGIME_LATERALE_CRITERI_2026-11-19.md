# Togliere i trade laterali (filtro di regime) sull'incrocio EMA 9/21: criteri scritti PRIMA dei numeri (19/11/2026)
**Domanda di Claudio:** si possono togliere i trade in mercato laterale tenendo quelli che "corrono"? Da cosa dipendono i piccoli profitti/le perdite? Si puo' far segnalare solo dove l'oro (o altri simboli) corre?
**Metodo (due parti):**
1. **Diagnosi:** per ogni segnale di incrocio EMA 9/21 con ADX > 12 (Universal Scalper) si misura, **a barra chiusa del segnale**, quattro indicatori di "quanto il mercato corre": **ER20** (efficienza di Kaufman su 20 barre: |variazione| / somma dei movimenti; vicino a 0 = laterale, vicino a 1 = trend pulito), **ADX**, **pendenza della EMA21 su 10 barre in ATR**, **ATR / media ATR a 100 barre** (volatilita' relativa). Poi si guarda la mediana di ciascuno per i trade perdenti, piccoli (|R| <= 0,3) e vincenti (R > 0,3), e il rendimento medio per metà alta/bassa dell'indicatore.
2. **Filtro:** si opera solo se l'indicatore e' **sopra la mediana calcolata sui segnali del periodo In-Sample** (primo 70% delle barre); una sola regola per indicatore, **nessuna soglia ottimizzata**; si valuta sull'Out-of-Sample (ultimo 30%) con la stessa soglia. Controllo del caso: 300 estrazioni casuali di meta' dei segnali In-Sample/OOS (stessa dimensione) per vedere se il filtro batte il caso.
**Dati/mercati/TF:** XAUUSD e EURUSD (FTMO 2014-2020), NASUSD e SPXUSD (2015-2024) a **M15 e H1**; uscita **B2** (stop 1,5 ATR + uscita sul segnale opposto, la migliore del test precedente) e **A** (SL 1,5 / TP 2 ATR). Costi come prima. 4 mercati x 2 TF x 2 uscite x 4 indicatori = **64 test**: per solo caso qualcuno sembrera' migliore.
**Porte:** il filtro "aiuta" se, **nell'Out-of-Sample**, il PF filtrato supera quello non filtrato di almeno 0,10, con >= 100 operazioni, il PF filtrato > 1,0 e batte il 95% delle estrazioni casuali; e lo stesso segno in almeno 3 mercati su 4 per lo stesso indicatore. Un EA valido richiede poi le porte di Claudio (IS PF >= 1,5, DD <= 15%, >= 100 op.; OOS PF > 1,2).
## Previsioni
- I trade perdenti/piccoli hanno ER20 e pendenza mediani piu' bassi dei vincenti: **70%** (e' la lettura intuitiva del laterale).
- Il filtro porta il PF OOS filtrato sopra 1,2 in almeno un mercato/TF/uscita con >= 100 operazioni: **15%**.
- Il filtro aiuta secondo la porta (stesso indicatore, >= 3 mercati su 4): **10%**.
- Esempi gia' visti in questa sessione: il filtro di volatilita' del 4-Day Breakout e il filtro ATR del Donchian non hanno retto fuori campione.
## Limiti
Un solo sistema (incrocio EMA), 4 mercati; indicatori calcolati sulla stessa barra del segnale (nessun futuro); il regime "corre/laterale" si riconosce bene dopo, meno in tempo reale.

## RISULTATI PARTE 1 e 2 (`universal_scalper_regime.py`)
- **Diagnosi (uscita B2, mediane dell'indicatore al segnale, medie su 8 serie): perdenti / piccoli / vincenti** — ER20 0,110 / 0,101 / 0,109; ADX 19,9 / 20,1 / 20,0; pendenza EMA21 0,143 / 0,137 / 0,146; ATR relativo 0,95 / 1,07 / 1,03. **Gli indicatori di "mercato che corre" non distinguono i trade perdenti da quelli vincenti** (differenze di pochi punti percentuali; i vincenti hanno ATR relativo piu' alto di quello dei perdenti in 8 serie su 8, ma 1,03 contro 0,95). Previsione "perdenti/piccoli hanno ER20 e pendenza piu' bassi" (70%) -> **no**.
- **Filtro (sopra la mediana In-Sample), 64 test:** migliora il PF OOS in 33 test su 64 e il PF IS in 28 su 64 (testa o croce). **Passano la porta di aiuto 2 test su 64** (Nasdaq H1 B2 ER20: OOS 1,13 -> 1,42; S&P M15 B2 ER20: 0,89 -> 1,08), ma l'IS dello stesso filtro non migliora (0,93 -> 0,90; 0,77 -> 0,74), l'oro non migliora (OOS 1,22 -> 0,98 su H1) e con 64 test qualche p < 0,05 e' atteso. **Nessuna combinazione validata dalle porte di Claudio.** Previsioni: PF OOS filtrato > 1,2 con >= 100 operazioni (15%) -> si' in 3 casi (Nasdaq H1 1,42; EURUSD H1 1,30; oro H1 ADX 1,34), tutti con IS < 1; filtro aiuta secondo la porta su >= 3 mercati (10%) -> **no**.
**Verdetto: non si dimostra che si possano togliere i trade laterali con ER20, ADX, pendenza o volatilita' relativa.** Il perche' e' strutturale: l'incrocio EMA 9/21 scatta dopo il movimento; nel momento del segnale i trade che finiranno in stop e quelli che correranno hanno lo stesso aspetto.
## PARTE 3 (richiesta del 19/11: ridurre i trade da pochi punti e quelli che fanno stop) — scritta prima dei numeri
- **Costo:** si misura quanto del risultato e' dovuto al costo all-in confrontando PF lordo (costo 0) e netto (B2; M15 e H1; 4 mercati). Previsione: il PF lordo su M15 e' >= 0,15 sopra il netto in tutti i casi e il costo spiega piu' della meta' della perdita: **75%**.
- **Fascia oraria:** si confronta il R medio per blocco di 8 ore dell'ora dei dati (00-08, 08-16, 16-24) In-Sample e Out-of-Sample. **Ipotesi:** il blocco 00-08 (notte, laterale) e' il peggiore sia in IS sia in OOS in almeno 3 mercati su 4 su entrambi i TF; se si' e' un candidato a filtro da testare poi; se no, nessuna regola oraria. Previsione: ipotesi confermata: **20%**.

## RISULTATI PARTE 3 (`universal_scalper_costi_orari.py`, uscita B2)
| Mercato / TF | PF lordo | PF netto | R medio lordo | R medio netto | costo per operazione |
|---|---|---|---|---|---|
| Oro M15 / H1 | 1,08 / 1,12 | 0,83 / 0,99 | +0,048 / +0,076 | -0,134 / -0,008 | 0,18 / 0,08 R |
| EURUSD M15 / H1 | 0,98 / 1,07 | 0,83 / 0,99 | -0,012 / +0,042 | -0,121 / -0,007 | 0,11 / 0,05 R |
| Nasdaq M15 / H1 | 1,10 / 1,10 | 0,88 / 0,98 | +0,069 / +0,062 | -0,099 / -0,012 | 0,17 / 0,07 R |
| S&P M15 / H1 | 1,04 / 0,94 | 0,80 / 0,83 | +0,030 / -0,037 | -0,162 / -0,121 | 0,19 / 0,08 R |
- **Il costo spiega la perdita:** il segnale lordo e' appena positivo (PF 1,04-1,12 nei casi migliori, R +0,03/+0,08) e il costo per operazione (0,05-0,19 R, dipende dal TF: M15 il doppio di H1) lo azzera. Previsione "PF lordo >= 0,15 sopra il netto su M15 in tutti i casi" (75%) -> si' su M15 (0,15-0,25), meno su H1 (0,08-0,13).
- **Fascia oraria:** il blocco 00-08 e' il peggiore sia in IS sia in OOS in **1 caso su 8** (previsione 20% di conferma) -> **nessuna regola oraria**; il blocco peggiore cambia tra IS e OOS.
- **Costo = assunzioni nostre** (oro 0,35 USD, EURUSD 1 pip, Nasdaq 2 punti, S&P 0,7): il costo reale su BCM/FTMO non e' misurato qui. Anche dimezzandolo il PF netto resterebbe attorno a 1,0-1,1, lontano dalle porte (PF >= 1,5).
**Lettura:** i trade "da pochi punti" non sono laterali riconoscibili: sono trade con un movimento atteso piccolo rispetto al costo. L'unico filtro con un motivo meccanico e' il rapporto movimento/costo (volatilita' del momento contro costo all-in), cioe' ridurre il numero di operazioni piu' sensibili al costo o salire di timeframe; non e' stato ancora testato.
