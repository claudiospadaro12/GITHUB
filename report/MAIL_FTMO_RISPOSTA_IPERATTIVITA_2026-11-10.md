# Risposta a FTMO sull'avviso di iperattivita (bozza del 10/11/2026) — da inviare da Claudio

Rispondere alla mail di FTMO sull'account 1515150476 (stessa conversazione). Compilare le parti tra [parentesi quadre] (in particolare l'ora in cui l'algo trading e stato spento sul VPS e il tuo nome). Non inserire password. Conservare la risposta.

---

**Subject:** Re: Hyperactivity on account 1515150476 — questions about how requests are counted

Hello FTMO Support,

Thank you for your message about account 1515150476 (the Free Trial). I take it seriously and I have reviewed the order history of the account. It shows a loop on 10/11 after my own risk manager closed the positions at the daily loss limit: the Expert Advisors kept placing new pending orders and my risk manager kept cancelling them, producing well over a thousand order placements and cancellations in a few hours. I stopped it on 10/11 at [time, local time] by switching off algorithmic trading on the account's terminal, and I am redesigning that behavior so that it cannot happen again. The EAs are commercial third-party products.

To fix this correctly, could you please tell me:

1. **The numbers on my account.** How many requests did your system record on account 1515150476 on each of the days for which you sent the warning (date and count)?

2. **How the day is counted.** At what time does the daily count start and end (which time zone or server time)?

3. **Rejected requests.** Do rejected requests count towards the 2,000 per day (for example a request to modify a stop loss or take profit that the server rejects because the market is closed), or only accepted ones? Do pending order placements, expirations and deletions also count?

4. **Warnings and consequences.** What is the threshold that triggers this warning, and how many warnings (or on how many days) lead to the account being disabled? Does the same limit and procedure apply to Challenge, Verification and funded accounts, and what happens there when the limit is exceeded?

I also sent you a separate email on 09/11/2026 with other questions about the rules (third-party EAs, the 400,000 USD allocation limit, gold leverage, weekend and gap trading, symbol specifications, account currency). If it has not been answered yet, I would be grateful for a reply to that message as well.

Thank you for your help.

Kind regards,
[Full name]
[Email of the FTMO account]
