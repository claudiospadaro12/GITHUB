//+------------------------------------------------------------------+
//| ABTG_Time.mqh  -  orari indipendenti dal cambio ora e dal broker |
//| Versione 1.00 (16/11/2026). DA COLLAUDARE nel tester: compila la |
//| prova ABTG_TestOrari.mq5 e controlla "falliti=0" nel giornale.   |
//|                                                                  |
//| IDEA: nel tester TimeGMT() coincide con l'ora del server, quindi |
//| NON rileva il cambio d'ora. Qui l'ora vera (UTC) si ricava dal   |
//| timestamp con regole deterministiche (UE: ultima domenica di     |
//| marzo/ottobre 01:00 UTC; USA dal 2007: 2a domenica di marzo      |
//| 07:00 UTC -> 1a domenica di novembre 06:00 UTC; prima del 2007:  |
//| 1a domenica di aprile -> ultima di ottobre). Identico live e     |
//| tester. Le sessioni si esprimono nel loro fuso di riferimento    |
//| (DAX: Berlino; Nasdaq/Dow: New York; Londra) e si confrontano    |
//| con l'ora del fuso, non con ore del server.                      |
//|                                                                  |
//| MODELLI DEL SERVER (CLAUDE.md): BCM = GMT+1 FISSO (nessun cambio |
//| d'ora); FTMO = ora italiana + 1 (GMT+2 inverno, GMT+3 estate,    |
//| regola UE). ATTENZIONE: lo STORICO _EXT di Nasdaq/S&P ha un      |
//| orologio diverso dal feed live (apertura USA a 14:30 anche in    |
//| inverno; 13:30 in alcune settimane): per quei test serve un      |
//| modello dei DATI, non del broker.                                |
//+------------------------------------------------------------------+
#ifndef ABTG_TIME_MQH
#define ABTG_TIME_MQH
#define ABTG_TIME_VERSION "1.00"

enum ENUM_ABTG_DST { ABTG_DST_NONE=0, ABTG_DST_EU=1, ABTG_DST_US=2 };

struct ABTG_Zone { int offStd; int offDst; int rule; };  // offset in MINUTI rispetto a UTC

ABTG_Zone ABTG_MkZone(int offStdMin,int offDstMin,int rule){ ABTG_Zone z; z.offStd=offStdMin; z.offDst=offDstMin; z.rule=rule; return z; }
ABTG_Zone ABTG_ZoneBerlin(){ return ABTG_MkZone(60,120,ABTG_DST_EU); }   // anche Roma/Francoforte/Parigi
ABTG_Zone ABTG_ZoneLondon(){ return ABTG_MkZone(0,60,ABTG_DST_EU); }
ABTG_Zone ABTG_ZoneNewYork(){ return ABTG_MkZone(-300,-240,ABTG_DST_US); }
ABTG_Zone ABTG_ZoneTokyo(){ return ABTG_MkZone(540,540,ABTG_DST_NONE); }
ABTG_Zone ABTG_ZoneBCM(){ return ABTG_MkZone(60,60,ABTG_DST_NONE); }     // server BCM: GMT+1 fisso
ABTG_Zone ABTG_ZoneFTMO(){ return ABTG_MkZone(120,180,ABTG_DST_EU); }    // server FTMO: ora italiana + 1

datetime ABTG_Mk(int y,int m,int d,int h=0,int mi=0)
{
   MqlDateTime s; s.year=y; s.mon=m; s.day=d; s.hour=h; s.min=mi; s.sec=0; s.day_of_week=0; s.day_of_year=0;
   return StructToTime(s);
}
int ABTG_DaysInMonth(int y,int m)
{
   if(m==2) return ((y%4==0 && y%100!=0) || (y%400==0)) ? 29 : 28;
   if(m==4 || m==6 || m==9 || m==11) return 30;
   return 31;
}
int ABTG_Dow(int y,int m,int d){ MqlDateTime s; TimeToStruct(ABTG_Mk(y,m,d),s); return s.day_of_week; }   // 0 = domenica
int ABTG_LastSunday(int y,int m){ for(int d=ABTG_DaysInMonth(y,m); d>=1; d--) if(ABTG_Dow(y,m,d)==0) return d; return 1; }
int ABTG_NthSunday(int y,int m,int n)
{
   int c=0;
   for(int d=1; d<=ABTG_DaysInMonth(y,m); d++) if(ABTG_Dow(y,m,d)==0){ c++; if(c==n) return d; }
   return 1;
}

