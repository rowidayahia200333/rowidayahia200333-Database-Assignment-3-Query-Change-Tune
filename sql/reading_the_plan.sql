--clustered index scan -> join : ممكن hash match لان الجدولين دول كبار شوية الداتا فيهم او ممكن لو هنفلتر بال where يختلف الطريقة nest loop مثلا -> select مبياخدش وقت  -> order by الترتيب ممكن لو مفيش index hash بردوا مثلا لان الداتا كبيره شوية مش عملاقة بردوا -> top

-- Table 'StudentProfiles'
logical reads 471 : يعني كان بيقرا من الرام عدد المرات دي ومراحش لل hard disk فيهم
physical reads 60 : راح قرا من ال hard deskk عدد المرات دي 

-- Table 'Worktable'     موجود مرتين ممكن يكون جدول مؤقت بيخزن فيه معلومات 
 logical reads 0, physical reads 0


 --Table 'Invoices'
  Scan count 13 : كام مرة عمل index 
 logical reads 2674, physical reads 3

 --ِActual Execution plan:-

 clustered 75% -> بيقرا كل صفحات الجدول finance.invoice وبيفلتر بيحقق الشروط 

 computer scalar 0% -> بيحسبلي ال total amount -> اختارة لان بيحسب ال remainng قبل ل sort 
 في المرة التانية عشان اجله يحسبه بل 15 فقط 

 sort -> 21% بيرتبلي كل لفواتير -> لان مفيش index  ف متضطر يرتبهبهم باستخدام ال sort 

 clustered index seek 0% -> بيدور علي طول جوا جدول profiles بال primary key 

 nest loops inner join 0% -> بيجمع الداتا المطلوبة من الجدولين -> لأن فرع الطلاب مفهرس بـ Clustered Index على Id، وكمان لأننا عايزين أول 15 صف بس (TOP 15)؛ فالـ Nested Loops بيسمح له يوقف البحث بمجرد ما يلاقي أول 15 صف متطابق من غير ما يضطر يربط باقي الجدول كله

 paralism ->  بيجمع نتائج الـ threads المتوازية اللي كانت شغالة مع بعض -> لأن حجم الشغل في مسح جدول الفواتير وترتيبه كان كبير كفاية إن الـ Optimizer يشغله على أكتر من Thread

 top 0% -> بيعد الصفوف الخارجة ويوقف لحد الصف 15 

 select -> 0% عشان يعرضلي البيانات 


 االي توقعتة صح -> claustered and sort 
  اللي توقعتة غلط ->  parallism 