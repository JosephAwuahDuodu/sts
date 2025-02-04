-- QUESTION
-- Use the student science_class data from @Emma  (Kindly share the student data), Using Windows Functions in SQL, rank the students into the following groups.

select *, 
Case
when science_marks >= 90 Then  'A'
when science_marks >= 80 Then  'B'
when science_marks >= 70 Then  'C'
when science_marks >= 60 Then  'D'
when science_marks >= 40 Then  'E'
when science_marks >= 30 Then  'F'
when science_marks >= 0 Then  'Demote'
END as Grade,
Rank() OVER (Order by science_marks desc) as position
From students; 

-- RESULTS

 enrollment_id |  name   | science_marks | grade  | position 
---------------+---------+---------------+--------+----------
             5 | Robb    |            97 | A      |        1
            10 | Junior  |            83 | B      |        2
            15 | Kofi    |            82 | B      |        3
             4 | Zooey   |            82 | B      |        3
             1 | Linnett |            79 | C      |        5
             8 | Arya    |            78 | C      |        6
             3 | Sam     |            63 | D      |        7
            13 | Miky    |            62 | D      |        8
             9 | Sampson |            56 | E      |        9
             7 | Sansa   |            54 | E      |       10
             2 | Jayden  |            45 | E      |       11
             6 | Jon     |            38 | F      |       12
            12 | Ama     |            31 | F      |       13
            11 | Akosua  |            20 | Demote |       14
            14 | Rose    |            19 | Demote |       15


-- QUESTION 2
-- Explain the difference between RANK(), ROW_NUMBER() and DENSE_RANK() as window functions in SQL
All three functions are Window functions but the main differences are
ROW_NUMBER() - Assigns a unique row number without skipping any ranks.
DENSE_RANK() - Assigns the same rank to duplicate values without skipping ranks.
RANK() - Assigns the same rank to rows with the same values.
