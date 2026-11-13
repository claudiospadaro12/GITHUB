#!/usr/bin/env python3
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
OUT='/home/user/GITHUB/report/REAPER_TABELLA_DEFINITIVA_PER_MASSIMO_2026-11-13_v2.pdf'
ss=getSampleStyleSheet()
B=ParagraphStyle('B',parent=ss['Normal'],fontName='Helvetica',fontSize=9.3,leading=12.6)
S=ParagraphStyle('S',parent=B,fontSize=8.2,leading=10.8,textColor=colors.HexColor('#444444'))
H1=ParagraphStyle('H1',parent=ss['Title'],fontName='Helvetica-Bold',fontSize=16.5,leading=20,alignment=0,spaceAfter=2)
H2=ParagraphStyle('H2',parent=B,fontName='Helvetica-Bold',fontSize=11.3,leading=14.5,spaceBefore=8,spaceAfter=3,textColor=colors.HexColor('#1f3a5f'))
BL=ParagraphStyle('BL',parent=B,leftIndent=10)
def P(t,st=B): return Paragraph(t,st)
def cell(t,fs=8.2): return Paragraph(str(t),ParagraphStyle('c',parent=B,fontSize=fs,leading=fs+2.4))
GREEN=colors.HexColor('#cfe8d2'); YEL=colors.HexColor('#fbefc4'); RED=colors.HexColor('#f4cccc')
rows=[ # combinazione, giorni, fall centrali/doppi (TUTTE le partenze), gg>=4,5%, verdetto
 ('Goldbot L3 + Phantom L3 + <b>Reaper L3</b>','216','0% / 0%','0','SI'),
 ('Goldbot L3 + Phantom L0 + <b>Reaper L3</b>','223','0% / 0%','0','SI'),
 ('Goldbot L0 + <b>Reaper L3</b> (due EA)','271','0% / 0%','0','SI (lenta)'),
 ('Goldbot L3 + <b>Reaper L3</b> (due EA)','295','0% / 0%','0','SI (lenta)'),
 ('P4: <b>Reaper L3</b> + Goldbot L0 + Daytrade Pro (3 anni)','145','0% / n.d.','n.d.','SI'),
 ('Goldbot L0 + Phantom L0 + <b>Reaper L3</b>','205','0% / 7,0%','2','CON LIMITI'),
 ('Goldbot L0 + Phantom L1 + <b>Reaper L3</b>','163','10,2% / 11,8%','4','NO'),
 ('Goldbot L1 + Phantom L0 + <b>Reaper L3</b>','158','8,5% / 13,1%','5','NO'),
 ('Goldbot L1 + Phantom L1 + <b>Reaper L3</b>','133','10,9% / 17,8%','8','NO'),
 ('Goldbot L1 + <b>Reaper L3</b> (due EA)','190','8,4% / 11,1%','4','NO'),
 ('Goldbot + Phantom + <b>Reaper L3</b> + Gold Trade Pro Combo','167-191','8,8-9,6% / 10,8-13,1%','4','NO'),
 ('Goldbot L0 + Phantom L1 + <b>Reaper L0</b>','91','14,9% / 23,3%','7','NO'),
 ('Goldbot L0 + <b>Reaper L0</b> (due EA)','139','11,9% / 21,3%','7','NO'),
 ('<b>Reaper L0</b> da solo (set prop standard)','151','17,3% / 23,3%','4','NO senza Guardian'),
 ('<b>Reaper L1</b> da solo (15% maxrisk)','96','28% / 43%','13','NO'),
 ('<b>Reaper Medium (L2)</b> da solo','32','64% / 72%','82','NO'),
 ('<b>Reaper L3</b> da solo','554','0% / 0%','0','TROPPO LENTO'),
]
E=[]
E.append(P('Gold Reaper: si puo usare per una challenge? Tabella definitiva (versione corretta)',H1))
E.append(P('Per Massimo - 13/11/2026 (v2, corregge la versione di oggi pomeriggio) - STIME DA BACKTEST (tester BCM, 80.000 EUR, XAUUSD), non previsioni. Nessuna indicazione su lotti, taglie o acquisti.',S))
E.append(P('1. La risposta in breve',H2))
E.append(P('<b>CORREZIONE</b>: la versione precedente diceva che il Reaper L0 poteva andare da solo e che certe combinazioni con Goldbot L1 erano sicure: era un errore di metodo (partenze solo di gennaio-marzo, che nascondevano le giornate peggiori del 2013). <b>Si, il Reaper si puo usare in combinazione, ma solo il Reaper Combo (L3) con Goldbot e Phantom a livelli Prop/Combo.</b> Il Reaper a L0 da solo, L1 e Medium non passano: nel tester fallisce la challenge nel 17%, 28% e 64% delle partenze. Il tester NON simula il Guardian: a 4,3% giornaliero potrebbe evitare parte dei fallimenti del Reaper L0, ma non e misurato.'))
E.append(P('2. Tabella (parte oro, 4 anni 2013/2018/2020/2025, partenze in TUTTO l\'anno, costi FTMO ipotizzati)',H2))
data=[[cell('<b>Combinazione</b>'),cell('<b>Giorni per le 2 fasi</b>'),cell('<b>Fallimenti: costi centrali / doppi</b>'),cell('<b>Giorni con perdita >= 4,5%</b>'),cell('<b>Verdetto</b>')]]
for a,b,c,d,v in rows: data.append([cell(a),cell(b),cell(c),cell(d),cell('<b>%s</b>'%v)])
t=Table(data,colWidths=[84*mm,20*mm,34*mm,22*mm,22*mm],repeatRows=1)
st=[('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#b8c2cc')),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#dfe8f2')),('VALIGN',(0,0),(-1,-1),'MIDDLE'),('TOPPADDING',(0,0),(-1,-1),2.2),('BOTTOMPADDING',(0,0),(-1,-1),2.2)]
for i,r in enumerate(rows,1):
    col=GREEN if r[4].startswith('SI') else (YEL if r[4].startswith('CON') else RED)
    st.append(('BACKGROUND',(4,i),(4,i),col))