// true se alla data UTC e in vigore l'ora legale secondo la regola
bool ABTG_IsDST(int rule,datetime utc)
{
   if(rule==ABTG_DST_NONE) return false;
   MqlDateTime u; TimeToStruct(utc,u); int y=u.year; datetime s,e;
   if(rule==ABTG_DST_EU){ s=ABTG_Mk(y,3,ABTG_LastSunday(y,3),1,0); e=ABTG_Mk(y,10,ABTG_LastSunday(y,10),1,0); }
   else if(y>=2007){ s=ABTG_Mk(y,3,ABTG_NthSunday(y,3,2),7,0); e=ABTG_Mk(y,11,ABTG_NthSunday(y,11,1),6,0); }
   else { s=ABTG_Mk(y,4,ABTG_NthSunday(y,4,1),7,0); e=ABTG_Mk(y,10,ABTG_LastSunday(y,10),6,0); }
   return (utc>=s && utc<e);
}
int ABTG_Off(const ABTG_Zone &z,datetime utc){ return ABTG_IsDST(z.rule,utc) ? z.offDst : z.offStd; }   // minuti

// ora locale del fuso -> UTC. Ambiguita del cambio d'ora: si sceglie la prima occorrenza (ora legale)
datetime ABTG_LocalToUTC(const ABTG_Zone &z,datetime local)
{
   datetime uS=(datetime)((long)local-(long)z.offStd*60);
   datetime uD=(datetime)((long)local-(long)z.offDst*60);
   if(z.rule!=ABTG_DST_NONE && ABTG_IsDST(z.rule,uD)) return uD;
   return uS;
}
datetime ABTG_UTCToLocal(const ABTG_Zone &z,datetime utc){ return (datetime)((long)utc+(long)ABTG_Off(z,utc)*60); }

// ora del server -> ora del fuso di riferimento (es. TimeTradeServer() -> ora di Berlino)
datetime ABTG_ServerToRef(const ABTG_Zone &srv,const ABTG_Zone &ref,datetime serverTime){ return ABTG_UTCToLocal(ref,ABTG_LocalToUTC(srv,serverTime)); }
// data e ora nel fuso di riferimento -> ora del server (per piazzare ordini o leggere le barre)
datetime ABTG_RefToServer(const ABTG_Zone &ref,const ABTG_Zone &srv,int y,int m,int d,int h,int mi)
{
   return ABTG_UTCToLocal(srv,ABTG_LocalToUTC(ref,ABTG_Mk(y,m,d,h,mi)));
}
int ABTG_MinOfDay(datetime t){ MqlDateTime s; TimeToStruct(t,s); return s.hour*60+s.min; }

// riconosce il broker dal nome del server; false se sconosciuto (l'EA deve NON operare e scriverlo)
bool ABTG_DetectServer(ABTG_Zone &srv,string &nome)
{
   string sv=AccountInfoString(ACCOUNT_SERVER); string lo=sv; StringToLower(lo);
   if(StringFind(lo,"bcm")>=0){ srv=ABTG_ZoneBCM(); nome="BCM (GMT+1 fisso)"; return true; }
   if(StringFind(lo,"ftmo")>=0){ srv=ABTG_ZoneFTMO(); nome="FTMO (ora italiana + 1, regola UE)"; return true; }
   nome="server sconosciuto: "+sv; return false;
}
// controllo dal vivo: l'offset reale (TimeTradeServer - TimeGMT) deve coincidere con il modello
string ABTG_LiveCheck(const ABTG_Zone &srv)
{
   if(MQLInfoInteger(MQL_TESTER)) return "tester: controllo dal vivo non applicabile";
   datetime g=TimeGMT(); long d=(long)TimeTradeServer()-(long)g;
   int dm=(int)MathRound((double)d/1800.0)*30; int atteso=ABTG_Off(srv,g);
   if(dm==atteso) return "ok (offset "+IntegerToString(dm)+" min)";
   return "ATTENZIONE: offset reale "+IntegerToString(dm)+" min, atteso "+IntegerToString(atteso)+" min";
}

