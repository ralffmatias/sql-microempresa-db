USE ladycake
GO

--------------------------------------------------------------------------------
-- 02_Tabela_recheios
--------------------------------------------------------------------------------
IF object_id(N'prod.tabela_recheios', N'U') is null
BEGIN
	CREATE TABLE prod.tabela_recheios
		(
			id_recheio		tinyint identity(1,1),
			nm_recheio		varchar(50) unique not null,
			dv_especial		bit not null default 0,
			vl_especial		numeric(19,2) not null default 0.00,
			dv_ativo		bit not null default 1,
			dt_inclusao		datetime not null default getdate(),
			dt_alteracao	datetime,

			CONSTRAINT pk_tabela_recheios$id_recheio 
			PRIMARY KEY (id_recheio),

			CONSTRAINT CK_tabela_recheios$vl_especial
			CHECK (vl_especial >= 0)
		) ON dados
END
