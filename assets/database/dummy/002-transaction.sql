INSERT INTO "transaction" ("id", "ledger", "timestamp", "type", "title", "description", "amount") VALUES
(RANDOM(), 1, DATETIME(), 'income', '[PROJECT] Codename Finn', 'Do FINN project', 5000000),
(RANDOM(), 1, DATETIME(), 'income', '[QUEST] Hyman Bug Bounty', 'Complete quest from Hyman Roth', 250000),
(RANDOM(), 1, DATETIME(), 'income', '[QUEST] Repair Broken Laptop', 'Repair friends PC', 500000),
(RANDOM(), 1, DATETIME(), 'expense', '[VACATION] Small Vacation', 'Little trip to my granmas house', 1500000),
(RANDOM(), 1, DATETIME(), 'expense', '[SERVICE] Rent VPS', 'VPS Pro Package at bestvps.com', 750000),
(RANDOM(), 2, DATETIME(), 'income', '[WORK] Receive Salary', 'Monthly salary', 10000000),
(RANDOM(), 2, DATETIME(), 'expense', '[DAILY] Daily Consumes', 'Diverse spendings', 6000000),
(RANDOM(), 2, DATETIME(), 'expense', '[DEPOSIT] Save Deposit', 'Save to bank', 2000000);
