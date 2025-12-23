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
			PRIMARY KEY (id_papel),			

			CONSTRAINT CK_tabela_papeis$cd_papel
			CHECK (cd_papel LIKE '[A-Z]')
		) ON dados

	-- Papeis
	INSERT INTO cad.tabela_papeis (cd_papel, nm_papel, dv_ativo, dt_inclusao)
	VALUES
		('C', 'Cliente', 1, GETDATE()),
		('F', 'Fornecedor', 1, GETDATE()),
		('U', 'Usuário do sistema', 1, GETDATE()),
		('A', 'Administrador', 1, GETDATE()),
		('E', 'Funcionário', 1, GETDATE())
END