// ------------------------- collaudo interno ---------------------------
// Casi calcolati in modo INDIPENDENTE (fusi ufficiali IANA di Python) e incollati qui.
const long ABTG_T_EU[] = {
   1364688000, 0, 1364691600, 1, 1364695200, 1, 1382832000, 1,
   1382835600, 0, 1382839200, 0, 1396137600, 0, 1396141200, 1,
   1396144800, 1, 1414281600, 1, 1414285200, 0, 1414288800, 0,
   1427587200, 0, 1427590800, 1, 1427594400, 1, 1445731200, 1,
   1445734800, 0, 1445738400, 0, 1459036800, 0, 1459040400, 1,
   1459044000, 1, 1477785600, 1, 1477789200, 0, 1477792800, 0,
   1490486400, 0, 1490490000, 1, 1490493600, 1, 1509235200, 1,
   1509238800, 0, 1509242400, 0, 1521936000, 0, 1521939600, 1,
   1521943200, 1, 1540684800, 1, 1540688400, 0, 1540692000, 0,
   1553990400, 0, 1553994000, 1, 1553997600, 1, 1572134400, 1,
   1572138000, 0, 1572141600, 0, 1585440000, 0, 1585443600, 1,
   1585447200, 1, 1603584000, 1, 1603587600, 0, 1603591200, 0,
   1616889600, 0, 1616893200, 1, 1616896800, 1, 1635638400, 1,
   1635642000, 0, 1635645600, 0, 1648339200, 0, 1648342800, 1,
   1648346400, 1, 1667088000, 1, 1667091600, 0, 1667095200, 0,
   1679788800, 0, 1679792400, 1, 1679796000, 1, 1698537600, 1,
   1698541200, 0, 1698544800, 0, 1711843200, 0, 1711846800, 1,
   1711850400, 1, 1729987200, 1, 1729990800, 0, 1729994400, 0,
   1743292800, 0, 1743296400, 1, 1743300000, 1, 1761436800, 1,
   1761440400, 0, 1761444000, 0, 1774742400, 0, 1774746000, 1,
   1774749600, 1, 1792886400, 1, 1792890000, 0, 1792893600, 0,
   1736942400, 0, 1752580800, 1, 1584705600, 0, 1603972800, 0 };
const long ABTG_T_US[] = {
   1362895200, 0, 1362898800, 1, 1362902400, 1, 1383454800, 1,
   1383458400, 0, 1383462000, 0, 1394344800, 0, 1394348400, 1,
   1394352000, 1, 1414904400, 1, 1414908000, 0, 1414911600, 0,
   1425794400, 0, 1425798000, 1, 1425801600, 1, 1446354000, 1,
   1446357600, 0, 1446361200, 0, 1457848800, 0, 1457852400, 1,
   1457856000, 1, 1478408400, 1, 1478412000, 0, 1478415600, 0,
   1489298400, 0, 1489302000, 1, 1489305600, 1, 1509858000, 1,
   1509861600, 0, 1509865200, 0, 1520748000, 0, 1520751600, 1,
   1520755200, 1, 1541307600, 1, 1541311200, 0, 1541314800, 0,
   1552197600, 0, 1552201200, 1, 1552204800, 1, 1572757200, 1,
   1572760800, 0, 1572764400, 0, 1583647200, 0, 1583650800, 1,
   1583654400, 1, 1604206800, 1, 1604210400, 0, 1604214000, 0,
   1615701600, 0, 1615705200, 1, 1615708800, 1, 1636261200, 1,
   1636264800, 0, 1636268400, 0, 1647151200, 0, 1647154800, 1,
   1647158400, 1, 1667710800, 1, 1667714400, 0, 1667718000, 0,
   1678600800, 0, 1678604400, 1, 1678608000, 1, 1699160400, 1,
   1699164000, 0, 1699167600, 0, 1710050400, 0, 1710054000, 1,
   1710057600, 1, 1730610000, 1, 1730613600, 0, 1730617200, 0,
   1741500000, 0, 1741503600, 1, 1741507200, 1, 1762059600, 1,
   1762063200, 0, 1762066800, 0, 1772949600, 0, 1772953200, 1,
   1772956800, 1, 1793509200, 1, 1793512800, 0, 1793516400, 0,
   1736942400, 0, 1752580800, 1, 1584705600, 1, 1603972800, 1 };
