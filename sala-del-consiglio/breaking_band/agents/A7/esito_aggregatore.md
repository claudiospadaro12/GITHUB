# Verifica indipendente dell'aggregatore di conferma forex (A7, ciclo 2, 02/11/2026)
Oggetto: `agents/A4/agg_conferma.py` (sha256 `1c8e365c2ef7a66679be92000d902a3b72b3b5029984c2bbd005d6ee4ce08cbc`) e `test_agg_conferma.py` (`528c1c36...`). Criteri: `congelati/criteri_conferma_forex_v1.md` (sha256 `0125e484...`, = HASH_DOCUMENTI_ESTENSIONE) + D010. Codice del run (engine/signals/params/run_test) = v2 (verificato file per file). Nessun CSV degli anni nuovi toccato (non sono qui); nessun CSV letto in assoluto. Evidenze in `agents/A7/`.
**Metodo.** Ho scritto da zero `agg_indipendente.py` leggendo SOLO il documento dei criteri, D010 e il formato dei JSON di `final/run_forex/EURUSD.json`; ho letto `agg_conferma.py` solo dopo aver finito scenari e confronto.
Stati: SUPERATO / FALLITO / NON_ESEGUITO.

## Sintesi
| Punto | Stato |
|---|---|
| (1) Riscrittura indipendente criteri 1-5 + verdetto | **SUPERATO** (`agg_indipendente.py`) |
| (2) 15 scenari sintetici con esito scritto a mano, confronto con A4 | **SUPERATO: 15/15 atteso = mio = A4**, 0 divergenze; stessi IC90, medie, pareggio (differenza < 1e-9), stesse 5 condizioni, stessa lettura alternativa (`scenari_aggregatore_esito.txt`) |
| (3) Controlli di integrita | **SUPERATO: 13/13 anomalie segnalate** con `controlli_integrita_ok=false` (`integrita_aggregatore_esito.txt`); 1 osservazione (tf) e 1 RISCHIO OPERATIVO (sotto, R1) |
| (4) L'aggregatore NON legge CSV | **SUPERATO** (audit hook di Python: 0 aperture di .csv, 0 listdir/glob/subprocess/socket; un CSV esca accanto ai JSON non e stato aperto) (`aggregatore_non_legge_csv_esito.txt`) |
| (5) Scelte non dichiarate che cambierebbero un verdetto | vedi sezione 5: nessuna cambia il verdetto sui dati disponibili; 2 rischi operativi da correggere/dichiarare PRIMA di aprire i nuovi CSV |
| Test di A4 (16) rieseguiti | OK; riproducibilita dell'aggregatore: due esecuzioni identiche byte per byte (JSON) |

**Giudizio: l'aggregatore calcola correttamente criteri 1-5 e verdetto secondo il documento e D010. Puo essere usato sui nuovi anni, con le due cautele operative R1 e R2.**

## 1-2. Scenari (esito atteso scritto a mano PRIMA di eseguire)
Costruzione: JSON nel formato di run_test.py (template EURUSD, periodi 2015/2017/2019/2022, LOG_TRADE e T2 ricostruiti, `sha256_risultati` ricalcolato col JSON canonico), 4 coppie.
| # | Scenario | Atteso | Mio | A4 |
|---|---|---|---|---|
| 01 | 4x12 trade, 11 vincite +0,30 e 1 perdita -1,0, settimane distinte | CONFERMATO | = | = |
| 02 | N=28 tutto positivo | INCONCLUSIVO | = | = |
| 03 | N=30 (limite) tutto +0,30 | CONFERMATO | = | = |
| 04 | N=29 | INCONCLUSIVO | = | = |
| 05 | solo cond.2 falsa (N=32, IC90 contiene 0, media 0,097) | NON DIMOSTRATO | = | = |
| 06 | solo cond.3 falsa (wr 66,7% < 80%, media 0,43) | NON DIMOSTRATO | = | = |
| 07 | solo cond.4 falsa (una coppia +3,0 trascina; le altre -0,25) | NON DIMOSTRATO | = | = |
| 08 | solo cond.5 falsa (media 0,042, IC [0,01; 0,07]) | NON DIMOSTRATO | = | = |
| 09 | media 0, IC90 ~[-0,012; 0,012] (contiene 0, sup < 0,05): D010 | NESSUN VANTAGGIO RILEVANTE (alternativa letterale: NON DIMOSTRATO) | = (anche l'alternativa) | = (anche l'alternativa) |
| 10 | tutto -0,30 | NESSUN VANTAGGIO RILEVANTE | = | = |
| 11 | media -0,1, IC largo (sup ~0,16) | NON DIMOSTRATO | = | = |
| 12 | pareggio CON costo (D=0,5, c=0,1): wr 91,7% supera 90,7% (senza costo) ma non 93,6% (con costo) | NON DIMOSTRATO (cond.3 falsa) | = | = |
| 13 | blocchi settimanali CONDIVISI: 12 settimane comuni alle 4 coppie, 10 vincite +0,3 e 2 perdite -0,8 (con blocchi per coppia sarebbe CONFERMATO) | NON DIMOSTRATO (cond.2 falsa) | = | = |
| 14 | costo extra: media 0,06 (0,06-0,05 > 0) | CONFERMATO | = | = |
| 15 | costo extra: media 0,04 annulla | NESSUN VANTAGGIO RILEVANTE (IC sup 0,04 < 0,05; cond.5 falsa) | = | = |
Stabilita al seme: per tutti i 15 scenari il mio esito non cambia con 30 semi diversi. I casi "una sola condizione falsa" (05-08) danno tutti NON DIMOSTRATO per la regola residua (vedi O2).

