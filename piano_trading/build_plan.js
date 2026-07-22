const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType,
  Table, TableRow, TableCell, WidthType, BorderStyle, ShadingType,
  LevelFormat, PageBreak
} = require('docx');
const fs = require('fs');

const BLUE = "1F4E79", GREEN = "1F7A3D", RED = "B02418", GREY = "444444", LIGHT = "EDF2F7";

// ---- helpers ----
const H1 = (t) => new Paragraph({ heading: HeadingLevel.HEADING_1, spacing: { before: 260, after: 120 },
  children: [new TextRun({ text: t, bold: true, color: BLUE })] });
const H2 = (t) => new Paragraph({ heading: HeadingLevel.HEADING_2, spacing: { before: 180, after: 80 },
  children: [new TextRun({ text: t, bold: true, color: GREY })] });
const P = (runs, opts = {}) => new Paragraph({ spacing: { after: 90 }, ...opts,
  children: Array.isArray(runs) ? runs : [new TextRun(runs)] });
const bullet = (text, opts = {}) => new Paragraph({ numbering: { reference: "bul", level: 0 }, spacing: { after: 50 },
  children: [new TextRun({ text, ...opts })] });
const check = (text) => new Paragraph({ numbering: { reference: "chk", level: 0 }, spacing: { after: 50 },
  children: [new TextRun(text)] });

function tbl(rows, widths) {
  const total = widths.reduce((a, b) => a + b, 0);
  return new Table({
    width: { size: total, type: WidthType.DXA }, columnWidths: widths,
    rows: rows.map((r, ri) => new TableRow({
      tableHeader: ri === 0,
      children: r.map((c, ci) => new TableCell({
        width: { size: widths[ci], type: WidthType.DXA },
        shading: { type: ShadingType.CLEAR, fill: ri === 0 ? BLUE : (ri % 2 ? "FFFFFF" : LIGHT) },
        margins: { top: 60, bottom: 60, left: 100, right: 100 },
        children: [new Paragraph({ children: [new TextRun({ text: c, bold: ri === 0, color: ri === 0 ? "FFFFFF" : "000000", size: 19 })] })]
      }))
    }))
  });
}

