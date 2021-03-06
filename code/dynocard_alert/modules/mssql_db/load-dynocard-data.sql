/******************************************************
 *
 * Name:         load-dynocard-data.sql
 *     
 * Design Phase:
 *     Author:   John Miner
 *     Date:     04-01-2018
 *     Purpose:  Create the schema for the [db4cards] database.
 * 
 ******************************************************/

/*

Special thanks to
	Kimberly Martinez 
	Robert Cutler

From
    Sandia National Laboratories
    Albuquerque, NM 

For supplying sample data
    http://www.sandia.gov/media/dynamo.htm

Execute the following t-sql scripts prior to running this script

  create-dynocard-db.sql
  create-dynocard-schema.sql

  insert-pump-data-set1.sql
  insert-pump-data-set2.sql

  insert-surface-data-set1.sql
  insert-surface-data-set2.sql
  insert-surface-data-set3.sql
  insert-surface-data-set4.sql

*/


-- !!!


/*
  ~~ 1 - Add sample pump data to the schema ~~
*/

INSERT INTO [ACTIVE].[PUMP] VALUES
(
    'SANDIA-06',
	'1996-12-01',
	'32.7767',
	'-90.0404',
	'TENSION PUMP DATA FROM DYNOCARD DATABASE CERCA 1996.',
	DEFAULT,
	DEFAULT
);
GO

-- Show the data
SELECT * FROM [ACTIVE].[PUMP];
GO

/*
  ~~ 2 - Add dyno card data to the schema ~~
*/

-- Card 1
INSERT INTO [ACTIVE].[DYNO_CARD] VALUES
(
1,
DEFAULT,
DEFAULT
);
GO

-- Card 2
INSERT INTO [ACTIVE].[DYNO_CARD] VALUES
(
1,
DEFAULT,
DEFAULT
);
GO

-- Card 3
INSERT INTO [ACTIVE].[DYNO_CARD] VALUES
(
1,
DEFAULT,
DEFAULT
);
GO

-- Card 4
INSERT INTO [ACTIVE].[DYNO_CARD] VALUES
(
1,
DEFAULT,
DEFAULT
);
GO

-- Show the data
SELECT * FROM [ACTIVE].[DYNO_CARD];
GO



/*
  ~~ 3 - Create a surface card & pump card header/detail for each dyno card 1 ~~
*/

-- A - surface data (summary)
INSERT INTO [ACTIVE].[CARD_HEADER] 
(
    DC_ID,
	CH_EPOC_DATE,
    CH_SCALED_MAX_LOAD,
    CH_SCALED_MIN_LOAD,
    CH_STROKE_LENGTH,
    CH_STROKE_PERIOD,
	CH_NUMBER_OF_POINTS,
    CH_CARD_TYPE
) 
SELECT 
    1 AS DC_ID,
	CONVERT(int, DATEDIFF(ss, '01-01-1970 00:00:00', '12/13/96 10:00:00 AM')) as CH_EPOC_DATE,
    MAX(SD_LOAD) AS CH_SCALED_MAX_LOAD,
    MIN(SD_LOAD) AS CH_SCALED_MIN_LOAD,
	MAX(SD_POSITION) AS CH_STROKE_LENGTH,
	60.0 AS CH_STROKE_PERIOD,
	100 AS CH_NUMBER_OF_POINTS,
	'S' AS CH_CARD_TYPE
FROM 
    [STAGE].[SURFACE_DATA] WHERE SD_TAG = 'SX6E03A';
GO


-- B - surface data (details)
INSERT INTO [ACTIVE].[CARD_DETAIL]
(
    CH_ID,
	CD_POSITION,
	CD_LOAD
)
SELECT 
    1 AS CH_ID,
    SD_POSITION AS CH_POSITION,
    SD_LOAD AS CH_LOAD
FROM 
    [STAGE].[SURFACE_DATA] WHERE SD_TAG = 'SX6E03A'
GO


-- C - pump data (summary)
INSERT INTO [ACTIVE].[CARD_HEADER] 
(
    DC_ID,
	CH_EPOC_DATE,
    CH_SCALED_MAX_LOAD,
    CH_SCALED_MIN_LOAD,
    CH_STROKE_LENGTH,
    CH_STROKE_PERIOD,
	CH_NUMBER_OF_POINTS,
    CH_CARD_TYPE
) 
SELECT
    1 AS DC_ID,
	CONVERT(int, DATEDIFF(ss, '01-01-1970 00:00:00', '12/13/96 10:00:00 AM')) as CH_EPOC_DATE,
    MAX(PD_LOAD) AS CH_SCALED_MAX_LOAD,
    MIN(PD_LOAD) AS CH_SCALED_MIN_LOAD,
	MAX(PD_POSITION) AS CH_STROKE_LENGTH,
	60.0 AS CH_STROKE_PERIOD,
	275 AS CH_NUMBER_OF_POINTS,
	'P' AS CH_CARD_TYPE
