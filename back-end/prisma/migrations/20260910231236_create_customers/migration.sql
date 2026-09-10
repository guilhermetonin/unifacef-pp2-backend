-- DropIndex
DROP INDEX "Customer_email_key";

-- DropIndex
DROP INDEX "Customer_ident_document_key";

-- AlterTable
ALTER TABLE "Customer" ALTER COLUMN "state" SET DATA TYPE TEXT;