const long ABTG_T_REF[] = {
   1, 2024, 3, 8, 9, 0, 1709888400, 1709892000,
   1, 2024, 3, 11, 9, 0, 1710147600, 1710151200,
   1, 2024, 3, 28, 9, 0, 1711616400, 1711620000,
   1, 2024, 4, 1, 9, 0, 1711958400, 1711965600,
   1, 2024, 10, 25, 9, 0, 1729843200, 1729850400,
   1, 2024, 10, 28, 9, 0, 1730106000, 1730109600,
   1, 2024, 11, 1, 9, 0, 1730451600, 1730455200,
   1, 2024, 11, 4, 9, 0, 1730710800, 1730714400,
   1, 2025, 3, 7, 9, 0, 1741338000, 1741341600,
   1, 2025, 3, 10, 9, 0, 1741597200, 1741600800,
   1, 2025, 3, 12, 9, 0, 1741770000, 1741773600,
   1, 2025, 3, 26, 9, 0, 1742979600, 1742983200,
   1, 2025, 3, 28, 9, 0, 1743152400, 1743156000,
   1, 2025, 3, 31, 9, 0, 1743408000, 1743415200,
   1, 2025, 10, 24, 9, 0, 1761292800, 1761300000,
   1, 2025, 10, 27, 9, 0, 1761555600, 1761559200,
   1, 2025, 10, 29, 9, 0, 1761728400, 1761732000,
   1, 2025, 10, 31, 9, 0, 1761901200, 1761904800,
   1, 2025, 11, 3, 9, 0, 1762160400, 1762164000,
   1, 2025, 11, 5, 9, 0, 1762333200, 1762336800,
   1, 2026, 3, 6, 9, 0, 1772787600, 1772791200,
   1, 2026, 3, 9, 9, 0, 1773046800, 1773050400,
   1, 2026, 3, 27, 9, 0, 1774602000, 1774605600,
   1, 2026, 3, 30, 9, 0, 1774857600, 1774864800,
   1, 2026, 10, 23, 9, 0, 1792742400, 1792749600,
   1, 2026, 10, 26, 9, 0, 1793005200, 1793008800,
   1, 2026, 10, 30, 9, 0, 1793350800, 1793354400,
   1, 2026, 11, 2, 9, 0, 1793610000, 1793613600,
   1, 2026, 11, 16, 9, 0, 1794819600, 1794823200,
   1, 2013, 6, 3, 9, 0, 1370246400, 1370253600,
   1, 2013, 12, 2, 9, 0, 1385974800, 1385978400,
   1, 2020, 3, 9, 9, 0, 1583744400, 1583748000,
   1, 2020, 3, 16, 9, 0, 1584349200, 1584352800,
   1, 2020, 10, 26, 9, 0, 1603702800, 1603706400,
   1, 2020, 11, 2, 9, 0, 1604307600, 1604311200,
   1, 2015, 7, 1, 9, 0, 1435737600, 1435744800,
   2, 2024, 3, 8, 9, 30, 1709911800, 1709915400,
   2, 2024, 3, 11, 9, 30, 1710167400, 1710171000,
   2, 2024, 3, 28, 9, 30, 1711636200, 1711639800,
   2, 2024, 4, 1, 9, 30, 1711981800, 1711989000,
   2, 2024, 10, 25, 9, 30, 1729866600, 1729873800,
   2, 2024, 10, 28, 9, 30, 1730125800, 1730129400,
   2, 2024, 11, 1, 9, 30, 1730471400, 1730475000,
   2, 2024, 11, 4, 9, 30, 1730734200, 1730737800,
   2, 2025, 3, 7, 9, 30, 1741361400, 1741365000,
   2, 2025, 3, 10, 9, 30, 1741617000, 1741620600,
   2, 2025, 3, 12, 9, 30, 1741789800, 1741793400,
   2, 2025, 3, 26, 9, 30, 1742999400, 1743003000,
   2, 2025, 3, 28, 9, 30, 1743172200, 1743175800,
   2, 2025, 3, 31, 9, 30, 1743431400, 1743438600,
   2, 2025, 10, 24, 9, 30, 1761316200, 1761323400,
   2, 2025, 10, 27, 9, 30, 1761575400, 1761579000,
   2, 2025, 10, 29, 9, 30, 1761748200, 1761751800,
   2, 2025, 10, 31, 9, 30, 1761921000, 1761924600,
   2, 2025, 11, 3, 9, 30, 1762183800, 1762187400,
   2, 2025, 11, 5, 9, 30, 1762356600, 1762360200,
   2, 2026, 3, 6, 9, 30, 1772811000, 1772814600,
   2, 2026, 3, 9, 9, 30, 1773066600, 1773070200,
   2, 2026, 3, 27, 9, 30, 1774621800, 1774625400,
   2, 2026, 3, 30, 9, 30, 1774881000, 1774888200,
   2, 2026, 10, 23, 9, 30, 1792765800, 1792773000,
   2, 2026, 10, 26, 9, 30, 1793025000, 1793028600,
   2, 2026, 10, 30, 9, 30, 1793370600, 1793374200,
   2, 2026, 11, 2, 9, 30, 1793633400, 1793637000,
   2, 2026, 11, 16, 9, 30, 1794843000, 1794846600,
   2, 2013, 6, 3, 9, 30, 1370269800, 1370277000,
   2, 2013, 12, 2, 9, 30, 1385998200, 1386001800,
   2, 2020, 3, 9, 9, 30, 1583764200, 1583767800,
   2, 2020, 3, 16, 9, 30, 1584369000, 1584372600,
   2, 2020, 10, 26, 9, 30, 1603722600, 1603726200,
   2, 2020, 11, 2, 9, 30, 1604331000, 1604334600,
   2, 2015, 7, 1, 9, 30, 1435761000, 1435768200,
   3, 2024, 3, 8, 8, 0, 1709888400, 1709892000,
   3, 2024, 3, 11, 8, 0, 1710147600, 1710151200,
   3, 2024, 3, 28, 8, 0, 1711616400, 1711620000,
   3, 2024, 4, 1, 8, 0, 1711958400, 1711965600,
   3, 2024, 10, 25, 8, 0, 1729843200, 1729850400,
   3, 2024, 10, 28, 8, 0, 1730106000, 1730109600,
   3, 2024, 11, 1, 8, 0, 1730451600, 1730455200,
   3, 2024, 11, 4, 8, 0, 1730710800, 1730714400,
   3, 2025, 3, 7, 8, 0, 1741338000, 1741341600,
   3, 2025, 3, 10, 8, 0, 1741597200, 1741600800,
   3, 2025, 3, 12, 8, 0, 1741770000, 1741773600,
   3, 2025, 3, 26, 8, 0, 1742979600, 1742983200,
   3, 2025, 3, 28, 8, 0, 1743152400, 1743156000,
   3, 2025, 3, 31, 8, 0, 1743408000, 1743415200,
   3, 2025, 10, 24, 8, 0, 1761292800, 1761300000,
   3, 2025, 10, 27, 8, 0, 1761555600, 1761559200,
   3, 2025, 10, 29, 8, 0, 1761728400, 1761732000,
   3, 2025, 10, 31, 8, 0, 1761901200, 1761904800,
   3, 2025, 11, 3, 8, 0, 1762160400, 1762164000,
   3, 2025, 11, 5, 8, 0, 1762333200, 1762336800,
   3, 2026, 3, 6, 8, 0, 1772787600, 1772791200,
   3, 2026, 3, 9, 8, 0, 1773046800, 1773050400,
   3, 2026, 3, 27, 8, 0, 1774602000, 1774605600,
   3, 2026, 3, 30, 8, 0, 1774857600, 1774864800,
   3, 2026, 10, 23, 8, 0, 1792742400, 1792749600,
   3, 2026, 10, 26, 8, 0, 1793005200, 1793008800,
   3, 2026, 10, 30, 8, 0, 1793350800, 1793354400,
   3, 2026, 11, 2, 8, 0, 1793610000, 1793613600,
   3, 2026, 11, 16, 8, 0, 1794819600, 1794823200,
   3, 2013, 6, 3, 8, 0, 1370246400, 1370253600,
   3, 2013, 12, 2, 8, 0, 1385974800, 1385978400,
   3, 2020, 3, 9, 8, 0, 1583744400, 1583748000,
   3, 2020, 3, 16, 8, 0, 1584349200, 1584352800,
   3, 2020, 10, 26, 8, 0, 1603702800, 1603706400,
   3, 2020, 11, 2, 8, 0, 1604307600, 1604311200,
   3, 2015, 7, 1, 8, 0, 1435737600, 1435744800 };

