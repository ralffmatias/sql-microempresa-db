USE ladycake;
GO

--------------------------------------------------------------------------------
-- 06_tabela_adicionais
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_adicionais', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_adicionais
	(
		id_adicional int identity(1,1),
		nm_adicional varchar(50) not null,
		vl_adicional numeric(19,2) default 0,
		CONSTRAINT	pk_tabela_adicionais$id_adicional 
		PRIMARY		KEY (id_adicional)
	) ON dados
END
