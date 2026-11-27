-- task 9
-- DISTINCT on a non-indexed column
SET STATISTICS IO, TIME ON;

SELECT DISTINCT Status
FROM finance.Invoices;

SET STATISTICS IO, TIME OFF;

--  DISTINCT on an already unique column
SET STATISTICS IO, TIME ON;

SELECT DISTINCT Id
FROM finance.Invoices;

SET STATISTICS IO, TIME OFF;

--في الحالة الاولي استخدم hash table عشان يشيل الصفوف المتكررة 
-- بتعدي علي البيانات وتقارن الصف الحالي باللي قبلة في hash function  الاول ف متعملش مساحة كبيرة 
--عشان يختار الطريقة الارخص الصفوف تكون مترتبة اصلا 
-- في المرة التانية مع حاجة unique القيم مترتبة وهي اصلا unique ف هو عارف انه مش محتاج يشيل اي تكرارات بيكون في index