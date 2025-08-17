ALTER TABLE IF EXISTS "accounts" DROP CONSTRAINT IF EXISTS "owner_currency_key";
ALTER TABLE IF EXISTS "accounts" DROP FOREIGN KEY IF EXISTS "accounts_owner_fkey";

DROP TABLE IF EXISTS "users";