FROM
    [STAGE].[PUMP_DATA] 
WHERE 
    PD_TAG = '3X6E03' AND PD_ID >= 1 AND PD_ID <= 275;
GO

-- D - pump data (details)
INSERT INTO [ACTIVE].[CARD_DETAIL]
(
    CH_ID,
	CD_POSITION,
	CD_LOAD
)
SELECT 
    2 AS CH_ID,
    PD_POSITION AS CH_POSITION,
    PD_LOAD AS CH_LOAD
FROM
    [STAGE].[PUMP_DATA] 
WHERE 
    PD_TAG = '3X6E03' AND PD_ID >= 1 AND PD_ID <= 275;
GO

-- Show the data
SELECT * FROM [ACTIVE].[CARD_HEADER] WHERE DC_ID = 1;
GO

-- Show the data
SELECT * FROM [ACTIVE].[CARD_DETAIL] WHERE CH_ID IN (1, 2);
GO



/*
  ~~ 4 - Create a surface card & pump card header/detail for each dyno card 2 ~~
*/

-- A - surface data (summary)
INSERT INTO [ACTIVE].[CARD_HEADER] 
(
    DC_ID,
	CH_EPOC_DATE,
    CH_SCALED_MAX_LOAD,
    CH_SCALED_MIN_LOAD,
    CH_STROKE_LENGTH,
    CH_STROKE_PERIOD,
	CH_NUMBER_OF_POINTS,
    CH_CARD_TYPE
) 
SELECT 
    2 AS DC_ID,
	CONVERT(int, DATEDIFF(ss, '01-01-1970 00:00:00', '12/13/96 11:00:00 AM')) as CH_EPOC_DATE,
    MAX(SD_LOAD) AS CH_SCALED_MAX_LOAD,
    MIN(SD_LOAD) AS CH_SCALED_MIN_LOAD,
	MAX(SD_POSITION) AS CH_STROKE_LENGTH,
	60.0 AS CH_STROKE_PERIOD,
	100 AS CH_NUMBER_OF_POINTS,
	'S' AS CH_CARD_TYPE
FROM 
    [STAGE].[SURFACE_DATA] WHERE SD_TAG = 'SX6E03B';
GO


-- B - surface data (details)
INSERT INTO [ACTIVE].[CARD_DETAIL]
(
    CH_ID,
	CD_POSITION,
	CD_LOAD
)
SELECT 
    3 AS CH_ID,
    SD_POSITION AS CH_POSITION,
    SD_LOAD AS CH_LOAD
FROM 
    [STAGE].[SURFACE_DATA] WHERE SD_TAG = 'SX6E03B'
GO


-- C - pump data (summary)
INSERT INTO [ACTIVE].[CARD_HEADER] 
(
    DC_ID,
	CH_EPOC_DATE,
    CH_SCALED_MAX_LOAD,
    CH_SCALED_MIN_LOAD,
    CH_STROKE_LENGTH,
    CH_STROKE_PERIOD,
	CH_NUMBER_OF_POINTS,
    CH_CARD_TYPE
) 
SELECT
    2 AS DC_ID,
	CONVERT(int, DATEDIFF(ss, '01-01-1970 00:00:00', '12/13/96 11:00:00 AM')) as CH_EPOC_DATE,
    MAX(PD_LOAD) AS CH_SCALED_MAX_LOAD,
    MIN(PD_LOAD) AS CH_SCALED_MIN_LOAD,
	MAX(PD_POSITION) AS CH_STROKE_LENGTH,
	60.0 AS CH_STROKE_PERIOD,
	275 AS CH_NUMBER_OF_POINTS,
	'P' AS CH_CARD_TYPE
FROM
    [STAGE].[PUMP_DATA] 
WHERE 
    PD_TAG = '3X6E03' AND PD_ID >= 276 AND PD_ID <= 550;
GO

-- D - pump data (details)
INSERT INTO [ACTIVE].[CARD_DETAIL]
(
    CH_ID,
	CD_POSITION,
	CD_LOAD
)
SELECT 
    4 AS CH_ID,
    PD_POSITION AS CH_POSITION,
    PD_LOAD AS CH_LOAD
FROM
    [STAGE].[PUMP_DATA] 
