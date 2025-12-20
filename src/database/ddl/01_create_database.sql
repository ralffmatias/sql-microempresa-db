/* 
========================================================
 Script: 01_create_database.sql
 Projeto: LadyCake
 Descrição:
   - Criação do banco de dados do zero
   - Separação de filegroups para dados e índices
   - Tamanhos iniciais realistas e crescimento controlado
========================================================
*/

USE master
GO

--------------------------------------------------------
-- Derruba o banco se existir (ambiente de estudo/dev)
--------------------------------------------------------
IF DB_ID('ladycake') IS NOT NULL
BEGIN
    ALTER DATABASE ladycake 
        SET SINGLE_USER 
        WITH ROLLBACK IMMEDIATE

    DROP DATABASE ladycake
END
GO

DECLARE 
    @DataPath NVARCHAR(260),
    @LogPath  NVARCHAR(260),
    @sql      NVARCHAR(MAX)

--------------------------------------------------------
-- Obtém o caminho padrão da instância.
-- Caso deseje, este valor pode ser sobrescrito por um caminho manual.
--------------------------------------------------------
SELECT
    @DataPath = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(260)),
    @LogPath  = CAST(SERVERPROPERTY('InstanceDefaultLogPath')  AS NVARCHAR(260)) 

--------------------------------------------------------
-- Criação do banco
--------------------------------------------------------
IF @DataPath IS NOT NULL
BEGIN
	set @sql = N'
	CREATE DATABASE ladycake
	ON PRIMARY
		(
			NAME = ''ladycake_primary'',
			FILENAME = ''' + @DataPath + 'ladycake_primary.ndf'',
			SIZE = 512MB,
			FILEGROWTH = 128MB
		),

		FILEGROUP dados
		(
			NAME = ''ladycake_dados_01'',              
			FILENAME = ''' + @DataPath + 'ladycake_dados_01.ndf'', 
			SIZE = 1024MB,
			FILEGROWTH = 256MB
		),

		FILEGROUP indices
		(
			NAME = ''ladycake_indices_01'',
			FILENAME = ''' + @DataPath + 'ladycake_indices_01.ndf'',  
			SIZE = 512MB,
			FILEGROWTH = 128MB
		)

		LOG ON
		(
			NAME = ''ladycake_log'',
			FILENAME = ''' + isnull(@LogPath, @DataPath) + 'ladycake_log.ldf'', 
			SIZE = 512MB,
			FILEGROWTH = 128MB
		)'

	EXEC sys.sp_executesql @sql 

	--------------------------------------------------------
	-- Define filegroup de dados como padrão
	--------------------------------------------------------
	ALTER DATABASE ladycake 
		MODIFY FILEGROUP dados DEFAULT

	--------------------------------------------------------
	-- Configura comportamento padrão de estatísticas
	-- (boa prática para o otimizador de consultas)
	--------------------------------------------------------
	ALTER DATABASE ladycake 
		SET AUTO_CREATE_STATISTICS ON

	ALTER DATABASE ladycake 
		SET AUTO_UPDATE_STATISTICS ON
END
ELSE BEGIN

	RAISERROR('InstanceDefaultDataPath não configurado.', 16, 1)

    RETURN
END

/*
OBSERVAÇÕES IMPORTANTES:

1. Índices NÃO vão automaticamente para o filegroup 'indices'
   se você não especificar isso no CREATE INDEX.
   Exemplo correto:
   
   CREATE NONCLUSTERED INDEX IX_Tabela_Campo
   ON dbo.Tabela (Campo)
   WITH (FILLFACTOR = 90)
   ON indices

2. Este script é para:
   - Ambiente local
   - Estudo
   - Portfólio
   NÃO usar em produção sem revisão.

*/
