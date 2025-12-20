USE ladycake
GO

--------------------------------------------------------------------------------
-- 01_tabela_medidas
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_medidas', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_medidas
		(
			id_medida			int identity(1, 1),
			nm_peso				varchar(10) not null,
			nm_tamanho_forma	varchar(12) not null,
			nr_fatias_100g		tinyint not null,
			vl_preco			numeric(19,2) not null,
			CONSTRAINT			pk_tabela_medidas$id_medida
			PRIMARY KEY			(id_medida)
		) ON dados
END
