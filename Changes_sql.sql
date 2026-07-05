use hospital;

select * from hospital_management;

CREATE TABLE hospital_management_backup AS SELECT * FROM hospital_management;

UPDATE hospital_management
SET TotalBillAmount = ROUND(
    TotalBillAmount 
    * (0.5 + RAND() * 1.5)  -- random 50%-200% of original, much wider spread
    * CASE RoomType
        WHEN 'ICU' THEN 1.4
        WHEN 'Private' THEN 1.2
        ELSE 0.9
      END
    * CASE Department
        WHEN 'Cardiology' THEN 1.20
        WHEN 'Neurology' THEN 1.15
        WHEN 'Surgery' THEN 1.25
        WHEN 'General' THEN 0.85
        ELSE 1.0
      END
, 2)
WHERE PatientID IS NOT NULL;


UPDATE hospital_management
SET AmountPaid = ROUND(
    TotalBillAmount * 
    CASE 
        WHEN RAND() < 0.12 THEN 0.02 + RAND() * 0.08         -- 12% of patients: nearly unpaid (2-10%)
        WHEN RAND() < 0.25 THEN 0.90 + RAND() * 0.10         -- ~13% of patients: fully paid (90-100%)
        WHEN PaymentMode = 'Insurance' THEN 0.55 + RAND() * 0.40   -- 55-95%, wide spread
        WHEN PaymentMode = 'Card'      THEN 0.35 + RAND() * 0.45   -- 35-80%
        WHEN PaymentMode = 'UPI'       THEN 0.25 + RAND() * 0.45   -- 25-70%
        WHEN PaymentMode = 'Cash'      THEN 0.15 + RAND() * 0.45   -- 15-60%
        ELSE 0.45 + RAND() * 0.30
    END
, 2)
WHERE PatientID IS NOT NULL;



UPDATE hospital_management
SET FeedbackRating = 
    CASE 
        WHEN Department IN ('Cardiology', 'Neurology') THEN 
            LEAST(5, GREATEST(1, ROUND(3.5 + RAND() * 2.5 - 1, 0)))
        WHEN Department = 'General' THEN 
            LEAST(5, GREATEST(1, ROUND(2.0 + RAND() * 2.5, 0)))
        ELSE 
            LEAST(5, GREATEST(1, ROUND(1 + RAND() * 4, 0)))
    END
WHERE PatientID IS NOT NULL;

-- Checking
select department,avg(feedbackrating) from hospital_management group by depARTment;
SELECT SUM(TotalBillAmount), SUM(AmountPaid), SUM(PendingAmount) FROM hospital_management; 
UPDATE hospital_management
SET PendingAmount = ROUND(TotalBillAmount - AmountPaid, 2)
WHERE PatientID IS NOT NULL;
SELECT SUM(TotalBillAmount), SUM(AmountPaid), SUM(PendingAmount) FROM hospital_management;


-- diagnosis fixing

DROP TABLE IF EXISTS hospital_management_backup2;
CREATE TABLE hospital_management_backup2 AS SELECT * FROM hospital_management;
SELECT COUNT(*) FROM hospital_management_backup2;

UPDATE hospital_management
SET Diagnosis = 
    CASE Department
        WHEN 'Ortho' THEN 
            CASE WHEN RAND() < 0.7 THEN 'Fracture' ELSE 'Hypertension' END
        WHEN 'Cardiology' THEN 
            CASE WHEN RAND() < 0.75 THEN 'Hypertension' ELSE 'Diabetes' END
        WHEN 'Neurology' THEN 
            CASE WHEN RAND() < 0.75 THEN 'Migraine' ELSE 'Cancer' END
        WHEN 'Surgery' THEN 
            CASE WHEN RAND() < 0.5 THEN 'Fracture' ELSE 'Cancer' END
        WHEN 'Pediatrics' THEN 
            CASE 
                WHEN RAND() < 0.35 THEN 'Asthma'
                WHEN RAND() < 0.65 THEN 'Flu'
                WHEN RAND() < 0.85 THEN 'COVID-19'
                ELSE 'Fracture'
            END
        WHEN 'ENT' THEN 
            CASE 
                WHEN RAND() < 0.4 THEN 'Flu'
                WHEN RAND() < 0.7 THEN 'Asthma'
                ELSE 'COVID-19'
            END
        WHEN 'General' THEN 
            CASE 
                WHEN RAND() < 0.25 THEN 'Flu'
                WHEN RAND() < 0.45 THEN 'COVID-19'
                WHEN RAND() < 0.65 THEN 'Diabetes'
                WHEN RAND() < 0.85 THEN 'Hypertension'
                ELSE 'Asthma'
            END
        ELSE Diagnosis
    END
WHERE PatientID IS NOT NULL;





-- verify fixing
SELECT Department, Diagnosis, COUNT(*) 
FROM hospital_management 
GROUP BY Department, Diagnosis 
ORDER BY Department, COUNT(*) DESC;