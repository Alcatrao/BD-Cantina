USE [master]
GO
/****** Object:  Database [p2g8]    Script Date: 2020-06-12 23:36:36 ******/
CREATE DATABASE [p2g8]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'p2g8', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\p2g8.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'p2g8_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\p2g8_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [p2g8] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [p2g8].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [p2g8] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [p2g8] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [p2g8] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [p2g8] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [p2g8] SET ARITHABORT OFF 
GO
ALTER DATABASE [p2g8] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [p2g8] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [p2g8] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [p2g8] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [p2g8] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [p2g8] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [p2g8] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [p2g8] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [p2g8] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [p2g8] SET  ENABLE_BROKER 
GO
ALTER DATABASE [p2g8] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [p2g8] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [p2g8] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [p2g8] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [p2g8] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [p2g8] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [p2g8] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [p2g8] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [p2g8] SET  MULTI_USER 
GO
ALTER DATABASE [p2g8] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [p2g8] SET DB_CHAINING OFF 
GO
ALTER DATABASE [p2g8] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [p2g8] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [p2g8] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [p2g8] SET QUERY_STORE = OFF
GO
USE [p2g8]
GO
/****** Object:  User [p2g8]    Script Date: 2020-06-12 23:36:37 ******/
CREATE USER [p2g8] FOR LOGIN [p2g8] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [p2g8]
GO
/****** Object:  Schema [Aula09]    Script Date: 2020-06-12 23:36:37 ******/
CREATE SCHEMA [Aula09]
GO
/****** Object:  Schema [Cantina]    Script Date: 2020-06-12 23:36:37 ******/
CREATE SCHEMA [Cantina]
GO
/****** Object:  Schema [Company]    Script Date: 2020-06-12 23:36:37 ******/
CREATE SCHEMA [Company]
GO
/****** Object:  Schema [Prescricao]    Script Date: 2020-06-12 23:36:37 ******/
CREATE SCHEMA [Prescricao]
GO
/****** Object:  Schema [Stocks]    Script Date: 2020-06-12 23:36:37 ******/
CREATE SCHEMA [Stocks]
GO
/****** Object:  UserDefinedFunction [Company].[udfRecordSet]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--g)
CREATE FUNCTION [Company].[udfRecordSet](@dno int) RETURNS @table TABLE (pname varchar(15), number int, plocation varchar(15), dnum int, budget decimal(10,2), totalbudget decimal(10,2))
AS
BEGIN

	DECLARE @pname as varchar(15), @number as int, @plocation as varchar(15), @dnum as int, @budget as decimal(10,2), @totalbudget as decimal(10,2);
	DECLARE C CURSOR FAST_FORWARD

	FOR SELECT Pname, Pnumber, Plocation, Dnumber, Sum(Salary*[Hours]/40) FROM	Company.DEPARTMENT JOIN Company.PROJECT ON Dnumber=Dnum JOIN Company.WORKS_ON ON Pnumber=Pno JOIN Company.EMPLOYEE ON Essn=Ssn WHERE Dnumber=@dno GROUP BY Pname, Pnumber, Plocation, Dnumber;

	OPEN C;

	FETCH C INTO @pname, @number, @plocation, @dnum, @budget;
	SELECT @totalbudget = 0;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @totalbudget += @budget;
		INSERT INTO @table VALUES (@pname, @number, @plocation, @dnum, @budget, @totalbudget)
		FETCH C INTO @pname, @number, @plocation, @dnum, @budget;
	END

	CLOSE C;

	DEALLOCATE C;

	return;
END
GO
/****** Object:  Table [Company].[EMPLOYEE]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Company].[EMPLOYEE](
	[Fname] [varchar](15) NOT NULL,
	[Minit] [char](1) NULL,
	[Lname] [varchar](15) NOT NULL,
	[Ssn] [char](9) NOT NULL,
	[Bdate] [date] NULL,
	[Address] [varchar](30) NULL,
	[Sex] [char](1) NULL,
	[Salary] [decimal](10, 2) NULL,
	[Super_ssn] [char](9) NULL,
	[Dno] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Ssn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Company].[PROJECT]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Company].[PROJECT](
	[Pname] [varchar](15) NULL,
	[Pnumber] [int] NOT NULL,
	[Plocation] [varchar](15) NULL,
	[Dnum] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Pnumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Company].[WORKS_ON]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Company].[WORKS_ON](
	[Essn] [char](9) NOT NULL,
	[Pno] [int] NOT NULL,
	[Hours] [decimal](3, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Essn] ASC,
	[Pno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [Company].[udfNomeLocal]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--e)
CREATE FUNCTION [Company].[udfNomeLocal] (@Ssn DECIMAL(9,0)) RETURNS Table
AS

	RETURN(SELECT Pname, Plocation FROM Company.EMPLOYEE JOIN Company.WORKS_ON ON Ssn=Essn JOIN Company.PROJECT ON Pno=Pnumber WHERE EMPLOYEE.SSN=@Ssn);
GO
/****** Object:  UserDefinedFunction [Company].[udfVencimento]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--f)
CREATE FUNCTION [Company].[udfVencimento](@dno int) RETURNS TABLE
AS
	RETURN(SELECT Ssn FROM Company.EMPLOYEE WHERE DNO=@Dno AND Salary>(SELECT AVG(Salary) FROM Company.EMPLOYEE WHERE Dno=@Dno));
GO
/****** Object:  Table [Aula09].[Customers]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Aula09].[Customers](
	[CustomerID] [int] NOT NULL,
	[CompanyName] [varchar](300) NULL,
	[ContactName] [varchar](300) NULL,
	[Address] [varchar](300) NULL,
	[City] [varchar](300) NULL,
	[Region] [varchar](300) NULL,
	[PostalCode] [varchar](300) NULL,
	[Country] [varchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[CARGO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[CARGO](
	[Codigo] [varchar](76) NOT NULL,
	[Descricao] [varchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[CESTO_DE_COMPRA]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[CESTO_DE_COMPRA](
	[Pid] [int] NOT NULL,
	[C_ref_fatura] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Pid] ASC,
	[C_ref_fatura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[CLIENTE]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[CLIENTE](
	[Nif] [int] NOT NULL,
	[Fname] [varchar](32) NULL,
	[Lname] [varchar](32) NULL,
	[Email] [varchar](76) NULL,
	[Tipo] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Nif] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[COMPOSICAO_DO_MENU]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[COMPOSICAO_DO_MENU](
	[Pid] [int] NOT NULL,
	[Mid] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Mid] ASC,
	[Pid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[COMPOSICAO_DO_PRATO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[COMPOSICAO_DO_PRATO](
	[Pid] [int] NOT NULL,
	[Iid] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Iid] ASC,
	[Pid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[COMPRA]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[COMPRA](
	[Cnif] [int] NOT NULL,
	[Datahora] [datetime] NOT NULL,
	[Ref_fatura] [int] IDENTITY(1,1) NOT NULL,
	[Fid] [int] NOT NULL,
 CONSTRAINT [PK__COMPRA__5104B0E169851E56] PRIMARY KEY CLUSTERED 
(
	[Ref_fatura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[DISPENSA]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[DISPENSA](
	[Id] [int] NOT NULL,
	[Capacidade] [decimal](15, 2) NOT NULL,
	[CapacidadeAtual] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[FUNCIONARIO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[FUNCIONARIO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fname] [varchar](32) NOT NULL,
	[Lname] [varchar](32) NOT NULL,
	[Email] [varchar](76) NOT NULL,
	[Ccodigo] [varchar](76) NOT NULL,
	[Salario] [decimal](10, 2) NULL,
 CONSTRAINT [PK__FUNCIONA__3214EC0718002211] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[INGREDIENTE]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[INGREDIENTE](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](76) NULL,
	[Valor_nutritivo] [decimal](10, 2) NULL,
	[Quantidade_disponivel] [decimal](10, 2) NOT NULL,
	[Alergenios] [varchar](76) NULL,
	[Did] [int] NULL,
 CONSTRAINT [PK__INGREDIE__3214EC07B8875FED] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[MENU]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[MENU](
	[Id] [int] NOT NULL,
	[Nome] [varchar](76) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[PRATO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[PRATO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [varchar](76) NULL,
	[Nome] [varchar](76) NULL,
 CONSTRAINT [PK__PRATO__3214EC07D582BD13] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[TIPO_CLIENTE]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[TIPO_CLIENTE](
	[Id] [int] NOT NULL,
	[Nome] [varchar](32) NULL,
	[Preco] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[TURNO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[TURNO](
	[Datahora_inicio] [varchar](64) NOT NULL,
	[Datahora_fim] [varchar](64) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Datahora_inicio] ASC,
	[Datahora_fim] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cantina].[TURNO_ATRIBUIDO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cantina].[TURNO_ATRIBUIDO](
	[Datahora_inicio] [varchar](64) NOT NULL,
	[Datahora_fim] [varchar](64) NOT NULL,
	[Fid] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Datahora_inicio] ASC,
	[Datahora_fim] ASC,
	[Fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Company].[DEPARTMENT]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Company].[DEPARTMENT](
	[Dname] [varchar](60) NULL,
	[Dnumber] [int] NOT NULL,
	[Mgr_ssn] [char](9) NULL,
	[Mgr_start_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[Dnumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Company].[DEPENDENT]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Company].[DEPENDENT](
	[Essn] [char](9) NOT NULL,
	[Dependent_name] [varchar](15) NOT NULL,
	[Sex] [char](1) NOT NULL,
	[Bdate] [date] NULL,
	[Relationship] [varchar](8) NULL,
PRIMARY KEY CLUSTERED 
(
	[Essn] ASC,
	[Dependent_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Company].[DEPT_LOCATIONS]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Company].[DEPT_LOCATIONS](
	[Dnumber] [int] NOT NULL,
	[Dlocation] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Dnumber] ASC,
	[Dlocation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Hello]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hello](
	[MsgID] [int] NOT NULL,
	[MsgSubject] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MsgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prescricao].[FARMACEUTICA]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prescricao].[FARMACEUTICA](
	[nome] [varchar](15) NOT NULL,
	[numReg] [int] NOT NULL,
	[endereco] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[numReg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prescricao].[FARMACIA]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prescricao].[FARMACIA](
	[nome] [varchar](15) NOT NULL,
	[telefone] [int] NOT NULL,
	[endereco] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prescricao].[FARMACO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prescricao].[FARMACO](
	[numRegFarm] [int] NOT NULL,
	[nome] [varchar](15) NOT NULL,
	[formula] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[formula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prescricao].[MEDICO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prescricao].[MEDICO](
	[numSNS] [int] NOT NULL,
	[nome] [varchar](30) NULL,
	[especialidade] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[numSNS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prescricao].[PACIENTE]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prescricao].[PACIENTE](
	[numUtente] [int] NOT NULL,
	[nome] [varchar](30) NULL,
	[dataNasc] [date] NOT NULL,
	[endereco] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[numUtente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prescricao].[PRESC_FARMACO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prescricao].[PRESC_FARMACO](
	[numPresc] [int] NOT NULL,
	[numRegFarm] [int] NOT NULL,
	[nomeFarmaco] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[numPresc] ASC,
	[numRegFarm] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prescricao].[PRESCRICAO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prescricao].[PRESCRICAO](
	[numPresc] [int] NOT NULL,
	[numUtente] [int] NOT NULL,
	[numMedico] [int] NOT NULL,
	[farmacia] [varchar](15) NULL,
	[dataProc] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[numPresc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Stocks].[ENCOMENDA]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stocks].[ENCOMENDA](
	[Data] [date] NOT NULL,
	[Numero] [int] NOT NULL,
	[Fornecedor] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Stocks].[FORNECEDOR]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stocks].[FORNECEDOR](
	[Nif] [int] NOT NULL,
	[Nome] [varchar](15) NOT NULL,
	[Fax] [int] NULL,
	[Endereço] [varchar](30) NULL,
	[Condpag] [int] NOT NULL,
	[Tipo] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Nif] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Stocks].[ITEM]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stocks].[ITEM](
	[NumEnc] [int] NOT NULL,
	[CodProd] [int] NOT NULL,
	[Unidades] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumEnc] ASC,
	[CodProd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Stocks].[PRODUTO]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stocks].[PRODUTO](
	[PreCo] [decimal](10, 2) NOT NULL,
	[Iva] [decimal](10, 2) NOT NULL,
	[Nome] [varchar](30) NOT NULL,
	[Unidades] [int] NULL,
	[Codigo] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Stocks].[TIPO_FORNECEDOR]    Script Date: 2020-06-12 23:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stocks].[TIPO_FORNECEDOR](
	[Codigo] [int] NOT NULL,
	[Designacao] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [Aula09].[Customers] ([CustomerID], [CompanyName], [ContactName], [Address], [City], [Region], [PostalCode], [Country]) VALUES (1, N'UAveiro', N'Té', N'Rua Velha', N'Aveiro', N'Aveiro', N'123-123', N'123-123')
INSERT [Aula09].[Customers] ([CustomerID], [CompanyName], [ContactName], [Address], [City], [Region], [PostalCode], [Country]) VALUES (2, N'UAlgarve', N'12312312', N'Rua Velha', N'Aveiro', N'Aveiro', N'123-123', N'123-123')
INSERT [Aula09].[Customers] ([CustomerID], [CompanyName], [ContactName], [Address], [City], [Region], [PostalCode], [Country]) VALUES (3, N'UA', N'456456', N'Rua dos sonhhos', N'Aveiro', N'Aveiro', N'674563', N'674563')
INSERT [Aula09].[Customers] ([CustomerID], [CompanyName], [ContactName], [Address], [City], [Region], [PostalCode], [Country]) VALUES (4, N'Ualcabaz', N'Alcatrão', N'Praia de Mira', N'Coimbra', N'Mira', N'7073', N'7070')
INSERT [Aula09].[Customers] ([CustomerID], [CompanyName], [ContactName], [Address], [City], [Region], [PostalCode], [Country]) VALUES (5, N'Caretos', N'Deus me livre', N'Nossa Senhora', N'Fátima', N'', N'', N'')
INSERT [Cantina].[CARGO] ([Codigo], [Descricao]) VALUES (N'atendimento', N'Empregados de atendimento')
INSERT [Cantina].[CARGO] ([Codigo], [Descricao]) VALUES (N'cozinha', N'Empregados de cozinha')
INSERT [Cantina].[CARGO] ([Codigo], [Descricao]) VALUES (N'limpeza', N'Empregados de limpeza')
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (2, 1)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 1)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 1)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 4)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (8, 6)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (6, 7)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 10)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 16)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (6, 16)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 16)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 17)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 18)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 18)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 19)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 20)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (6, 20)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 21)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 24)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 25)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 26)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (6, 27)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 29)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 30)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (2, 32)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 34)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (6, 34)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (5, 35)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 35)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 35)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 38)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (5, 40)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 40)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 41)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 44)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 45)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (2, 46)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 47)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 49)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (5, 50)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 58)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (8, 59)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 61)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 63)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 63)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 65)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 65)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (8, 66)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 66)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 66)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (5, 67)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 68)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 69)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 70)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 71)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (5, 71)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (6, 71)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 71)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 72)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 72)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 72)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 73)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (6, 76)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 76)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 76)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 78)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 79)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 79)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 80)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (6, 81)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (8, 82)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 83)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 84)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 86)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 86)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 87)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 89)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (2, 90)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 90)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 90)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 91)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 92)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 92)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 93)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (5, 94)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (1, 95)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 95)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (7, 96)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (8, 97)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 97)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (6, 99)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (4, 100)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (9, 100)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (10, 100)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 108)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (17, 108)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 109)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (17, 109)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (13, 110)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (17, 110)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (15, 111)
GO
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (16, 111)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (14, 113)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (16, 113)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (17, 114)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (14, 116)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (16, 116)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (3, 117)
INSERT [Cantina].[CESTO_DE_COMPRA] ([Pid], [C_ref_fatura]) VALUES (13, 117)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000001, N'Ryder', N'Montoya', N'arcu.Sed@urnaVivamus.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000002, N'Quintessa', N'Rosales', N'feugiat.nec.diam@Donec.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000003, N'Harding', N'Dale', N'vitae.aliquet@velfaucibus.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000004, N'Rowan', N'Lucas', N'magna.Duis.dignissim@eget.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000005, N'Inez', N'Chan', N'dolor.Donec.fringilla@etnunc.org', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000006, N'Belle', N'Foley', N'ultrices.Duis.volutpat@Pellentesqueut.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000007, N'Mari', N'Sutton', N'quis@nostraper.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000008, N'Brielle', N'Soto', N'in.consequat.enim@ategestasa.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000009, N'Erasmus', N'Moses', N'porttitor.moses@ipsumPhasellusvitae.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000010, N'Dustin', N'Frazier', N'amet.dapibus.id@antedictum.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000011, N'Hyacinth', N'Telisma', N'Morbi.sit.amet@loremipsum.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000012, N'Felicia', N'Salas', N'Aliquam.vulputate.ullamcorper@fermentumfermentum.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000013, N'Amaya', N'Kirk', N'molestie.tortor@vitaesemper.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000014, N'Bradley', N'Green', N'Sed.id@porttitor.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000015, N'Francis', N'Bush', N'arcu.Nunc@sagittis.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000016, N'Magee', N'Hancock', N'ullamcorper.Duis.at@semNulla.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000017, N'Beck', N'Molina', N'Nam.porttitor@auctor.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000018, N'Jasper', N'Caldwell', N'accumsan@eu.edu', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000019, N'Hedy', N'Buck', N'fringilla@et.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000020, N'Violet', N'Suarez', N'vsuarez@Aliquamadipiscinglobortis.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000021, N'Elijah', N'Bean', N'eu@doloregestas.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000022, N'Magee', N'Jacobs', N'ornare.libero.at@risusat.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000023, N'Wayne', N'Gamble', N'sed@ipsumprimis.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000024, N'Aidan', N'Dudley', N'varius.orci.in@sodalesat.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000025, N'Neville', N'Mcdowell', N'diam.vel@facilisisSuspendissecommodo.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000026, N'Hammett', N'Hoffman', N'Quisque.libero@amet.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000027, N'Kylie', N'Parker', N'a.tortor.Nunc@Sed.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000028, N'Fritz', N'Hoover', N'Nunc@euismodestarcu.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000029, N'Hayden', N'Barron', N'erat.vel@ligula.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000030, N'Caldwell', N'Duran', N'amet.luctus@sedliberoProin.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000031, N'Wendy', N'Tate', N'eu@convallisest.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000032, N'Jerome', N'Emerson', N'vel.vulputate@Nunc.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000033, N'Kenneth', N'Klein', N'interdum.Sed.auctor@ornare.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000034, N'Montana', N'Petty', N'Aenean@arcu.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000035, N'Fredericka', N'Gilliam', N'vitae@Etiamvestibulum.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000036, N'Kaitlin', N'Bartlett', N'vulputate.velit@Phasellus.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000037, N'Dieter', N'Mccarthy', N'porta.elit@dignissim.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000038, N'Raymond', N'Humphrey', N'mollis.Phasellus@interdum.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000039, N'Blaze', N'Cooper', N'Etiam.bibendum@mauris.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000040, N'Elton', N'Alston', N'Nullam.suscipit.est@nunc.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000041, N'Addison', N'Keith', N'diam@felis.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000042, N'Deborah', N'Castillo', N'ipsum.porta.elit@dapibusrutrum.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000043, N'Fuller', N'Holder', N'nascetur.ridiculus@molestiesodalesMauris.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000044, N'Beatrice', N'Harrell', N'velit.Quisque.varius@Donecconsectetuermauris.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000045, N'Demetrius', N'Wood', N'primis.in.faucibus@Aliquamerat.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000046, N'Hedley', N'Greene', N'tempus.lorem.fringilla@Proin.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000047, N'Ferdinand', N'Duffy', N'sit@sollicitudin.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000048, N'Chanda', N'Morin', N'sed@elit.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000049, N'Eden', N'Conway', N'ullamcorper.Duis.cursus@leoin.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000050, N'Aladdin', N'Willis', N'varius@miDuis.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000051, N'Coby', N'Warner', N'tincidunt.nunc@nonantebibendum.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000052, N'Laurel', N'Obrien', N'mi.Duis@ut.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000053, N'Uma', N'Robles', N'sociis.natoque@dictum.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000054, N'Zenaida', N'Cummings', N'dolor.sit@fermentumarcu.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000055, N'Akeem', N'Rosales', N'consequat.auctor@temporest.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000056, N'Len', N'Goodwin', N'est.ac.facilisis@Uttinciduntorci.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000057, N'Barrett', N'Baker', N'laoreet.libero.et@dignissim.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000058, N'Judith', N'Grimes', N'Vestibulum.accumsan.neque@nisi.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000059, N'Cailin', N'Holloway', N'Suspendisse.non.leo@imperdietnecleo.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000060, N'Adrienne', N'Castillo', N'orci.consectetuer@interdumenimnon.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000061, N'Madaline', N'Holden', N'adipiscing.elit.Aliquam@feugiatmetus.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000062, N'Freya', N'Sawyer', N'dolor.Quisque@elitelitfermentum.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000063, N'Regan', N'Weber', N'Vivamus@placeratvelit.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000064, N'Gareth', N'Zamora', N'enim.nisl@lorem.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000065, N'Lara', N'Chapman', N'dui.lectus.rutrum@Quisque.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000066, N'Sylvia', N'Blackwell', N'augue.ac.ipsum@Quisque.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000067, N'Dylan', N'Hunter', N'sapien.Cras.dolor@porttitortellus.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000068, N'Fleur', N'Everett', N'non.sapien.molestie@Phasellusdolorelit.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000069, N'Berk', N'Brewer', N'dui.in.sodales@maurissagittis.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000070, N'Griffith', N'Beach', N'sapien.cursus@sed.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000071, N'Aladdin', N'Glass', N'Donec.tempor@nonbibendum.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000072, N'Cally', N'Fleming', N'turpis.Nulla@dolorsit.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000073, N'Eve', N'Gentry', N'Aenean@Nullamvitae.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000074, N'Allistair', N'Lucas', N'Etiam.laoreet@liberoat.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000075, N'Freya', N'Neal', N'natoque@sed.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000076, N'Ciara', N'Peters', N'convallis.ante.lectus@nonluctus.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000077, N'Lilah', N'Everett', N'nec@quisaccumsan.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000078, N'Phillip', N'Stone', N'eget.laoreet@placerat.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000079, N'Samantha', N'Cabrera', N'consectetuer.adipiscing@dictum.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000080, N'Edward', N'Mathews', N'Vestibulum.ante.ipsum@molestieorci.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000081, N'Samson', N'Hill', N'dictum.eu.eleifend@mollislectus.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000082, N'May', N'Nieves', N'in.cursus@luctussit.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000083, N'Miriam', N'Mayo', N'In.condimentum@loremauctor.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000084, N'Nathan', N'Ellison', N'aliquet.molestie@primisinfaucibus.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000085, N'Brittany', N'Tate', N'ipsum@scelerisque.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000086, N'Dexter', N'Justice', N'luctus.vulputate@vitaeposuereat.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000087, N'Frances', N'Smith', N'eget.nisi@rutrumFuscedolor.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000088, N'Tanek', N'Reynolds', N'arcu@liberonec.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000089, N'Keegan', N'Cooper', N'faucibus.ut@dictum.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000090, N'Carl', N'Fischer', N'posuere.vulputate@Aliquam.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000091, N'Amaya', N'Rodriquez', N'tortor.Nunc.commodo@ultrices.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000092, N'Chaney', N'Robles', N'pharetra@eu.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000093, N'Cedric', N'Keller', N'accumsan.neque.et@suscipitest.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000094, N'Cameran', N'Singleton', N'eleifend.vitae.erat@velesttempor.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000095, N'Christian', N'Houston', N'id.sapien.Cras@lacusUt.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000096, N'Abdul', N'Burns', N'sit.amet.orci@musDonec.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000097, N'Violet', N'Bentley', N'ipsum.Suspendisse.non@nonvestibulum.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000098, N'Eve', N'Daniels', N'egestas.nunc.sed@porttitor.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000099, N'Gisela', N'Cote', N'lacus.Quisque.purus@necante.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000100, N'Debra', N'Huber', N'eu.nulla@disparturientmontes.ca', 1)
GO
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000101, N'Maggie', N'Burris', N'interdum.Nunc.sollicitudin@acfacilisis.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000102, N'Reuben', N'Yates', N'quis.diam@Aenean.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000103, N'Kibo', N'Page', N'Nulla.dignissim.Maecenas@atpretiumaliquet.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000104, N'Simon', N'Goodwin', N'dui.in.sodales@arcu.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000105, N'McKenzie', N'Hale', N'Sed.nec@amagna.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000106, N'Kasper', N'Stevens', N'rutrum.non.hendrerit@acmattisvelit.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000107, N'Caryn', N'Clark', N'non.luctus.sit@atpretiumaliquet.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000108, N'Jason', N'Peters', N'molestie.pharetra.nibh@consequatauctor.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000109, N'Keegan', N'Bolton', N'montes.nascetur.ridiculus@vitae.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000110, N'Amery', N'Holden', N'pretium.et@semperauctorMauris.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000111, N'Darius', N'Benson', N'enim.sit@auctor.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000112, N'Griffin', N'Suarez', N'aliquet.molestie@purus.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000113, N'Murphy', N'Fuentes', N'semper@sit.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000114, N'Kimberley', N'Collier', N'arcu.iaculis@purusDuis.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000115, N'Keiko', N'Schultz', N'sodales.purus.in@quamvel.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000116, N'Whitney', N'White', N'ante@massarutrum.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000117, N'Mari', N'Miller', N'dolor@amalesuada.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000118, N'Evangeline', N'Hewitt', N'posuere@bibendumsed.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000119, N'Ivan', N'Dejesus', N'et.magnis@tristique.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000120, N'Freya', N'Hayden', N'ornare.egestas@nonhendrerit.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000121, N'Channing', N'William', N'feugiat.tellus@consectetuermauris.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000122, N'Lucy', N'Bradshaw', N'blandit@Nam.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000123, N'Lani', N'Gentry', N'ut.nisi.a@dolor.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000124, N'Keely', N'Callahan', N'ullamcorper@sodalesMauris.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000125, N'Clarke', N'Jensen', N'leo@eleifend.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000126, N'Kaseem', N'Cortez', N'mauris.Morbi@dapibusligula.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000127, N'Zorita', N'Giles', N'leo@facilisis.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000128, N'Quinn', N'Ryan', N'massa.Quisque.porttitor@iaculislacus.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000129, N'Callum', N'Sosa', N'non.nisi.Aenean@Maurisnon.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000130, N'Darius', N'Sparks', N'elementum.sem@nuncrisusvarius.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000131, N'Nichole', N'Leach', N'quis.turpis@elementumsemvitae.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000132, N'Roanna', N'Dixon', N'risus.Duis@purusaccumsaninterdum.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000133, N'Dara', N'Boyer', N'nec@utnullaCras.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000134, N'Bevis', N'Ashley', N'iaculis@amalesuadaid.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000135, N'George', N'Hunter', N'Nulla.tincidunt.neque@etnetuset.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000136, N'Nelle', N'Harrison', N'sapien.imperdiet.ornare@risus.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000137, N'Denton', N'Travis', N'vitae.erat@in.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000138, N'Sade', N'Jones', N'Aenean.egestas.hendrerit@amet.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000139, N'Macey', N'Burke', N'Quisque.tincidunt@gravida.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000140, N'Colleen', N'Phillips', N'Morbi.non.sapien@vitae.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000141, N'Melodie', N'Carrillo', N'Nullam.ut@Morbimetus.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000142, N'Slade', N'Travis', N'ipsum@Donectincidunt.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000143, N'Carl', N'Heath', N'et.ultrices.posuere@auctorveliteget.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000144, N'Davis', N'Woodward', N'elit.a@urnaconvallis.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000145, N'Wang', N'Fox', N'neque.vitae@viverra.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000146, N'Asher', N'Phelps', N'id.ante.Nunc@euultrices.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000147, N'Christian', N'Nieves', N'tellus.Nunc@imperdietnonvestibulum.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000148, N'Gannon', N'Valenzuela', N'amet@vitaeorci.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000149, N'Christian', N'Shields', N'tellus.non@nunc.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000150, N'Raja', N'Taylor', N'erat.in@eteuismodet.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000151, N'Rogan', N'Lawrence', N'elit@magnaLorem.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000152, N'Bertha', N'Calderon', N'nec.orci.Donec@vitaepurus.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000153, N'Laura', N'Sears', N'dui.Cras.pellentesque@atpede.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000154, N'Hillary', N'Savage', N'at.fringilla@vulputateeuodio.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000155, N'Alexa', N'Watkins', N'Sed.et.libero@tempordiamdictum.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000156, N'Brock', N'Elliott', N'dictum@FuscefeugiatLorem.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000157, N'Andrew', N'Reese', N'fringilla.est.Mauris@auctornuncnulla.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000158, N'Ryder', N'Obrien', N'dolor.elit.pellentesque@leoelementum.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000159, N'Hoyt', N'Berg', N'auctor.non.feugiat@ante.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000160, N'Cherokee', N'Fulton', N'ac@enimEtiam.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000161, N'Nehru', N'Mcdowell', N'dui.semper@morbitristiquesenectus.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000162, N'Jessamine', N'Gentry', N'senectus.et@montesnasceturridiculus.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000163, N'Scarlett', N'Peck', N'varius.et@nectempus.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000164, N'Quamar', N'Phillips', N'semper.rutrum.Fusce@miacmattis.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000165, N'Wilma', N'Roach', N'nec.quam.Curabitur@duinec.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000166, N'Rhoda', N'Reeves', N'ornare@Curabiturvellectus.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000167, N'Craig', N'Juarez', N'et.rutrum@fringilla.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000168, N'Zorita', N'Mitchell', N'Cras.vehicula@Suspendisse.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000169, N'Maxwell', N'Harrell', N'sem@euerat.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000170, N'McKenzie', N'Pruitt', N'a.purus@habitantmorbitristique.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000171, N'Ahmed', N'Bailey', N'dictum@ullamcorpereueuismod.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000172, N'Giacomo', N'Nixon', N'tincidunt.dui.augue@felisNullatempor.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000173, N'Aline', N'Cooper', N'a.sollicitudin.orci@idsapien.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000174, N'Ross', N'Leonard', N'ornare@in.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000175, N'Karyn', N'Barrett', N'Nunc.mauris@dolorquam.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000176, N'Lael', N'Anthony', N'quis.tristique.ac@eu.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000177, N'Declan', N'Glover', N'Sed.nunc.est@idmollis.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000178, N'Jerome', N'Hale', N'Integer.urna@hendrerit.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000179, N'Francesca', N'Rios', N'elit.pellentesque.a@placerat.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000180, N'Brenden', N'Holland', N'lorem.vitae@dictumultricies.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000181, N'Burke', N'Nicholson', N'elit.Aliquam@imperdiet.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000182, N'Caldwell', N'Wong', N'Maecenas@diamSeddiam.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000183, N'Briar', N'Norris', N'feugiat.placerat.velit@vulputateullamcorper.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000184, N'Yoshio', N'Holden', N'nascetur.ridiculus.mus@consectetuercursuset.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000185, N'Palmer', N'Villarreal', N'mauris@disparturient.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000186, N'Valentine', N'Salazar', N'arcu.Morbi.sit@Vestibulumaccumsan.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000187, N'Kevin', N'Knox', N'sit.amet.risus@nisi.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000188, N'Ivor', N'Cole', N'eu.euismod@necante.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000189, N'Adam', N'Bray', N'Etiam.bibendum@sed.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000190, N'Idola', N'Paul', N'Aenean.eget.magna@Phasellusdolorelit.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000191, N'Rina', N'Estes', N'Nulla@miAliquamgravida.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000192, N'Lester', N'Jimenez', N'lectus.a.sollicitudin@afelisullamcorper.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000193, N'John', N'Hubbard', N'tincidunt.Donec.vitae@semPellentesque.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000194, N'Kyle', N'Jimenez', N'suscipit.nonummy@dis.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000195, N'Elvis', N'Camacho', N'accumsan.neque@etnetuset.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000196, N'Barry', N'Dominguez', N'vulputate.eu@vulputatevelit.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000197, N'Haviva', N'Sandoval', N'Proin.velit.Sed@metusurnaconvallis.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000198, N'Quemby', N'Rosa', N'diam@estNunclaoreet.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000199, N'Ian', N'Velazquez', N'eget.nisi.dictum@pedeultrices.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000200, N'Joy', N'Riley', N'urna.nec@Nam.ca', 1)
GO
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000201, N'Imogene', N'Mayo', N'risus.Quisque.libero@aaliquet.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000202, N'Lillian', N'Cook', N'dolor.Donec@Praesenteu.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000203, N'Bernard', N'Russo', N'nibh.Quisque.nonummy@semperrutrumFusce.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000204, N'Maia', N'Holloway', N'eget.odio.Aliquam@ipsumdolor.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000205, N'Claudia', N'Lloyd', N'ut@elitCurabitursed.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000206, N'Armand', N'Rodriquez', N'rutrum.non@risus.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000207, N'Adara', N'Cochran', N'Praesent@Phasellus.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000208, N'Benedict', N'Hampton', N'sagittis.lobortis@habitantmorbi.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000209, N'Keely', N'Baxter', N'odio.auctor.vitae@interdum.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000210, N'John', N'Armstrong', N'Quisque@eget.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000211, N'Armando', N'Fitzgerald', N'tellus.non.magna@acrisus.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000212, N'Arsenio', N'Booker', N'non.massa@elitsedconsequat.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000213, N'Elijah', N'Gallegos', N'elementum.dui.quis@maurisanunc.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000214, N'Tanek', N'Underwood', N'quis@dapibusligula.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000215, N'Victor', N'Frost', N'eget.metus@Duismi.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000216, N'Daphne', N'Juarez', N'Nunc.sed.orci@nectellusNunc.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000217, N'Quemby', N'Hudson', N'tellus.lorem.eu@quis.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000218, N'Porter', N'Joyce', N'pede.nonummy@Nullamutnisi.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000219, N'Halee', N'Pitts', N'luctus@Nullamsuscipit.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000220, N'Graiden', N'Raymond', N'ac@Nullam.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000221, N'Hedy', N'William', N'ante@convallisante.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000222, N'Allistair', N'Mccormick', N'Cras.interdum.Nunc@bibendumfermentum.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000223, N'Nyssa', N'Preston', N'eros@libero.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000224, N'Amir', N'Ashley', N'ac.urna@egetodio.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000225, N'Cynthia', N'Pratt', N'cursus.et.magna@suscipitnonummy.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000226, N'Mollie', N'Parsons', N'Proin.velit@Ut.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000227, N'Kylan', N'Day', N'lobortis@mi.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000228, N'Scarlet', N'Head', N'vitae.velit@et.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000229, N'Barry', N'Kramer', N'Cras.convallis.convallis@atvelit.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000230, N'Shay', N'Gaines', N'nunc@diam.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000231, N'Candice', N'Clements', N'elit.pretium.et@sedfacilisisvitae.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000232, N'Bo', N'Hansen', N'mauris@afeugiat.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000233, N'Ralph', N'Burch', N'arcu@blanditcongue.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000234, N'Dieter', N'Baxter', N'Nunc.ac@faucibuslectusa.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000235, N'Wilma', N'Vaughan', N'blandit.Nam@tinciduntnunc.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000236, N'Amber', N'Wolfe', N'enim@MorbivehiculaPellentesque.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000237, N'Joseph', N'Watson', N'natoque@eu.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000238, N'Richard', N'Mcintyre', N'Sed.eget@turpisegestasAliquam.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000239, N'Sara', N'Callahan', N'ultricies.sem@quam.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000240, N'Chester', N'Munoz', N'Proin.eget@convallisincursus.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000241, N'Joseph', N'Mcmillan', N'blandit@sitametconsectetuer.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000242, N'Laith', N'Conway', N'sagittis@augue.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000243, N'Dacey', N'Emerson', N'laoreet@DonecegestasAliquam.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000244, N'Mari', N'Russell', N'odio.a@elementum.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000245, N'Moses', N'Suarez', N'congue.a.aliquet@antedictum.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000246, N'Chadwick', N'Chaney', N'parturient.montes@Donecconsectetuermauris.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000247, N'Emerson', N'Moss', N'velit.eu.sem@Proin.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000248, N'Jaquelyn', N'Sexton', N'dui@eratvelpede.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000249, N'Hop', N'Collins', N'vulputate@Namac.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000250, N'Kalia', N'Rodriguez', N'In.mi@semut.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000251, N'Rhonda', N'Baird', N'nec.metus@elementum.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000252, N'Cain', N'Daniels', N'Sed.eu@aultricies.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000253, N'Callie', N'May', N'risus.Donec@sed.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000254, N'Luke', N'Mcfadden', N'eget.ipsum@libero.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000255, N'Chester', N'Weaver', N'Cum.sociis.natoque@neque.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000256, N'Leah', N'Conley', N'et.risus.Quisque@non.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000257, N'Paloma', N'Goodman', N'Quisque.purus@Maurisutquam.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000258, N'Edward', N'Tyler', N'Curae@penatibusetmagnis.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000259, N'Dorothy', N'Wise', N'mi.fringilla.mi@orciinconsequat.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000260, N'Carla', N'Williamson', N'neque@Integervulputaterisus.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000261, N'Phoebe', N'Sutton', N'risus@quamPellentesque.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000262, N'Dustin', N'Stanton', N'et@congueturpisIn.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000263, N'Prescott', N'Steele', N'mauris.ipsum.porta@idanteNunc.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000264, N'Adrian', N'Mendez', N'et@senectusetnetus.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000265, N'Adrian', N'Winters', N'vel.arcu@ametfaucibus.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000266, N'Tasha', N'Mcintyre', N'enim.mi@adipiscing.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000267, N'Demetrius', N'Day', N'auctor.odio.a@consectetuer.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000268, N'Henry', N'Patrick', N'Integer@Nullaeuneque.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000269, N'Inga', N'Steele', N'Aliquam.vulputate.ullamcorper@malesuada.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000270, N'Raven', N'Clark', N'nascetur.ridiculus@odioPhasellusat.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000271, N'Vanna', N'Ray', N'accumsan.sed.facilisis@Duis.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000272, N'Dane', N'Bowen', N'tellus@faucibusleo.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000273, N'Madaline', N'Tran', N'sociis.natoque.penatibus@consectetuer.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000274, N'Hedwig', N'Boyle', N'lorem.tristique.aliquet@Utnecurna.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000275, N'Myles', N'Cooke', N'Nunc.mauris.elit@dolor.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000276, N'Aileen', N'Rogers', N'vitae.odio@diam.edu', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000277, N'Sage', N'Bonner', N'commodo.ipsum.Suspendisse@diamDuis.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000278, N'Jasper', N'Hooper', N'aliquam@fringillamilacinia.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000279, N'Isaiah', N'Mueller', N'dui@laciniaorciconsectetuer.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000280, N'Griffith', N'Powers', N'sit@egetmollislectus.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000281, N'Hope', N'Wilkins', N'non@egestas.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000282, N'Fritz', N'Lowe', N'semper.rutrum.Fusce@idante.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000283, N'Hayley', N'Landry', N'Mauris.non@posuere.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000284, N'Madaline', N'Meyers', N'blandit@Donecest.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000285, N'Eugenia', N'Rhodes', N'ut@neque.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000286, N'Erasmus', N'Lowe', N'eu@mitempor.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000287, N'Kelly', N'Rush', N'a.facilisis@apurus.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000288, N'Zephania', N'Garner', N'turpis@luctusutpellentesque.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000289, N'Hyacinth', N'Walter', N'enim.sit@utaliquam.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000290, N'Tyrone', N'Dyer', N'pede.Cras@egetvenenatis.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000291, N'Kelsey', N'Russell', N'et.tristique@magna.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000292, N'Madeline', N'Hinton', N'Proin.vel.arcu@sedorci.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000293, N'Rigel', N'Padilla', N'orci.luctus.et@a.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000294, N'Illana', N'Peck', N'Donec.egestas@malesuada.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000295, N'Jared', N'Mcintosh', N'felis@amet.com', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000296, N'Liberty', N'Howe', N'ultrices@ridiculus.org', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000297, N'Raymond', N'Reese', N'ullamcorper.Duis.at@senectusetnetus.co.uk', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000298, N'Jocelyn', N'Morse', N'nunc.sit@quisturpisvitae.net', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000299, N'Althea', N'Ortiz', N'mauris.sagittis.placerat@nislsemconsequat.ca', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000300, N'Alan', N'Howe', N'sed.facilisis.vitae@etpede.com', 4)
GO
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000301, N'Shelley', N'Robles', N'felis@Nunccommodo.edu', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000302, N'Emmanuel', N'Clark', N'parturient.montes.nascetur@aliquet.com', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000303, N'Ann', N'Barron', N'Quisque.varius@duiquis.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000304, N'Helen', N'May', N'est@tinciduntorci.co.uk', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000305, N'Hayes', N'Castillo', N'nibh@tempor.co.uk', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000306, N'Felix', N'Massey', N'augue.ac.ipsum@veliteusem.co.uk', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000307, N'Mark', N'Chaney', N'eleifend.nec.malesuada@Vestibulumante.com', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000308, N'Orlando', N'Chapman', N'ultricies.adipiscing@Cras.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000309, N'Pandora', N'Banks', N'nec.ante.blandit@Sed.net', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000310, N'Kenneth', N'Farley', N'sem@lorem.com', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000311, N'Henry', N'Stanton', N'eu@est.ca', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000312, N'September', N'Rivers', N'tellus@turpis.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000313, N'Rinah', N'Bray', N'aliquam@euplacerat.org', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000314, N'Jaime', N'Charles', N'lorem@idnuncinterdum.edu', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000315, N'Shad', N'Faulkner', N'lobortis.quis@pharetrafelis.edu', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000316, N'Hanae', N'Valentine', N'semper@odio.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000317, N'Ariel', N'Bridges', N'felis@nec.org', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000318, N'Hollee', N'Douglas', N'sodales@augue.org', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000319, N'Hayes', N'Obrien', N'tincidunt@est.net', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000320, N'Caldwell', N'Gray', N'lacus.varius.et@nibhAliquamornare.net', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000321, N'Bert', N'Rivera', N'elementum.dui@ante.edu', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000322, N'Carla', N'Bullock', N'ac@magnaatortor.org', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000323, N'Blossom', N'Dyer', N'malesuada@iaculisenim.co.uk', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000324, N'Zachary', N'Lyons', N'risus@Utnecurna.edu', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000325, N'Dieter', N'Gillespie', N'eleifend.non.dapibus@aliquetodioEtiam.org', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000326, N'Melinda', N'Lucas', N'nec.leo.Morbi@auctorveliteget.edu', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000327, N'Clayton', N'Holmes', N'semper@Ut.org', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000328, N'Yvette', N'Munoz', N'enim.nisl@consectetueripsum.co.uk', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000329, N'Ross', N'Payne', N'lacus@luctusCurabituregestas.com', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000330, N'Kiona', N'Rocha', N'et.rutrum.non@orciluctuset.edu', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000331, N'Josiah', N'Nguyen', N'Nam.nulla@risus.com', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000332, N'Giacomo', N'Reid', N'id.libero@odiotristiquepharetra.org', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000333, N'Joy', N'Juarez', N'consequat@ametlorem.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000334, N'Mark', N'Collier', N'turpis.non@augue.co.uk', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000335, N'Hollee', N'Kidd', N'feugiat@feugiat.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000336, N'Haviva', N'Morgan', N'ante.dictum.cursus@faucibusMorbi.co.uk', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000337, N'Gannon', N'Colon', N'sit@laciniavitae.net', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000338, N'TaShya', N'Diaz', N'eget@arcuMorbi.org', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000339, N'Fiona', N'Pierce', N'Fusce.fermentum@rutrumFusce.com', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000340, N'Levi', N'Ayala', N'tortor@velpedeblandit.edu', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000341, N'Daquan', N'Preston', N'luctus.ipsum@in.net', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000342, N'Isabella', N'Estrada', N'Duis.mi@noncursus.ca', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000343, N'August', N'Sherman', N'facilisis.non@lacuspedesagittis.co.uk', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000344, N'Carl', N'Chavez', N'ante@vulputaterisus.org', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000345, N'Byron', N'Wheeler', N'mi@egetmagna.net', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000346, N'Duncan', N'Foster', N'neque.In@sapienmolestieorci.edu', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000347, N'Joel', N'Justice', N'fringilla.est.Mauris@accumsannequeet.co.uk', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000348, N'Wallace', N'Figueroa', N'commodo.hendrerit.Donec@tempus.edu', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000349, N'Holmes', N'Waters', N'augue.porttitor.interdum@Nullaaliquet.com', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000350, N'Gray', N'England', N'ipsum@ornareliberoat.com', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000351, N'Hillary', N'Short', N'non.feugiat.nec@nonummyipsumnon.edu', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000352, N'Erasmus', N'Mcintosh', N'non.sapien.molestie@egestasa.net', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000353, N'Hamish', N'Boone', N'sapien.cursus@metusIn.edu', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000354, N'Holmes', N'Coleman', N'vitae@eleifendnunc.com', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000355, N'Scarlet', N'Jarvis', N'Cras@fermentum.net', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000356, N'Clio', N'James', N'ut.molestie@eliterat.co.uk', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000357, N'Maggy', N'Baldwin', N'erat@a.edu', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000358, N'Chaim', N'Rivers', N'lorem@Quisque.org', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000359, N'Maisie', N'Wise', N'nec.cursus.a@lobortisrisus.org', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000360, N'Germaine', N'Mccray', N'id@orci.org', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000361, N'Lana', N'Carrillo', N'Nunc.pulvinar.arcu@venenatislacus.co.uk', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000362, N'Clementine', N'Carey', N'elit.pharetra@infelis.com', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000363, N'Armando', N'Duffy', N'ultrices@ipsumSuspendisse.co.uk', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000364, N'Kathleen', N'Vinson', N'id@rhoncus.com', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000365, N'Garrison', N'Sims', N'Nulla.tincidunt.neque@erateget.edu', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000366, N'Amanda', N'Hendricks', N'nulla@sapienAeneanmassa.org', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000367, N'Sasha', N'Collier', N'risus.Donec@aliquet.com', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000368, N'Jason', N'Nguyen', N'penatibus.et@lorem.edu', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000369, N'Vance', N'Haney', N'consequat@arcuvel.com', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000370, N'Galena', N'Norton', N'erat.vitae.risus@necurnasuscipit.com', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000371, N'Tobias', N'Hines', N'tincidunt@ultriciesornare.co.uk', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000372, N'Carson', N'Cole', N'Aliquam.ornare@nisi.ca', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000373, N'Inga', N'Rowland', N'quis.massa.Mauris@semperrutrum.net', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000374, N'August', N'Dunn', N'penatibus.et@maurisblandit.com', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000375, N'Bernard', N'Joyce', N'molestie.sodales.Mauris@velit.ca', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000376, N'Marshall', N'Tyler', N'magna@nuncQuisqueornare.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000377, N'Prescott', N'Miranda', N'lorem@sapien.co.uk', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000378, N'Lev', N'Chang', N'sagittis.lobortis@seddictum.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000379, N'Jade', N'Torres', N'euismod.urna@ut.co.uk', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000380, N'Prescott', N'Rodriquez', N'a.arcu.Sed@CuraeDonec.ca', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000381, N'Kerry', N'Maddox', N'nostra.per@IncondimentumDonec.edu', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000382, N'Rhea', N'Clayton', N'Mauris@semmolestie.net', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000383, N'April', N'Poole', N'tortor@montes.edu', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000384, N'Raphael', N'Murphy', N'In@a.org', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000385, N'Akeem', N'Nixon', N'In.nec.orci@natoquepenatibuset.edu', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000386, N'Caleb', N'Bolton', N'non@arcuMorbisit.com', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000387, N'Pearl', N'Miller', N'accumsan.sed.facilisis@dapibus.ca', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000388, N'Uriah', N'Washington', N'semper@egestaslaciniaSed.co.uk', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000389, N'Chaim', N'Castillo', N'Integer.in.magna@In.org', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000390, N'Declan', N'Cantrell', N'sed.sem.egestas@gravidamaurisut.ca', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000391, N'Joshua', N'Sims', N'arcu.Vestibulum.ante@Maecenasliberoest.net', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000392, N'Igor', N'Hampton', N'faucibus@Aliquam.com', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000393, N'Mikayla', N'Camacho', N'et@sed.co.uk', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000394, N'Reagan', N'Donaldson', N'ante@necdiam.ca', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000395, N'Katelyn', N'Buck', N'placerat.Cras.dictum@Uttincidunt.net', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000396, N'Winifred', N'Tate', N'elit.pretium.et@Donec.ca', 3)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000397, N'Louis', N'Beach', N'auctor@nuncQuisqueornare.edu', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (100000398, N'Zephr', N'Bowman', N'magna@Inscelerisquescelerisque.org', 2)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (111111111, N'João', N'Alcatrão', N'jalcatrao@ua.pt', 4)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (111111211, N'Luís', N'Rêgo', N'lasr@ua.pt', 1)
GO
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (222222222, N'', N'anomalie', N'abajura', 1)
INSERT [Cantina].[CLIENTE] ([Nif], [Fname], [Lname], [Email], [Tipo]) VALUES (333333333, N'Ederzito', N'Griezmann', N'eder@portugal', 1)
INSERT [Cantina].[COMPOSICAO_DO_MENU] ([Pid], [Mid]) VALUES (3, 1)
INSERT [Cantina].[COMPOSICAO_DO_MENU] ([Pid], [Mid]) VALUES (13, 1)
INSERT [Cantina].[COMPOSICAO_DO_MENU] ([Pid], [Mid]) VALUES (17, 1)
INSERT [Cantina].[COMPOSICAO_DO_MENU] ([Pid], [Mid]) VALUES (14, 2)
INSERT [Cantina].[COMPOSICAO_DO_MENU] ([Pid], [Mid]) VALUES (15, 2)
INSERT [Cantina].[COMPOSICAO_DO_MENU] ([Pid], [Mid]) VALUES (16, 2)
INSERT [Cantina].[COMPOSICAO_DO_MENU] ([Pid], [Mid]) VALUES (41, 2)
INSERT [Cantina].[COMPOSICAO_DO_MENU] ([Pid], [Mid]) VALUES (42, 3)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (42, 1)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (16, 2)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (41, 2)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (14, 3)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (41, 3)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (16, 4)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (3, 6)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (14, 6)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (42, 7)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (3, 8)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (3, 10)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (16, 10)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (17, 10)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (41, 10)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (17, 15)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (3, 16)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (17, 16)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (42, 18)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (42, 22)
INSERT [Cantina].[COMPOSICAO_DO_PRATO] ([Pid], [Iid]) VALUES (41, 23)
SET IDENTITY_INSERT [Cantina].[COMPRA] ON 

INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000150, CAST(N'2020-06-01T04:20:44.000' AS DateTime), 1, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000325, CAST(N'2020-06-05T04:55:33.000' AS DateTime), 2, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000073, CAST(N'2020-06-02T11:42:08.000' AS DateTime), 3, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000088, CAST(N'2020-06-06T20:16:00.000' AS DateTime), 4, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000095, CAST(N'2020-06-04T02:27:36.000' AS DateTime), 5, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000037, CAST(N'2020-06-03T14:08:46.000' AS DateTime), 6, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000311, CAST(N'2020-06-06T10:31:57.000' AS DateTime), 7, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000135, CAST(N'2020-06-05T16:15:11.000' AS DateTime), 8, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000090, CAST(N'2020-06-05T00:05:54.000' AS DateTime), 9, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000047, CAST(N'2020-06-07T13:42:25.000' AS DateTime), 10, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000060, CAST(N'2020-06-02T14:11:54.000' AS DateTime), 11, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000051, CAST(N'2020-06-07T15:39:32.000' AS DateTime), 12, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000055, CAST(N'2020-06-02T16:38:16.000' AS DateTime), 13, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000394, CAST(N'2020-06-02T00:21:10.000' AS DateTime), 14, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000297, CAST(N'2020-06-07T22:03:13.000' AS DateTime), 15, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000260, CAST(N'2020-06-06T14:58:07.000' AS DateTime), 16, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000291, CAST(N'2020-06-05T08:48:00.000' AS DateTime), 17, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000152, CAST(N'2020-06-03T20:26:26.000' AS DateTime), 18, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000182, CAST(N'2020-06-06T14:13:17.000' AS DateTime), 19, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000231, CAST(N'2020-06-01T23:40:51.000' AS DateTime), 20, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000245, CAST(N'2020-06-06T16:55:26.000' AS DateTime), 21, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000263, CAST(N'2020-06-03T06:09:00.000' AS DateTime), 22, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000113, CAST(N'2020-06-06T08:12:55.000' AS DateTime), 23, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000341, CAST(N'2020-06-05T08:16:27.000' AS DateTime), 24, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000018, CAST(N'2020-06-02T22:23:34.000' AS DateTime), 25, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000186, CAST(N'2020-06-06T17:08:03.000' AS DateTime), 26, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000391, CAST(N'2020-06-05T11:46:53.000' AS DateTime), 27, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000277, CAST(N'2020-06-02T13:52:54.000' AS DateTime), 28, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000183, CAST(N'2020-06-02T15:07:20.000' AS DateTime), 29, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000127, CAST(N'2020-06-01T05:59:27.000' AS DateTime), 30, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000258, CAST(N'2020-06-01T22:12:07.000' AS DateTime), 31, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000113, CAST(N'2020-06-04T21:39:12.000' AS DateTime), 32, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000379, CAST(N'2020-06-05T20:27:36.000' AS DateTime), 33, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000272, CAST(N'2020-06-05T06:43:55.000' AS DateTime), 34, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000109, CAST(N'2020-06-01T12:36:46.000' AS DateTime), 35, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000366, CAST(N'2020-06-03T06:21:35.000' AS DateTime), 36, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000070, CAST(N'2020-06-01T11:43:06.000' AS DateTime), 37, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000341, CAST(N'2020-06-07T02:27:53.000' AS DateTime), 38, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000288, CAST(N'2020-06-05T21:33:17.000' AS DateTime), 39, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000139, CAST(N'2020-06-07T21:30:52.000' AS DateTime), 40, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000036, CAST(N'2020-06-04T00:32:46.000' AS DateTime), 41, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000260, CAST(N'2020-06-05T21:18:07.000' AS DateTime), 42, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000217, CAST(N'2020-06-04T11:28:49.000' AS DateTime), 43, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000083, CAST(N'2020-06-06T17:45:54.000' AS DateTime), 44, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000218, CAST(N'2020-06-07T01:10:08.000' AS DateTime), 45, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000319, CAST(N'2020-06-01T20:10:47.000' AS DateTime), 46, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000141, CAST(N'2020-06-05T06:13:43.000' AS DateTime), 47, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000109, CAST(N'2020-06-07T05:45:45.000' AS DateTime), 48, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000215, CAST(N'2020-06-03T19:42:09.000' AS DateTime), 49, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000155, CAST(N'2020-06-06T05:12:12.000' AS DateTime), 50, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000158, CAST(N'2020-06-06T15:27:02.000' AS DateTime), 51, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000139, CAST(N'2020-06-01T06:13:57.000' AS DateTime), 52, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000059, CAST(N'2020-06-07T16:00:52.000' AS DateTime), 53, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000357, CAST(N'2020-06-06T12:27:54.000' AS DateTime), 54, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000135, CAST(N'2020-06-05T09:39:19.000' AS DateTime), 55, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000260, CAST(N'2020-06-05T15:46:49.000' AS DateTime), 56, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000266, CAST(N'2020-06-06T03:25:33.000' AS DateTime), 58, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000072, CAST(N'2020-06-06T08:59:39.000' AS DateTime), 59, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000371, CAST(N'2020-06-01T17:13:00.000' AS DateTime), 60, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000165, CAST(N'2020-06-04T11:15:12.000' AS DateTime), 61, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000147, CAST(N'2020-06-02T06:04:37.000' AS DateTime), 62, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000379, CAST(N'2020-06-04T07:34:59.000' AS DateTime), 63, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000038, CAST(N'2020-06-04T02:21:52.000' AS DateTime), 65, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000090, CAST(N'2020-06-03T04:28:56.000' AS DateTime), 66, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000139, CAST(N'2020-06-04T07:57:43.000' AS DateTime), 67, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000211, CAST(N'2020-06-05T09:35:41.000' AS DateTime), 68, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000164, CAST(N'2020-06-06T03:00:55.000' AS DateTime), 69, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000235, CAST(N'2020-06-03T21:29:25.000' AS DateTime), 70, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000377, CAST(N'2020-06-03T03:22:12.000' AS DateTime), 71, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000292, CAST(N'2020-06-07T19:42:09.000' AS DateTime), 72, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000289, CAST(N'2020-06-04T21:15:28.000' AS DateTime), 73, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000319, CAST(N'2020-06-04T00:57:01.000' AS DateTime), 74, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000056, CAST(N'2020-06-03T04:23:44.000' AS DateTime), 75, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000305, CAST(N'2020-06-04T04:43:53.000' AS DateTime), 76, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000325, CAST(N'2020-06-04T13:23:06.000' AS DateTime), 77, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000123, CAST(N'2020-06-02T15:56:30.000' AS DateTime), 78, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000036, CAST(N'2020-06-05T16:28:01.000' AS DateTime), 79, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000233, CAST(N'2020-06-03T03:32:34.000' AS DateTime), 80, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000301, CAST(N'2020-06-02T17:45:37.000' AS DateTime), 81, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000242, CAST(N'2020-06-03T11:29:40.000' AS DateTime), 82, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000236, CAST(N'2020-06-04T02:52:36.000' AS DateTime), 83, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000064, CAST(N'2020-06-04T10:19:40.000' AS DateTime), 84, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000068, CAST(N'2020-06-07T11:56:36.000' AS DateTime), 85, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000205, CAST(N'2020-06-03T09:36:31.000' AS DateTime), 86, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000336, CAST(N'2020-06-03T21:18:22.000' AS DateTime), 87, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000342, CAST(N'2020-06-02T14:21:28.000' AS DateTime), 88, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000372, CAST(N'2020-06-07T22:22:11.000' AS DateTime), 89, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000012, CAST(N'2020-06-07T10:08:17.000' AS DateTime), 90, 14)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000070, CAST(N'2020-06-04T06:59:00.000' AS DateTime), 91, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000114, CAST(N'2020-06-07T23:44:11.000' AS DateTime), 92, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000221, CAST(N'2020-06-01T21:11:43.000' AS DateTime), 93, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000022, CAST(N'2020-06-02T13:41:51.000' AS DateTime), 94, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000048, CAST(N'2020-06-02T21:37:02.000' AS DateTime), 95, 9)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000181, CAST(N'2020-06-05T14:36:39.000' AS DateTime), 96, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000369, CAST(N'2020-06-02T00:53:14.000' AS DateTime), 97, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000028, CAST(N'2020-06-02T07:18:25.000' AS DateTime), 98, 16)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000143, CAST(N'2020-06-05T14:03:28.000' AS DateTime), 99, 2)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000079, CAST(N'2020-06-01T15:15:49.000' AS DateTime), 100, 3)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000005, CAST(N'2020-06-07T19:31:57.147' AS DateTime), 104, 8)
GO
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000002, CAST(N'2020-06-07T19:35:10.770' AS DateTime), 105, 7)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (111111111, CAST(N'2020-06-07T19:37:44.143' AS DateTime), 107, 1)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000001, CAST(N'2020-06-10T18:13:29.937' AS DateTime), 108, 68826)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000001, CAST(N'2020-06-10T18:28:13.473' AS DateTime), 109, 76763)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000001, CAST(N'2020-06-10T18:55:09.740' AS DateTime), 110, 21)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000001, CAST(N'2020-06-10T19:00:39.440' AS DateTime), 111, 4)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000002, CAST(N'2020-06-10T20:30:17.800' AS DateTime), 113, 21)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (333333333, CAST(N'2020-06-11T01:35:11.593' AS DateTime), 114, 11)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000002, CAST(N'2020-06-11T16:30:23.577' AS DateTime), 116, 11)
INSERT [Cantina].[COMPRA] ([Cnif], [Datahora], [Ref_fatura], [Fid]) VALUES (100000006, CAST(N'2020-06-11T16:48:53.600' AS DateTime), 117, 9)
SET IDENTITY_INSERT [Cantina].[COMPRA] OFF
INSERT [Cantina].[DISPENSA] ([Id], [Capacidade], [CapacidadeAtual]) VALUES (1, CAST(10000.00 AS Decimal(15, 2)), CAST(6583.66 AS Decimal(10, 2)))
INSERT [Cantina].[DISPENSA] ([Id], [Capacidade], [CapacidadeAtual]) VALUES (2, CAST(7000.00 AS Decimal(15, 2)), CAST(2107.15 AS Decimal(10, 2)))
INSERT [Cantina].[DISPENSA] ([Id], [Capacidade], [CapacidadeAtual]) VALUES (3, CAST(5769.00 AS Decimal(15, 2)), CAST(76.00 AS Decimal(10, 2)))
INSERT [Cantina].[DISPENSA] ([Id], [Capacidade], [CapacidadeAtual]) VALUES (4, CAST(4500.00 AS Decimal(15, 2)), NULL)
SET IDENTITY_INSERT [Cantina].[FUNCIONARIO] ON 

INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (1, N'Alika', N'Jacobs', N'ipsum.Curabitur@Phasellusat.org', N'cozinha', CAST(646.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (2, N'Tucker', N'Forbes', N'odio@Namconsequatdolor.edu', N'Atendimento', CAST(644.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (3, N'Dana', N'Keller', N'nascetur.ridiculus.mus@tempus.ca', N'Atendimento', CAST(627.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (4, N'Charlotte', N'Rosario', N'et@luctusCurabitur.ca', N'limpeza', CAST(600.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (5, N'Kelsie', N'Cote', N'sagittis.Duis.gravida@feugiat.com', N'limpeza', CAST(691.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (6, N'Preston', N'Moses', N'odio.tristique@Uttincidunt.com', N'limpeza', CAST(630.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (7, N'Jonas', N'Price', N'auctor.vitae@a.co.uk', N'Cozinha', CAST(661.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (8, N'Bernard', N'Suarez', N'malesuada.malesuada@tellusPhasellus.edu', N'limpeza', CAST(693.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (9, N'Hadassah', N'Ball', N'augue.ut.lacus@fringillacursus.edu', N'Atendimento', CAST(700.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (10, N'Paul', N'Sherman', N'ultrices@euismod.co.uk', N'limpeza', CAST(634.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (11, N'Ursa', N'Arnold', N'Nam@magnaSedeu.net', N'cozinha', CAST(676.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (12, N'Wylie', N'Porter', N'Suspendisse.aliquet@inaliquetlobortis.ca', N'limpeza', CAST(628.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (13, N'Yeo', N'Leonel', N'sem@massaSuspendisse.co.uk', N'cozinha', CAST(624.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (14, N'Wilma', N'Whitney', N'dolor.sit@feugiatnon.edu', N'Atendimento', CAST(648.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (15, N'Steven', N'Mathews', N'posuere.enim.nisl@dictumPhasellusin.edu', N'limpeza', CAST(630.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (16, N'Sade', N'Mcdonald', N'Pellentesque.ultricies@lobortisquama.co.uk', N'atendimento', CAST(676.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (17, N'Ryder', N'Cole', N'at.pede@turpis.co.uk', N'cozinha', CAST(600.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (18, N'Jamal', N'Knight', N'Cum.sociis.natoque@purusmauris.co.uk', N'limpeza', CAST(671.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (19, N'Cleo', N'Snider', N'magna@eratnequenon.ca', N'cozinha', CAST(692.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (20, N'Mufutau', N'Justice', N'diam.eu.dolor@Proinsedturpis.net', N'atendimento', CAST(633.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (21, N'Telisma', N'Helisma', N'alisma@lis.pt', N'atendimento', CAST(700.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (68826, N'Luís', N'Rêgo', N'luis.sousa.rego@gmail.com', N'cozinha', CAST(1200.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (76763, N'João', N'Alcatrão', N'jalcatrao@ua.pt', N'atendimento', CAST(6900.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (76807, N'Joana', N'Alberto', N'jalber@ua.pt', N'limpeza', CAST(1200.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (76808, N'Afonso', N'Amaral', N'aa@ua.pt', N'cozinha', CAST(1200.00 AS Decimal(10, 2)))
INSERT [Cantina].[FUNCIONARIO] ([Id], [Fname], [Lname], [Email], [Ccodigo], [Salario]) VALUES (76809, N'Joao', N'Francisco', N'jf@ua,.pt', N'cozinha', CAST(1200.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [Cantina].[FUNCIONARIO] OFF
SET IDENTITY_INSERT [Cantina].[INGREDIENTE] ON 

INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (1, N'Cebolas', CAST(59.00 AS Decimal(10, 2)), CAST(967.27 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (2, N'Cabeças-de-alho', CAST(49.00 AS Decimal(10, 2)), CAST(1013.08 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (3, N'Massa', CAST(16.00 AS Decimal(10, 2)), CAST(999.35 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (4, N'Bacalhau', CAST(93.00 AS Decimal(10, 2)), CAST(1010.69 AS Decimal(10, 2)), NULL, 2)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (5, N'Frango', CAST(76.00 AS Decimal(10, 2)), CAST(1036.46 AS Decimal(10, 2)), NULL, 2)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (6, N'Arroz', CAST(29.00 AS Decimal(10, 2)), CAST(924.96 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (7, N'Batatas', CAST(154.00 AS Decimal(10, 2)), CAST(269.00 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (8, N'Feijão', CAST(120.00 AS Decimal(10, 2)), CAST(130.00 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (9, N'Alface', CAST(70.00 AS Decimal(10, 2)), CAST(50.00 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (10, N'Couve', CAST(90.00 AS Decimal(10, 2)), CAST(350.00 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (11, N'Arroz Preto', CAST(29.00 AS Decimal(10, 2)), CAST(1000.00 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (13, N'Couve-Flor', CAST(90.00 AS Decimal(10, 2)), CAST(380.00 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (14, N'Feijão Frade', CAST(150.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (15, N'Vinho Branco', CAST(400.00 AS Decimal(10, 2)), CAST(30.00 AS Decimal(10, 2)), NULL, 3)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (16, N'Vinho Verde', CAST(400.00 AS Decimal(10, 2)), CAST(26.00 AS Decimal(10, 2)), NULL, 3)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (17, N'Vinho Tinto', CAST(400.00 AS Decimal(10, 2)), CAST(10.00 AS Decimal(10, 2)), NULL, 3)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (18, N'Alho-Francês', CAST(50.00 AS Decimal(10, 2)), CAST(200.00 AS Decimal(10, 2)), NULL, 1)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (22, N'Grão', CAST(314.00 AS Decimal(10, 2)), CAST(10.00 AS Decimal(10, 2)), NULL, 3)
INSERT [Cantina].[INGREDIENTE] ([Id], [Nome], [Valor_nutritivo], [Quantidade_disponivel], [Alergenios], [Did]) VALUES (23, N'Soja', CAST(543.00 AS Decimal(10, 2)), CAST(60.00 AS Decimal(10, 2)), NULL, 2)
SET IDENTITY_INSERT [Cantina].[INGREDIENTE] OFF
INSERT [Cantina].[MENU] ([Id], [Nome]) VALUES (1, N'Segunda-feira')
INSERT [Cantina].[MENU] ([Id], [Nome]) VALUES (2, N'Terça-feira')
INSERT [Cantina].[MENU] ([Id], [Nome]) VALUES (3, N'Quarta-feira')
INSERT [Cantina].[MENU] ([Id], [Nome]) VALUES (4, N'Quinta-feira')
INSERT [Cantina].[MENU] ([Id], [Nome]) VALUES (5, N'Sexta-feira')
INSERT [Cantina].[MENU] ([Id], [Nome]) VALUES (6, N'Sábado')
INSERT [Cantina].[MENU] ([Id], [Nome]) VALUES (7, N'Domingo')
SET IDENTITY_INSERT [Cantina].[PRATO] ON 

INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (1, N'Vegetariano', N'Pizza')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (2, N'Vegetariano', N'Salada')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (3, N'Vegetariano', N'Feijoada')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (4, N'Vegetariano', N'Esparguete')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (5, N'Vegetariano', N'Massas')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (6, N'Vegetariano', N'Poré')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (7, N'Não-Vegetariano', N'Hambuerguer')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (8, N'Não-Vegetariano', N'Bacalhau à brás')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (9, N'Não-Vegetariano', N'Carapau')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (10, N'Não-Vegetariano', N'Frango Churrasco')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (11, N'Não-Vegetariano', N'Bifana')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (12, N'Vegetariano', N'Paté de miscaros e nozes')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (13, N'Vegetariano', N'Seitan de almôndegas com molho de cepes')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (14, N'Vegetariano', N'Massa de arroz com pimentos e tofu')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (15, N'Vegetariano', N'Cuzcuz com legumes e especiarias')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (16, N'Vegetariano', N'Sopa de legumes')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (17, N'Vegetariano', N'Caldo Verde')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (30, N'Veg', N'Salada russa')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (31, N'veg', N'agua seca')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (41, N'Vegetariano', N'Esparguete de soja')
INSERT [Cantina].[PRATO] ([Id], [Tipo], [Nome]) VALUES (42, N'Vegetariano', N'Sopa de grão')
SET IDENTITY_INSERT [Cantina].[PRATO] OFF
INSERT [Cantina].[TIPO_CLIENTE] ([Id], [Nome], [Preco]) VALUES (1, N'Estudante', CAST(3.00 AS Decimal(10, 2)))
INSERT [Cantina].[TIPO_CLIENTE] ([Id], [Nome], [Preco]) VALUES (2, N'Professor', CAST(2.50 AS Decimal(10, 2)))
INSERT [Cantina].[TIPO_CLIENTE] ([Id], [Nome], [Preco]) VALUES (3, N'Funcionario', CAST(2.00 AS Decimal(10, 2)))
INSERT [Cantina].[TIPO_CLIENTE] ([Id], [Nome], [Preco]) VALUES (4, N'Nao-Estudante', CAST(4.00 AS Decimal(10, 2)))
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Domingo 10:00h', N'Domingo 16:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Domingo 18:00h', N'Domingo 22:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Quarta 18:00h', N'Quarta 22:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Quinta 10:00h', N'Quinta 16:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Quinta 18:00h', N'Quinta 22:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Sábado 10:00h', N'Sábado 16:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Sábado 18:00h', N'Sábado 22:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Segunda 10:00h', N'Segunda 16:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Segunda 18:00h', N'Segunda 22:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Sexta 10:00h', N'Sexta 16:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Terça 10:00h', N'Terça 16:00h')
INSERT [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim]) VALUES (N'Terça 18:00h', N'Terça 22:00h')
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 10:00h', N'Domingo 16:00h', 3)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 10:00h', N'Domingo 16:00h', 5)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 10:00h', N'Domingo 16:00h', 9)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 10:00h', N'Domingo 16:00h', 13)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 10:00h', N'Domingo 16:00h', 15)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 18:00h', N'Domingo 22:00h', 4)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 18:00h', N'Domingo 22:00h', 6)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 18:00h', N'Domingo 22:00h', 8)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 18:00h', N'Domingo 22:00h', 10)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 18:00h', N'Domingo 22:00h', 14)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 18:00h', N'Domingo 22:00h', 16)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Domingo 18:00h', N'Domingo 22:00h', 20)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h', 1)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h', 4)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h', 7)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h', 8)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h', 11)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h', 14)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h', 17)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h', 21)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 10:00h', N'Quarta 16:00h', 76808)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 18:00h', N'Quarta 22:00h', 2)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 18:00h', N'Quarta 22:00h', 3)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 18:00h', N'Quarta 22:00h', 11)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 18:00h', N'Quarta 22:00h', 12)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 18:00h', N'Quarta 22:00h', 13)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quarta 18:00h', N'Quarta 22:00h', 18)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 10:00h', N'Quinta 16:00h', 1)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 10:00h', N'Quinta 16:00h', 5)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 10:00h', N'Quinta 16:00h', 7)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 10:00h', N'Quinta 16:00h', 11)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 10:00h', N'Quinta 16:00h', 15)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 10:00h', N'Quinta 16:00h', 17)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 10:00h', N'Quinta 16:00h', 19)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 10:00h', N'Quinta 16:00h', 21)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 18:00h', N'Quinta 22:00h', 2)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 18:00h', N'Quinta 22:00h', 6)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 18:00h', N'Quinta 22:00h', 8)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 18:00h', N'Quinta 22:00h', 11)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 18:00h', N'Quinta 22:00h', 12)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 18:00h', N'Quinta 22:00h', 16)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 18:00h', N'Quinta 22:00h', 18)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Quinta 18:00h', N'Quinta 22:00h', 76809)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 10:00h', N'Sábado 16:00h', 3)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 10:00h', N'Sábado 16:00h', 5)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 10:00h', N'Sábado 16:00h', 7)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 10:00h', N'Sábado 16:00h', 13)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 10:00h', N'Sábado 16:00h', 15)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 10:00h', N'Sábado 16:00h', 19)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 10:00h', N'Sábado 16:00h', 76809)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 18:00h', N'Sábado 22:00h', 4)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 18:00h', N'Sábado 22:00h', 6)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 18:00h', N'Sábado 22:00h', 8)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 18:00h', N'Sábado 22:00h', 12)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 18:00h', N'Sábado 22:00h', 14)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 18:00h', N'Sábado 22:00h', 16)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 18:00h', N'Sábado 22:00h', 18)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sábado 18:00h', N'Sábado 22:00h', 20)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 10:00h', N'Segunda 16:00h', 1)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 10:00h', N'Segunda 16:00h', 4)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 10:00h', N'Segunda 16:00h', 14)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 10:00h', N'Segunda 16:00h', 15)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 10:00h', N'Segunda 16:00h', 17)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 10:00h', N'Segunda 16:00h', 76807)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 10:00h', N'Segunda 16:00h', 76809)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 18:00h', N'Segunda 22:00h', 2)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 18:00h', N'Segunda 22:00h', 3)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 18:00h', N'Segunda 22:00h', 6)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 18:00h', N'Segunda 22:00h', 16)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 18:00h', N'Segunda 22:00h', 18)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 18:00h', N'Segunda 22:00h', 76808)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Segunda 18:00h', N'Segunda 22:00h', 76809)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 10:00h', N'Sexta 16:00h', 1)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 10:00h', N'Sexta 16:00h', 7)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 10:00h', N'Sexta 16:00h', 13)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 10:00h', N'Sexta 16:00h', 15)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 10:00h', N'Sexta 16:00h', 17)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 10:00h', N'Sexta 16:00h', 19)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 10:00h', N'Sexta 16:00h', 76808)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 10:00h', N'Sexta 16:00h', 76809)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h', 2)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h', 6)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h', 8)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h', 12)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h', 16)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h', 17)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h', 18)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h', 20)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Sexta 18:00h', N'Sexta 22:00h', 76807)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 10:00h', N'Terça 16:00h', 1)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 10:00h', N'Terça 16:00h', 4)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 10:00h', N'Terça 16:00h', 7)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 10:00h', N'Terça 16:00h', 14)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 10:00h', N'Terça 16:00h', 76807)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 18:00h', N'Terça 22:00h', 2)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 18:00h', N'Terça 22:00h', 3)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 18:00h', N'Terça 22:00h', 8)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 18:00h', N'Terça 22:00h', 12)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 18:00h', N'Terça 22:00h', 13)
INSERT [Cantina].[TURNO_ATRIBUIDO] ([Datahora_inicio], [Datahora_fim], [Fid]) VALUES (N'Terça 18:00h', N'Terça 22:00h', 76807)
GO
INSERT [Company].[DEPARTMENT] ([Dname], [Dnumber], [Mgr_ssn], [Mgr_start_date]) VALUES (N'Investigacao', 1, N'21312332 ', CAST(N'2010-08-02' AS Date))
INSERT [Company].[DEPARTMENT] ([Dname], [Dnumber], [Mgr_ssn], [Mgr_start_date]) VALUES (N'Comercial', 2, N'321233765', CAST(N'2013-05-16' AS Date))
INSERT [Company].[DEPARTMENT] ([Dname], [Dnumber], [Mgr_ssn], [Mgr_start_date]) VALUES (N'Logistica', 3, N'41124234 ', CAST(N'2013-05-16' AS Date))
INSERT [Company].[DEPARTMENT] ([Dname], [Dnumber], [Mgr_ssn], [Mgr_start_date]) VALUES (N'Recursos Humanos', 4, N'12652121 ', CAST(N'2014-04-02' AS Date))
INSERT [Company].[DEPARTMENT] ([Dname], [Dnumber], [Mgr_ssn], [Mgr_start_date]) VALUES (N'Desporto', 5, NULL, NULL)
INSERT [Company].[DEPENDENT] ([Essn], [Dependent_name], [Sex], [Bdate], [Relationship]) VALUES (N'21312332 ', N'Joana Costa', N'F', CAST(N'2008-04-01' AS Date), N'Filho')
INSERT [Company].[DEPENDENT] ([Essn], [Dependent_name], [Sex], [Bdate], [Relationship]) VALUES (N'21312332 ', N'Maria Costa', N'F', CAST(N'1990-10-05' AS Date), N'Neto')
INSERT [Company].[DEPENDENT] ([Essn], [Dependent_name], [Sex], [Bdate], [Relationship]) VALUES (N'21312332 ', N'Rui Costa', N'M', CAST(N'2000-08-04' AS Date), N'Neto')
INSERT [Company].[DEPENDENT] ([Essn], [Dependent_name], [Sex], [Bdate], [Relationship]) VALUES (N'321233765', N'Filho Lindo', N'M', CAST(N'2001-02-22' AS Date), N'Filho')
INSERT [Company].[DEPENDENT] ([Essn], [Dependent_name], [Sex], [Bdate], [Relationship]) VALUES (N'342343434', N'Rosa Lima', N'F', CAST(N'2006-03-11' AS Date), N'Filho')
INSERT [Company].[DEPENDENT] ([Essn], [Dependent_name], [Sex], [Bdate], [Relationship]) VALUES (N'41124234 ', N'Ana Sousa', N'F', CAST(N'2007-04-13' AS Date), N'Neto')
INSERT [Company].[DEPENDENT] ([Essn], [Dependent_name], [Sex], [Bdate], [Relationship]) VALUES (N'41124234 ', N'Gaspar Pinto', N'M', CAST(N'2006-02-08' AS Date), N'Sobrinho')
INSERT [Company].[DEPT_LOCATIONS] ([Dnumber], [Dlocation]) VALUES (2, N'Aveiro')
INSERT [Company].[DEPT_LOCATIONS] ([Dnumber], [Dlocation]) VALUES (3, N'Coimbra')
INSERT [Company].[EMPLOYEE] ([Fname], [Minit], [Lname], [Ssn], [Bdate], [Address], [Sex], [Salary], [Super_ssn], [Dno]) VALUES (N'Ana', N'L', N'Silva', N'12652121 ', CAST(N'1990-03-03' AS Date), N'Rua ZIG ZAG', N'F', CAST(1400.00 AS Decimal(10, 2)), N'21312332 ', 2)
INSERT [Company].[EMPLOYEE] ([Fname], [Minit], [Lname], [Ssn], [Bdate], [Address], [Sex], [Salary], [Super_ssn], [Dno]) VALUES (N'Paula', N'A', N'Sousa', N'183623612', CAST(N'2001-08-11' AS Date), N'Rua da FRENTE', N'F', CAST(1450.00 AS Decimal(10, 2)), NULL, 3)
INSERT [Company].[EMPLOYEE] ([Fname], [Minit], [Lname], [Ssn], [Bdate], [Address], [Sex], [Salary], [Super_ssn], [Dno]) VALUES (N'Carlos', N'D', N'Gomes', N'21312332 ', CAST(N'2000-01-01' AS Date), N'Rua XPTO', N'M', CAST(1200.00 AS Decimal(10, 2)), NULL, 1)
INSERT [Company].[EMPLOYEE] ([Fname], [Minit], [Lname], [Ssn], [Bdate], [Address], [Sex], [Salary], [Super_ssn], [Dno]) VALUES (N'Juliana', N'A', N'Amaral', N'321233765', CAST(N'1980-08-11' AS Date), N'Rua BZZZZ', N'F', CAST(1350.00 AS Decimal(10, 2)), NULL, 3)
INSERT [Company].[EMPLOYEE] ([Fname], [Minit], [Lname], [Ssn], [Bdate], [Address], [Sex], [Salary], [Super_ssn], [Dno]) VALUES (N'Maria', N'I', N'Pereira', N'342343434', CAST(N'2001-05-01' AS Date), N'Rua JANOTA', N'F', CAST(1250.00 AS Decimal(10, 2)), N'21312332 ', 2)
INSERT [Company].[EMPLOYEE] ([Fname], [Minit], [Lname], [Ssn], [Bdate], [Address], [Sex], [Salary], [Super_ssn], [Dno]) VALUES (N'Joao', N'G', N'Costa', N'41124234 ', CAST(N'2001-01-01' AS Date), N'Rua YGZ', N'M', CAST(1300.00 AS Decimal(10, 2)), N'21312332 ', 2)
INSERT [Company].[PROJECT] ([Pname], [Pnumber], [Plocation], [Dnum]) VALUES (N'Aveiro Digital', 1, N'Aveiro', 3)
INSERT [Company].[PROJECT] ([Pname], [Pnumber], [Plocation], [Dnum]) VALUES (N'BD Open Day', 2, N'Espinho', 2)
INSERT [Company].[PROJECT] ([Pname], [Pnumber], [Plocation], [Dnum]) VALUES (N'Dicoogle', 3, N'Aveiro', 3)
INSERT [Company].[PROJECT] ([Pname], [Pnumber], [Plocation], [Dnum]) VALUES (N'GOPACS', 4, N'Aveiro', 3)
INSERT [Company].[WORKS_ON] ([Essn], [Pno], [Hours]) VALUES (N'183623612', 1, CAST(20.0 AS Decimal(3, 1)))
INSERT [Company].[WORKS_ON] ([Essn], [Pno], [Hours]) VALUES (N'183623612', 3, CAST(10.0 AS Decimal(3, 1)))
INSERT [Company].[WORKS_ON] ([Essn], [Pno], [Hours]) VALUES (N'21312332 ', 1, CAST(20.0 AS Decimal(3, 1)))
INSERT [Company].[WORKS_ON] ([Essn], [Pno], [Hours]) VALUES (N'321233765', 1, CAST(25.0 AS Decimal(3, 1)))
INSERT [Company].[WORKS_ON] ([Essn], [Pno], [Hours]) VALUES (N'342343434', 1, CAST(20.0 AS Decimal(3, 1)))
INSERT [Company].[WORKS_ON] ([Essn], [Pno], [Hours]) VALUES (N'342343434', 4, CAST(25.0 AS Decimal(3, 1)))
INSERT [Company].[WORKS_ON] ([Essn], [Pno], [Hours]) VALUES (N'41124234 ', 2, CAST(20.0 AS Decimal(3, 1)))
INSERT [Company].[WORKS_ON] ([Essn], [Pno], [Hours]) VALUES (N'41124234 ', 3, CAST(30.0 AS Decimal(3, 1)))
INSERT [dbo].[Hello] ([MsgID], [MsgSubject]) VALUES (1245, N'Olá tudo bem')
INSERT [Prescricao].[FARMACEUTICA] ([nome], [numReg], [endereco]) VALUES (N'Roche', 905, N'Estrada Nacional 249')
INSERT [Prescricao].[FARMACEUTICA] ([nome], [numReg], [endereco]) VALUES (N'Bayer', 906, N'Rua da Quinta do Pinheiro 5')
INSERT [Prescricao].[FARMACEUTICA] ([nome], [numReg], [endereco]) VALUES (N'Merck', 908, N'Alameda Fernão Lopes 12')
INSERT [Prescricao].[FARMACO] ([numRegFarm], [nome], [formula]) VALUES (908, N'Aspirina 1000', N'BIOZZ02')
INSERT [Prescricao].[FARMACO] ([numRegFarm], [nome], [formula]) VALUES (906, N'Xelopironi 350', N'FRR-34')
INSERT [Prescricao].[FARMACO] ([numRegFarm], [nome], [formula]) VALUES (906, N'Voltaren Spray', N'PLTZ32')
INSERT [Prescricao].[FARMACO] ([numRegFarm], [nome], [formula]) VALUES (906, N'Gucolan 1000', N'VFR-750')
INSERT [Prescricao].[MEDICO] ([numSNS], [nome], [especialidade]) VALUES (101, N'Joao Pires Lima', N'Cardiologia')
INSERT [Prescricao].[MEDICO] ([numSNS], [nome], [especialidade]) VALUES (102, N'Manuel Jose Rosa', N'Cardiologia')
INSERT [Prescricao].[MEDICO] ([numSNS], [nome], [especialidade]) VALUES (103, N'Rui Luis Caraca', N'Pneumologia')
INSERT [Prescricao].[MEDICO] ([numSNS], [nome], [especialidade]) VALUES (104, N'Sofia Sousa Silva', N'Radiologia')
INSERT [Prescricao].[MEDICO] ([numSNS], [nome], [especialidade]) VALUES (105, N'Ana Barbosa', N'Neurologia')
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-03' AS Date), 1, 509111222)
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-04' AS Date), 2, 509121212)
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-05' AS Date), 3, 509987654)
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-06' AS Date), 4, 509827353)
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-07' AS Date), 5, 509294734)
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-08' AS Date), 6, 509836433)
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-09' AS Date), 7, 509121212)
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-10' AS Date), 8, 509987654)
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-11' AS Date), 9, 509836433)
INSERT [Stocks].[ENCOMENDA] ([Data], [Numero], [Fornecedor]) VALUES (CAST(N'2015-03-12' AS Date), 10, 509987654)
INSERT [Stocks].[FORNECEDOR] ([Nif], [Nome], [Fax], [Endereço], [Condpag], [Tipo]) VALUES (509111222, N'LactoSerrano', 234872372, NULL, 60, 102)
INSERT [Stocks].[FORNECEDOR] ([Nif], [Nome], [Fax], [Endereço], [Condpag], [Tipo]) VALUES (509121212, N'FrescoNorte', 221234567, N'Rua do Complexo Grande - Edf 3', 90, 102)
INSERT [Stocks].[FORNECEDOR] ([Nif], [Nome], [Fax], [Endereço], [Condpag], [Tipo]) VALUES (509294734, N'PinkDrinks', 2123231732, N'Rua Poente 723', 30, 105)
INSERT [Stocks].[FORNECEDOR] ([Nif], [Nome], [Fax], [Endereço], [Condpag], [Tipo]) VALUES (509827353, N'LactoSerrano', 234872372, NULL, 60, 102)
INSERT [Stocks].[FORNECEDOR] ([Nif], [Nome], [Fax], [Endereço], [Condpag], [Tipo]) VALUES (509836433, N'LeviClean', 229343284, N'Rua Sol Poente 6243', 30, 107)
INSERT [Stocks].[FORNECEDOR] ([Nif], [Nome], [Fax], [Endereço], [Condpag], [Tipo]) VALUES (509987654, N'MaduTex', 234873434, N'Estrada da Cincunvalacao 213', 30, 104)
INSERT [Stocks].[FORNECEDOR] ([Nif], [Nome], [Fax], [Endereço], [Condpag], [Tipo]) VALUES (590972623, N'ConservasMac', 234112233, N'Rua da Recta 233', 30, 104)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (1, 10001, 200)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (1, 10004, 300)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (2, 10002, 1200)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (2, 10003, 3200)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (3, 10013, 900)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (4, 10006, 50)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (4, 10007, 40)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (4, 10014, 200)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (5, 10005, 500)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (5, 10008, 10)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (5, 10011, 1000)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (6, 10009, 200)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (6, 10010, 200)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (7, 10003, 1200)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (8, 10013, 350)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (9, 10009, 100)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (9, 10010, 300)
INSERT [Stocks].[ITEM] ([NumEnc], [CodProd], [Unidades]) VALUES (10, 10012, 200)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(8.75 AS Decimal(10, 2)), CAST(23.00 AS Decimal(10, 2)), N'Bife da Pa', 125, 10001)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(1.25 AS Decimal(10, 2)), CAST(23.00 AS Decimal(10, 2)), N'Laranja Algarve', 1000, 10002)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(1.45 AS Decimal(10, 2)), CAST(23.00 AS Decimal(10, 2)), N'Pera Rocha', 2000, 10003)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(10.15 AS Decimal(10, 2)), CAST(23.00 AS Decimal(10, 2)), N'Secretos de Porco Preto', 342, 10004)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(2.99 AS Decimal(10, 2)), CAST(13.00 AS Decimal(10, 2)), N'Vinho Rose Plus', 5232, 10005)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(15.00 AS Decimal(10, 2)), CAST(23.00 AS Decimal(10, 2)), N'Queijo de Cabra da Serra', 3243, 10006)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(0.65 AS Decimal(10, 2)), CAST(23.00 AS Decimal(10, 2)), N'Queijo Fresco do Dia', 452, 10007)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(1.65 AS Decimal(10, 2)), CAST(13.00 AS Decimal(10, 2)), N'Cerveja Preta Artesanal', 937, 10008)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(1.85 AS Decimal(10, 2)), CAST(23.00 AS Decimal(10, 2)), N'Lixivia de Cor', 9382, 10009)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(4.05 AS Decimal(10, 2)), CAST(23.00 AS Decimal(10, 2)), N'Amaciador Neutro', 932432, 10010)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(0.55 AS Decimal(10, 2)), CAST(6.00 AS Decimal(10, 2)), N'Agua Natural', 919323, 10011)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(0.15 AS Decimal(10, 2)), CAST(6.00 AS Decimal(10, 2)), N'Pao de Leite', 5434, 10012)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(1.00 AS Decimal(10, 2)), CAST(13.00 AS Decimal(10, 2)), N'Arroz Agulha', 7665, 10013)
INSERT [Stocks].[PRODUTO] ([PreCo], [Iva], [Nome], [Unidades], [Codigo]) VALUES (CAST(0.40 AS Decimal(10, 2)), CAST(13.00 AS Decimal(10, 2)), N'Iogurte Natural', 998, 10014)
INSERT [Stocks].[TIPO_FORNECEDOR] ([Codigo], [Designacao]) VALUES (105, N'Bebidas')
INSERT [Stocks].[TIPO_FORNECEDOR] ([Codigo], [Designacao]) VALUES (101, N'Carnes')
INSERT [Stocks].[TIPO_FORNECEDOR] ([Codigo], [Designacao]) VALUES (107, N'Detergentes')
INSERT [Stocks].[TIPO_FORNECEDOR] ([Codigo], [Designacao]) VALUES (103, N'Frutas e Legumes')
INSERT [Stocks].[TIPO_FORNECEDOR] ([Codigo], [Designacao]) VALUES (102, N'Laticinios')
INSERT [Stocks].[TIPO_FORNECEDOR] ([Codigo], [Designacao]) VALUES (104, N'Mercearia')
INSERT [Stocks].[TIPO_FORNECEDOR] ([Codigo], [Designacao]) VALUES (106, N'Peixe')
/****** Object:  Index [idx_COMPRA]    Script Date: 2020-06-12 23:36:41 ******/
CREATE NONCLUSTERED INDEX [idx_COMPRA] ON [Cantina].[CESTO_DE_COMPRA]
(
	[C_ref_fatura] ASC,
	[Pid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_CLIENTE]    Script Date: 2020-06-12 23:36:41 ******/
CREATE NONCLUSTERED INDEX [idx_CLIENTE] ON [Cantina].[CLIENTE]
(
	[Nif] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_COMPRA]    Script Date: 2020-06-12 23:36:41 ******/
CREATE NONCLUSTERED INDEX [idx_COMPRA] ON [Cantina].[COMPRA]
(
	[Cnif] ASC,
	[Ref_fatura] ASC,
	[Fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__FUNCIONA__A9D105347C19A334]    Script Date: 2020-06-12 23:36:41 ******/
ALTER TABLE [Cantina].[FUNCIONARIO] ADD  CONSTRAINT [UQ__FUNCIONA__A9D105347C19A334] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_INGREDIENTE]    Script Date: 2020-06-12 23:36:41 ******/
CREATE NONCLUSTERED INDEX [idx_INGREDIENTE] ON [Cantina].[INGREDIENTE]
(
	[Id] ASC,
	[Nome] ASC,
	[Valor_nutritivo] ASC,
	[Quantidade_disponivel] ASC,
	[Did] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__DEPARTME__83BFD849719C818C]    Script Date: 2020-06-12 23:36:41 ******/
ALTER TABLE [Company].[DEPARTMENT] ADD UNIQUE NONCLUSTERED 
(
	[Dname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__FARMACO__6F71C0DCBD014D72]    Script Date: 2020-06-12 23:36:41 ******/
ALTER TABLE [Prescricao].[FARMACO] ADD UNIQUE NONCLUSTERED 
(
	[nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__PRODUTO__06370DACD1BA7AD0]    Script Date: 2020-06-12 23:36:41 ******/
ALTER TABLE [Stocks].[PRODUTO] ADD UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__TIPO_FOR__59CD47325A67FE90]    Script Date: 2020-06-12 23:36:41 ******/
ALTER TABLE [Stocks].[TIPO_FORNECEDOR] ADD UNIQUE NONCLUSTERED 
(
	[Designacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [Cantina].[CESTO_DE_COMPRA]  WITH CHECK ADD  CONSTRAINT [FK__CESTO_DE___C_ref__55009F39] FOREIGN KEY([C_ref_fatura])
REFERENCES [Cantina].[COMPRA] ([Ref_fatura])
GO
ALTER TABLE [Cantina].[CESTO_DE_COMPRA] CHECK CONSTRAINT [FK__CESTO_DE___C_ref__55009F39]
GO
ALTER TABLE [Cantina].[CESTO_DE_COMPRA]  WITH CHECK ADD  CONSTRAINT [FK__CESTO_DE_CO__Pid__540C7B00] FOREIGN KEY([Pid])
REFERENCES [Cantina].[PRATO] ([Id])
GO
ALTER TABLE [Cantina].[CESTO_DE_COMPRA] CHECK CONSTRAINT [FK__CESTO_DE_CO__Pid__540C7B00]
GO
ALTER TABLE [Cantina].[CLIENTE]  WITH CHECK ADD FOREIGN KEY([Tipo])
REFERENCES [Cantina].[TIPO_CLIENTE] ([Id])
GO
ALTER TABLE [Cantina].[COMPOSICAO_DO_MENU]  WITH CHECK ADD FOREIGN KEY([Mid])
REFERENCES [Cantina].[MENU] ([Id])
GO
ALTER TABLE [Cantina].[COMPOSICAO_DO_MENU]  WITH CHECK ADD  CONSTRAINT [FK__COMPOSICAO___Pid__43A1090D] FOREIGN KEY([Pid])
REFERENCES [Cantina].[PRATO] ([Id])
GO
ALTER TABLE [Cantina].[COMPOSICAO_DO_MENU] CHECK CONSTRAINT [FK__COMPOSICAO___Pid__43A1090D]
GO
ALTER TABLE [Cantina].[COMPOSICAO_DO_PRATO]  WITH CHECK ADD FOREIGN KEY([Iid])
REFERENCES [Cantina].[INGREDIENTE] ([Id])
GO
ALTER TABLE [Cantina].[COMPOSICAO_DO_PRATO]  WITH CHECK ADD  CONSTRAINT [FK__COMPOSICAO___Pid__477199F1] FOREIGN KEY([Pid])
REFERENCES [Cantina].[PRATO] ([Id])
GO
ALTER TABLE [Cantina].[COMPOSICAO_DO_PRATO] CHECK CONSTRAINT [FK__COMPOSICAO___Pid__477199F1]
GO
ALTER TABLE [Cantina].[COMPRA]  WITH NOCHECK ADD  CONSTRAINT [FK__COMPRA__Cnif__4E53A1AA] FOREIGN KEY([Cnif])
REFERENCES [Cantina].[CLIENTE] ([Nif])
GO
ALTER TABLE [Cantina].[COMPRA] CHECK CONSTRAINT [FK__COMPRA__Cnif__4E53A1AA]
GO
ALTER TABLE [Cantina].[COMPRA]  WITH NOCHECK ADD  CONSTRAINT [FK__COMPRA__Fid__4F47C5E3] FOREIGN KEY([Fid])
REFERENCES [Cantina].[FUNCIONARIO] ([Id])
GO
ALTER TABLE [Cantina].[COMPRA] CHECK CONSTRAINT [FK__COMPRA__Fid__4F47C5E3]
GO
ALTER TABLE [Cantina].[FUNCIONARIO]  WITH CHECK ADD  CONSTRAINT [fk_Funcionario_Cargo] FOREIGN KEY([Ccodigo])
REFERENCES [Cantina].[CARGO] ([Codigo])
GO
ALTER TABLE [Cantina].[FUNCIONARIO] CHECK CONSTRAINT [fk_Funcionario_Cargo]
GO
ALTER TABLE [Cantina].[INGREDIENTE]  WITH CHECK ADD  CONSTRAINT [FK__INGREDIENTE__Did__5F7E2DAC] FOREIGN KEY([Did])
REFERENCES [Cantina].[DISPENSA] ([Id])
GO
ALTER TABLE [Cantina].[INGREDIENTE] CHECK CONSTRAINT [FK__INGREDIENTE__Did__5F7E2DAC]
GO
ALTER TABLE [Cantina].[TURNO_ATRIBUIDO]  WITH CHECK ADD  CONSTRAINT [FK__TURNO_ATRIB__Fid__308E3499] FOREIGN KEY([Fid])
REFERENCES [Cantina].[FUNCIONARIO] ([Id])
GO
ALTER TABLE [Cantina].[TURNO_ATRIBUIDO] CHECK CONSTRAINT [FK__TURNO_ATRIB__Fid__308E3499]
GO
ALTER TABLE [Cantina].[TURNO_ATRIBUIDO]  WITH CHECK ADD FOREIGN KEY([Datahora_inicio], [Datahora_fim])
REFERENCES [Cantina].[TURNO] ([Datahora_inicio], [Datahora_fim])
GO
ALTER TABLE [Company].[DEPARTMENT]  WITH CHECK ADD FOREIGN KEY([Mgr_ssn])
REFERENCES [Company].[EMPLOYEE] ([Ssn])
GO
ALTER TABLE [Company].[DEPENDENT]  WITH CHECK ADD FOREIGN KEY([Essn])
REFERENCES [Company].[EMPLOYEE] ([Ssn])
GO
ALTER TABLE [Company].[DEPT_LOCATIONS]  WITH CHECK ADD FOREIGN KEY([Dnumber])
REFERENCES [Company].[DEPARTMENT] ([Dnumber])
GO
ALTER TABLE [Company].[EMPLOYEE]  WITH CHECK ADD  CONSTRAINT [Dno] FOREIGN KEY([Dno])
REFERENCES [Company].[DEPARTMENT] ([Dnumber])
GO
ALTER TABLE [Company].[EMPLOYEE] CHECK CONSTRAINT [Dno]
GO
ALTER TABLE [Company].[EMPLOYEE]  WITH CHECK ADD FOREIGN KEY([Super_ssn])
REFERENCES [Company].[EMPLOYEE] ([Ssn])
GO
ALTER TABLE [Company].[PROJECT]  WITH CHECK ADD FOREIGN KEY([Dnum])
REFERENCES [Company].[DEPARTMENT] ([Dnumber])
GO
ALTER TABLE [Company].[WORKS_ON]  WITH CHECK ADD FOREIGN KEY([Essn])
REFERENCES [Company].[EMPLOYEE] ([Ssn])
GO
ALTER TABLE [Company].[WORKS_ON]  WITH CHECK ADD FOREIGN KEY([Pno])
REFERENCES [Company].[PROJECT] ([Pnumber])
GO
ALTER TABLE [Prescricao].[FARMACO]  WITH CHECK ADD FOREIGN KEY([numRegFarm])
REFERENCES [Prescricao].[FARMACEUTICA] ([numReg])
GO
ALTER TABLE [Prescricao].[PRESC_FARMACO]  WITH CHECK ADD FOREIGN KEY([nomeFarmaco])
REFERENCES [Prescricao].[FARMACO] ([nome])
GO
ALTER TABLE [Prescricao].[PRESC_FARMACO]  WITH CHECK ADD FOREIGN KEY([numPresc])
REFERENCES [Prescricao].[PRESCRICAO] ([numPresc])
GO
ALTER TABLE [Prescricao].[PRESC_FARMACO]  WITH CHECK ADD FOREIGN KEY([numRegFarm])
REFERENCES [Prescricao].[FARMACEUTICA] ([numReg])
GO
ALTER TABLE [Prescricao].[PRESCRICAO]  WITH CHECK ADD FOREIGN KEY([farmacia])
REFERENCES [Prescricao].[FARMACIA] ([nome])
GO
ALTER TABLE [Prescricao].[PRESCRICAO]  WITH CHECK ADD FOREIGN KEY([numMedico])
REFERENCES [Prescricao].[MEDICO] ([numSNS])
GO
ALTER TABLE [Prescricao].[PRESCRICAO]  WITH CHECK ADD FOREIGN KEY([numUtente])
REFERENCES [Prescricao].[PACIENTE] ([numUtente])
GO
ALTER TABLE [Stocks].[ENCOMENDA]  WITH CHECK ADD FOREIGN KEY([Fornecedor])
REFERENCES [Stocks].[FORNECEDOR] ([Nif])
GO
ALTER TABLE [Stocks].[FORNECEDOR]  WITH CHECK ADD FOREIGN KEY([Tipo])
REFERENCES [Stocks].[TIPO_FORNECEDOR] ([Codigo])
GO
ALTER TABLE [Stocks].[ITEM]  WITH CHECK ADD FOREIGN KEY([CodProd])
REFERENCES [Stocks].[PRODUTO] ([Codigo])
GO
ALTER TABLE [Stocks].[ITEM]  WITH CHECK ADD FOREIGN KEY([NumEnc])
REFERENCES [Stocks].[ENCOMENDA] ([Numero])
GO
ALTER TABLE [Cantina].[CLIENTE]  WITH CHECK ADD CHECK  (([Nif]>(100000000) AND [Nif]<(999999999)))
GO
ALTER TABLE [Cantina].[COMPRA]  WITH NOCHECK ADD  CONSTRAINT [CK__COMPRA__Cnif__4D5F7D71] CHECK  (([Cnif]>(100000000) AND [Cnif]<(999999999)))
GO
ALTER TABLE [Cantina].[COMPRA] CHECK CONSTRAINT [CK__COMPRA__Cnif__4D5F7D71]
GO
/****** Object:  StoredProcedure [Company].[procedureFuncionario]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Company].[procedureFuncionario] @SSN DECIMAL(9,0)
AS
BEGIN
	
	DELETE FROM Company.DEPENDENT WHERE Essn=@SSN;
	DELETE FROM Company.WORKS_ON WHERE Essn=@SSN;
	UPDATE Company.DEPARTMENT SET Mgr_ssn=null WHERE Mgr_ssn=@SSN;
	DELETE FROM Company.EMPLOYEE WHERE Ssn=@SSN;

	--Nota: temos de eliminar primeiro as referências ao funcionario, e só dps é que o podemos remover

END
GO
/****** Object:  StoredProcedure [Company].[procedureGestor]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--b)
CREATE PROCEDURE [Company].[procedureGestor] (@Ssn DECIMAL(9,0) OUTPUT, @Fname VARCHAR(15) OUTPUT, @Lname VARCHAR(15) OUTPUT, @diff INTEGER OUTPUT)
AS
BEGIN
	SELECT Ssn, Fname, Lname
	FROM Company.EMPLOYEE JOIN Company.DEPARTMENT ON Ssn=Mgr_ssn;
	SELECT TOP 1  @Ssn=Ssn, @Fname=Fname, @Lname=Lname, @diff=DATEDIFF(year, Mgr_start_date, CONVERT (date, SYSDATETIME())) FROM Company.EMPLOYEE JOIN Company.DEPARTMENT ON Ssn=Mgr_ssn ORDER BY Mgr_start_date;
END
GO
/****** Object:  StoredProcedure [dbo].[Apaga_Prato]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Apaga_Prato] 
	-- Add the parameters for the stored procedure here
	@Id int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE Cantina.PRATO WHERE Id=@Id
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_Cliente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Delete_Cliente] 
	-- Add the parameters for the stored procedure here
	@Nif int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE Cantina.CLIENTE WHERE Nif=@Nif
END

GO
/****** Object:  StoredProcedure [dbo].[Delete_Funcionario]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Delete_Funcionario] 
	-- Add the parameters for the stored procedure here
	@Id int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE Cantina.FUNCIONARIO WHERE Id=@Id
END

GO
/****** Object:  StoredProcedure [dbo].[Delete_Ingrediente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Delete_Ingrediente] 
	-- Add the parameters for the stored procedure here
	@Id int = 0
	--@capacity decimal(15,2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE Cantina.INGREDIENTE WHERE Id=@Id
END

GO
/****** Object:  StoredProcedure [dbo].[Delete_Turno_Atribuido]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Delete_Turno_Atribuido] 
	-- Add the parameters for the stored procedure here
	@Fid int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE Cantina.Turno_Atribuido WHERE Fid=@Fid
END

GO
/****** Object:  StoredProcedure [dbo].[Insert_Composicao_Menu]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Insert_Composicao_Menu] 
	-- Add the parameters for the stored procedure here
@Pid int, @Mid int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
INSERT Cantina.COMPOSICAO_DO_MENU (Pid, Mid) VALUES (@Pid, @Mid) 
END

GO
/****** Object:  StoredProcedure [dbo].[Insert_Composicao_Prato]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Insert_Composicao_Prato] 
	-- Add the parameters for the stored procedure here
@Pid int, @Iid int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
INSERT Cantina.COMPOSICAO_DO_PRATO (Pid, Iid) VALUES (@Pid, @Iid) 
END

GO
/****** Object:  StoredProcedure [dbo].[Insert_Compra]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Insert_Compra] 
	-- Add the parameters for the stored procedure here
@Id int,
@fid int,
@string varchar(500)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @fatura int;
	DECLARE @tableID table(Id int);
	DECLARE @i VARCHAR(64);

    -- Insert statements for procedure here
	BEGIN TRANSACTION [tran]
		BEGIN TRY
			-- Insert statements for procedure here
			INSERT Cantina.compra (cnif, datahora, fid) output inserted.Ref_fatura into @tableID VALUES (@Id, GETDATE(), @fid);
			SELECT @fatura = Id FROM @tableID

			SELECT * INTO #temp FROM STRING_SPLIT(@string, ',') WHERE RTRIM(value) <> ''
			WHILE EXISTS (SELECT * FROM #temp)
			BEGIN
				SELECT Top 1 @i = value FROM #temp
				DELETE #temp WHERE value = @i

				INSERT Cantina.CESTO_DE_COMPRA (pid, c_ref_fatura) VALUES (@i, @fatura);
			END
			COMMIT TRANSACTION [tran]
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION [tran]
		END CATCH
	END

GO
/****** Object:  StoredProcedure [dbo].[Insert_Compra_E_Cliente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Insert_Compra_E_Cliente] 
	-- Add the parameters for the stored procedure here
@Id int,
@fid int,
@string varchar(500),
@email varchar (76),
@tipo int,

--Parâmetros opcionais
@fname varchar(32) = NULL,
@lname varchar(32) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @fatura int;
	DECLARE @tableID table(Id int);
	DECLARE @i VARCHAR(64);

    -- Insert statements for procedure here
	BEGIN TRANSACTION [tran]
		BEGIN TRY
			-- Insert statements for procedure here
			INSERT Cantina.CLIENTE (Nif, Fname, Lname, Email, Tipo) VALUES (@Id, @fname, @lname, @email, @tipo);

			INSERT Cantina.compra (cnif, datahora, fid) output inserted.Ref_fatura into @tableID VALUES (@Id, GETDATE(), @fid);
			SELECT @fatura = Id FROM @tableID

			SELECT * INTO #temp FROM STRING_SPLIT(@string, ',') WHERE RTRIM(value) <> ''
			WHILE EXISTS (SELECT * FROM #temp)
			BEGIN
				SELECT Top 1 @i = value FROM #temp
				DELETE #temp WHERE value = @i

				INSERT Cantina.CESTO_DE_COMPRA (pid, c_ref_fatura) VALUES (@i, @fatura);
			END
			COMMIT TRANSACTION [tran]
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION [tran]
		END CATCH
	END


GO
/****** Object:  StoredProcedure [dbo].[Insert_Prato]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Insert_Prato] 
	-- Add the parameters for the stored procedure here
--@Id int, 
@Nome varchar(76), @Tipo varchar(76)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
--INSERT Cantina.PRATO (Id, Nome, Tipo) VALUES (@Id, @Nome, @Tipo)
INSERT Cantina.PRATO (Nome, Tipo) OUTPUT INSERTED.Id VALUES (@Nome, @Tipo)
END



GO
/****** Object:  StoredProcedure [dbo].[Remove_Composicao_Menu]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Remove_Composicao_Menu] 
	-- Add the parameters for the stored procedure here
@Pid int, @Mid int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DELETE Cantina.Composicao_do_menu WHERE Pid=@Pid and Mid=@Mid
END

GO
/****** Object:  StoredProcedure [dbo].[Remove_Composicao_Prato]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Remove_Composicao_Prato] 
	-- Add the parameters for the stored procedure here
@Pid int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DELETE Cantina.Composicao_do_prato WHERE Pid=@Pid
END

GO
/****** Object:  StoredProcedure [dbo].[Remove_Dispensa]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Remove_Dispensa] 
	-- Add the parameters for the stored procedure here
	@Id int = 0
	--@Capacidade decimal(15,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE Cantina.Dispensa WHERE Id = @Id
END

GO
/****** Object:  StoredProcedure [dbo].[Remove_Vendas]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Remove_Vendas] 
	-- Add the parameters for the stored procedure here
@fatura int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION trans
    -- Insert statements for procedure here
		DELETE Cantina.Cesto_de_Compra WHERE C_ref_fatura=@fatura
		DELETE Cantina.Compra WHERE Ref_fatura=@fatura
		COMMIT TRANSACTION trans
	END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION trans
END CATCH

END


GO
/****** Object:  StoredProcedure [dbo].[Select_Cargo]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Cargo]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Cantina.CARGO
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Cesto_Compra]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Cesto_Compra] @fatura int
	-- Add the parameters for the stored procedure here
	--@Id int = 0,
	--@QuantidadeOutput decimal(10,2)
	--@Capacidade decimal(15,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Pid, Nome, Ref_fatura from cantina.compra inner join cantina.cesto_de_compra on compra.Ref_fatura = CESTO_DE_COMPRA.C_ref_fatura inner join cantina.prato on prato.id = cesto_de_compra.pid where ref_fatura = @fatura
END


GO
/****** Object:  StoredProcedure [dbo].[Select_Cliente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Cliente] 
	-- Add the parameters for the stored procedure here
	--@Fid int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Cantina.CLIENTE inner join cantina.tipo_cliente on cliente.tipo = tipo_cliente.id
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Composicao_Prato]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Composicao_Prato] 
	-- Add the parameters for the stored procedure here
	--@Id int = 0,
	--@QuantidadeOutput decimal(10,2)
	--@Capacidade decimal(15,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select composicao_do_prato.pid,  composicao_do_prato.Iid, ingrediente.nome, alergenios from cantina.prato inner join cantina.composicao_do_prato on prato.id = composicao_do_prato.pid inner join cantina.ingrediente on composicao_do_prato.Iid = ingrediente.id
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Dispensa_Capacidade]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Dispensa_Capacidade] 
	-- Add the parameters for the stored procedure here
	@id int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Capacidade FROM cantina.Dispensa WHERE id=@id
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Dispensa_Null]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Dispensa_Null] 
	-- Add the parameters for the stored procedure here
--	@id int = 0,
	--@capacity decimal(15,2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Cantina.Dispensa WHERE CapacidadeAtual IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Funcionario]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Funcionario]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Cantina.FUNCIONARIO
END
GO
/****** Object:  StoredProcedure [dbo].[Select_Ingrediente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Ingrediente] 
	-- Add the parameters for the stored procedure here
	--@Nif int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Cantina.INGREDIENTE
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Ingrediente_Sum]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Ingrediente_Sum] 
	-- Add the parameters for the stored procedure here
	@iDid int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT SUM(Quantidade_disponivel) AS numero FROM Cantina.INGREDIENTE INNER JOIN Cantina.DISPENSA ON Cantina.INGREDIENTE.Did = Cantina.DISPENSA.Id WHERE Cantina.DISPENSA.Id = @iDid
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Menu]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Menu] 
	-- Add the parameters for the stored procedure here
	--@Id int = 0,
	--@QuantidadeOutput decimal(10,2)
	--@Capacidade decimal(15,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Cantina.MENU
END

GO
/****** Object:  StoredProcedure [dbo].[Select_N_Pratos_Vendidos]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_N_Pratos_Vendidos] 
	-- Add the parameters for the stored procedure here
	--@Id int = 0,
	--@QuantidadeOutput decimal(10,2)
	--@Capacidade decimal(15,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select nome, count(Pid) AS N_Pratos_vendidos from cantina.compra inner join cantina.cesto_de_compra on compra.ref_fatura = cesto_de_compra.c_ref_fatura inner join cantina.prato on cesto_de_compra.pid = prato.id group by nome order by count(pid) desc
END


GO
/****** Object:  StoredProcedure [dbo].[Select_N_Pratos_Vendidos_Por_Tipo_Cliente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_N_Pratos_Vendidos_Por_Tipo_Cliente] 
	-- Add the parameters for the stored procedure here
	--@Id int = 0,
	--@QuantidadeOutput decimal(10,2)
	--@Capacidade decimal(15,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select count (C_ref_fatura) as N_Compras, tipo, tipo_cliente.nome from cantina.compra inner join cantina.cesto_de_compra on compra.ref_fatura = cesto_de_compra.c_ref_fatura inner join cantina.cliente on cliente.nif = compra.cnif inner join cantina.tipo_cliente on cliente.tipo = tipo_cliente.id group by cliente.tipo, tipo_cliente.nome order by cliente.tipo
END


GO
/****** Object:  StoredProcedure [dbo].[Select_Prato]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Prato] 
	-- Add the parameters for the stored procedure here
	--@Id int = 0,
	--@QuantidadeOutput decimal(10,2)
	--@Capacidade decimal(15,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from cantina.prato inner join cantina.composicao_do_menu on prato.id = composicao_do_menu.pid
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Prato_Menu]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Select_Prato_Menu] @id int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from cantina.prato inner join cantina.composicao_do_menu on prato.id = composicao_do_menu.pid Where mid = @id
END


GO
/****** Object:  StoredProcedure [dbo].[Select_Tipo_Cliente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Tipo_Cliente]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from cantina.tipo_cliente
END


GO
/****** Object:  StoredProcedure [dbo].[Select_Turno]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Turno]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Cantina.TURNO
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Turno_Atribuido]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Turno_Atribuido]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Cantina.TURNO_ATRIBUIDO
END

GO
/****** Object:  StoredProcedure [dbo].[Select_Vendas]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================



CREATE PROCEDURE [dbo].[Select_Vendas] @pagVendas int



AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	Declare @Vendas AS int;
	SET @Vendas = @pagVendas;
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT ref_fatura, Datahora, Nif, cliente.Fname AS cfname, cliente.Lname AS clname, cliente.email, tipo_cliente.nome, funcionario.fname AS ffname, funcionario.lname AS flname FROM Cantina.Compra INNER JOIN cantina.cliente ON cantina.Compra.cnif = cantina.cliente.nif INNER JOIN cantina.tipo_cliente ON cantina.cliente.tipo = cantina.tipo_cliente.id INNER JOIN cantina.funcionario ON cantina.compra.Fid = cantina.funcionario.Id ORDER BY datahora DESC OFFSET @Vendas * 20 ROWS FETCH NEXT 20 ROWS ONLY;
END

GO
/****** Object:  StoredProcedure [dbo].[Submit_Cliente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Submit_Cliente] @Nif int, @Fname varchar(32), @Lname varchar(32), @Tipo int, @Email varchar(76)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
INSERT Cantina.CLIENTE (Nif, Fname, Lname, Tipo, Email) VALUES (@Nif, @Fname, @Lname, @Tipo, @Email) 
END

GO
/****** Object:  StoredProcedure [dbo].[Submit_Dispensa]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Submit_Dispensa] 
	-- Add the parameters for the stored procedure here
	@Id int = 0,
	@Capacidade decimal(15,2)
	--@capacity decimal(15,2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT Cantina.Dispensa (Id, Capacidade) VALUES (@Id, @Capacidade)
END

GO
/****** Object:  StoredProcedure [dbo].[Submit_Funcionario]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Submit_Funcionario] @Fname varchar(32), @Lname varchar(32), @Salario decimal(10,2), @Email varchar(76), @Ccodigo varchar(76),
@string VARCHAR(500)


AS
	SET NOCOUNT ON;
	DECLARE @i VARCHAR(64);
	DECLARE @i2 VARCHAR(64);
	DECLARE @Id int;
	DECLARE @tableID table(Id int);
	
	BEGIN TRANSACTION [tran]
	BEGIN TRY
    -- Insert statements for procedure here
	INSERT Cantina.FUNCIONARIO (Fname, Lname, Salario, Email, Ccodigo) OUTPUT INSERTED.Id INTO @tableID  VALUES (@Fname, @Lname, @Salario, @Email, @Ccodigo);
	SELECT @Id = Id FROM @tableID

	SELECT * INTO #temp FROM STRING_SPLIT(@string, ',') WHERE RTRIM(value) <> ''
	WHILE EXISTS (SELECT * FROM #temp)
	BEGIN
		SELECT Top 1 @i = value FROM #temp
		DELETE #temp WHERE value = @i

		SELECT Top 1 @i2 = value FROM #temp
		DELETE #temp WHERE value = @i2

		INSERT Cantina.TURNO_ATRIBUIDO (Fid, Datahora_inicio, Datahora_fim) VALUES (@Id, @i, @i2);
	END
	COMMIT TRANSACTION [tran]
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION [tran]
	END CATCH


GO
/****** Object:  StoredProcedure [dbo].[Submit_Ingrediente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Submit_Ingrediente] @Nome varchar(76), @Quantidade_disponivel decimal(10,2), @Valor_nutritivo decimal(10,2), @Did int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
INSERT Cantina.INGREDIENTE (Nome, Quantidade_disponivel, Valor_nutritivo, Did) VALUES (@Nome, @Quantidade_disponivel, @Valor_nutritivo, @Did)
END

GO
/****** Object:  StoredProcedure [dbo].[Submit_Turno_Atribuido]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Submit_Turno_Atribuido] @Datahora_inicio  varchar(64), @Datahora_fim varchar(64), @Fid int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	INSERT Cantina.TURNO_ATRIBUIDO (Datahora_inicio, Datahora_fim, Fid) VALUES (@Datahora_inicio, @Datahora_fim, @Fid)


END


GO
/****** Object:  StoredProcedure [dbo].[Update_Cliente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Update_Cliente] @Nif int, @Fname varchar(32), @Lname varchar(32), @Tipo int, @Email varchar(76)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
UPDATE Cantina.CLIENTE SET Lname = @Lname, Fname = @Fname, Tipo = @Tipo, Email = @Email WHERE Nif = @Nif
END

GO
/****** Object:  StoredProcedure [dbo].[Update_Dispensa]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Update_Dispensa] 
	-- Add the parameters for the stored procedure here
	@Id int = 0,
	@Capacidade decimal(15,2)
	--@capacity decimal(15,2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE Cantina.Dispensa SET Capacidade = @Capacidade WHERE Id = @Id
END

GO
/****** Object:  StoredProcedure [dbo].[Update_Dispensa_Capacidade]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Update_Dispensa_Capacidade] 
	-- Add the parameters for the stored procedure here
	@id int = 0,
	@capacity decimal(15,2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE Cantina.DISPENSA SET CapacidadeAtual = @capacity WHERE Id = @id
END

GO
/****** Object:  StoredProcedure [dbo].[Update_Funcionario]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Update_Funcionario] @Id int, @Fname varchar(32), @Lname varchar(32), @Salario decimal(10,2), @Email varchar(76), @Ccodigo varchar(76)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
UPDATE Cantina.FUNCIONARIO SET Lname = @Lname, Fname = @Fname,  Salario = @Salario, Ccodigo = @Ccodigo, Email = @Email WHERE Id = @Id
END

GO
/****** Object:  StoredProcedure [dbo].[Update_Ingrediente]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Update_Ingrediente] @Nome varchar(76), @Quantidade_disponivel decimal(10,2), @Valor_nutritivo decimal(10,2), @Did int, @Id int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
UPDATE Cantina.INGREDIENTE SET Nome = @Nome, Valor_nutritivo = @Valor_nutritivo, Quantidade_disponivel = @Quantidade_disponivel, Did=@Did WHERE Id = @Id
END

GO
/****** Object:  StoredProcedure [dbo].[Update_Ingrediente_Quantidade]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Update_Ingrediente_Quantidade] 
	-- Add the parameters for the stored procedure here
	@Id int = 0,
	@QuantidadeOutput decimal(10,2)
	--@Capacidade decimal(15,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE Cantina.INGREDIENTE SET Quantidade_disponivel = @QuantidadeOutput  WHERE Id = @Id
END

GO
/****** Object:  StoredProcedure [dbo].[Update_Prato]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alcatrao
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Update_Prato] 
	-- Add the parameters for the stored procedure here
@Id int, @Nome varchar(76), @Tipo varchar(76)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
UPDATE Cantina.PRATO SET Nome=@Nome, Tipo=@Tipo WHERE Id=@Id
END


GO
/****** Object:  Trigger [Company].[triggerDepartmentDeleted]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--h)
CREATE TRIGGER [Company].[triggerDepartmentDeleted] ON [Company].[DEPARTMENT]
INSTEAD OF DELETE
AS
BEGIN

	IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'COMPANY' AND TABLE_NAME = 'DEPARTMENT_DELETED'))
		BEGIN
			CREATE TABLE Company.DEPARTMENT_DELETED (Dname varchar(15) NOT NULL, Dnumber int PRIMARY KEY, Mgr_ssn char(9), Mgr_start_date date);
		END

	DELETE FROM Company.PROJECT WHERE Dnum in (SELECT Dnumber FROM deleted);
	UPDATE Company.EMPLOYEE SET Dno=NULL WHERE DNO IN (SELECT Dnumber FROM deleted);
	INSERT INTO Company.DEPARTMENT_DELETED SELECT * FROM DELETED;
	DELETE FROM Company.DEPARTMENT WHERE Dnumber IN (SELECT Dnumber FROM deleted);

END
GO
ALTER TABLE [Company].[DEPARTMENT] ENABLE TRIGGER [triggerDepartmentDeleted]
GO
/****** Object:  Trigger [Company].[triggerFuncGestor]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--c)
CREATE TRIGGER [Company].[triggerFuncGestor] ON [Company].[DEPARTMENT]
AFTER INSERT, UPDATE
AS
BEGIN
	
	DECLARE @Ssn as DECIMAL(9,0);
	SELECT @Ssn=Mgr_ssn FROM inserted;
	IF EXISTS(SELECT Mgr_ssn FROM Company.DEPARTMENT WHERE Mgr_ssn=@Ssn)
	BEGIN
		ROLLBACK TRAN;
		RAISERROR('Um funcionário pode ser gestor de, no máximo, 1 departamento', 16, 1);
	END
END
GO
ALTER TABLE [Company].[DEPARTMENT] ENABLE TRIGGER [triggerFuncGestor]
GO
/****** Object:  Trigger [Company].[triggerSalarioLimite]    Script Date: 2020-06-12 23:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--d)
CREATE TRIGGER [Company].[triggerSalarioLimite] ON [Company].[EMPLOYEE]
INSTEAD OF INSERT, UPDATE
AS
BEGIN
	DECLARE @Salary as decimal(10,2);
	DECLARE @ESalary as decimal(10,2) = NULL;
	DECLARE @updated as int;

	SELECT @Salary=Salary FROM inserted;
	SELECT @updated=COUNT(*) FROM deleted;
	SELECT @ESalary=Employee.Salary FROM inserted JOIN Company.DEPARTMENT ON inserted.Dno=Dnumber JOIN Company.EMPLOYEE ON Mgr_ssn=Employee.Ssn WHERE Employee.Salary<@Salary;

	if(@updated = 0)
	BEGIN
		if (@ESalary = NULL)
		BEGIN
			INSERT INTO Company.EMPLOYEE
			SELECT *
			FROM inserted;
		END
		ELSE
		BEGIN
			INSERT INTO Company.EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, [Address], Sex, Salary, Super_ssn, Dno) SELECT Fname, Minit, Lname, Ssn, Bdate, [Address], Sex, @ESalary-1, Super_ssn, Dno FROM inserted;
		END
	END
	ELSE
	BEGIN
		if (@ESalary = NULL)
		BEGIN
			UPDATE Company.EMPLOYEE
			SET Fname=inserted.Fname, Minit=inserted.Minit, Lname=inserted.Lname, Ssn=inserted.Ssn, Bdate=inserted.Bdate, [Address]=inserted.[Address], Sex=inserted.Sex, Salary=inserted.Salary, Super_ssn=inserted.Super_ssn, Dno=inserted.Dno FROM deleted JOIN inserted ON deleted.Ssn=inserted.Ssn;
		END
		ELSE
		BEGIN
			UPDATE Company.EMPLOYEE
			SET Fname=inserted.Fname, Minit=inserted.Minit, Lname=inserted.Lname, Ssn=inserted.Ssn, Bdate=inserted.Bdate, [Address]=inserted.[Address], Sex=inserted.Sex, Salary=@ESalary-1, Super_ssn=inserted.Super_ssn, Dno=inserted.Dno FROM deleted JOIN inserted ON deleted.Ssn=inserted.Ssn;
		END
	END
END
GO
ALTER TABLE [Company].[EMPLOYEE] ENABLE TRIGGER [triggerSalarioLimite]
GO
USE [master]
GO
ALTER DATABASE [p2g8] SET  READ_WRITE 
GO
