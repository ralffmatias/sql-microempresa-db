USE ladycake
GO

--------------------------------------------------------------------------------
-- 07_tabela_pessoas_papeis
--------------------------------------------------------------------------------
IF object_id(N'cad.tabela_pessoas_papeis', N'U') is null
BEGIN
	CREATE TABLE cad.tabela_pessoas_papeis
		(
			id_pessoa_papel	smallint identity(1,1),
			id_pessoa		int not null,
			id_papel		smallint not null,
			dv_ativo		bit not null default 1,
			dt_inclusao		datetime not null default getdate(),
			dt_alteracao	datetime,

			CONSTRAINT pk_tabela_pessoas_papeis$id_pessoa_papel
			PRIMARY KEY (id_pessoa_papel),

			CONSTRAINT fk_tabela_pessoas_papeis_X_tabela_pessoas$id_pessoa
			FOREIGN KEY (id_pessoa) REFERENCES cad.tabela_pessoas(id_pessoa),

			CONSTRAINT fk_tabela_pessoas_papeis_X_tabela_papeis$id_papel
			FOREIGN KEY (id_papel) REFERENCES cad.tabela_papeis(id_papel)
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'UX_tabela_pessoas_papeis$id_pessoa_X_id_papel')
	BEGIN
		CREATE UNIQUE INDEX UX_tabela_pessoas_papeis$id_pessoa_X_id_papel
		ON cad.tabela_pessoas_papeis(id_pessoa, id_papel)
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: UX_tabela_pessoas_papeis$id_pessoa_X_id_papel'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pessoas_papeis$id_pessoa')
	BEGIN
		CREATE nonclustered INDEX Idx_tabela_pessoas_papeis$id_pessoa		
		ON cad.tabela_pessoas_papeis(id_pessoa) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pessoas_papeis$id_pessoa'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pessoas_papeis$id_papel')
	BEGIN
		CREATE nonclustered INDEX Idx_tabela_pessoas_papeis$id_papel	
		ON cad.tabela_pessoas_papeis(id_papel) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pessoas_papeis$id_papel'
	END
END
