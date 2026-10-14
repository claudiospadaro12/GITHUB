# ATR(14) H1 del DAX (D30EUR, feed BCM) — LETTURA dell'export del 14/10/2026

Zip `EXPORT_BARRE_DAX_H1.zip` (run `a6e3e67227b8`, pin della riga `671c3579…`, PC di backtest, 14/10 19:16). Archivio: `backtest_pipeline/risultati_archivio/EXPORT_BARRE_DAX_H1_20261014/`. Letto con `collaudo_export_barre_dax_h1.py` e `leggi_atr_h1_dax.py` (uscita completa: `LETTURA_ATR_USCITA.txt`). Le attese e le alternative erano scritte PRIMA dei numeri nel docstring del lettore.

## 1. Provenienza e integrita'
- Provenienza: pin, SHA256 EA e `.ini`, run, SHA256 del CSV (`43C49748…`, ricalcolato qui: uguale) e `STATO: OK` coincidono col RIEPILOGO [MISURATO].
- Integrita': PASS. 11.498 barre H1 dal 2024.09.26 16:00 al 2026.10.13 21:00; 11.292 nella finestra di misura; 0 giorni feriali senza barre fuori dall'elenco feste; 1 chiusura (il primo giorno, parziale).
- 🔴 **Orologio: NON CONFERMATO** (A4) in due stagioni su quattro: inverno UE 2024/25 (escursione dice 09, tick_volume dice 08: le due grandezze non concordano) ed estate UE 2025 (salto alla barra attesa ma margine 1,10, non netto). Confermato: inverno 2025/26 (escursione 09 x1,86, tick_volume 09 x3,67 → UTC+1 fisso) ed estate 2026 (08 sulle due grandezze). Conseguenza dichiarata prima: le letture PER ORA (E2, E3, E4, mattino della live) escono con la scritta **SOSPESA** e non danno verdetto; E1, E5, E6 non dipendono dall'orologio e valgono.
- Non e' una smentita dell'orologio fisso UTC+1 (`OROLOGIO_BCM_2026-09-24.md`): e' una prova piu' debole di quelle gia' usate. Per la decisione del 25/10 sul campo l'inverno 2025/26 e' una conferma in piu' sul DAX, ma l'ambiguita' del 2024/25 NON e' spiegata.

## 2. Verdetto E1 (quello che conta)
**Mediana ATR(14) H1 su tutte le ore, 2024-09-26 → 2026-09-30, giorni feriali: 58,47 punti indice** (n 11.218; media 66,78; p10 36,94, p25 45,44, p75 78,23, p90 103,23).
Partizione scritta prima: [48,0 ; 60,0] = «IL DERIVATO REGGE» (derivato della mappa 53,6). **Esito: REGGE.**
- ⚠️ Pero' sta a **1,5 punti dal bordo** del ramo «> 60 = il derivato SOTTOSTIMA». Il Dow aveva fatto predire (inferenza, altro simbolo) E1 ≈ 65,4 → ramo «> 60»: **non si e' realizzato**, ma 58,47 e' piu' vicino a quel ramo che al centro della banda. Il derivato 53,6 sottostima comunque del 8% rispetto alla mediana misurata (e del 20% rispetto alla media).
- Riga H1 del cancello di costo (stop 1,5 × ATR, spread BCM 1,70): **51,6x** (≥ 40x), con 2,5 × ATR: 86,0x. Il controllo di riproduzione del 53,6 → 47,3x / 65,4x e 78,8x / 108,9x e' passato.
- 🟠 Ma la **quota** delle letture sopra la frontiera (ATR ≥ 45,33) e' **75,4%**: il 24,6% delle volte, in assoluto, la riga H1 sta sotto 40x. E' una distribuzione, non un numero.

