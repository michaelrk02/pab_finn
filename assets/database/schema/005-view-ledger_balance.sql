CREATE VIEW "ledger_balance" AS
SELECT
"l"."id",
("lti"."total_income" - "lte"."total_expense") "balance"
FROM "ledger" "l"
JOIN "ledger_total_income" "lti" ON "lti"."id" = "l"."id"
JOIN "ledger_total_expense" "lte" ON "lte"."id" = "l"."id";