t.setStyle(TableStyle(st)); E.append(t)
E.append(P('<b>Come si legge il verdetto (regola fissata prima)</b>: SI = 0% di fallimenti sia con costi centrali sia con costi doppi; CON LIMITI = fino al 5% con costi centrali e fino al 20% con costi doppi; NO = oltre. Fallisce chi perde il 5% in un giorno o il 10% totale. Fallimenti: partendo da OGNI giorno dell\'anno (fase 1). Giorni di calendario: mediana di fase 1 piu fase 2, partendo da gennaio-marzo. "Giorni con perdita >= 4,5%" = in tutto il periodo testato, equity ricostruita dalle barre da 1 minuto.',S))
E.append(P('3. I set da usare',H2))
E.append(P('<b>Reaper</b>: L3 <font face="Courier">Gold_reaper_propfirm_combo_3GOLD.set</font>; L0 <font face="Courier">Gold_reaper_propfirm.set</font>. <b>Goldbot</b>: L0 <font face="Courier">Goldbot_PropFirm_5_2.5.set</font>; L1 <font face="Courier">Goldbot_PropFirm_10_5.set</font>; L3 <font face="Courier">Goldbot_PropFirm_combo_3GOLD.set</font>. <b>Phantom</b>: L0 <font face="Courier">GoldPhantom_Propfirm_combo.set</font>; L1 <font face="Courier">GoldPhantom_Propfirm.set</font>; L3 <font face="Courier">GoldPhantom_Propfirm_combo_3GOLD.set</font>. Da verificare file per file che siano le versioni correnti di Wim.',S))
E.append(P('4. Due challenge insieme',H2))
E.append(tbl:=Table([[cell('<b>Coppia di challenge (con Daytrade Pro, 3 anni)</b>'),cell('<b>Entrambe finite entro 7 mesi</b>'),cell('<b>Entro 9 mesi</b>'),cell('<b>Almeno una fallisce</b>'),cell('<b>Ore con posizioni oro opposte (3 anni)</b>')],
 [cell('P1 + P4'),cell('75%'),cell('95%'),cell('0%'),cell('2.451')],
 [cell('P1 + P3'),cell('72%'),cell('93%'),cell('0%'),cell('7.171')],
 [cell('P3 + P4'),cell('74%'),cell('93%'),cell('0%'),cell('10.718')]],colWidths=[52*mm,30*mm,24*mm,28*mm,40*mm]))
