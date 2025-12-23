USE ladycake
GO

--------------------------------------------------------------------------------
-- 05_tabela_pessoas_enderecos
--------------------------------------------------------------------------------
IF object_id(N'cad.tabela_pessoas_enderecos', N'U') is null
BEGIN
	CREATE TABLE cad.tabela_pessoas_enderecos
		(
			id_pessoas_endereco		int identity(1,1),
			id_pessoa				int not null,
			id_tipo_endereco		smallint not null,
			dv_ativo				bit not null default 1,
			dv_principal			bit not null,
			nr_cep					char(8),
			nm_logradouro			varchar(150),
			nr_endereco				varchar(10) not null,
			nm_complemento			varchar(150),
			nm_bairro				varchar(100) not null,
			nm_cidade				varchar(100)not null,
			nm_uf					char(2)not null,
			dt_inclusao				datetime not null default getdate(),
			dt_alteracao			datetime,

			CONSTRAINT pk_tabela_pessoas_enderecos$id_pessoas_endereco
			PRIMARY KEY (id_pessoas_endereco),

			CONSTRAINT fk_tabela_pessoas_enderecos_X_tabela_pessoas$id_pessoa
			FOREIGN KEY (id_pessoa) REFERENCES cad.tabela_pessoas(id_pessoa),

			CONSTRAINT fk_tabela_pessoas_enderecos_X_tabela_tipo_enderecos$id_tipo_endereco
			FOREIGN KEY (id_tipo_endereco) REFERENCES cad.tabela_tipo_enderecos(id_tipo_endereco),

			CONSTRAINT CK_tabela_pessoas_enderecos$nm_logradouro
			CHECK	(
						nm_logradouro IS NULL
						OR LEN(LTRIM(RTRIM(nm_logradouro))) >= 3
					),
			
			CONSTRAINT CK_tabela_pessoas_enderecos$nm_bairro
			CHECK	(
						nm_bairro IS NULL
						OR LEN(LTRIM(RTRIM(nm_bairro))) >= 2
					),

			CONSTRAINT CK_tabela_pessoas_enderecos$nm_cidade
			CHECK	(
						nm_cidade IS NULL
						OR LEN(LTRIM(RTRIM(nm_cidade))) >= 2
					),

			CONSTRAINT CK_tabela_pessoas_enderecos$nr_cep
			CHECK (nr_cep IS NULL OR nr_cep LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),

			CONSTRAINT CK_tabela_pessoas_enderecos$nm_uf
			CHECK (nm_uf IN (
								'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT',
								'MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO',
								'RR','SC','SP','SE','TO'
							 ))
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'UX_tabela_pessoas_enderecos$id_pessoa_X_dv_principal')
	BEGIN
		CREATE UNIQUE INDEX UX_tabela_pessoas_enderecos$id_pessoa_X_dv_principal
		ON cad.tabela_pessoas_enderecos(id_pessoa)
		WHERE dv_principal = 1;
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: UX_tabela_pessoas_enderecos$id_pessoa_X_dv_principal'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pessoas_enderecos$id_pessoa')
	BEGIN
		CREATE nonclustered INDEX Idx_tabela_pessoas_enderecos$id_pessoa		
		ON cad.tabela_pessoas_enderecos(id_pessoa) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pessoas_enderecos$id_pessoa'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pessoas_enderecos$id_tipo_endereco')
	BEGIN
		CREATE nonclustered INDEX Idx_tabela_pessoas_enderecos$id_tipo_endereco		
		ON cad.tabela_pessoas_enderecos(id_tipo_endereco) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pessoas_enderecos$id_tipo_endereco'
	END
END
