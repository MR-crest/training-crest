-- Using Array functions
-- ##############

/*
Quick into of an array
----------------------------

1. An array is an ordered collection of values
2. The 'Cardinality' of an array is the number of elements in the array. This values can be zero or more.
3. You can access individual elements in an array by enclosing their 'subscripts' or position in square brackets.
    e.g
    If you have a array named customers, then
    customers[2] will refer to the second element of the customers array
*/


---- RANGE DATATYPES 
SELECT 
	INT4RANGE(2,7),   --- Default [)  closed-open
	NUMRANGE(1.223,4.565,'[]'),     --- closed-closed
	DATERANGE('20020101','20200101','()'),   --- open-open
	TSRANGE(LOCALTIMESTAMP , LOCALTIMESTAMP + interval '8 days' , '(]'); --- open-closed


---- Arrays constructing
SELECT
	ARRAY[1,2,3] AS "INT Array",
	ARRAY[1.223::float] AS "Floating Array",
	ARRAY[CURRENT_DATE + 5 , CURRENT_DATE];

--- Equality operator
SELECT 
	ARRAY[1,2,3,4] = ARRAY[1,2,3,4],   --- lexiographical values checking 
	ARRAY[1,2,3,4] = ARRAY[0,2,3,4],
	ARRAY[1,2,3,4] = ARRAY[2,3,4,5],
	ARRAY[1,2,3,4] < ARRAY[2,3,4,5],
	ARRAY[1,2,3,4] > ARRAY[2,3,4,5],
	ARRAY[1,2,3,4] <= ARRAY[2,3,4,5],
	ARRAY[1,2,3,4] >= ARRAY[1,2,3,4],
	ARRAY[1,2,3,4] <> ARRAY[2,3,4,5];

--- For ranges
SELECT 
	INT4RANGE(1,3) @> INT4RANGE(2,4),  --- Fully within concept checking
	DATERANGE(CURRENT_DATE , CURRENT_DATE + 5) @> DATERANGE(CURRENT_DATE , CURRENT_DATE + 4),
	NUMRANGE(0,4) && NUMRANGE(1.2,5) ;  --- Range Overlap Checking

--- Array Construction
--- Array combining 
SELECT ARRAY[1,2,3] || ARRAY[4,5,6];

--- Using ARRAY_CAT
SELECT ARRAY_CAT(ARRAY[1,2,3],ARRAY[4,5,6]);

--- element adding in Array concatenate 
SELECT 4 || ARRAY[1,2,3];

--- using prepend
SELECT ARRAY_PREPEND(4 , ARRAY[1,2,3]);

--- adding element at end
SELECT  ARRAY[1,2,3] || 4;

--- append
SELECT ARRAY_APPEND(ARRAY[1,2,3] , 4);

--- Array Metadata Function
SELECT ARRAY_NDIMS(ARRAY[[1,2],[3,4]]) --- returns dimension of array in integer


SELECT ARRAY_DIMS(ARRAY[[1,2],[3,4]])  --- returns text representation

SELECT ARRAY_LENGTH(ARRAY[1,2,3,4],1)   --- array(array,dimension)

SELECT ARRAY_LOWER(ARRAY[1,2,3,4],1)

SELECT ARRAY_UPPER(ARRAY[[1,2],[3,4]],2)

--- Cardinality  --- Returns Number of memebers

SELECT 
	CARDINALITY(ARRAY[[1],[2],[3]]),  --- 3
	CARDINALITY(ARRAY[1,2,3])   --- 3

--- Position  --- ARRAY MUST BE ONE DIMENSIONAL
SELECT 
	ARRAY_POSITION(ARRAY[1,2,3,4],3),
	ARRAY_POSITION(ARRAY['JAN','FEB','MARCH','JUNE'],'FEB')

	--- for multiple matching elements

SELECT 
	ARRAY_POSITIONS(ARRAY[1,2,3,4,3,5,6,7,3],3)

SELECT 
	ARRAY_REMOVE(ARRAY[1,2,3,4,5],4)

SELECT
	ARRAY_REPLACE(ARRAY[1,2,3,4],2,10)  --- array,index,replacing element

--- Array Comparison
SELECT 
	20 IN (10,20,30,40);

SELECT 
	4 NOT IN (10,20,30,40);

--- ALL expression
SELECT 
	20 = ALL(ARRAY[10,20,30,40]);

SELECT 
	20 = ALL(ARRAY[20,20,20,20]);

--- Any Expressiom
SELECT 
	20 = ANY(ARRAY[10,20,30,40]);

SELECT 
	20 = ANY(ARRAY[10,30,40,NULL]);  --- gives NULL not false

SELECT 
	20 <> ANY(ARRAY[10,20,30,40,NULL]);   --- gives true even if 20 is in array

SELECT 
	20 = SOME(ARRAY[10,20,40,NULL]);   --- any and some is equal 