## 3. Controlli di integrita (scenario CONFERMATO come base)
Tutti i casi manomessi danno `controlli_integrita_ok=false` in A4, con il controllo giusto in `controlli_falliti`: R modificato con hash non aggiornato (`sha256_risultati_ricalcolato` + `log_trade_coerente_con_T2_POOLED_H1`); sha256 sostituito; R modificato E hash ricalcolato (preso dal confronto log/T2: il mio controllo, piu debole, NON lo vedeva); trade tolto dal log; engine.py diverso da v2; codice v1 al posto di v2; PARAMETRI_NON_CONGELATI_PROVA; hash dei CSV non coincidenti; anni sbagliati (2013/2018/2020/2025-26); periodo mancante; simbolo diverso dall'etichetta; coppia mancante; stesso JSON usato per due coppie. Il caso nessuna-modifica da `true`. Solo `tf` senza M30 non e controllato (irrilevante per l'ipotesi primaria H1).
**Nota per l'uso:** `hash_dati_csv_coincidono` e `codice_v2_congelato` sono "non verificabili" (cioe `controlli_integrita_ok=false`) se run_test.py e lanciato SENZA `--hash-dati` o l'aggregatore SENZA `--hash-codice`. Per i nuovi anni servono quindi: un file HASH_DATI dei 16 CSV registrato prima, `run_test.py --hash-dati` e `agg_conferma.py --hash-codice congelati/HASH_CODICE_V2.txt`.

## 5. Ispezione dell'aggregatore: scelte non dichiarate
Coincidono con le mie letture, e D010 le conferma: pareggio dal log `(S+c)/(S+D)` con S=3, blocchi per settimana condivisi, media semplice nel leave-one-pair-out, costo extra = media - 0,05, precedenza NVR. Sono risultate non dichiarate (o implicite) nel documento:
- **S1 seme del bootstrap 20261101** (come run_test): il documento non lo fissa. Sensibilita sui dati in-sample (4 coppie, vecchi anni, N=64): limite inferiore IC90 tra 0,064 e 0,073 su 200 semi (0 semi con lo <= 0). Non cambia verdetto lontano dalla soglia; vicino a 0 potrebbe: il seme e FISSATO nel codice e nell'intestazione.
- **S2 statistica del replicato** = rapporto somma R / numero di trade dei blocchi estratti (non media delle medie settimanali). Sui dati in-sample: lo 0,0699 contro 0,1066 (media delle medie): non cambia verdetto, ma e una scelta (identica a run_test).
- **S3 blocco** = settimana di calendario condivisa tra coppie (D010). Alternative (blocco coppia x settimana, 2 settimane, nessun blocco) sui dati in-sample: lo tra 0,068 e 0,071, verdetto invariato. Nello scenario 13 (coppie perfettamente correlate nella stessa settimana) la scelta CAMBIA il verdetto (CONFERMATO se per coppia): la scelta condivisa e quella conservativa.
- **S4 settimana** presa dal campo `settimana` del log (non ricalcolata dall'`entry_time`): l'integrita e protetta solo dallo sha256 del JSON. Non cambia verdetto.
- **S5 pareggio con costo** usa lo spread d'INGRESSO (`c_atr`) anche per gli short, mentre il costo realmente pagato dagli short e quello d'uscita; differenza trascurabile (spread BCM 0-4 punti). Non cambia verdetto.
- **S6 quantile** `numpy` lineare: metodi alternativi spostano il limite di ~0,0001. Nessun effetto.
- **S7 uguaglianze esatte**: `media - 0,05 > 0` e `IC sup < 0,05` in virgola mobile; un esito esattamente a 0,05 e a rischio di arrotondamento (non testato, improbabile con dati reali).
**Cosa cambierebbe un verdetto:** solo S3 (e S2 in casi limite vicini a lo = 0). Tutte le altre no.

## Osservazioni e rischi operativi
- **R1 (RISCHIO OPERATIVO, da correggere o dichiarare):** quando `controlli_integrita_ok=false` il verdetto NON viene invalidato: `VERDETTO.esito` resta "CONFERMATO" (anche nel `.md` in testa), la riga stampata dalla CLI e `OK ... VERDETTO=CONFERMATO ...` senza lo stato di integrita, e il codice di uscita e 0. Chi legge solo il titolo o l'exit code puo prendere per valido un verdetto di input manomesso. Raccomandazione: esito = "NON VALIDO (integrita)" o stampa/exit code diversi quando integrita falsa; in alternativa, regola scritta: "un verdetto con controlli_integrita_ok=false non vale". (Non e un errore di calcolo.)
- **R2:** il docstring cita l'opzione `--hash-documenti-conferma`, ma l'argparse non la implementa (`unrecognized arguments`). L'aggregatore registra comunque lo sha256 dei criteri (0125e484..., = HASH_DOCUMENTI_ESTENSIONE) senza confrontarlo: confronto da fare a mano o con l'opzione.
- **O1:** il controllo `seme_e_replicati_coincidono` legge SEED e N_BOOTSTRAP dall'intestazione di run_test, non dalle costanti dell'aggregatore (coincidono: 20261101 e 10000).
- **O2:** il documento non dice cosa fare se N>=30, IC90 tutto sopra 0, ma una condizione 3-5 e falsa e il limite superiore e >= 0,05. A4 e io leggiamo NON DIMOSTRATO (resto). Se C0 intendesse altro ("NON CONFERMATO"), va deciso PRIMA di aprire i CSV.
- **O3:** nessun controllo su `tf` del JSON.
- Limiti della mia verifica: JSON sintetici costruiti da me (template EURUSD); il formato dei JSON dei nuovi anni sara quello di run_test v2; i nomi dei periodi dipendono da `--periodi` (devono essere 2015, 2017, 2019, 2022 esatti, altrimenti `periodi_attesi` falso).
