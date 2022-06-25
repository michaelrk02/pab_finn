CREATE TABLE "transaction" (
    "id" INTEGER,
    "ledger" INTEGER,
    "timestamp" TEXT,
    "type" TEXT,
    "title" TEXT,
    "description" TEXT,
    "amount" INTEGER,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("ledger") REFERENCES "ledger" ("id")
);
