USE ladycake
GO

--------------------------------------------------------------------------------
-- 01_tabela_pessoas
--------------------------------------------------------------------------------
IF object_id(N'cad.tabela_pessoas', N'U') is null
BEGIN
	CREATE TABLE cad.tabela_pessoas
		(
			id_pessoa				int identity(1,1),
			nr_cpf_cnpj				varchar(14) unique,
			nm_pessoa				varchar(150) not null,
			nm_pessoa_fantasia		varchar(150),
			cd_tipo_pessoa			char(1) not null default 'F',
			dt_nascimento			date,
			dv_ativo				bit default 1,
			dt_inclusao				datetime not null  default getdate(),
			id_usuario_inclusao		int,
			dt_alteracao			datetime,
			id_usuario_alteracao	int,

			CONSTRAINT pk_tabela_pessoas$id_pessoa
			PRIMARY KEY (id_pessoa),

			CONSTRAINT CK_tabela_pessoas$nm_pessoa
			CHECK (LEN(LTRIM(RTRIM(nm_pessoa))) > 0),

			CONSTRAINT CK_tabela_pessoas$cd_tipo_pessoa
			CHECK (cd_tipo_pessoa IN('F', 'J')),

			CONSTRAINT CK_tabela_pessoas$nr_cpf_cnpj
			CHECK	(
						nr_cpf_cnpj is null 
						OR (
								(cd_tipo_pessoa = 'F' AND LEN(nr_cpf_cnpj) = 11)
								OR (cd_tipo_pessoa = 'J' AND LEN(nr_cpf_cnpj) = 14)
							)
					)
		) ON dados
END
