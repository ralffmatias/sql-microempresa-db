USE ladycake
GO

--------------------------------------------------------------------------------
-- 04_tabela_tipo_enderecos
--------------------------------------------------------------------------------
IF object_id(N'cad.tabela_tipo_enderecos', N'U') is null
BEGIN
	CREATE TABLE cad.tabela_tipo_enderecos
		(
			id_tipo_endereco	smallint identity(1,1),
			cd_tipo_endereco	char(3) unique not null,
			nm_tipo_endereco	varchar(50) not null,
			dv_ativo			bit not null default 1,
			dt_inclusao			datetime not null default getdate(),
			dt_alteracao		datetime,

			CONSTRAINT pk_tabela_tipo_enderecos$id_tipo_endereco
			PRIMARY KEY (id_tipo_endereco),

			CONSTRAINT CK_tabela_tipo_enderecos$nm_tipo_endereco
			CHECK (LEN(LTRIM(RTRIM(nm_tipo_endereco))) >= 3),

			CONSTRAINT CK_tabela_tipo_enderecos$cd_tipo_endereco
			CHECK (cd_tipo_endereco LIKE '[A-Z][A-Z][A-Z]')
		) ON dados

	-- Tipos de endereço
	INSERT INTO cad.tabela_tipo_enderecos (cd_tipo_endereco, nm_tipo_endereco, dv_ativo, dt_inclusao)
	VALUES
		('RES', 'Residencial', 1, GETDATE()),
		('COM', 'Comercial', 1, GETDATE()),
		('ENT', 'Entrega', 1, GETDATE()),
		('COB', 'Cobrança', 1, GETDATE())
END
