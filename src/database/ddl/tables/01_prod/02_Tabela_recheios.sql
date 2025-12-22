USE ladycake
GO

--------------------------------------------------------------------------------
-- 02_Tabela_recheios
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_recheios', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_recheios
		(
			id_recheio		tinyint identity(1,1),
			nm_recheio		varchar(50) not null,
			dv_especial		bit default 0,
			vl_especial		numeric(19,2) default 0.00,
			dv_ativo		bit default 1,
			CONSTRAINT		pk_tabela_recheios$id_recheio 
			PRIMARY KEY		(id_recheio)
		) ON dados
END
