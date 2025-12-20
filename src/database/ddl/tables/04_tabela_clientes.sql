USE ladycake
GO

--------------------------------------------------------------------------------
-- 04_tabela_clientes
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_clientes', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_clientes
		(
			id_cliente		int identity(1,1),
			nm_cliente		varchar(150) not null,
			nm_cpf_cnpj		varchar(15),
			nm_endereco		varchar(150),
			nm_ddd			char(4),
			nm_celular		char(9),
			CONSTRAINT		pk_tabela_clientes$id_cliente
			PRIMARY KEY		(id_cliente)
		) ON dados

	CREATE nonclustered INDEX Idx_tabela_clientes$nm_celular_X_nm_cliente		
	ON dbo.tabela_clientes (nm_celular, nm_cliente) WITH(FILLFACTOR= 80) ON indices
END
