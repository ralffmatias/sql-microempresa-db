USE ladycake;
GO

--------------------------------------------------------------------------------
-- 05_tabela_pedidos
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_pedidos', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_pedidos
		(
			id_pedido	int identity(1,1),
			id_cliente	int not null,
			CONSTRAINT	pk_tabela_pedidos$id_pedidos 
			PRIMARY KEY (id_pedido),
			CONSTRAINT	fk_tabela_pedidos_X_tabela_clientes$id_cliente 
			FOREIGN KEY (id_cliente) REFERENCES dbo.tabela_clientes(id_cliente)
		) ON dados

	CREATE NONCLUSTERED INDEX Idx_tabela_pedidos$id_cliente	
	ON dbo.tabela_pedidos(id_cliente)  WITH(FILLFACTOR= 80) ON indices
END
