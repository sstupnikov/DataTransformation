CREATE DATABASE [BandGap]

CREATE TABLE [dbo].[_SubstancesConv](
	[SubstanceID] [int] NOT NULL,
	[UpdateStatus] [int] NOT NULL,
	[NumElements] [int] NOT NULL,
	[Compound] [varchar](256) NOT NULL,
	[Elements] [varchar](256) NOT NULL,
 CONSTRAINT [PK___SubstancesConv] PRIMARY KEY ([SubstanceID])
)

CREATE TABLE [dbo].[_PropertiesConv](
	[NOMPROP] [int] NOT NULL,
	[UpdateStatus] [int] NOT NULL,
	[NAZVPROP] [varchar](128) NOT NULL,
	[HTML] [varchar](128) NOT NULL,
 CONSTRAINT [PK___PropertiesConv] PRIMARY KEY ([NOMPROP])
) 

CREATE TABLE [dbo].[_DBContentConv](
	[SubstanceID] [int] NOT NULL,
	[NOMPROP] [int] NOT NULL,
	[UpdateStatus] [int] NOT NULL,
 CONSTRAINT [PK_DBContentConv] PRIMARY KEY ([SubstanceID],[NOMPROP])
) 
