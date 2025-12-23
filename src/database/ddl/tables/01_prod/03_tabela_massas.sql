USE ladycake
GO

--------------------------------------------------------------------------------
-- 03_tabela_massas
--------------------------------------------------------------------------------
IF object_id(N'prod.tabela_massas', N'U') is null
BEGIN
	CREATE TABLE prod.tabela_massas
		(
			id_massa		tinyint identity(1,1),
			nm_massa		varchar(20) unique not null,
			dv_ativo		bit not null default 1,
			dt_inclusao		datetime not null default getdate(),
			dt_alteracao	datetime,
			CONSTRAINT	pk_tabela_massas$id_massa 
			PRIMARY KEY (id_massa)
		) ON dados
END
