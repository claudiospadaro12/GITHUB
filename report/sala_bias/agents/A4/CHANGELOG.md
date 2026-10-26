# CHANGELOG A4 (SALA-BIAS-001, replica + studio S1)

## v1 (26/10/2026) - unica versione dei risultati
Nessuna modifica dopo aver visto i numeri dei rendimenti: lo studio e' stato eseguito UNA volta (replica spec. letterale) e UNA volta nella
variante descrittiva pre-dichiarata `--ema-valid-mult 1`; entrambe danno esito C. Nessun risultato e' stato scartato o sostituito.

Cronologia (tutto PRIMA del congelamento SHA256 e di qualunque rendimento reale):
1. Prima esecuzione dell'autotest rapido: 3 FAIL, tutti ERRORI DEL TEST (non del codice della replica), corretti nel test e riesecuzione completa:
   - T3b (simmetria specchio su D1 reale): costante di specchio K=1e7 -> arrotondamento di K-P > 1e-9 su 4094 barre (max diff < 5e-3); passata a K=1e4 e soglia 1e-6 (risultato: 0 barre fuori soglia, max 1.0e-10).
   - T6c/T6d (BOS su zigzag a mano): la discesa che avevo costruito faceva un minimo piu' basso (HH/LL, sMS=0,4 corretto per la specifica); riscritto il caso come zigzag ascendente che termina con un nuovo rialzo (HH/HL + BOS: sMS=1,0).
   - T8a (conservazione barre nella fusione): il confronto escludeva per errore la domenica 2004-06-13 (fusa nel lunedi' 2004-06-14); corretto l'insieme di confronto.
   Inoltre T3a: tolleranza portata da 1e-9 a 1e-7 (max misurato 8.3e-10, arrotondamento di K-P) per non avere un test fragile. Nessuna formula della replica e' stata modificata.
2. Test mutante (copia temporanea cancellata): inserito di proposito un look-ahead negli swing -> T12, T13, T9 e T10 FALLISCONO (differenze fino a 24 punti): i test di causalita' sono capaci di fallire.
3. Studio provato su dati sintetici (serie e score casuali, poi cancellati) per il debug del codice statistico; poi SHA256 (SHA256_CONGELAMENTO.txt, 09:38:30), poi esecuzione sui dati reali.
4. Verifica indipendente di alcuni numeri chiave dello studio con uno script a parte (medie BULL/BEAR h=20, t di Welch offset 0 e 4): coincidono (0,8466% / 0,6324% / spread 0,2142%; t 0,8595 e 0,4051).

## Risultati (per completezza, versione unica)
Replica spec. letterale (studio_S1_output.txt): esito C. Variante EMA valida da n barre (studio_S1_varN_output.txt, solo descrittiva): esito C.