const doc = new Document({
  numbering: {
    config: [
      { reference: "bul", levels: [{ level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 420, hanging: 220 } } } }] },
      { reference: "chk", levels: [{ level: 0, format: LevelFormat.BULLET, text: "✔", alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 420, hanging: 220 } } } }] },
    ]
  },
  styles: { default: { document: { run: { font: "Calibri", size: 21 } } } },
  sections: [{
    properties: { page: { margin: { top: 1000, bottom: 1000, left: 1100, right: 1100 } } },
    children: [
      // ---------- COPERTINA ----------
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { before: 400, after: 60 },
        children: [new TextRun({ text: "PIANO DI TRADING PERSONALE", bold: true, size: 40, color: BLUE })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 40 },
        children: [new TextRun({ text: "Claudio Spadaro", size: 28, color: GREY })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 30 },
        children: [new TextRun({ text: "Conto demo 50503392 — BCM Markets (EUR)", italics: true, size: 20, color: GREY })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 260 },
        children: [new TextRun({ text: "Versione 1.0 — luglio 2026  ·  documento da rivedere periodicamente", size: 18, color: GREY })] }),
      new Paragraph({ border: { top: { style: BorderStyle.SINGLE, size: 6, color: BLUE } }, spacing: { after: 160 }, children: [] }),
      P([new TextRun({ text: "Filosofia: ", bold: true }),
        new TextRun('"Plan a trade, trade a plan." Pianifico ogni operazione e seguo il piano, per togliere l’emotività e operare in modo sistematico, come un business.')]),
      P([new TextRun({ text: "Il mio approccio: ", bold: true }),
        new TextRun("automatizzato in primis. Per motivi di lavoro non ho tempo di stare al monitor, quindi il cuore del mio trading sono gli Expert Advisor (EA) che operano al posto mio secondo regole precise. In aggiunta, poche operazioni discrezionali "),
        new TextRun({ text: "selettive e ad alta probabilità", bold: true }),
        new TextRun(", solo quando il setup è di grado A/A+.")]),
      P([new TextRun({ text: "Stato attuale: ", bold: true }),
        new TextRun("in demo. Passo al conto reale solo dopo aver dimostrato disciplina e aspettativa positiva in demo, operando come se fosse denaro vero.")]),

      new Paragraph({ children: [new PageBreak()] }),

      // ---------- 1. OBIETTIVI E DISCIPLINA ----------
      H1("1. Obiettivi e Disciplina"),
      H2("Obiettivi (realizzabili e misurabili)"),
      tbl([
        ["Orizzonte", "Obiettivo", "Come lo misuro"],
        ["Breve (1-2 mesi)", "Disciplina esecutiva: seguire il piano", "Compliance ≥ 90% dei trade a journal"],
        ["Medio (3-6 mesi)", "Aspettativa POSITIVA in demo", "Profit factor > 1.3 su ≥ 100 trade"],
        ["Lungo (12 mesi)", "Profittevole e disciplinato, passaggio al reale", "3 mesi consecutivi positivi in demo"],
      ], [1900, 3400, 3400]),
      P([new TextRun({ text: "Nota: ", bold: true }), new TextRun("l’obiettivo n°1 NON è il profitto, è la ")]
        .concat([new TextRun({ text: "costanza", bold: true }), new TextRun(". Il profitto è la conseguenza della disciplina.")])),

      H2("Tempo che dedico"),
      bullet("EA: operano 24/5 in automatico sul VPS — non mi costano tempo durante il lavoro."),
      bullet("Discrezionale: solo nelle finestre buone (apertura EU ~08:00-10:00, apertura US ~14:30-16:00 ora Roma)."),
      bullet("Studio/backtest: 2-3 ore a settimana (weekend)."),
      bullet("Revisione settimanale del conto e del journal: ogni domenica."),

      H2("Regole di disciplina (i miei punti deboli, dichiarati)"),
      P([new TextRun({ text: "Dalla mia autodiagnosi so quali sono i miei errori ricorrenti. Queste regole servono a correggerli:", italics: true })]),
      check("NIENTE revenge trading. Dopo 2-3 stop consecutivi CHIUDO la giornata. La voglia di recuperare è il mio nemico n°1."),
      check("In demo opero ESATTAMENTE come se fosse reale: niente ingressi “tanto è finto”."),
      check("Entro SOLO su setup previsti dal piano. Se non è nel piano, non esiste."),
      check("NIENTE oro discrezionale fuori piano (è la mia perdita più grande — vedi dati)."),
      check("NIENTE trade in post-news ad alto impatto (mi ha già fatto male)."),
      check("Ogni trade va a journal, con grado del setup, errore ed emozione."),

      new Paragraph({ children: [new PageBreak()] }),

      // ---------- 2. MONEY MANAGEMENT ----------
      H1("2. Money Management — Size e Piano di Rischio"),
      P([new TextRun({ text: "È la parte più importante del piano: mi tiene in gioco anche quando sbaglio.", italics: true, color: RED })]),

      H2("Rischio per operazione (Position Size)"),
      tbl([
        ["Parametro", "Regola"],
        ["Rischio standard per trade", "1,0% del capitale"],
        ["Rischio massimo per trade", "2,0% del capitale (solo setup A+)"],
        ["Calcolo della size", "Lotti = (capitale × rischio%) / (distanza stop × valore per punto)"],
        ["Coerenza", "STESSO modello di rischio per TUTTI i trade e tutti gli EA — mai “a sensazione”"],
      ], [3200, 5500]),
      P([new TextRun({ text: "⚠ Correzione dai miei dati: ", bold: true, color: RED }),
        new TextRun("l’EA Bollinger a 10 ordini con rischio 5% è TROPPO. E ho avuto trade oro da 0,02 lotti e poi da 0,50 (25×): incoerenza pericolosa. Da ora, size calcolata sempre sul rischio %, uguale per tutti.")]),

      H2("Rischio giornaliero, settimanale e drawdown"),
      tbl([
        ["Limite", "Soglia", "Azione"],
        ["Perdita max giornaliera", "-3% del capitale", "STOP totale per la giornata (anche EA in pausa)"],
        ["Perdita max settimanale", "-6% del capitale", "Stop fino a lunedì + revisione"],
        ["Drawdown max mensile", "-10% del capitale", "Fermo tutto, analisi profonda prima di riprendere"],
        ["Rischio simultaneo (tutti gli EA)", "6% aggregato", "Non aprire nuovi trade oltre questa soglia complessiva"],
      ], [2900, 1900, 3900]),
      P([new TextRun({ text: "Il limite “rischio simultaneo” è fondamentale con più EA attivi: evita che 15 EA aprano tutti insieme e mi espongano troppo.", italics: true })]),

      H2("Rapporto rischio/rendimento e gestione"),
      bullet("Rapporto rischio/rendimento minimo accettato: 1:1,5. Preferito 1:2 o più."),
      bullet("Regola 1/3 – 2/3: parzializzo (chiudo una parte) al primo target e sposto lo stop a pareggio (breakeven) sul resto."),
      bullet("Dopo il breakeven: trailing stop per lasciar correre — “non posso più perdere” su quel trade (salvo gap/slippage)."),
      bullet("Non sposto MAI lo stop loss allargandolo per “dare respiro” al trade."),

      new Paragraph({ children: [new PageBreak()] }),

      // ---------- 3. STRATEGIE ----------
      H1("3. Strategie Operative"),
      P("Opero in modo SELETTIVO: solo setup di grado A/A+, nelle sessioni giuste. Due blocchi: automatico (il cuore) e discrezionale (poche operazioni sicure)."),

      H2("A) Automatico — il cuore (EA sul VPS)"),
      tbl([
        ["Strategia / EA", "Mercato & sessione", "Logica in breve", "Stato"],
        ["Apertura DAX (Apertura EU, Live 5m, MaxMin, M3)", "DAX (D30EUR), 08:00-10:00", "Breakout/aperture con ordini stop, gestione a BE", "Edge confermato"],
        ["Apertura Nasdaq (Apertura US, ORB, Live 5m)", "Nasdaq (NASUSD), 14:30-16:00", "Opening range breakout + retest", "Edge confermato (6/7)"],
        ["Bollinger H1 (multi-ordine)", "Forex, H1", "Compressione/espansione bande", "In test — ridurre rischio"],
        ["ABTG Nightly (box notturno)", "Forex cross tranquilli, notte", "Fade dei bordi del box asiatico", "In test / ottimizzazione"],
      ], [3000, 2400, 2400, 1900]),
      P([new TextRun({ text: "Gestione EA: ", bold: true }),
        new TextRun("stop e take profit definiti, parzializzazione e breakeven automatici. Ogni EA ha un magic number e un rischio % coerente col piano. Ottimizzazione periodica con walk-forward (vedi sezione 4).")]),

      H2("B) Discrezionale — poche operazioni sicure"),
      bullet("SOLO setup ad alta confluenza: Fibonacci H4 su ordini pendenti + Supertrend(3) + media 200 in H4, oppure retest dopo rottura ORB."),
      bullet("SOLO nelle sessioni buone (apertura EU / US). NIENTE nelle finestre “avoid” o a ridosso delle news."),
      bullet("SOLO grado A o A+. Se il setup è B o incerto: passo (skip)."),
      bullet("Ordini pendenti più vicini e più lontani, con size già calcolata sul rischio %."),
      P([new TextRun({ text: "Vietato per disciplina: ", bold: true, color: RED }),
        new TextRun("oro discrezionale “a naso” (numeri tondi/retest visti al volo) e trade in post-news. Sono le mie perdite storiche.")]),

      new Paragraph({ children: [new PageBreak()] }),

      // ---------- 4. CONTROLLO ----------
      H1("4. Controllo e Aggiornamento"),
      H2("Cosa controllo e con che frequenza"),
      tbl([
        ["Attività", "Frequenza", "Cosa guardo"],
        ["Journal dei trade", "Ogni trade", "Setup, grado, R multiplo, compliance, errore, emozione"],
        ["Relazione settimanale", "Ogni domenica", "P&L per simbolo/EA/sessione, win rate, profit factor, aspettativa"],
        ["Controllo conto / equity", "Giornaliero (veloce)", "Drawdown, rispetto dei limiti di rischio"],
        ["Backtest / ottimizzazione EA", "Mensile", "Walk-forward: parametri robusti, non il “picco” (anti-overfitting)"],
      ], [2600, 2100, 4100]),
      H2("Azioni per migliorare"),
      bullet("Tenere e potenziare ciò che ha edge (aperture DAX/Nasdaq)."),
      bullet("Rivedere o spegnere ciò che perde in modo sistematico (es. strategie GBPUSD 07:00, oro discrezionale)."),
      bullet("Analisi per fascia oraria: capire quali sessioni rendono e concentrarsi lì."),
      bullet("Ridurre progressivamente gli errori di compliance verso lo 0."),

      // ---------- 5. REGOLE NON NEGOZIABILI ----------
      H1("5. Regole NON negoziabili"),
      P([new TextRun({ text: "Se violo una di queste, ho sbagliato — a prescindere dal risultato del trade.", italics: true })]),
      check("Rischio massimo 2% per trade. Standard 1%."),
      check("Stop giornaliero a -3%: chiudo e torno domani."),
      check("Niente revenge trading dopo perdite consecutive."),
      check("Solo setup A/A+ previsti dal piano. Altrimenti skip."),
      check("Niente oro discrezionale, niente post-news."),
      check("Size sempre calcolata sul rischio %, mai a sensazione."),
      check("Stop loss mai allargato. Parziale + breakeven + trailing."),
      check("Ogni trade a journal, sempre."),

      new Paragraph({ spacing: { before: 300 }, border: { top: { style: BorderStyle.SINGLE, size: 6, color: BLUE } },
        children: [new TextRun({ text: "“Creare un piano è alla portata di tutti; la vera sfida è rispettarlo.”", italics: true, color: GREY })] }),
      P([new TextRun({ text: "[Da personalizzare con il coach] ", bold: true, color: RED }),
        new TextRun("capitale di partenza in reale, obiettivo di rendimento annuo realistico, e importi in € dei limiti di rischio in base al capitale scelto.")]),
    ]
  }]
});

Packer.toBuffer(doc).then((buf) => {
  fs.writeFileSync("/home/user/GITHUB/piano_trading/Piano_di_Trading_Claudio.docx", buf);
  console.log("OK docx creato");
});