tbl.setStyle(TableStyle([('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#b8c2cc')),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#dfe8f2')),('VALIGN',(0,0),(-1,-1),'MIDDLE'),('TOPPADDING',(0,0),(-1,-1),2.2),('BOTTOMPADDING',(0,0),(-1,-1),2.2)]))
E.append(P('P1 = Phantom Gradino 1 + Goldbot Prop + Daytrade Pro; P3 = Goldbot Combo + Gold Trade Pro Combo + Daytrade Pro; P4 = Reaper Combo + Goldbot Prop + Daytrade Pro. Le due challenge girano sullo stesso oro: i risultati NON sono indipendenti. Quando una incontra un giorno brutto, di solito lo incontra anche l\'altra. Avere due conti non dimezza il rischio, riduce solo l\'effetto di una partenza sfortunata sul tempo. "Entrambe passano" al 75% significa che il 25% delle partenze non e ancora arrivato al +10% entro la finestra del test (9-12 mesi), non che fallisce.',S))
E.append(P('5. Regole d\'uso se si sceglie il Reaper',H2))
for x in ['<b>Mai alzare il livello</b> del Reaper e mai usarlo da solo a L0, L1 o Medium; nemmeno il Goldbot va alzato a L1 (con L1 fallisce 8-28%).',
 '<b>Guardian acceso</b> a 4,3% giornaliero e 9,5% totale su ogni conto: il Reaper L0 ha avuto nel 2013 giorni a -6% (15/08, 22/10, 18/12), sopra il limite FTMO del 5%; Goldbot L1 -7,3% il 31/12/2013.',
 '<b>Non cambiare</b> il filtro NFP ne gli altri input dei set.',
 'Sul trial il Reaper ha perso 2.705 EUR in una notte (10/11, strategia 4, con altri settaggi); su una demo ha guadagnato 3.299 EUR nello stesso evento. Non e una prova ne a favore ne contro il Combo, ma conferma che il giorno storto esiste.',
 'Lo stesso EA su due conti apre posizioni identiche negli stessi momenti: la regola FTMO sulle posizioni opposte fra conti e sulla stessa strategia su piu conti NON e ancora stata chiarita da FTMO.']:
    E.append(Paragraph(x,BL,bulletText='-'))
E.append(P('6. Cosa NON e verificato',H2))
for x in ['Tester, non conto reale: spread e slippage FTMO, margine sullo Swing (leva oro 1:15) e stop out non sono simulati. Costi extra ipotizzati: 36 EUR a lotto oro (centrali), il doppio (prudenti).',
 'Un percorso per anno, 4 anni; il Reaper ha un rumore proprio (Randomization 50): i dettagli per anno non sono affidabili.',
 'Il Reaper non e mai stato misurato live con questi set; le percentuali di fallimento non sono garanzie.']:
    E.append(Paragraph(x,BL,bulletText='-'))
E.append(P('Fonti: report/GOLD_BUNDLE_COMBINAZIONI_2026-11-13.md, REAPER_SOLO_2026-11-13.md, CONFRONTO_P1_P3_P4_CON_A_B_2026-11-13.md. Non controllato da altri.',S))
doc=SimpleDocTemplate(OUT,pagesize=A4,leftMargin=14*mm,rightMargin=14*mm,topMargin=12*mm,bottomMargin=12*mm,title='Gold Reaper - tabella definitiva',author='Claudio Spadaro')
doc.build(E); print(OUT)