WHERE 
    PD_TAG = '3X6E03' AND PD_ID >= 276 AND PD_ID <= 550;
GO


-- Show the data
SELECT * FROM [ACTIVE].[CARD_HEADER] WHERE DC_ID = 2;
GO

-- Show the data
SELECT * FROM [ACTIVE].[CARD_DETAIL] WHERE CH_ID IN (3, 4);
GO



/*
  ~~ 5 - Create a surface card & pump card header/detail for each dyno card 3 ~~
*/

-- A - surface data (summary)
INSERT INTO [ACTIVE].[CARD_HEADER] 
(
    DC_ID,
	CH_EPOC_DATE,
    CH_SCALED_MAX_LOAD,
    CH_SCALED_MIN_LOAD,
    CH_STROKE_LENGTH,
    CH_STROKE_PERIOD,
	CH_NUMBER_OF_POINTS,
    CH_CARD_TYPE
) 
SELECT 
    3 AS DC_ID,
	CONVERT(int, DATEDIFF(ss, '01-01-1970 00:00:00', '12/13/96 12:00:00 PM')) as CH_EPOC_DATE,
    MAX(SD_LOAD) AS CH_SCALED_MAX_LOAD,
    MIN(SD_LOAD) AS CH_SCALED_MIN_LOAD,
	MAX(SD_POSITION) AS CH_STROKE_LENGTH,
	60.0 AS CH_STROKE_PERIOD,
	100 AS CH_NUMBER_OF_POINTS,
	'S' AS CH_CARD_TYPE
FROM 
    [STAGE].[SURFACE_DATA] WHERE SD_TAG = 'SX6I03A';
GO


-- B - surface data (details)
INSERT INTO [ACTIVE].[CARD_DETAIL]
(
    CH_ID,
	CD_POSITION,
	CD_LOAD
)
SELECT 
    5 AS CH_ID,
    SD_POSITION AS CH_POSITION,
    SD_LOAD AS CH_LOAD
FROM 
    [STAGE].[SURFACE_DATA] WHERE SD_TAG = 'SX6I03A'
GO


-- C - pump data (summary)
INSERT INTO [ACTIVE].[CARD_HEADER] 
(
    DC_ID,
	CH_EPOC_DATE,
    CH_SCALED_MAX_LOAD,
    CH_SCALED_MIN_LOAD,
    CH_STROKE_LENGTH,
    CH_STROKE_PERIOD,
	CH_NUMBER_OF_POINTS,
    CH_CARD_TYPE
) 
SELECT
    3 AS DC_ID,
	CONVERT(int, DATEDIFF(ss, '01-01-1970 00:00:00', '12/13/96 12:00:00 PM')) as CH_EPOC_DATE,
    MAX(PD_LOAD) AS CH_SCALED_MAX_LOAD,
    MIN(PD_LOAD) AS CH_SCALED_MIN_LOAD,
	MAX(PD_POSITION) AS CH_STROKE_LENGTH,
	60.0 AS CH_STROKE_PERIOD,
	275 AS CH_NUMBER_OF_POINTS,
	'P' AS CH_CARD_TYPE
FROM
    [STAGE].[PUMP_DATA] 
WHERE 
    PD_TAG = '3X6I03' AND PD_ID > 3002 AND PD_ID < 3278
GO


-- D - pump data (details)
INSERT INTO [ACTIVE].[CARD_DETAIL]
(
    CH_ID,
	CD_POSITION,
	CD_LOAD
)
SELECT 
    6 AS CH_ID,
    PD_POSITION AS CH_POSITION,
    PD_LOAD AS CH_LOAD
FROM
    [STAGE].[PUMP_DATA] 
WHERE 
    PD_TAG = '3X6I03' AND PD_ID > 3002 AND PD_ID < 3278
GO


-- Show the data
SELECT * FROM [ACTIVE].[CARD_HEADER] WHERE DC_ID = 3;
GO

-- Show the data
SELECT * FROM [ACTIVE].[CARD_DETAIL] WHERE CH_ID IN (5, 6);
GO



/*
  ~~ 6 - Create a surface card & pump card header/detail for each dyno card 4 ~~
*/

