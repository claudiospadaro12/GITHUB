# Risposta a FTMO sull'avviso di iperattivita (bozza del 10/11/2026) — da inviare da Claudio

Rispondere alla mail di FTMO sull'account 1515150476 (stessa conversazione). Resta da compilare solo [Full name] e l'email del conto FTMO. L'ora dello spegnimento (circa 09:30 ora italiana, detta da Claudio) e gia inserita; i numeri vengono dal registro del terminale del 10/11 (Logs: 8.239 righe; giorni 04-09/11 da 16 a 837 righe; registro di trading vuoto alle 13). Inviarla dalla connessione normale, non dall'hotspot. Non inserire password. Conservare la risposta.

---

**Subject:** Re: Hyperactivity on account 1515150476 — questions about how requests are counted

Hello FTMO Support,

Thank you for your message about account 1515150476 (the Free Trial). I take it seriously and I have reviewed the account's order history and the terminal logs. They show a loop on 10 November: after my own risk manager closed all positions at its daily loss limit (at 02:32 server time), the Expert Advisors kept placing new pending orders and my risk manager kept deleting them, producing well over a thousand placements and cancellations in a few hours. The terminal's trade log for that day has about 8,200 lines, against 16 to 840 lines on each of the previous days (4 to 9 November). I stopped it on 10 November by switching off algorithmic trading on the account's terminal: the last order on the account was placed at 09:45:00 server time and the last cancellation was at 09:45:02, and the terminal's trade log shows no requests in the early afternoon. After the daily reset of my risk manager on 11 November I re-enabled algorithmic trading and I am checking the log line count every day; in the previous days (4 to 9 November) the log had between 16 and 840 lines. The EAs are commercial third-party products.

To fix this correctly, could you please tell me:

1. **The numbers on my account.** How many requests did your system record on account 1515150476 on each of the days for which you sent the warning (date and count)?

2. **How the day is counted.** At what time does the daily count start and end (which time zone or server time)?

3. **Rejected requests.** Do rejected requests count towards the 2,000 per day (for example a request to modify a stop loss or take profit that the server rejects because the market is closed), or only accepted ones? Do pending order placements, expirations and deletions also count?

4. **Warnings and consequences.** What is the threshold that triggers this warning, and how many warnings (or on how many days) lead to the account being disabled? Does the same limit and procedure apply to Challenge, Verification and funded accounts, and what happens there when the limit is exceeded?

Thank you for your help.

Kind regards,
[Full name]
[Email of the FTMO account]
