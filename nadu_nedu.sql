USE [Nadu_Nedu]
GO
/****** Object:  Table [dbo].[DistrictData]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DistrictData](
	[SlNo] [int] NULL,
	[DistrictName] [varchar](100) NULL,
	[TotalNoOfSchools] [int] NULL,
	[NoOfWorksSanctioned] [int] NULL,
	[NoOfWorksCaptured] [int] NULL,
	[NoOfWorksInProgress] [int] NULL,
	[NoOfWorksNotStarted] [int] NULL,
	[NoOfWorksStarted] [int] NULL,
	[CivilWorkInProgress] [int] NULL,
	[WorkCompletedExceptDoorsFixing] [int] NULL,
	[NoOfWorksCompleted] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Districts_Master]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Districts_Master](
	[District_Code] [int] NULL,
	[District_Name] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Mandal_Work_Status]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mandal_Work_Status](
	[SlNo] [int] NULL,
	[MandalName] [nvarchar](100) NULL,
	[TotalNoOfSchools] [int] NULL,
	[NoOfWorksSanctioned] [int] NULL,
	[NoOfWorksCaptured] [int] NULL,
	[NoOfWorks] [int] NULL,
	[Stages_NotStarted] [int] NULL,
	[Stages_Started] [int] NULL,
	[Stages_CivilWorkInProgress] [int] NULL,
	[Stages_WorkCompletedExceptDoorsAndWindowsFixing] [int] NULL,
	[Stages_Completed] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Mandals_Master]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mandals_Master](
	[District_Code] [int] NULL,
	[District_Name] [varchar](50) NULL,
	[Mandal_Code] [int] NULL,
	[Mandal_Name] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Schools_Master _code]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schools_Master _code](
	[Id] [bigint] NULL,
	[District_Code] [smallint] NULL,
	[Mandal_Code] [smallint] NULL,
	[School_Name] [varchar](120) NULL,
	[Udise_Code] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SchoolWorks]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchoolWorks](
	[No.] [int] NULL,
	[School Name] [varchar](100) NULL,
	[UDISE-Code] [varchar](20) NULL,
	[Works Status] [varchar](100) NULL,
	[Work Captured during the week (Tuesday to Monday)] [varchar](3) NULL,
	[Not Started] [varchar](3) NULL,
	[Started] [varchar](3) NULL,
	[In - Progress] [varchar](3) NULL,
	[Completed] [varchar](3) NULL,
	[Civil work inprogress] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetDistricts]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[GetDistricts]
AS
BEGIN
    SELECT *
    FROM DistrictData;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetDistricts_Mandal]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create PROCEDURE [dbo].[GetDistricts_Mandal]
    @District_Name varchar(50) null,
    @District_Code int null
AS
BEGIN
    SELECT 
	m.[Mandal_Code],
	m.District_Name,
	ms.MandalName, 
	ms.TotalNoOfSchools, 
	ms.NoOfWorksSanctioned, 
	ms.NoOfWorksCaptured,
	ms.NoOfWorks, 
	ms.Stages_NotStarted, 
	ms.Stages_Started, 
	ms.Stages_CivilWorkInProgress, 
	ms.Stages_WorkCompletedExceptDoorsAndWindowsFixing,
	ms.Stages_Completed
    FROM Mandals_Master m
    FULL JOIN Mandal_Work_Status ms ON m.Mandal_Name = ms.MandalName
    WHERE m.District_Name = @District_Name OR m.District_Code = @District_Code;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetMandal]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	  CREATE PROCEDURE [dbo].[GetMandal]
AS
BEGIN
    SELECT *
    FROM Mandal_Work_Status;
END;
GO
/****** Object:  StoredProcedure [dbo].[School_Works]    Script Date: 21-03-2024 5.00.50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[School_Works]
@Mandal_Code INT null,
@Mandal_Name varchar(50) null
AS
BEGIN
    SELECT MM.[Mandal_Code],MM.Mandal_Name,
	S.[No.],S.[School Name],
	S.[UDISE-Code],
	S.[Works Status], 
	S.[Work Captured during the week (Tuesday to Monday)], 
	S.[Not Started], 
	S.[Started],
	S.[In - Progress],
	S.[Completed],
	S.[Civil work inprogress]

    FROM SchoolWorks S  join [Schools_Master _code] sc
	on S.[UDISE-Code] = sc.[Udise_Code]  join [Mandals_Master] MM on MM.Mandal_Code=sc.[Mandal_Code]
	WHERE MM.Mandal_Code=@Mandal_Code or MM.Mandal_Name=@Mandal_Name
	order by [No.]
END;
GO
