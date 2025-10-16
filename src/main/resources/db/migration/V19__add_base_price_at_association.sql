-- Add base_price_at_association column to toothclinicalexamination
ALTER TABLE toothclinicalexamination 
ADD COLUMN IF NOT EXISTS base_price_at_association DOUBLE;

-- Backfill base_price_at_association using historical price at association time when available,
-- else fallback to current procedure price, else the stored total
UPDATE toothclinicalexamination tce
LEFT JOIN procedure_prices p ON p.id = tce.procedure_id
SET tce.base_price_at_association = COALESCE(
  (
    SELECT pph.price
    FROM procedure_price_history pph
    WHERE pph.procedure_id = tce.procedure_id
      AND pph.effective_from <= COALESCE(tce.examination_date, tce.created_at)
    ORDER BY pph.effective_from DESC
    LIMIT 1
  ),
  p.price,
  tce.total_procedure_amount
)
WHERE tce.base_price_at_association IS NULL;