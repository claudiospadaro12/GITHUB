from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.units import mm
import sys
out=sys.argv[1] if len(sys.argv)>1 else 'GOLD_REAPER_RISPOSTA_AI_SEI_PASSI_2026-10-27.pdf'
ss=getSampleStyleSheet()
TT=ParagraphStyle('TT',parent=ss['Title'],fontSize=17,spaceAfter=4)
H1=ParagraphStyle('H1',parent=ss['Heading1'],keepWithNext=1,fontSize=12.5,spaceBefore=10,spaceAfter=4,textColor=colors.HexColor('#1f3a64'))
B=ParagraphStyle('B',parent=ss['BodyText'],fontSize=9.2,leading=12.4,spaceAfter=3)
C=ParagraphStyle('C',parent=B,fontSize=8.3,leading=10.4,spaceAfter=0)
S=ParagraphStyle('S',parent=B,fontSize=8,leading=10,textColor=colors.HexColor('#444444'))
BX=ParagraphStyle('BX',parent=B,backColor=colors.HexColor('#fff6e0'),borderPadding=4,borderColor=colors.HexColor('#e0b050'),borderWidth=0.5,spaceBefore=4,spaceAfter=6)
def P(t,st=B): return Paragraph(t,st)
def T(rows,w):
    t=Table([[P(str(c),C) for c in r] for r in rows],colWidths=[x*mm for x in w],repeatRows=1)
    t.setStyle(TableStyle([('GRID',(0,0),(-1,-1),0.3,colors.grey),('VALIGN',(0,0),(-1,-1),'TOP'),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e8eef7')),('LEFTPADDING',(0,0),(-1,-1),3),('RIGHTPADDING',(0,0),(-1,-1),3),('TOPPADDING',(0,0),(-1,-1),2),('BOTTOMPADDING',(0,0),(-1,-1),2)])); return t
def foot(c,d):
    c.saveState(); c.setFont('Helvetica',7); c.setFillColor(colors.grey); c.drawString(15*mm,8*mm,'Risposta ai sei passi di verifica - The Gold Reaper - 27/10/2026'); c.drawRightString(195*mm,8*mm,'pag. %d'%d.page); c.restoreState()

doc=SimpleDocTemplate(out,pagesize=A4,leftMargin=15*mm,rightMargin=15*mm,topMargin=14*mm,bottomMargin=14*mm,title='Risposta ai sei passi di verifica del Gold Reaper',author='Claudio Spadaro')
E=[]
E.append(P('Risposta ai sei passi di verifica del Gold Reaper',TT))
E.append(P('Preparata il 27/10/2026 per Massimo e per il suo Claude. Seguito della risposta del 26/10 e del "Rapporto dettagliato dei test". Ogni numero è del Strategy Tester (BCM, 80.000 EUR, tick reali) salvo dove scritto; dove non è misurato lo diciamo.',S))
E.append(P('In breve',H1))
E.append(P('L\'ordine proposto è giusto e lo seguiamo. <b>Dei sei passi, uno è fatto (il 2) e ha dato un risultato diverso da quello atteso</b>; gli altri aspettano il PC di backtest (un giro alla volta). Tre cose nuove da sapere: (a) <b>le protezioni interne al 9% e al 4% non hanno cambiato nemmeno un\'operazione in 21 mesi</b>, e <b>MaxAllowedDD=0 manda l\'EA al lotto minimo</b>: questo conferma la recensione indipendente, MaxAllowedDD è almeno in parte un input di dimensionamento; (b) il giro "protezioni spente" va rifatto separando i due input; (c) <b>sul conto Swing il margine sull\'oro è il vero rischio del passo 5</b>: con la leva sui metalli a 1:9 (secondo la scheda FTMO che abbiamo in archivio, da riverificare) il picco dei 21 mesi usa circa l\'81% del saldo.',B))
E.append(P('Stato dei sei passi',H1))
E.append(T([['#','Passo','Stato oggi','Cosa serve'],
['1','Equity minima giornaliera da barre M1 (21 mesi + 2013), contro il saldo di mezzanotte CE(S)T; soglia -4% sulla stima pessimistica','<b>Non fatto.</b> Script di export e lettore dell\'equity scritti e provati su dati di prova, mai lanciati sul PC di backtest. Oggi c\'è solo il realizzato: peggior giorno -1,2% (-1.514 EUR), 0 giorni con perdita >= 3% sui 21 mesi; nel 2013 un giorno a -4,6%.','Lanciare l\'export (pochi minuti) per 21 mesi e per il 2013. Accettiamo la soglia -4% e la lettura pessimistica (estremo della barra); si riportano anche la lettura centrale e i giorni fra -3% e -4%. Il 2013 è a Modello 1 (OHLC), quindi per l\'anno vecchio l\'equity è solo indicativa.'],
['2','Giro con le protezioni spente (21 mesi, 80k)','<b>Fatto il 27/10</b> (vedi sotto). Esito inatteso.','Rifare separando i due input (vedi sotto).'],
['3','Posizioni attorno a CPI e FOMC 2025-2026','<b>Non fatto.</b> Da qui non riusciamo a leggere i calendari ufficiali.','<b>Accettiamo l\'offerta: mandateci le date e gli orari</b> (FOMC: giorno e ora del comunicato; CPI: giorno e ora), meglio con la fonte. Poi si contano le posizioni aperte da 60 minuti prima a 60 minuti dopo ogni evento, dal report dei 21 mesi (791 operazioni).'],
['4','Stop esterno al 3% e al 4% sull\'equity ricostruita','<b>Non fatto</b>: dipende dal passo 1.','Si misura costo in netto, giorni salvati, posizioni tagliate che sarebbero rientrate. Vedi sotto.'],
['5','Venerdì (Standard) oppure margine a leva ridotta (Swing)','<b>Margine: stima fatta ora</b> (vedi sotto). Test del venerdì: non fatto.','Dipende da una scelta di Claudio: conto Standard o Swing. Per lo Standard servono due giri con FridayStopHour più basso e FridayCloseOpen attivo.'],
['6','Forward su demo, almeno 4 settimane','Non iniziato, dopo i passi 1-5.','Licenza in affitto o acquisto: decisione di Claudio. Free Trial FTMO per spread, slippage, orologio e filtro news.']],[7,45,63,65]))
E.append(P('Passo 2: protezioni spente, cosa è uscito',H1))
E.append(T([['','Protezioni 9% / 4% (set di Claudio)','MaxAllowedDD=0, PropFirmMaxDailyDD=0'],
['Netto 01/01/2025-01/10/2026','+59.796','+3.620'],
['PF / DD equity (tester)','2,89 / 3.854 (4,8% di 80.000)','2,79 / 238'],
['Operazioni','791','791 (stesse: 1.582 deal con gli stessi istanti e le stesse direzioni, verificato deal per deal)'],
['Lotto per operazione','0,07-0,42, medio 0,154','0,01 su tutte e 791']],[45,60,75]))
for t in ['<b>Le protezioni a 9% e 4% non sono mai intervenute</b> in 21 mesi: nessuna operazione aperta, chiusa o saltata in più o in meno. Questo vale per il DD complessivo (il massimo del tester è il 4,8%, lontano dal 9%) e per il limite giornaliero a 4% (il peggior giorno realizzato è -1,2%).',
'<b>MaxAllowedDD=0 non spegne un freno: abbassa il lotto al minimo.</b> Coerente con la recensione secondo cui è un input di dimensionamento. Quale dei due input faccia scendere il lotto, <b>NON MISURATO</b> (sono stati cambiati insieme); che il lotto sia proporzionale a MaxAllowedDD è solo un\'ipotesi.',
'Il criterio "netto positivo e DD equity sotto il limite con margine" è soddisfatto <b>dal set di Claudio</b>: +59.796 e DD equity 4,8% contro il 10%, ma è un solo percorso storico. La corsa a 0 non lo misura perché cambia la dimensione.',
'<b>Prossima corsa proposta (circa 3 ore):</b> solo PropFirmMaxDailyDD=0, MaxAllowedDD=9 invariato. Se le operazioni escono identiche, il limite giornaliero non ha mai agito con lotti veri. Per MaxAllowedDD come limite (e non come lotto) il tester non permette di separarlo: servirebbe vederlo agire dal vivo.']:
    E.append(P('- '+t,B))
E.append(P('Passo 5: margine sull\'oro a leve diverse (stima dai deal del report dei 21 mesi)',H1))
E.append(T([['Misura','Valore'],
['Posizioni aperte insieme, massimo (21 mesi)','14 (19/02/2025); nel 2013 fino a 23 (lotti 2013: NON MISURATI)'],
['Lotti aperti insieme, massimo','2,22 (12 posizioni, 27/03/2025); 2,0 lotti a 4.452 il 19/08/2026'],
['Picco di nozionale','circa 890.000 USD (19/08/2026; l\'oro nei 21 mesi va da 2.636 a 5.263)'],
['Margine rispetto al saldo, picco, leva 1:100 / 1:30 / 1:9','7% / 24% / 81% (27/03/2025, 11 posizioni, 1,93 lotti, oro a 3.056, saldo 81.180)']],[70,110]))
E.append(P('Lettura: a 1:100 e a 1:30 il margine tiene; <b>a 1:9, la leva che la nostra scheda FTMO indica per i metalli sul conto Swing, il margine arriva a circa l\'81% del saldo</b> già con un\'oscillazione normale, e col flottante negativo sarebbe vicino al margin call. Nota: la proposta parla di "leva 1:30"; per i metalli sullo Swing la nostra scheda dice 1:9 (forex 1:30, indici 1:15) da riverificare sulla pagina ufficiale prima di scegliere. Metodo: nozionale = lotti aperti x 100 once x prezzo dell\'ultima operazione, diviso la leva, rapportato al saldo del report (euro contro dollari, senza cambio: ordine di grandezza). Il tester ignora la leva del .ini e il margine dell\'oro di BCM è fisso, quindi la leva non si può testare girando: si calcola dai deal. Con CheckMargin=true l\'EA su 1:9 rifiuterebbe ingressi, e il risultato reale sarebbe diverso dal tester (<b>NON MISURATO</b>).',B))
E.append(P('Sullo Standard il test del venerdì è obbligatorio: la scheda FTMO dice che sul conto funded Standard le posizioni vanno chiuse poco prima della chiusura del fine settimana. Con il set di Claudio (FridayStopHour=25, cioè nessuno stop) il Reaper ha tenuto aperte posizioni 20 venerdì su 91 alle 21:00 server, fino a 5 insieme (1,19 lotti), e 31 posizioni hanno attraversato il fine settimana (somma dei risultati finali +540 EUR, 10 perdenti su 31). Propongo due giri da 21 mesi con FridayCloseOpen=true e FridayStopHour a due valori da fissare prima del lancio (propongo 20 e 22 ora server BCM), criteri: netto positivo, DD equity <= 8.000 EUR, nessuna posizione aperta al venerdì sera.',B))
E.append(P('Passo 4: lo stop esterno, con cautela',H1))
E.append(P('Sulle stime di equity (passo 1) si applica la regola "chiudi tutto se la perdita del giorno raggiunge il 3% o il 4% del saldo di mezzanotte, nessun nuovo ingresso fino alla mezzanotte successiva". Si riportano: costo in netto, giorni salvati, posizioni tagliate che sarebbero rientrate. Due ragioni di prudenza già misurate: sugli EA Umbra e Microedge le guardie dei venditori al 5% hanno trasformato flottante in perdita e il netto a 21 mesi è sceso del 41% e del 69%; e sul reale il Guardian ha vissuto la stessa dinamica. <b>Se l\'equity ricostruita non mostra nessun giorno oltre -3%, lo stop non scatta mai e costa zero nel test</b>: sarebbe solo un\'assicurazione, da valutare sul rischio di coda e non sul netto. Limite: la simulazione non sa se l\'EA si comporterebbe diversamente dopo il taglio.',B))
E.append(P('Passo 6: l\'orologio e il filtro news',H1))
E.append(P('Gli offset dell\'EA (AutoGMT con 2 inverno e 3 estate) coincidono con il fuso del server MetaTrader FTMO come lo indica la nostra scheda (GMT+2 inverno, GMT+3 estate); il server BCM del tester è diverso (circa un\'ora indietro rispetto all\'Italia), quindi <b>il tester su BCM non riproduce l\'orologio FTMO</b> e va confrontato dal vivo sulla Free Trial: ora dell\'EA contro ora del server, e il filtro news che chiude o blocca davvero intorno a CPI e FOMC. Il calendario news non funziona nel tester, quindi il filtro non è mai stato misurato da noi.',B))
E.append(P('Cosa chiediamo a voi / cosa decide Claudio',H1))
E.append(T([['Chi','Cosa'],
['Massimo (o il suo Claude)','Date e orari di CPI e FOMC 2025-2026 con la fonte; conferma delle soglie (-4% sulla stima pessimistica; DD equity <= 8.000 EUR; nessun giorno >= 5% realizzato) <b>prima</b> che lanciamo i giri; il riferimento della recensione indipendente su MaxAllowedDD.'],
['Claudio','Standard oppure Swing (cambia il passo 5); ordine dei lanci sul PC (export M1 prima, perché dura minuti); affitto o acquisto della licenza e taglia: restano sue decisioni.'],
['Noi (io)','Riga di export M1 (21 mesi + 2013), riga del Reaper con solo PropFirmMaxDailyDD=0, riga dei due giri del venerdì, lettori dell\'equity e dello stop esterno, con criteri e previsioni scritti prima dei numeri.']],[40,140]))
E.append(P('Limiti',H1))
E.append(P('Tester: un solo percorso storico, oro in forte rialzo negli ultimi 21 mesi; l\'equity da M1 è una stima per gli EA con molte posizioni; nessuna slippage misurata; l\'EA è la versione demo del Market; il filtro news non è mai stato misurato; il margine a leva 1:9 è una stima senza cambio EUR/USD. Nessuna indicazione di acquisto, lotto o taglia.',B))
doc.build(E,onFirstPage=foot,onLaterPages=foot)
print('ok')
