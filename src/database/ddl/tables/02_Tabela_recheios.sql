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
			dv_especial		bit,
			vl_especial		numeric(19,2),
			CONSTRAINT		pk_tabela_recheios$id_recheio 
			PRIMARY KEY		(id_recheio)
		) ON dados

	CREATE  nonclustered INDEX Idx_tabela_recheios$id_recheio		
	ON dbo.tabela_recheios(id_recheio) WITH(FILLFACTOR= 80) ON indices
END
