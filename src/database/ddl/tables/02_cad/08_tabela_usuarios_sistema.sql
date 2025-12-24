USE ladycake
GO

--------------------------------------------------------------------------------
-- 08_tabela_usuarios_sistema
--------------------------------------------------------------------------------
IF object_id(N'cad.tabela_usuarios_sistema', N'U') IS NULL
BEGIN
	CREATE TABLE cad.tabela_usuarios_sistema
	(
		id_usuario_sistema		int identity(1,1),
		id_pessoa				int not null,
		id_pessoa_papel			int not null, -- papel = Usuário do sistema
		cd_usuario				varchar(50) not null unique,
		dv_ativo				bit not null default 1,
		dt_ultimo_acesso		datetime,
		dt_inclusao				datetime not null default getdate(),
		id_usuario_inclusao		int,
		dt_alteracao			datetime,
		id_usuario_alteracao	int,

		CONSTRAINT pk_tabela_usuarios_sistema$id_usuario_sistema
		PRIMARY KEY (id_usuario_sistema),

		CONSTRAINT fk_tabela_usuarios_sistema_X_tabela_pessoas$id_pessoa
		FOREIGN KEY (id_pessoa) REFERENCES cad.tabela_pessoas(id_pessoa),

		CONSTRAINT fk_tabela_usuarios_sistema_X_tabela_pessoas_papeis$id_pessoa_papel
		FOREIGN KEY (id_pessoa_papel) REFERENCES cad.tabela_pessoas_papeis(id_pessoa_papel),

		CONSTRAINT fk_tabela_usuarios_sistema_X_tabela_usuarios_sistema$id_usuario_inclusao_X_id_usuario_sistema
		FOREIGN KEY (id_usuario_inclusao) REFERENCES cad.tabela_usuarios_sistema(id_usuario_sistema),

		CONSTRAINT fk_tabela_usuarios_sistema_X_tabela_usuarios_sistema$id_usuario_alteracao_X_id_usuario_sistema
		FOREIGN KEY (id_usuario_alteracao) REFERENCES cad.tabela_usuarios_sistema(id_usuario_sistema),

		CONSTRAINT CK_tabela_usuarios_sistema$cd_usuario
		CHECK (
				LEN(LTRIM(RTRIM(cd_usuario))) >= 3
				AND cd_usuario NOT LIKE '% %'
			  )
	) ON dados


	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'Idx_tabela_usuarios_sistema$id_pessoa')
	BEGIN
		CREATE NONCLUSTERED INDEX Idx_tabela_usuarios_sistema$id_pessoa
		ON cad.tabela_usuarios_sistema(id_pessoa)
		WITH (FILLFACTOR = 80) ON indices
	END

	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'Idx_tabela_usuarios_sistema$id_pessoa_papel')
	BEGIN
		CREATE NONCLUSTERED INDEX Idx_tabela_usuarios_sistema$id_pessoa_papel
		ON cad.tabela_usuarios_sistema(id_pessoa_papel)
		WITH (FILLFACTOR = 80) ON indices
	END
END
GO

--Adicionar FK id_usuario_inclusao na tabela tabela_pessoas do tipo nullable
IF NOT EXISTS	(
					SELECT top 1 1
					FROM sys.foreign_keys
					WHERE name = 'Fk_tabela_pessoas_X_tabela_usuarios_sistema$id_usuario_inclusao_X_id_usuario_sistema'
				)
BEGIN
	ALTER TABLE cad.tabela_pessoas
	ADD CONSTRAINT Fk_tabela_pessoas_X_tabela_usuarios_sistema$id_usuario_inclusao_X_id_usuario_sistema
	FOREIGN KEY (id_usuario_inclusao)
	REFERENCES cad.tabela_usuarios_sistema(id_usuario_sistema)
END
GO

--Adicionar FK id_usuario_alteracao na tabela tabela_pessoas do tipo nullable
IF NOT EXISTS	(
					SELECT top 1 1
					FROM sys.foreign_keys
					WHERE name = 'Fk_tabela_pessoas_X_tabela_usuarios_sistema$id_usuario_alteracao_X_id_usuario_sistema'
				)
BEGIN
	ALTER TABLE cad.tabela_pessoas
	ADD CONSTRAINT Fk_tabela_pessoas_X_tabela_usuarios_sistema$id_usuario_alteracao_X_id_usuario_sistema
	FOREIGN KEY (id_usuario_alteracao)
	REFERENCES cad.tabela_usuarios_sistema(id_usuario_sistema)
END
GO