# Test a fondo a 80.000 EUR dei primi 8 EA del Market: cosa si misura e soglie scritte PRIMA dei numeri (25/10/2026)

**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (25/10): preparare la riga del test a fondo a 80K per i primi EA da setaccio, da lanciare appena finisce il test del set di SomaGold. Capitale di riferimento fisso: **80.000 EUR (FTMO Pro)**. Qui si scrive COME si legge, prima di vedere un solo numero. Acquisti, taglie e lotti sono decisioni di Claudio, non mie.

## Quali EA e perche (dal setaccio del 24/10, `MARKET_SETACCIO80K_NUOVI_ANALISI_2026-10-24.md`)
Sono i gruppi 1 e 2 di quella tabella: operano (>= 10 operazioni in una passata) e hanno DD equity <= 10% a 80K nei due mesi, sull'oro, con i default. **Il setaccio non ha valore di merito**: sono due mesi. Ordine di lancio nella riga: prima i sei che NON risultano gia provati, poi **SixtyNine EA** e **Gold Snap** (esiste dal 20/10 una `RIGA_LANCIA_TRE_EA_80K.txt` con SomaGold + SixtyNine + Gold Snap: se Claudio l'ha gia lanciata e ha lo zip `EA3_80K.zip`, i risultati di quei due ci sono gia e si possono fermare; nel repo non c'e' nessun risultato, quindi NON so se li ha).

| # | EA | Nota dal setaccio (24/10) |
|---|---|---|
| 1 | Umbra Vault AI EA | 42 op, PF 16,4, lotti 2,4-2,7: coda da misurare |
| 2 | Vortex Turbo EA | 73 op, PF 2,5, lotti 0,4-3,4, Recovery=false |
| 3 | Microedge Neural Matrix EA | 36 op, PF 34,7: coda da misurare |
| 4 | Entry Points Pro Robot | 18 op, PF 1,34, lotti 0,03-0,23 |
| 5 | Rocket Breakout EA | 14/24 op, PF 1,21/1,66 |
| 6 | ORB Revolution | 11 op, nome da indice: strumento da confermare, l'oro potrebbe non essere il suo |
| 7 | SixtyNine EA | 92/119 op, PF 3,3/3,1 |
| 8 | Gold Snap | 13 op, tutte vincenti, lotti 3,6-4,3 |

**Fuori da questa riga, per scelta:** SomaGold (prima il test del set), Diagonal Resistance EA (serve un set di lotto), Aetheris Gold Stack (rosso: +167% in 2 mesi con impilamento, il rischio va capito prima), tutti i gruppi 3-10.

## Cosa si fa
Per ciascun EA **una corsa CONTINUA 01/01/2025 - 01/10/2026**, XAUUSD **H1**, ticks reali (Modello 4), deposito **80.000 EUR**, leva 1:100, input NON imposti. Script `DEEP80K_TESTER_TRANCHE.ps1` con `-Tranche 22` (gia usato il 19/10). Limiti dichiarati:
- **H1 e' la scelta di default del test, non il timeframe dichiarato dal venditore** (per SixtyNine il venditore dichiara H1 o H4: H4 non e' coperto qui).
- **Input non imposti**: restano quelli salvati dal tester per quell'EA su questo PC (cioe quelli del setaccio, default). Il lettore li confronta con il referto del setaccio; se differiscono, la corsa non vale come "default".
- Per ORB Revolution il simbolo giusto puo' non essere l'oro: un risultato brutto sull'oro NON e' un giudizio sull'EA.
- Un periodo di 21 mesi puo' coprire ottimizzazioni del venditore: per questo si guarda anche il **2026 da solo** (S-H e riga 2026).

