# Scalper Claudio 1.02, passata A (base) sul 1o trimestre 2025 a tick reali: RISULTATI (14/11/2026)

**Natura: MISURA dal tester** (BCM, Modello 4 tick reali: 15.346.257 tick di XAUUSD, 01/01/2025-01/04/2025, 10.000 EUR, EA `ABTG_ScalperClaudio.ex5` 1.02, input tutti imposti: uscita per posizione, lotto a piramide sul guadagno, recupero a zero, freno 20 EUR). Fonte: zip `ANNO_ORO_GRADINI_SCALPERCLAUDIO_20261114_2339_PARZIALE_0026` (giornali del tester). **Solo UNA passata delle sei e finita; il rapporto HTML non e stato salvato** (cartella `report` vuota): i numeri sono dal riepilogo che l'EA stampa nel giornale. Criteri e previsioni scritti prima: `EA_SOLO_POSITIVE_ACCELERAZIONE_CRITERI_2026-11-14.md`.

## Numeri (riepilogo dell'EA)
| | Valore |
|---|---|
| Saldo finale | **345,52 EUR** (da 10.000: **-9.654,48, -96,5%**) in 3 mesi |
| Posizioni aperte e chiuse | 23.962 (circa 380 al giorno) |
| Win rate (netto > 0) | 55,6% |
| PF | **0,29** |
| Vita media | 522,9 s; oltre 1 ora: 273 posizioni (1,1%) |
| Uscite | target 1.556 (6,5%); a zero 18.058 (75%); **freno 4.348 (18%)** |
| Scatti del freno | **639** (circa 10 al giorno di mercato); cesti in recupero 3.377 (quindi il **19% dei cesti in recupero finisce al freno**) |
| Lotto massimo usato | 0,04; posizioni aperte massime 8; perdita fluttuante massima -42,80 EUR |
| Misura S-9 (direzione) | 869.985 segnali: proseguito 43,2%, tornato indietro oltre la soglia 44,4% (conteggio gonfiato: vedi sotto) |
| Richieste al server | 913.085 in totale, **massimo 44.460 in un giorno**; **rifiuti 865.156** |
| Tempo di tester | **57,7 secondi** (non 20-60 minuti: la mia stima era sbagliata) |

## Previsioni (scritte prima) contro risultati
| | Previsione | Esito |
|---|---|---|
| S-1 / S-14 | win rate >= 90% / >= 97% | **FALSA**: 55,6% |
| S-2 / S-16 | il freno scatta almeno una volta all'anno | **vera** (639 in un trimestre) |
| S-3 | netto positivo in tutti e tre gli anni (25%) | **FALSA** nel solo periodo provato: -96,5% |
| S-4 | DD fluttuante almeno 3 volte il freno (40%) | **FALSA**: -42,80 = 2,1 volte |
| S-5 | >= 5% delle posizioni oltre 1 ora (70%) | **FALSA**: 1,1% |
| S-6 | costi oltre meta del profitto lordo (60%) | verosimilmente vera (netto negativo con 24.000 operazioni a 0,01-0,04 lotti: circa -0,40 EUR a posizione); non misurato per voce |
| S-9 | direzione prosegue in 45-55% (70%) | **43,2%**: appena sotto; reverse 44,4%: nessun vantaggio |
| S-10, S-12, S-13, S-15, S-17, S-18 | confronti con altre varianti | NON VALUTABILI (passate B-F non finite) |

## Difetti dell'EA che questa corsa mostra
1. **Spam di ordini a mercato chiuso**: 865.156 ordini rifiutati ("market closed") nelle ore di chiusura (per esempio 23:58-23:59 server), con picchi di 44.460 richieste al giorno. L'EA riprova a ogni tick. Gonfia anche i conteggi dei passi e dei segnali (S-9 contaminato). In live sarebbe un problema serio sul limite di richieste.
2. **Il recupero a zero ha un conto che non torna**: quando riesce, guadagna circa 0 (esce a zero meno i costi); quando non riesce, il freno chiude a -20. Con il 19% di fallimenti: +0 x 81% e -20 x 19% = circa -3,8 EUR per ogni cesto in recupero. Per essere in pari servirebbe una probabilita di recupero oltre il 99%.
3. **Nessun vantaggio nella direzione a 2 secondi** (43,2% contro 44,4%): il segnale non porta informazione.
4. **Costi**: 24.000 posizioni a lotti piccoli: lo spread pesa piu del possibile profitto.

## Cosa NON dice
Una passata, un trimestre, un solo insieme di parametri; il rapporto HTML manca, quindi niente PF per voce di uscita; il tester non ha slippage ne latenza (in live sarebbe peggio); il blocco dopo la passata non e spiegato (il tester e finito, il terminale e uscito con codice 0, ma il file del rapporto non c'e).
