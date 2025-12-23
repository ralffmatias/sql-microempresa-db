USE ladycake
GO

--------------------------------------------------------------------------------
-- 04_tabela_adicionais
--------------------------------------------------------------------------------
IF object_id(N'prod.tabela_adicionais', N'U') is null
BEGIN
	CREATE TABLE prod.tabela_adicionais
		(
			id_adicional	int identity(1,1),
			nm_adicional	varchar(50) unique not null,
			vl_adicional	numeric(19,2) not null default 0.00,
			dv_ativo		bit not null default 1,
			dt_inclusao		datetime not null default getdate(),
			dt_alteracao	datetime,

			CONSTRAINT	pk_tabela_adicionais$id_adicional 
			PRIMARY KEY (id_adicional),

			CONSTRAINT CK_tabela_adicionais$vl_adicional
			CHECK (vl_adicional >= 0)
		) ON dados
END