## Soglie (invariate rispetto al 19/10, `MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md`; la corsa e' continua, quindi le soglie mensili si calcolano dai realizzi)
Un EA e' "candidato" solo se soddisfa TUTTE; altrimenti la riga dice quale soglia fallisce.
- **S-N**: >= **150 operazioni** nei 21 mesi (sotto: "NON MISURATO", non si decide; vale anche per le corse con poche operazioni e PF enorme).
- **S-M**: >= **60% dei mesi con realizzo positivo** E somma positiva (mesi dai realizzi per data di chiusura, costi del tester inclusi).
- **S-H**: somma positiva in **entrambe** le meta' (gen 2025 - mag 2026 / giu - set 2026). In piu', per ogni EA si riporta il **2026 da solo** (gen-set): se negativo, e' un campanello, non una bocciatura automatica.
- **S-DD**: perdita massima dal deposito (DD equity dal report) **<= 10% di 80.000** (8.000 EUR), DD mensile massimo **<= 15,2%**.
- **S-NOSCALA**: lotto massimo / minimo di apertura **<= 3** e mai piu di **10 posizioni aperte insieme**; niente martingala/griglia/mediazione, verificato dalla sequenza dei trade (lotto dopo una perdita; posizioni nello stesso verso aperte a prezzi crescenti). Se l'EA e' di questo tipo non e' "non buono": e' di un'altra classe di rischio e si valuta a parte.
- **S-COSTO**: profitto medio per operazione **>= 3 volte lo spread medio** (lo spread del tester sull'oro, da riverificare nel report). Il lettore scrive il rapporto e quale spread ha usato.
- **S-STAB**: solo se l'EA ha una componente casuale dichiarata; qui NON verificata: se il lettore vede che l'EA non e' ripetibile, e' NON VERIFICATO.
- **S-CORR / S-PORT**: dopo, sui soli EA che passano le soglie precedenti, con i realizzi giornalieri (stesso metodo di `correlazione_pacchetto.py`, ma con deposito 80.000: il tool congelato vuole 5.000, quindi calcolo a parte e lo dichiaro). Correlazione <= 0,5 per coppia (anche con Gold Reaper e Prop Firm Gold); DD combinato <= 10% di 80.000.

## Previsioni dichiarate ORA
- **P1**: corse valide per almeno 6 degli 8 (stato OK, senza stop out). Fiducia 75%.
- **P2**: **S-N fallisce** (< 150 operazioni) per almeno 4 degli 8: il setaccio ne ha viste 11-92 in due mesi, e 21 mesi sono circa 10 volte tanto solo se l'attivita e' uniforme. Fiducia 55%.
- **P3**: **nessun** EA passa TUTTE le soglie. Fiducia 60%. Se nessuno passa, la conclusione e' "nessuno da comprare da questa riga" e si scrive cosi.
- **P4**: per Umbra Vault, Microedge e Gold Snap (PF molto alto in pochi trade) il PF a 21 mesi scende sotto meta' di quello del setaccio. Fiducia 70%.
- **P5**: almeno un EA ha DD equity > 10% di 80.000 sui 21 mesi pur avendo avuto DD < 6% nei due mesi. Fiducia 50%.
- **P6**: il lotto massimo / minimo supera 3 in almeno 3 EA (scala col saldo o col rischio). Fiducia 50%.
- **P7**: ORB Revolution opera molto meno dell'ordine di grandezza dei 150 (strumento sbagliato). Fiducia 65%.

## Cosa NON si fa
Non si sceglie un EA perche ha fatto di piu. Non si cambiano periodo, simbolo o soglie dopo aver visto i numeri. Non si riusano i numeri del setaccio come merito. Non si fa nessun giudizio sul prezzo o sull'acquisto.

## Cosa NON misura
Slippage, ritardi, spread allargato in news, margine reale (oro nel tester circa 8.580 EUR/lotto contro 1.784 sul reale), regole di una prop da 80K, licenza della demo del Market su demo/real, qualunque prova dal vivo.

## Lettore
`backtest_pipeline/leggi_deep80k_nuovi.py` (congelato prima dello zip, con `--autotest`): legge `MANIFEST_DEEP80K.csv` e il report .htm di ogni cartella `DEEP80K_<TOKEN>`; stampa per EA S-N, S-M, S-H, 2026 da solo, S-DD, S-NOSCALA, S-COSTO, confronto degli input con il setaccio, e l'esito per soglia. Non decide acquisti.
