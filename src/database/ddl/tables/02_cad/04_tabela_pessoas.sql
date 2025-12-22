USE ladycake
GO

--------------------------------------------------------------------------------
-- 04_tabela_pessoas
--------------------------------------------------------------------------------
IF object_id(N'cad.tabela_pessoas', N'U') is null
BEGIN
	CREATE TABLE cad.tabela_pessoas
		(
			id_pessoa		int identity(1,1),
			nm_pessoa		varchar(150) not null,
			nm_cpf_cnpj		varchar(14),
			nm_endereco		varchar(150),
			nm_ddd			char(2),
			nm_celular		char(9),
			CONSTRAINT		pk_tabela_pessoas$id_pessoa
			PRIMARY KEY		(id_pessoa)
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pessoas$nm_celular_X_nm_pessoa')
	BEGIN
		CREATE nonclustered INDEX Idx_tabela_pessoas$nm_celular_X_nm_pessoa		
		ON cad.tabela_pessoas (nm_celular, nm_pessoa) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pessoas$nm_celular_X_nm_pessoa'
	END
END
