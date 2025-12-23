USE ladycake
GO

--------------------------------------------------------------------------------
-- 06_tabela_papeis
--------------------------------------------------------------------------------
IF object_id(N'cad.tabela_papeis', N'U') is null
BEGIN
	CREATE TABLE cad.tabela_papeis
		(
			id_papel		smallint identity(1,1),
			cd_papel		char(1) unique not null,
			nm_papel		varchar(20) not null,
			dv_ativo		bit not null default 1,
			dt_inclusao		datetime not null default getdate(),
			dt_alteracao	datetime,
			CONSTRAINT pk_tabela_papeis$id_papel
			PRIMARY KEY (id_papel)
		) ON dados
END
