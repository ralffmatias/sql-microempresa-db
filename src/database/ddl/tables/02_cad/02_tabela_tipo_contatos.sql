USE ladycake
GO

--------------------------------------------------------------------------------
-- 02_tabela_tipo_contatos
--------------------------------------------------------------------------------
IF object_id(N'cad.tabela_tipo_contatos', N'U') is null
BEGIN
	CREATE TABLE cad.tabela_tipo_contatos
		(
			id_tipo_contato		smallint identity(1,1),
			cd_tipo_contato		char(3) unique not null,
			nm_tipo_contato		varchar(50) not null,
			dv_ativo			bit not null default 1,
			dt_inclusao			datetime not null default getdate(),
			dt_alteracao		datetime,

			CONSTRAINT pk_tabela_tipo_contatos$id_tipo_contato
			PRIMARY KEY (id_tipo_contato),

			CONSTRAINT CK_tabela_tipo_contatos$nm_tipo_contato
			CHECK (LEN(LTRIM(RTRIM(nm_tipo_contato))) >= 3),

			CONSTRAINT CK_tabela_tipo_contatos$cd_tipo_contato
			CHECK (cd_tipo_contato LIKE '[A-Z][A-Z][A-Z]')
		) ON dados

	-- Tipos de contato
	INSERT INTO cad.tabela_tipo_contatos (cd_tipo_contato, nm_tipo_contato, dv_ativo, dt_inclusao)
	VALUES
		('MAI', 'E-mail', 1, GETDATE()),
		('CEL', 'Celular', 1, GETDATE()),
		('TEL', 'Telefone fixo', 1, GETDATE()),
		('WTP', 'WhatsApp', 1, GETDATE())
END