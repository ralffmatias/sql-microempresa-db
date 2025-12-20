USE ladycake
GO

--------------------------------------------------------------------------------
-- 03_tabela_massas
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_massas', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_massas
		(
			id_massa	tinyint identity(1,1),
			nm_massa	varchar(20) not null,
			CONSTRAINT	pk_tabela_massas$id_massa 
			PRIMARY KEY (id_massa)
		) ON dados
END