ABTG_Zone ABTG_RefZoneById(int id){ if(id==1) return ABTG_ZoneBerlin(); if(id==2) return ABTG_ZoneNewYork(); return ABTG_ZoneLondon(); }

// restituisce il numero di casi FALLITI (0 = tutto corretto); rep contiene i primi errori
int ABTG_Time_SelfTest(string &rep,int &casi)
{
   int bad=0; casi=0; rep="";
   int sz=ArraySize(ABTG_T_EU);
   for(int i=0;i+1<sz;i+=2){ casi++; int got=ABTG_IsDST(ABTG_DST_EU,(datetime)ABTG_T_EU[i])?1:0;
      if(got!=(int)ABTG_T_EU[i+1]){ bad++; if(bad<=12) rep+="EU utc="+TimeToString((datetime)ABTG_T_EU[i],TIME_DATE|TIME_MINUTES)+" atteso="+IntegerToString((int)ABTG_T_EU[i+1])+"\n"; } }
   sz=ArraySize(ABTG_T_US);
   for(int i=0;i+1<sz;i+=2){ casi++; int got=ABTG_IsDST(ABTG_DST_US,(datetime)ABTG_T_US[i])?1:0;
      if(got!=(int)ABTG_T_US[i+1]){ bad++; if(bad<=12) rep+="US utc="+TimeToString((datetime)ABTG_T_US[i],TIME_DATE|TIME_MINUTES)+" atteso="+IntegerToString((int)ABTG_T_US[i+1])+"\n"; } }
   sz=ArraySize(ABTG_T_REF);
   for(int i=0;i+7<sz;i+=8)
   {
      int id=(int)ABTG_T_REF[i],y=(int)ABTG_T_REF[i+1],m=(int)ABTG_T_REF[i+2],d=(int)ABTG_T_REF[i+3],h=(int)ABTG_T_REF[i+4],mi=(int)ABTG_T_REF[i+5];
      datetime eb=(datetime)ABTG_T_REF[i+6], ef=(datetime)ABTG_T_REF[i+7]; ABTG_Zone rz=ABTG_RefZoneById(id);
      datetime loc=ABTG_Mk(y,m,d,h,mi);
      casi++; datetime gb=ABTG_RefToServer(rz,ABTG_ZoneBCM(),y,m,d,h,mi);
      if(gb!=eb){ bad++; if(bad<=12) rep+="ref"+IntegerToString(id)+" "+TimeToString(loc)+" -> BCM "+TimeToString(gb)+" atteso "+TimeToString(eb)+"\n"; }
      casi++; datetime gf=ABTG_RefToServer(rz,ABTG_ZoneFTMO(),y,m,d,h,mi);
      if(gf!=ef){ bad++; if(bad<=12) rep+="ref"+IntegerToString(id)+" "+TimeToString(loc)+" -> FTMO "+TimeToString(gf)+" atteso "+TimeToString(ef)+"\n"; }
      casi++; datetime rb=ABTG_ServerToRef(ABTG_ZoneBCM(),rz,eb);
      if(rb!=loc){ bad++; if(bad<=12) rep+="inverso BCM "+TimeToString(eb)+" -> "+TimeToString(rb)+" atteso "+TimeToString(loc)+"\n"; }
      casi++; datetime rf=ABTG_ServerToRef(ABTG_ZoneFTMO(),rz,ef);
      if(rf!=loc){ bad++; if(bad<=12) rep+="inverso FTMO "+TimeToString(ef)+" -> "+TimeToString(rf)+" atteso "+TimeToString(loc)+"\n"; }
   }
   return bad;
}
#endif
