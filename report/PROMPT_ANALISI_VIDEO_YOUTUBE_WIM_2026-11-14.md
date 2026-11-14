# Prompt per Claude (Claude Code o Claude Desktop con terminale, sul tuo PC): trascrizione e fotogrammi di tutti i video di Wim su YouTube (14/11/2026)

**Dove lanciarlo**: sul PC di Claudio che ha internet e spazio (anche il PC di backtest va bene), NON sul VPS e NON su cartelle dei terminali MT5 (`C:\FTMO`, `C:\BCM_Reale`, `C:\MT5_*`). Serve un Claude che puo eseguire comandi (Claude Code, oppure Claude Desktop con accesso al terminale). Il browser da solo non basta: il pannello "Mostra trascrizione" non ha restituito testo. Con `yt-dlp` e `ffmpeg` (come per i video di ottobre: `.vtt` + fotogrammi ogni 20 secondi + `info.json`) funziona. Gli zip prodotti (ognuno < 10 MB) li carichi qui in chat. Per gli indirizzi dei 5 video della dashboard UBS vedi in fondo.

```
Lavori sul mio PC Windows (PowerShell) in SOLA LETTURA rispetto a YouTube: nessun login, nessun cookie, nessun commento scritto, nessuna iscrizione. Lavora in una cartella NUOVA e vuota C:\WIM_YOUTUBE (se non esiste creala; non toccare nessun'altra cartella, in particolare niente su C:\FTMO, C:\BCM_Reale, C:\MT5_MANUALE, C:\MT5_Wim, C:\ABTG). Non usare il VPS.

OBIETTIVO: per TUTTI i video del canale di Wim (Profalgo / Wim The Algo Trader / ForexEASolutions, canale https://www.youtube.com/@forexeasolutions e, se esiste, il canale personale di Wim con gli stessi video, controlla l'elenco) produrre per ogni video: trascrizione con minuti, un fotogramma ogni 20 secondi, descrizione e metadati. Poi zip da meno di 10 MB ciascuno, che mi servono per analizzarli.

PASSO 0 - Strumenti. Verifica con `yt-dlp --version` e `ffmpeg -version`. Se mancano: `pip install -U yt-dlp` (o `winget install yt-dlp.yt-dlp`) e `winget install Gyan.FFmpeg`. Non installare altro. Se un'installazione fallisce, fermati e dimmi l'errore.

PASSO 1 - Elenco completo (nessun download di video ancora):
  yt-dlp --flat-playlist --dump-json "https://www.youtube.com/@forexeasolutions/videos" > videos.jsonl
  Ripeti per le sezioni "streams" (dirette registrate) e "shorts" e per ogni playlist del canale. Se compaiono duplicati tieni un solo id.
  Crea 00_ELENCO.csv con: numero progressivo, id, titolo, data di pubblicazione, durata, visualizzazioni, indirizzo, tipo (video/diretta/short), categoria stimata dal titolo (UBS, Gold Reaper, Gold Phantom, Goldbot One, Gold Trade Pro, Daytrade Pro, Luna, ORB/Indicement, Bitcoin, prop firm, portafoglio/rischio, ottimizzazione, altro). Scrivimi in chat quanti video ci sono in totale e la durata complessiva, e ORDINA in questo modo di priorita: 1) UBS Optimizer app e UBS (tutti), 2) Gold Reaper, Gold Phantom, Goldbot One, Gold Trade Pro, Daytrade Pro, 3) prop firm, rischio, portafoglio, ottimizzazione, 4) tutto il resto, dal piu recente. Gli short (< 90 s) mettili per ultimi e salta il passo dei fotogrammi per loro.

PASSO 2 - Per OGNI video, in ordine di priorita, a gruppi di 10, senza chiedermi conferma tra un video e l'altro:
  a) Sottotitoli (niente video): 
     yt-dlp --skip-download --write-subs --write-auto-subs --sub-langs "en.*,it" --sub-format vtt --write-info-json --write-description -o "<cartella_video>\%(id)s" <url>
     Converti il .vtt in <id>_trascrizione.txt: una riga ogni 20-30 secondi con il minuto [mm:ss] e il testo senza le righe duplicate tipiche dei sottotitoli automatici. Tieni anche il .vtt originale. Se NON ci sono sottotitoli: segna "SENZA SOTTOTITOLI" nell'elenco e NON inventare; passa al video successivo (se vuoi, alla fine, trascrivi quei video con faster-whisper modello "small", solo se prima te lo ho chiesto io).
  b) Fotogrammi ogni 20 secondi: scarica TEMPORANEAMENTE il video a bassa qualita (360p o 480p, senza audio se possibile):
     yt-dlp -f "bv*[height<=480][ext=mp4]/bv*[height<=480]" -o "<cartella_video>\tmp.%(ext)s" <url>
     poi: ffmpeg -i tmp.mp4 -vf "fps=1/20,scale=960:-2" -q:v 5 "<cartella_video>\f_%04d.jpg"
     (il fotogramma numero N e al secondo (N-1)*20: scrivi in un file fotogrammi.txt la corrispondenza numero -> minuto). Appena finito CANCELLA il file tmp.mp4: non devo avere i video, solo testo e fotogrammi. Se un video dura piu di 90 minuti usa un fotogramma ogni 30 secondi e scrivilo.
  c) Informazioni extra per ogni video (dal info.json e dalla descrizione): titolo, data, durata, visualizzazioni, capitoli (con i minuti), descrizione completa, TUTTI i link nella descrizione (set file, pagine prodotto, manuali, sconti/affiliazioni: elencali ma non cliccarli), hashtag, e i 40 commenti piu in alto con le risposte di Wim: yt-dlp --skip-download --write-comments --extractor-args "youtube:max_comments=40,all,0,0" --write-info-json. Se i commenti sono disattivati scrivi "COMMENTI NON DISPONIBILI".
  d) Scrivi per ogni video un breve riepilogo.md: 8-12 righe in italiano di cosa dice (SOLO dalla trascrizione, citando i minuti), con una sezione "Numeri e impostazioni citati" (valori di rischio, DD, lotti, periodi di backtest, nomi di input, set file, versioni degli EA) con il minuto accanto a ciascuno, e una sezione "Novita o cambiamenti rispetto alle versioni precedenti". Non interpretare i fotogrammi in dettaglio e non riassumere cio che non e nella trascrizione: se un'informazione e solo a schermo scrivi "visibile nel fotogramma f_00NN, non letta".
  e) Comprimi ogni video in uno zip: <NN>_<id>_<titolo-breve>.zip contenente: trascrizione.txt, .vtt, info.json, descrizione.txt, riepilogo.md, fotogrammi.txt e la cartella dei fotogrammi. Se uno zip supera 9,5 MB, riduci i fotogrammi (scale=800, -q:v 7) oppure dividi in _parte1 e _parte2. Tutti gli zip < 10 MB.

PASSO 3 - Dopo ogni gruppo di 10 video, scrivi in chat: i numeri dei video fatti, quelli con problemi (senza sottotitoli, errore, 429 troppi richieste), e il nome degli zip. Se YouTube risponde 429 o blocca, aspetta 10 minuti e riprova; non usare cookie del browser, non usare proxy, non cercare di aggirare i blocchi: se continua, fermati e dimmelo.
Alla fine crea 00_ELENCO.csv aggiornato, 00_INDICE.md (per video: numero, titolo, data, durata, stato di ogni cosa: sottotitoli SI/NO, fotogrammi SI/NO, zip) e 99_PROBLEMI.md, e comprimili in 00_INDICE_E_ELENCO.zip.

REGOLE: non cancellare nulla fuori da C:\WIM_YOUTUBE; non mandare nulla a nessuno; non pubblicare niente; non cercare di aprire link di affiliazione o a pagamento; non dare consigli di acquisto o di lotto. Nessuna frase inventata: quando manca un dato scrivi "NON TROVATO".
```

## Dopo
Mi carichi gli zip qui (prima `00_INDICE_E_ELENCO.zip`, poi i gruppi di priorita 1 e 2). Leggo la trascrizione e i fotogrammi nei punti chiave, confronto con i test e il manuale UBS, ed estraggo cio che cambia per P1, P4, Reaper e UBS. Dei 5 video della dashboard UBS gli indirizzi sono: https://youtu.be/uPNzvBfIckQ, https://youtu.be/uOt1O8b6F1U (UBS APP VIDEO GUIDE V1.0, quello che ci manca), https://youtu.be/PLn70LlTRsw, https://youtu.be/RZpzy5F_C9I, https://youtu.be/OD3KpEL6IPg.
