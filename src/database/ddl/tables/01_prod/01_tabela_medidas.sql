USE ladycake
GO

--------------------------------------------------------------------------------
-- 01_tabela_medidas
--------------------------------------------------------------------------------
IF object_id(N'prod.tabela_medidas', N'U') is null
BEGIN
	CREATE TABLE prod.tabela_medidas
		(
			id_medida			int identity(1, 1),
			nm_peso				varchar(10) unique not null,
			nm_tamanho_forma	varchar(12) unique not null,
			nr_fatias_100g		tinyint,
			vl_preco			numeric(19,2) not null,
			dv_ativo			bit not null default 1,
			dt_inclusao			datetime not null default getdate(),
			dt_alteracao		datetime,

			CONSTRAINT pk_tabela_medidas$id_medida
			PRIMARY KEY (id_medida),

			CONSTRAINT CK_tabela_medidas$vl_preco
			CHECK (vl_preco > 0),

			CONSTRAINT CK_tabela_medidas$nr_fatias_100g
			CHECK (nr_fatias_100g > 0)
		) ON dados
END