-- A - surface data (summary)
INSERT INTO [ACTIVE].[CARD_HEADER] 
(
    DC_ID,
	CH_EPOC_DATE,
    CH_SCALED_MAX_LOAD,
    CH_SCALED_MIN_LOAD,
    CH_STROKE_LENGTH,
    CH_STROKE_PERIOD,
	CH_NUMBER_OF_POINTS,
    CH_CARD_TYPE
) 
SELECT 
    4 AS DC_ID,
	CONVERT(int, DATEDIFF(ss, '01-01-1970 00:00:00', '12/13/96 01:00:00 PM')) as CH_EPOC_DATE,
    MAX(SD_LOAD) AS CH_SCALED_MAX_LOAD,
    MIN(SD_LOAD) AS CH_SCALED_MIN_LOAD,
	MAX(SD_POSITION) AS CH_STROKE_LENGTH,
	60.0 AS CH_STROKE_PERIOD,
	100 AS CH_NUMBER_OF_POINTS,
	'S' AS CH_CARD_TYPE
FROM 
    [STAGE].[SURFACE_DATA] WHERE SD_TAG = 'SX6I03B';
GO


-- B - surface data (details)
INSERT INTO [ACTIVE].[CARD_DETAIL]
(
    CH_ID,
	CD_POSITION,
	CD_LOAD
)
SELECT 
    7 AS CH_ID,
    SD_POSITION AS CH_POSITION,
    SD_LOAD AS CH_LOAD
FROM 
    [STAGE].[SURFACE_DATA] WHERE SD_TAG = 'SX6I03B'
GO


-- C - pump data (summary)
INSERT INTO [ACTIVE].[CARD_HEADER] 
(
    DC_ID,
	CH_EPOC_DATE,
    CH_SCALED_MAX_LOAD,
    CH_SCALED_MIN_LOAD,
    CH_STROKE_LENGTH,
    CH_STROKE_PERIOD,
	CH_NUMBER_OF_POINTS,
    CH_CARD_TYPE
) 
SELECT
    4 AS DC_ID,
	CONVERT(int, DATEDIFF(ss, '01-01-1970 00:00:00', '12/13/96 01:00:00 PM')) as CH_EPOC_DATE,
    MAX(PD_LOAD) AS CH_SCALED_MAX_LOAD,
    MIN(PD_LOAD) AS CH_SCALED_MIN_LOAD,
	MAX(PD_POSITION) AS CH_STROKE_LENGTH,
	60.0 AS CH_STROKE_PERIOD,
	275 AS CH_NUMBER_OF_POINTS,
	'P' AS CH_CARD_TYPE
FROM
    [STAGE].[PUMP_DATA] 
WHERE 
    PD_TAG = '3X6I03' AND PD_ID > 3278 AND PD_ID < 3554
GO


-- D - pump data (details)
INSERT INTO [ACTIVE].[CARD_DETAIL]
(
    CH_ID,
	CD_POSITION,
	CD_LOAD
)
SELECT 
    8 AS CH_ID,
    PD_POSITION AS CH_POSITION,
    PD_LOAD AS CH_LOAD
FROM
    [STAGE].[PUMP_DATA] 
WHERE 
    PD_TAG = '3X6I03' AND PD_ID > 3278 AND PD_ID < 3554
GO


-- Show the data
SELECT * FROM [ACTIVE].[CARD_HEADER] WHERE DC_ID = 4;
GO

-- Show the data
SELECT * FROM [ACTIVE].[CARD_DETAIL] WHERE CH_ID IN (7, 8);
GO




/*
  ~~ 7 - Create a single event ~~
*/


-- Add sample events
INSERT INTO [ACTIVE].[EVENT] VALUES
(
    1,
	CONVERT(int, DATEDIFF(ss, '01-01-1970 00:00:00', '12/13/96 10:00:00 AM')),
	NEWID(),
	DEFAULT,
	DEFAULT
);
GO

-- Show the data
SELECT * FROM [ACTIVE].[EVENT];
GO


/*
  ~~ 8 - Link 4 cards to one event ~~
*/


-- A - event detail 1 = dyno card 1
INSERT INTO [ACTIVE].[EVENT_DETAIL] VALUES
(
    1,
	1,
	DEFAULT,
	DEFAULT,
	DEFAULT
);
GO

-- B - event detail 2 = dyno card 2
INSERT INTO [ACTIVE].[EVENT_DETAIL] VALUES
(
    1,
	2,
	-1,
	DEFAULT,
	DEFAULT
);
GO

-- C - event detail 3 = dyno card 3
INSERT INTO [ACTIVE].[EVENT_DETAIL] VALUES
(
    1,
	3,
	DEFAULT,
	DEFAULT,
	DEFAULT
);
GO

-- D - event detail 4 = dyno card 4
INSERT INTO [ACTIVE].[EVENT_DETAIL] VALUES
(
    1,
	4,
	DEFAULT,
	DEFAULT,
	DEFAULT
);
GO

-- Show the data
SELECT * FROM [ACTIVE].[EVENT_DETAIL];
GO