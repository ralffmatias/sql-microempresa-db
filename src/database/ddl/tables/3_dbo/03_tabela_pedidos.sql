USE ladycake
GO

--------------------------------------------------------------------------------
-- 07_tabela_pedidos
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_pedidos', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_pedidos
		(
			id_pedido				int identity(1,1),
			id_pessoa_cliente		int not null,
			dt_pedido				smalldatetime not null default getdate(),
			id_status				smallint not null,
			dt_cancelamento			smalldatetime,
			nm_motivo_cancelamento	varchar(200),
			dt_inclusao				datetime not null  default getdate(),
			id_usuario_inclusao		int,
			dt_alteracao			datetime,
			id_usuario_alteracao	int,

			CONSTRAINT pk_tabela_pedidos$id_pedidos 
			PRIMARY KEY (id_pedido),

			CONSTRAINT fk_tabela_pedidos_X_tabela_pessoas$id_pessoa_cliente_X_id_pessoa 
			FOREIGN KEY (id_pessoa_cliente) REFERENCES cad.tabela_pessoas(id_pessoa),

			CONSTRAINT fk_tabela_pedidos_X_tabela_status$id_status 
			FOREIGN KEY	(id_status) REFERENCES dbo.tabela_status(id_status),

			CONSTRAINT CK_tabela_pedidos$nm_motivo_cancelamento_X_dt_cancelamento
			CHECK	(
						(dt_cancelamento IS NULL AND nm_motivo_cancelamento IS NULL)
						OR (dt_cancelamento IS NOT NULL AND nm_motivo_cancelamento IS NOT NULL)
					)
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pedidos$id_pessoa_cliente')
	BEGIN
		CREATE NONCLUSTERED INDEX Idx_tabela_pedidos$id_pessoa_cliente
		ON dbo.tabela_pedidos(id_pessoa_cliente)  WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pedidos$id_pessoa_cliente'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pedidos$dt_pedido')
	BEGIN
		CREATE  nonclustered INDEX Idx_tabela_pedidos$dt_pedido	
		ON dbo.tabela_pedidos(dt_pedido) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pedidos$dt_pedido'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pedidos$id_status')
	BEGIN
		CREATE  nonclustered INDEX Idx_tabela_pedidos$id_status		
		ON dbo.tabela_pedidos(id_status) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pedidos$id_status'
	END
END
