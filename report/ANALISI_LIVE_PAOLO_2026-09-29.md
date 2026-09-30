# Live di Paolo, 29/09/2026 — VWAP (e cosa dice dell'ORB)

Fonti: trascrizione `LIVE_PAOLO_29.09.26_2026-09-29_21-30-00-396.txt` (numeri di riga = righe del file) e `VWAP_Unified_PRO_Presentazione.pdf` (25 pagine: **e' solo la spiegazione dell'indicatore VWAP, non contiene nessuna regola ORB**). La trascrizione e' un dettato automatico: "VooWap/WAP/VVAP" = VWAP, "Orbe" = ORB. Ogni cosa qui sotto e' **DICHIARATO da lui**, non misurato da noi.

## 1. Cosa dice dell'ORB (r.55-57, 91-109, 349)
| # | Dichiarato | Riga | Noi |
|---|---|---|---|
| O1 | ORB = box dei primi 15 minuti dopo le 15:30 italiane (15:30-15:45, "15:44:59"); si entra quando una candela **M5 CHIUDE oltre** la linea del box; da convertire in ora broker | 57, 91 | I nostri motori entrano a **rottura con ordine pendente** (buffer), non su chiusura M5. Il confronto "chiusura M5 fuori" contro "primo tocco" **non e' misurato**. |
| O2 | Filtro VWAP giornaliero: con l'ORB "entro long solo se il prezzo e' sopra il VWAP, short solo se sotto"; VWAP **giornaliero ancorato al rollover (23:00 italiane)** | 349, 217-233 | Il filtro VWAP l'abbiamo misurato in **R101 `07_vwap`: PF +0,007 Dow / -0,061 DAX, bocciato** (`report/ANALISI_LIVE_EMILIANO_2026-09-09.md` r.279). MA quello era il VWAP **di sessione**. Il suo e' ancorato al **rollover** (mescola notte asiatica ed Europa): ancora diversa, **NON misurata**. |
| O3 | Variante "Open NYSE": box = i **5 minuti prima** dell'apertura, in **M1**, ordini 2-3 punti fuori (Nasdaq 3, Dow 2), con EA; uscita a 20 punti, oggi 60; parziale al primo target; quando un ordine scatta l'altro si cancella (lui valuta di lasciarlo) | 93-109 | Famiglia PreOpen: `Nasdaq_PreOpen_Breakout_EA` esterno **mai girato**, "fuso cablato + costo 13,3x" (`CENSIMENTO_ORB_2026-09-29.md` r.59). M5 sugli indici e' escluso per costo; **M1 con stop di 25-60 punti e' peggio**: verifica del costo da fare col numero, non a memoria. |
| O4 | Risultati: "ieri due stop, oggi uno stop e una operazione a profitto (25 punti)", "una settimana che andava bene"; sta ancora **calibrando** contingenza e stop | 93, 97, 103, 107 | **2-3 giorni di aneddoti**, zero campione. Non e' evidenza. |
| O5 | Uscita ragionata a occhio: VWAP come livello di chiusura, zone di liquidita', Fibonacci, "50% ritracciato" | 59-69, 159 | Discrezionale: non automatizzabile senza definire una regola. |
| O6 | Contesto di trend: medie inclinate, sotto Supertrend, "candele senza stoppino" prima di entrare | 71-81, 155 | Filtri EMA/Supertrend: gia' nei nostri motori (`InpUseEmaFilter`, `InpUseSupertrend`) e nell'ablazione R101. |

## 2. Cosa vale la pena misurare (mai "parametri", solo MECCANISMI non ancora misurati)
1. **Chiusura M5 fuori dal box contro primo tocco** (O1). Costo basso: e' uno split descrittivo dell'anatomia dei movimenti (`backtest_pipeline/anatomia_movimenti_m5.py`, dati M1 HistData 2010-2020 / cassaforte 2021-2026). Attesa da scrivere prima: la chiusura M5 filtra una parte del 69% di falsi breakout entro 15 minuti; contro-esempio: se tiene solo i movimenti gia' avvenuti, il guadagno e' la sola perdita di R per il ritardo.
2. **VWAP ancorato al rollover come filtro di direzione** (O2). Serve il volume: i CSV HistData degli indici hanno volume **non affidabile** [NON VERIFICATO]; va misurato sul tester BCM (volume di tick) con un input di ancora nel filtro `InpUseVwapFilter` (oggi solo VWAP di sessione, `ABTG_Apertura_3Ingressi.mq5` r.1896). E' una modifica a un EA: passa dal cancello e la firma Claudio.
3. **Il box M1 dei 5 minuti prima** (O3): prima il numero del costo (`stop >= 40 x spread`), poi il resto. Verosimilmente escluso per costo, ma va scritto col numero.

## 3. Cosa NON prendo
- I risultati dei suoi 2-3 giorni (O4).
- L'ingresso a occhio "aggressivo/conservativo" (r.155-157) e le uscite a intuito (O5).
- Il VWAP come sostituto di quello che abbiamo: R101 resta valido per il VWAP di sessione.

## 4. Nota d'orario (utile per FTMO)
Lui ripete: box alle 15:30 **ora italiana**, "da tramutare in ora broker" (r.91). Nelle settimane di sfasamento dell'ora legale (marzo, fine ottobre) rollover e apertura US slittano di un'ora (PDF pag. 7). E' lo stesso tema dell'orologio d'inverno in R246: per FTMO (ora italiana + 1 tutto l'anno) l'apertura US cade alle 16:30 ora FTMO nella maggior parte dell'anno; nelle settimane di sfasamento (USA in ora legale, Europa ancora solare, o viceversa) slitta di un'ora [DA VERIFICARE col calendario].

## 5. Nessuna azione sul campo
Nessuna sedia, preset, taglia o conto toccati. Nessun round lanciato.
