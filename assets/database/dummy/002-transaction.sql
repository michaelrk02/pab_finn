INSERT INTO "transaction" ("id", "ledger", "timestamp", "type", "title", "description", "amount") VALUES
(RANDOM(), 1, DATETIME(), 'income', '[PROJECT] Codename Finn', '', 5000000),
(RANDOM(), 1, DATETIME(), 'income', '[QUEST] Hyman Bug Bounty', '', 250000),
(RANDOM(), 1, DATETIME(), 'income', '[QUEST] Repair Broken Laptop', '', 500000),
(RANDOM(), 1, DATETIME(), 'expense', '[VACATION] Small Vacation', '', 1500000),
(RANDOM(), 1, DATETIME(), 'expense', '[SERVICE] Rent VPS', '', 750000),
(RANDOM(), 2, DATETIME(), 'income', '[WORK] Receive Salary', '', 10000000),
(RANDOM(), 2, DATETIME(), 'expense', '[DAILY] Daily Consumes', '', 6000000),
(RANDOM(), 2, DATETIME(), 'expense', '[DEPOSIT] Save Deposit', '', 2000000);
