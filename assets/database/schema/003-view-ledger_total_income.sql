CREATE VIEW "ledger_total_income" AS
SELECT
"l"."id",
SUM(COALESCE("t"."amount", 0)) "total_income"
FROM "ledger" "l"
LEFT JOIN "transaction" "t" ON "t"."ledger" = "l"."id" AND "t"."type" = 'income'
GROUP BY "l"."id";
