CREATE VIEW "ledger_total_expense" AS
SELECT
"l"."id",
SUM(COALESCE("t"."amount", 0)) "total_expense"
FROM "ledger" "l"
LEFT JOIN "transaction" "t" ON "t"."ledger" = "l"."id" AND "t"."type" = 'expense'
GROUP BY "l"."id";
