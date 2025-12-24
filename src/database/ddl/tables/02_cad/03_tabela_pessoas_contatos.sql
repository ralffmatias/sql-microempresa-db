USE ladycake
GO

--------------------------------------------------------------------------------
-- 03_tabela_pessoas_contatos
--------------------------------------------------------------------------------
IF object_id(N'cad.tabela_pessoas_contatos', N'U') is null
BEGIN
	CREATE TABLE cad.tabela_pessoas_contatos
		(
			id_pessoas_contato		int identity(1,1),
			id_pessoa				int not null,
			nm_descricao			varchar(200),
			id_tipo_contato			smallint not null,
			dv_ativo				bit not null default 1,
			dv_principal			bit not null,
			nm_ddd					char(2),
			nm_celular				char(9),
			nm_email				varchar(150),
			dt_inclusao				datetime not null default getdate(),
			dt_alteracao			datetime,

			CONSTRAINT pk_tabela_pessoas_contatos$id_pessoas_contato
			PRIMARY KEY (id_pessoas_contato),

			CONSTRAINT fk_tabela_pessoas_contatos_X_tabela_pessoas$id_pessoa
			FOREIGN KEY (id_pessoa) REFERENCES cad.tabela_pessoas(id_pessoa),

			CONSTRAINT fk_tabela_pessoas_contatos_X_tabela_tipo_contatos$id_tipo_contato
			FOREIGN KEY (id_tipo_contato) REFERENCES cad.tabela_tipo_contatos(id_tipo_contato),

			CONSTRAINT CK_tabela_pessoas_contatos$nm_email_X_nm_ddd_X_nm_celular
			CHECK	(
						(nm_email IS NOT NULL AND LEN(LTRIM(RTRIM(nm_email))) > 0)
						OR (nm_ddd IS NOT NULL AND nm_celular IS NOT NULL
						AND nm_ddd LIKE '[1-9][0-9]'
						AND nm_celular LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
					)
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'UX_tabela_pessoas_contatos$id_pessoa_X_dv_principal')
	BEGIN
		CREATE UNIQUE INDEX UX_tabela_pessoas_contatos$id_pessoa_X_dv_principal
		ON cad.tabela_pessoas_contatos(id_pessoa)
		WHERE dv_principal = 1;
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: UX_tabela_pessoas_contatos$id_pessoa_X_dv_principal'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'UX_tabela_pessoas_contatos$id_pessoa_X_nm_email')
	BEGIN
		CREATE UNIQUE INDEX UX_tabela_pessoas_contatos$id_pessoa_X_nm_email
		ON cad.tabela_pessoas_contatos(id_pessoa, nm_email)
		WHERE nm_email IS NOT NULL
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: UX_tabela_pessoas_contatos$id_pessoa_X_nm_email'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pessoas_contatos$id_pessoa')
	BEGIN
		CREATE nonclustered INDEX Idx_tabela_pessoas_contatos$id_pessoa		
		ON cad.tabela_pessoas_contatos(id_pessoa) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pessoas_contatos$id_pessoa'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pessoas_contatos$id_tipo_contato')
	BEGIN
		CREATE nonclustered INDEX Idx_tabela_pessoas_contatos$id_tipo_contato		
		ON cad.tabela_pessoas_contatos(id_tipo_contato) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pessoas_contatos$id_tipo_contato'
	END
END