## 3. Le letture per ora (SOSPESE: non sono verdetti)
Stampate lo stesso, ma NON danno verdetto finche' l'orologio non e' confermato:
- E4: minimo dell'ATR alla barra 07 server (45,31), massimo alla 19 (69,13): coerente con l'attesa «finestra di 14 ore tutta notte al mattino, minimo fra le 5 e le 8». Minimo/mediana = 0,775 (sul Dow 0,662).
- E2 (barre chiuse delle 07:00-08:00 IT): mediana **45,07** (p25 35,20, p75 61,34) → «GRIGIA» (44-50). L'alternativa «Emiliano vede un'ora bassa» prediceva E1 in [48;60] **e** E2 ≤ 44: la prima meta' e' vera, la seconda e' mancata di 1 punto (45,07) e comunque sospesa. Il suo ATR 37 (e Luca 40) cade fra p25 e la mediana di quelle barre: **compatibile con una lettura bassa ordinaria del mattino**, non dimostra che «H1 sia 37». Non e' una conferma piena della spiegazione; e' una non-smentita.
- Quota delle letture alle barre delle 07:00-08:00 IT con ATR ≥ 45,33: **49,6%** [SOSPESA]; mediana 07-08 IT: 39,8x sulla frontiera 40x (cioe' esattamente a cavallo).
- Costo per ora d'ingresso (spread mediano orario, tick 2024.09.26-2026.06.30, stagioni miste): 1,5×ATR/spread vale **40,0x / 40,6x** alle ore 08-09 server (apertura) e 43-55x dalle 10 alle 16 [SOSPESA]. All'apertura la riga H1 sta **sul** pavimento di casa, non sopra.
- Mattino della live del 14/10: NON PRESENTE nel CSV (il CSV ha dati fino al 13/10): nessuna taratura.

## 4. Per mese (E5, dipende dai regimi, non dall'orologio)
Mediana ATR H1 da 37 (dic 2024) a 100,5 (apr 2025) e 117,6 (mar 2026). Sotto la frontiera (ATR < 45,33 = 40x) le mediane di 3 mesi su 24: ott 2024 (43,5), dic 2024 (37,5), gen 2025 (42,2); a cavallo (45,3-48,3): nov 2024, dic 2025, ago 2026. Alto (mar-apr 2025, mar-lug 2026): 72-118. La mediana su 24 mesi nasconde un'oscillazione 3x fra mesi.

## 5. Che cosa cambia (e cosa no)
- ✅ La riga H1 del cancello di costo della mappa del DAX **resta "passa" come mediana** (51,6x invece di 47,3x): il derivato non era sbagliato verso il pericoloso. La paura nata dalla live (ATR 37 = 32,6x) **non si conferma come valore tipico**.
- ⚠️ Pero' il cancello di costo non e' una proprieta' fissa dell'H1 sul DAX: dipende dal **regime del mese** e dall'**ora** (apertura sulla frontiera, notte sotto). Una sedia con stop = 1,5 × ATR(H1) all'apertura ha un costo relativo che varia, sulle mediane mensili, da ~33x (dic 2024) a ~104x (mar 2026). Non e' un verdetto su nessun motore: dice che per le sedie ATR-stop sul DAX serve leggere la distribuzione del costo, non la mediana.
- ❌ Non decide nessuna taglia, non promuove nessuna sedia, non riapre nessun cancello. Nessun candidato archiviato o promosso da questa lettura.

## 6. Limiti dichiarati
- Un feed (BCM), 24 mesi, due regimi di volatilita' molto diversi (non e' il 2010). Il numero e' descrittivo; la banda 48-60 era del 14/10, scritta prima.
- Spread orario da tick fino al 30/06/2026 (stagioni miste).
- L'orologio resta non confermato nelle stagioni 2024/25 e estate 2025: le letture per ora restano sospese.
- Contro-esempio provato dal lettore (autotest): sezione `--autotest` del lettore; non rieseguito qui oltre alla lettura reale.

## 7. Aggiunta dopo il cancello sul giro con Gemini (14/10)
Il cancello ha ricalcolato dal CSV con codice proprio: ATR di Wilder mediana 59,06 (contro 58,47 della media semplice), quindi la differenza fra le due definizioni NON spiega il 37-40, ma su una lettura singola Wilder non si esclude (barre del mattino con ATR in 37-40: 8,1% con la media semplice contro 6,3% con Wilder). Le barre del mattino da settembre 2026 in poi (estate, orologio confermato) hanno mediana 38,15 e il 53,2% delle letture <= 40: la spiegazione piu' corta del 37-40 e' **ora bassa + regime recente**. Dettagli: `docs/RISPOSTA_A_GEMINI_ATR_H1_DAX_2026-10-14.md`. Il conteggio 08/09 del 2024/25 non e' un'alternanza (z +1,21) e non cambia il verdetto del collaudo: orologio 2024/25 resta NON CONFERMATO.
