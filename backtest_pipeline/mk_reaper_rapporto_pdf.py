import json
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.units import mm
d=json.load(open('gr_dati.json'))
out='GOLD_REAPER_RAPPORTO_DETTAGLIATO_TEST_2026-10-26.pdf'
ss=getSampleStyleSheet()
TT=ParagraphStyle('TT',parent=ss['Title'],fontSize=20,spaceAfter=4)
H1=ParagraphStyle('H1',parent=ss['Heading1'],fontSize=14,spaceBefore=12,spaceAfter=5,textColor=colors.HexColor('#1f3a64'))
H2=ParagraphStyle('H2',parent=ss['Heading2'],fontSize=11,spaceBefore=8,spaceAfter=3)
B=ParagraphStyle('B',parent=ss['BodyText'],fontSize=9,leading=12.2,spaceAfter=3)
S=ParagraphStyle('S',parent=B,fontSize=8,leading=10,textColor=colors.HexColor('#444444'))
C=ParagraphStyle('C',parent=B,fontSize=8,leading=10,spaceAfter=0)
BX=ParagraphStyle('BX',parent=B,backColor=colors.HexColor('#fff6e0'),borderPadding=4,borderColor=colors.HexColor('#e0b050'),borderWidth=0.5,spaceBefore=4,spaceAfter=6)
def P(t,st=B): return Paragraph(t,st)
def T(rows,widths,head=True,zebra=False,fs=None):
    data=[[P(str(c),C) for c in r] for r in rows]
    t=Table(data,colWidths=[w*mm for w in widths],repeatRows=1 if head else 0)
    st=[('GRID',(0,0),(-1,-1),0.3,colors.grey),('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),3),('RIGHTPADDING',(0,0),(-1,-1),3),('TOPPADDING',(0,0),(-1,-1),2),('BOTTOMPADDING',(0,0),(-1,-1),2)]
    if head: st.append(('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e8eef7')))
    t.setStyle(TableStyle(st)); return t
def n0(x): return '{:,.0f}'.format(x).replace(',','.')
def n2(x): return '{:,.2f}'.format(x).replace(',','X').replace('.',',').replace('X','.')
def foot(c,doc):
    c.saveState(); c.setFont('Helvetica',7); c.setFillColor(colors.grey)
    c.drawString(15*mm,8*mm,'The Gold Reaper MT5 - rapporto dettagliato dei test - 26/10/2026'); c.drawRightString(195*mm,8*mm,'pag. %d'%doc.page); c.restoreState()
doc=SimpleDocTemplate(out,pagesize=A4,leftMargin=15*mm,rightMargin=15*mm,topMargin=14*mm,bottomMargin=14*mm,title='The Gold Reaper MT5 - rapporto dettagliato dei test',author='Claudio Spadaro')
E=[]
E.append(P('The Gold Reaper MT5',TT))
E.append(P('Rapporto dettagliato di tutti i test eseguiti - 26 ottobre 2026',ParagraphStyle('sub',parent=B,fontSize=11,spaceAfter=8)))
E.append(P('Documento preparato per un secondo controllo indipendente. Ogni numero ha una fonte (file del repository del progetto, elencati in fondo). Quando un dato viene dal venditore o da terzi e scritto <b>DICHIARATO</b>; quando e una deduzione e scritto <b>INFERITO</b>; quando non lo sappiamo e scritto <b>NON VERIFICATO</b>. I test sono stati fatti da Claudio Spadaro sul PC di backtest con il suo terminale BCM Markets (server UTC+1 fisso), solo nello Strategy Tester: nessun conto reale, nessun grafico con l\'EA attaccato, nessun guardiano esterno.',B))
E.append(P('Sintesi',H1))
E.append(T([['Cosa','Risultato'],
['Corsa continua 21 mesi (01/01/2025-01/10/2026), set di Claudio, tick reali, 80.000 EUR','+59.796 EUR (+74,7%), PF 2,89, 791 operazioni, 591 vincenti (74,7%), drawdown equity 3.854 EUR (2,97% dal picco; 4,8% degli 80.000), 18 mesi positivi su 21'],
['Stessa corsa a 5.000 EUR','+3.970 (+79,4%), PF 2,88, DD equity 4,77% - le percentuali coincidono con quelle a 80.000 (lotto che scala col saldo)'],
['Stress di latenza 1.000 ms','-1,2% del netto (+59.068), DD 5,1%'],
['Costi extra ipotetici (0,30 USD/oncia a giro)','netto +56.579, PF 2,76: il secondo piu alto margine di costo fra 12 EA confrontati (5,68 USD/oncia; il primo e SomaGold con 6,06)'],
['Tre anni di regime diverso (Modello 1, 80.000)','2013 ribasso +27,2%; 2018 laterale +16,9%; 2020 rialzo +25,5%; calibrazione 2025 OK; criterio PROP-ANNI superato'],
['Giorni di perdita (solo realizzato)','0 giorni >= 3% sui 21 mesi; nel 2013 un giorno a -4,6%'],
['Punti aperti piu importanti','protezioni interne che potrebbero chiudere il flottante; posizioni aperte fino a 19 giorni e fino a 23 insieme nel 2013; orologio GMT dell\'EA non verificato su BCM; mai provato dal vivo']],[60,120]))
E.append(P('1. Metodo e regole del progetto',H1))
E.append(P('Ogni test e stato preceduto da un documento di <b>criteri e previsioni scritto prima di vedere i numeri</b> (nome file in fondo); i lettori dei report sono script congelati con autotest. Gli errori di impostazione trovati lungo la strada sono dichiarati (per esempio: il tester riusa l\'ultimo set di input salvato, per cui in ogni passata gli input imposti sono stati riletti dal report prima di guardare i risultati). Nessun risultato e stato scelto fra piu tentativi per apparire migliore; non c\'e stata nessuna ottimizzazione dei parametri.',B))
E.append(P('Convenzioni: "tick reali" = Modello 4 dello Strategy Tester (storico BCM; per l\'oro i tick reali esistono solo dal 10/07/2024); "Modello 1" = OHLC a 1 minuto (usato per gli anni 2013, 2018, 2020, con calibrazione sul 2025). Il giorno FTMO e calcolato a mezzanotte CE(S)T. "PF" = profit factor delle operazioni chiuse, commissioni incluse.',B))
E.append(P('2. L\'EA e le impostazioni',H1))
E.append(P('EA di terzi dal MQL5 Market (venditore: Wim), <b>versione demo</b> installata sul terminale BCM del PC di backtest; la versione a pagamento potrebbe differire. File .ex5 del 16/10/2026, 254 KB, SHA256 <font size="7">AB636AF9E912F6A0 ... F7E4</font> (impronta presa prima e ricontrollata dopo ogni passata: sempre uguale). Nome interno: The Gold Reaper MT5 (versione 5.4 nei report). Strategia dichiarata da una recensione di terzi: 8-9 strategie di breakout sull\'oro con ordini pendenti oltre livelli giornalieri, H4 e H1. Il codice non e leggibile (.ex5).',B))
E.append(T([['Input','Set di Claudio (usato quasi ovunque)','Default dell\'EA'],
['TradeFrequency','2','5'],['MaxAllowedDD','9,0','30,0'],['PropFirmMaxDailyDD','4,0','0,0 (spento)'],['OnlyUp','false','true']],[45,70,65]))
E.append(P('Tutti gli altri input sono ai valori di default (elenco completo in appendice A): StartLots 0,01, FridayStopHour=25 (cioe nessuno stop del venerdi), filtro NFP acceso (chiude posizioni e ordini 100 minuti prima e 60 dopo), AutoGMT=true con offset 2/3, MaxSpread 500 punti. Il file .set portato da Claudio contiene solo le impostazioni generali e di lotto, non i parametri delle singole strategie (stop loss, take profit, livelli): il meccanismo di uscita non e leggibile.',B))
E.append(P('3. Elenco cronologico dei test',H1))
E.append(T([['#','Data','Test','Condizioni','Esito'],
['1','16/10','Luglio 2026, default','5.000, tick reali, 1 mese','-66,83 (-1,3%), PF 0,60, 33 operazioni, DD equity 4,35%'],
['2','17/10','Luglio-settembre 2026, default','3 tranche mensili indipendenti da 5.000','PF aggregato 3,72 (0,60 / 4,00 / 8,44 per mese); lotti vivi 0,06 / 0,22 / 0,14'],
['3','19/10','21 tranche mensili, default','21 tranche da 5.000','+7.963,73, 1.019 operazioni, lotti fino a 0,06'],
['4','19-20/10','21 mesi continui, set di Claudio','5.000, tick reali','+3.969,57, PF 2,88, 791 operazioni'],
['5','20/10','21 mesi continui, set di Claudio','80.000, tick reali','+59.796,28, PF 2,89, 791 operazioni'],
['6','22/10','Stress di latenza','80.000, 200 ms e 1.000 ms','-0,3% e -1,2% del netto'],
['7','26/10','Giorni di perdita FTMO','80.000, realizzato','0 giorni >= 3%'],
['8','26/10','Costi extra (ipotesi)','80.000, +0,15/0,30/0,60 USD a giro','netto 58.158 / 56.579 / 53.421'],
['9','26/10','Tre anni di regime diverso','80.000, Modello 1','tutti positivi; PROP-ANNI superato'],
['10','26/10','Prova FTMO simulata, primi 12 mesi','80.000, anno 2025','+35%, +10% il 23/04/2025, nessuna violazione']],[7,14,42,50,67]))
E.append(P('4. Corsa continua a 80.000 EUR (test 5)',H1))
g=d['gr80k']
E.append(P('Condizioni (dal manifest e dal report): XAUUSD H1, 01/01/2025-01/10/2026 in una sola passata, qualita storico 100% (146.152.231 tick), deposito 80.000 EUR, leva 1:100, ExecutionMode 0, quattro input del set di Claudio confermati dal report, nessuno stop out, nessun "no money", durata 10.835 secondi. Errori nel giornale del tester: servizio GMT (4014) e modifica dello stop (4753): il filtro orario/news dell\'EA non e verificabile nel tester.',B))
E.append(T([['Misura','Valore'],
['Operazioni chiuse','%d (%d vincenti = %.1f%%, %d perdenti)'%(g['ops'],g['w'],100*g['w']/g['ops'],g['l'])],
['Netto / PF','+59.796,28 EUR / %s'%n2(g['pf'])],
['Vincita media / perdita media','+%s / %s EUR (payoff %s)'%(n2(g['avgw']),n2(g['avgl']),n2(g['avgw']/-g['avgl']))],
['Maggior vincita / maggior perdita','+%s / %s EUR'%(n2(g['maxw']),n2(g['maxl']))],
['Lotti d\'ingresso','da %s a %s, mediano %s'%(n2(g['volmin']),n2(g['volmax']),n2(g['volmed']))],
['Posizioni insieme (massimo)',str(g['mx'])],
['Permanenza in posizione','mediana %.1f h; 90 percentile %.1f h; massima %.0f h (circa %.0f giorni)'%(g['hold_med']*1,g['hold_p90'],g['hold_max'],g['hold_max']/24)],
['Lato','%d acquisti, %d vendite'%(g['buy'],g['sell'])],
['Commissioni totali del tester','%s EUR (circa 3,5 EUR a lotto a giro)'%n2(g['comm'])],
['DD equity','3.854 EUR (2,97% dal picco di equity; 4,8% degli 80.000 iniziali); DD del saldo piu basso'],
['Peggior giorno realizzato','-1.513,84 EUR (1,9% degli 80.000; -1,2% del saldo a inizio giorno), 23/04/2026'],
['Prima / seconda meta','gen 2025-mag 2026: +44.625,75; giu-set 2026: +15.170,53'],
['Costo del tester vs profitto','netto / costo = 27 volte (a K=3 resta +55.410)']],[60,120]))
E.append(P('Netto mensile (EUR, un solo conto che compone: i lotti crescono col saldo)',H2))
mon=g['mon']; ks=list(mon)
rows=[['Mese','Netto','Mese','Netto','Mese','Netto']]
for i in range(7): rows.append([ks[i],n0(mon[ks[i]]),ks[i+7],n0(mon[ks[i+7]]),ks[i+14],n0(mon[ks[i+14]])])
E.append(T(rows,[24,36,24,36,24,36]))
E.append(P('Mesi negativi: 2025.02 (-1.899), 2025.10 (-782), 2026.07 (-1.141). Mesi positivi 18 su 21 (85,7%%). Per anno: 2025 +%s (%d operazioni, PF %s); 2026 gen-set +%s (%d operazioni, PF %s).'%(n0(d['gr80k_2025']['net']),d['gr80k_2025']['ops'],n2(d['gr80k_2025']['pf']),n0(d['gr80k_2026']['net']),d['gr80k_2026']['ops'],n2(d['gr80k_2026']['pf'])),B))
E.append(P('Previsioni scritte prima (G1-G6) e verdetto',H2))
E.append(T([['#','Previsione','Esito'],['G1','il lotto scala (>0,02)','confermata (0,07-0,42)'],['G2','netto +40..+120%','confermata (+74,7%)'],['G3','DD <= 8% dal picco e <= 10% degli 80.000','confermata (2,97% / 4,8%)'],['G4','operazioni 633-949, posizioni <= 11','confermata (791; 11)'],['G5','rapporto lotto max/min 1,5-4','SBAGLIATA: 6,0 (0,42/0,07)'],['G6','la regola giornaliera interviene piu spesso','NON VERIFICABILE dal report']],[10,95,75]))
E.append(P('Cancelli del progetto: S-N (>= 150 operazioni) ok; S-M (>= 60% mesi positivi) ok; S-H (entrambe le meta positive) ok; S-DD (perdita dal deposito <= 10%) ok; S-COSTO (profitto medio >= 3 volte lo spread) ok (27x); <b>S-NOSCALA non passa alla lettera</b>: rapporto lotti 6,0 e 11 posizioni contro i limiti 3 e 10 (a 5.000 il lotto e schiacciato dal pavimento 0,01). Resta una violazione formale, da accettare o meno.',BX))
E.append(P('5. Stessa corsa a 5.000 EUR (test 4) e confronto',H1))
E.append(T([['','5.000 EUR','80.000 EUR'],['Netto','+3.969,57 (+79,4%)','+59.796,28 (+74,7%)'],['PF','2,88','2,89'],['Operazioni','791','791 (identiche)'],['DD equity dal picco','4,77% (2,67% dal deposito)','2,97% (4,8% degli 80.000)'],['Lotti','0,01-0,02','0,07-0,42 (mediana 0,14)'],['Posizioni insieme','11','11'],['Mesi positivi','18/21','18/21'],['Vincenti','74,72%','74,7%']],[45,65,70]))
E.append(P('A 5.000 il lotto minimo 0,01 non permette di scalare: il comportamento in percentuale e praticamente lo stesso, e questo e coerente con un lotto proporzionale al saldo. Il default dell\'EA, a mesi indipendenti da 5.000 per 21 mesi, ha dato +7.963,73 con 1.019 operazioni e lotti fino a 0,06 (non confrontabile: somma di 21 conti indipendenti).',B))
E.append(P('6. Stress di latenza (test 6)',H1))
E.append(T([['','Base 0 ms','200 ms','1.000 ms'],['Operazioni','791','791','787'],['Netto EUR','59.796,28','59.620,09 (-0,3%)','59.067,85 (-1,2%)'],['PF','2,89','2,88','2,82'],['DD equity','3.854 (4,8%)','3.909 (4,9%)','4.047 (5,1%)'],['Stop out / no money','0 / 0','0 / 0','0 / 0']],[40,45,45,50]))
E.append(P('Previsioni GL1-GL5 centrate (GL1: con 1.000 ms netto positivo fra -35% e 0%: risultato molto migliore, -1,2%). Soglia scritta: netto > 0 e PF > 1,10: passata. Limite: un ritardo fisso non e lo slippage che cresce con la volatilita o con i lotti; non e stato misurato. Requote, spread in notizia e latenza reale non sono nel tester.',B))
E.append(P('7. Giorni a rischio FTMO (test 7) e prova simulata (test 10)',H1))
E.append(P('Giorno FTMO a mezzanotte CE(S)T, soglie 3/4/5% del saldo a inizio giorno e 4.000 EUR fissi (5% di 80.000). Sul solo realizzato: 214 giorni attivi, <b>0 giorni con perdita >= 3%</b>, peggior giorno -1,2% (-1.514 EUR, 23/04/2026). FTMO misura sull\'equity, flottante compreso: il realizzato e un limite inferiore; l\'equity vera richiede l\'export delle barre M1 (non ancora fatto).',B))
E.append(P('Prova simulata (regole usate dal progetto, da riverificare sul contratto: perdita giornaliera 5%, perdita totale 10% dal capitale iniziale, obiettivo fase 1 +10%): partendo da 80.000 il 01/01/2025, nei primi 12 mesi +27.985 (+35%), PF 2,62, DD realizzato 3,3%, obiettivo +10% raggiunto il 23/04/2025, nessuna violazione.',B))
E.append(P('8. Costi: slippage, spread e commissioni (test 8)',H1))
E.append(P('Il tester contiene gia i tick reali BCM (quindi lo spread storico), una commissione di circa 3,5 EUR a lotto a giro (la demo BCM addebita 4,00) e <b>nessuna slippage</b>. La slippage dell\'oro non e misurabile con i dati disponibili: la demo BCM riempie esattamente al prezzo dell\'ordine (misurato su 2.149 uscite a stop, 3.121 a take profit e 5.653 ingressi pendenti: scarto 0,000) e sul conto reale non ci sono operazioni sull\'oro misurate. Gli extra sotto sono quindi <b>ipotesi</b> di sensibilita, sottratti al risultato senza ricalcolare il lotto.',B))
E.append(T([['Scenario','Extra per giro','Netto EUR','PF','DD realizz.'],['C0 (tester)','0','59.737 (commissione portata a 4,00)','2,91','-'],['C1 leggero','0,15 USD/oz (13 EUR/lotto)','58.158','2,83','3,4%'],['C2 medio','0,30 USD/oz (26 EUR/lotto)','56.579','2,76','3,4%'],['C3 duro','0,60 USD/oz (52 EUR/lotto)','53.421','2,61','3,6%']],[30,45,50,25,30]))
E.append(P('Margine di costo (extra per giro che azzera il netto): <b>5,68 USD per oncia</b>, calcolato sui lotti negoziati (122 lotti a giro), stabile fra il 2025 (4,26) e il 2026 (8,02). E il secondo piu alto fra i 12 EA confrontati dal progetto (SomaGold 6,06; gli altri vanno da -0,76 a 2,67). Limite: il costo ipotizzato non cresce con la dimensione dell\'ordine (qui fino a 0,42 lotti).',B))
E.append(P('9. Tre anni di regime diverso (test 9)',H1))
E.append(P('Anni scelti con una regola scritta prima dai soli prezzi D1 di BCM: LONG se l\'anno sale di almeno il 10%, SHORT se scende di almeno il 5%, altrimenti laterale. Negli ultimi 20 anni interi (2006-2025): 11 anni LONG, 7 LATERALI, 2 SHORT (2013 e 2015). Quindi i tre anni sono un controllo a campione. Modello 1 (OHLC 1 minuto) perche i tick reali dell\'oro iniziano il 10/07/2024; calibrazione: il 2025 rifatto a Modello 1 contro la corsa a tick reali (stesso segno, rapporto 0,5-2,0, correlazione mensile >= 0,5): rapporto 1,08, correlazione 0,99. Criterio PROP-ANNI (scritto prima): netto > 0, DD equity <= 8.000 EUR, nessuno stop out e nessun giorno >= 5% in tutti e tre gli anni.',B))
yrs=[('2013','SHORT','+21.757 (+27,2%)','1,63','5.621','3 / 1 / 0','-4,6% (-3.697)','-3,3%'),('2018','LATERALE','+13.535 (+16,9%)','1,51','5.504','0 / 0 / 0','-2,2% (-1.851)','-2,0%'),('2020','LONG','+20.388 (+25,5%)','1,87','3.839','0 / 0 / 0','-1,6% (-1.608)','-2,3%'),('2025','calibrazione','+30.457 (+38,1%)','2,77','3.077','0 / 0 / 0','-1,1% (-883)','-2,0%')]
E.append(T([['Anno','Regime','Netto','PF','DD equity','Giorni >=3/4/5%','Peggior giorno','Peggior mese']]+[list(y) for y in yrs],[14,22,32,12,18,26,32,24]))
E.append(P('Struttura delle operazioni per anno',H2))
rows=[['Anno','Operazioni','Vincenti','Vincita media','Perdita media','Lotti (min-max, mediano)','Posizioni insieme max','Permanenza max']]
for y in ('2013','2018','2020','2025'):
    s=d['y'+y]; rows.append([y,str(s['ops']),'%d (%.0f%%)'%(s['w'],100*s['w']/s['ops']),n2(s['avgw']),n2(s['avgl']),'%s-%s, %s'%(n2(s['volmin']),n2(s['volmax']),n2(s['volmed'])),str(s['mx']),'%.0f h (%.1f gg)'%(s['hold_max'],s['hold_max']/24)])
E.append(T(rows,[14,20,22,22,22,38,24,22]))
E.append(P('Netto mensile per anno (EUR)',H2))
rows=[['Mese']+['2013','2018','2020','2025']]
for m in range(1,13):
    r=['%02d'%m]
    for y in ('2013','2018','2020','2025'):
        v=d['y'+y]['mon'].get('%s.%02d'%(y,m)); r.append(n0(v) if v is not None else '-')
    rows.append(r)
E.append(T(rows,[20,40,40,40]))
E.append(P('Mesi negativi: 2013 gen, mar, lug, nov, dic (5 su 12); 2018 mar, set, nov (3 su 12); 2020 mar, giu, dic (3 su 12); 2025 feb, ott (2 su 12). Il peggior mese realizzato e -3,3% (2013), -2,0% (2018), -2,3% (2020). <b>Osservazioni:</b> nel 2013 (ribasso) l\'EA ha aperto fino a 23 posizioni insieme (contro 11 nel 2025) e un lotto massimo di 1,41; la permanenza massima e arrivata a 143,8 ore nel 2018. Sono dati da tenere presenti per la soglia sul numero di posizioni.',B))
E.append(P('10. Correlazione con gli altri EA del pacchetto e combinazioni',H1))
E.append(T([['Coppia (risultati giornalieri)','r'],['Gold Reaper - Gold Trade Pro','0,51-0,56'],['Gold Reaper - Goldbot One','0,41-0,46'],['Gold Reaper - The Gold Phantom','0,55-0,58'],['Gold Trade Pro - Goldbot One','0,42'],['Gold Trade Pro - Phantom','0,52'],['Goldbot One - Phantom','0,60']],[100,80]))
E.append(P('La soglia che il progetto si era dato (S-CORR: r <= 0,5 per coppia) non e rispettata per la maggior parte delle coppie dello stesso pacchetto: sono tutti EA sull\'oro che perdono insieme (per esempio aprile-maggio 2026). Gold Reaper + Goldbot One (step 6000) sullo stesso conto a 80.000, somma dei due test: netto +70.970, DD del saldo 4.5%, DD equity massimo rigoroso 8,8% (limite superiore: somma dei due DD), correlazione giornaliera 0,53 (0,67 sull\'equity), stesso peggior giorno (23/03/2026, -2,2%). La simultaneita intraday non si vede dai report.',B))
E.append(P('11. Cosa dicono il venditore e terzi (DICHIARATO, non verificato da noi)',H1))
E.append(P('Una recensione indipendente sul blog MQL5 (14/10/2026, v4.6; l\'autore dichiara di non essere affiliato ma ha link di affiliazione a un broker e vende un EA concorrente): 8 strategie di breakout sull\'oro con ordini pendenti; backtest a 0,01 lotti su 4.000 USD, feb 2020-set 2026, OHLC 1 minuto, commissioni zero: +9.578,50 USD, DD storico peggiore 8,46%; con tick reali nov 2025-apr 2026 il win rate scende dal 78,26% al 71,38%; stress test su 1.000 scenari: 664 superano il DD storico, P95 14,34%, P99 17,89%. La stessa fonte dice che <i>MaxAllowedDD</i> e un input di dimensionamento e non un tetto alla perdita. Il venditore dichiara +312% su Myfxbook: <b>non replicato da noi</b>. Altri blog commerciali citano DD live 30-41% e PF live 1,08: <b>NON VERIFICATI</b>, fonte promozionale. Esistono prodotti con nome simile (Gold Reaper EA di altro autore, Gold Reaper X): non sono questo.',B))
E.append(P('12. Limiti, rischi e cose non verificate',H1))
for t in ['<b>Protezioni interne.</b> MaxAllowedDD=9 e PropFirmMaxDailyDD=4 possono chiudere posizioni e ordini pendenti come un guardiano; dal report non si vede se siano mai intervenute. Con UseEquity=false non e chiaro se misurino saldo o equity. Non e stata fatta una prova con le protezioni spente.',
'<b>Orologio.</b> L\'EA ha AutoGMT=true con offset 2/3 (server GMT+2/+3 con ora legale USA); BCM e UTC+1 fisso. Nel tester il servizio per il GMT automatico non e raggiungibile (errore 4014) e il filtro NFP/news dell\'EA non e verificabile. Il comportamento su BCM in live non e misurato; per un altro EA della stessa famiglia (ORB Master) un offset sbagliato di un\'ora ha cambiato molto i risultati.',
'<b>Struttura delle posizioni.</b> Fino a 11 posizioni insieme nel 2025-2026 e 23 nel 2013 (Modello 1); permanenze fino a 457 ore (19 giorni) nella corsa continua: flottante potenzialmente grande e lungo. Il drawdown equity misurato e basso (2,97% dal picco) ma e un solo percorso storico.',
'<b>Scala dei lotti.</b> Con OnlyUp=true (default) il lotto non scende dopo le perdite; nel set di Claudio e spento. A 80.000 il lotto arriva a 0,42 (1,41 nel 2013).',
'<b>Un solo regime recente.</b> I 21 mesi a tick reali sono quasi tutti di oro in rialzo; il 2026 da gennaio a settembre e positivo per l\'EA. Gli anni vecchi sono a Modello 1 (calibrazione 2025 buona) e a prezzi molto piu bassi di oggi.',
'<b>Un solo anno laterale su sette</b> fra i test sui tre anni: un controllo a campione.',
'<b>Slippage non misurata</b> e demo BCM che non la simula; spread allargato in notizia non simulato.',
'<b>Mai provato dal vivo.</b> Il progetto prevede almeno 4 settimane su demo prima di qualsiasi reale. Acquisto, lotti e taglie sono decisioni di Claudio.']:
    E.append(P('- '+t,B))
E.append(P('13. Come replicare il controllo su un altro broker',H1))
E.append(P('Strategy Tester di MT5, Expert The Gold Reaper MT5 (demo dal Market), XAUUSD (nome esatto sul broker), periodo H1, 01/01/2025-01/10/2026, modello "Ogni tick basato su tick reali" (qualita storico 100%: dichiararlo se diversa), ritardo nessuno, ottimizzazione spenta, leva 1:100, deposito 5.000 o 80.000 nella valuta del conto (dichiararla). Impostare i quattro input del set (TradeFrequency=2, MaxAllowedDD=9.0, PropFirmMaxDailyDD=4.0, OnlyUp=false) e tenere gli altri ai default. <b>Aprire il report e leggere la sezione "Dati in ingresso" prima di guardare i numeri</b>: il tester riusa l\'ultimo set di input salvato per quell\'EA. Riportare: profitto netto, PF, operazioni, % vincenti, DD equity (assoluto e %), lotto minimo e massimo, posizioni insieme al massimo, mesi positivi, qualita storico, spread medio. Numeri diversi sono attesi (broker, feed e spread diversi): e un controllo incrociato, non una prova; non concludere da una sola corsa.',B))
E.append(P('14. Fonti nel repository (branch lavoro, cartella report/ e backtest_pipeline/)',H1))
for t in ['THE_GOLD_REAPER_ATTESE_2026-10-16.md; THE_GOLD_REAPER_LUGLIO_LETTURA_2026-10-16.md; THE_GOLD_REAPER_SET_ANALISI_2026-10-16.md',
'PACCHETTO_ORO_W1_LETTURA_2026-10-17.md; PACCHETTO_ORO_W2_LETTURA_2026-10-18.md; PACCHETTO_ORO_LUNGO_LETTURA_2026-10-19.md; CLASSIFICA_4_EA_GOLD_REAPER_2026-10-19.md',
'GOLD_REAPER_80K_ATTESE_2026-10-20.md; GOLD_REAPER_80K_LETTURA_2026-10-20.md (dati: risultati_archivio/GR80K_20261020)',
'GOLD_REAPER_LATENZA_ATTESE_2026-10-20.md; GOLD_REAPER_LATENZA_LETTURA_2026-10-22.md',
'GOLDBOT_ONE_E_GOLD_REAPER_INSIEME_2026-10-22.md',
'GIORNI_DD_GIORNALIERO_PROP_CRITERI/RISULTATI_2026-10-26.md; CLASSIFICA_CON_COSTI_CRITERI/RISULTATI_2026-10-26.md',
'TRE_ANNI_PROP_80K_3EA_CRITERI_2026-10-26.md; TRE_ANNI_PROP_80K_3EA_RISULTATI_PARZIALI_2026-10-26.md (dati: risultati_archivio/ANNO80K_TRE_EA_ZIP_1444)',
'CANDIDATI_REALE_E_PROP_2026-10-26.md; PACCHETTO_6_SU_12_SELEZIONE_CRITERI_2026-10-26.md',
'Lettori: backtest_pipeline/leggi_giorni_dd_prop.py, leggi_prop80k_anno.py, leggi_classifica_costi.py, leggi_tre_anni_80k.py (con --autotest)']:
    E.append(P('- '+t,S))
E.append(PageBreak())
E.append(P('Appendice A - Elenco completo degli input (dal report della corsa a 80.000 EUR)',H1))
inp=[x for x in d['gr80k_inputs'] if '=' in x and not x.startswith(('lijntje',))]
half=(len(inp)+1)//2
rows=[['Input','Input']]
for i in range(half): rows.append([inp[i][:70],inp[i+half][:70] if i+half<len(inp) else ''])
E.append(T(rows,[90,90]))
E.append(P('Appendice B - Glossario',H1))
E.append(T([['Termine','Significato'],['Tick reali (Modello 4)','simulazione con lo storico tick del broker (BCM), spread storico incluso'],['Modello 1','simulazione sulle barre OHLC a 1 minuto'],['PF','profit factor: somma delle vincite / somma delle perdite delle operazioni chiuse'],['DD equity','massima discesa dell\'equity (saldo + flottante) dal suo picco'],['Realizzato','solo operazioni chiuse; non vede il flottante'],['S-NOSCALA','cancello del progetto: al massimo 10 posizioni insieme e rapporto lotto max/min <= 3, niente martingala/griglia'],['PROP-ANNI','criterio del progetto per i tre anni di regime diverso'],['OnlyUp','il lotto non scende dopo le perdite']],[45,135]))
doc.build(E,onFirstPage=foot,onLaterPages=foot)
print('ok')
