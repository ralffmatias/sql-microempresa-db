USE ladycake
GO

--------------------------------------------------------------------------------
-- 10_tabela_pedidos_itens_adicionais
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_pedidos_itens_adicionais', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_pedidos_itens_adicionais
		(
			id_pedidos_itens_adicional	int identity(1,1),
			id_pedidos_item				int not null,
			id_adicional				int not null,
			dv_ativo					bit not null default 1,
			dt_inclusao					datetime not null default getdate(),
			dt_alteracao				datetime,

			CONSTRAINT pk_tabela_pedidos_itens_adicionais$id_pedidos_itens_adicional
			PRIMARY KEY (id_pedidos_itens_adicional),

			CONSTRAINT fk_tabela_pedidos_itens_adicionais_X_tabela_pedidos_itens$id_pedidos_item		
			FOREIGN KEY (id_pedidos_item) REFERENCES dbo.tabela_pedidos_itens(id_pedidos_item),

			CONSTRAINT fk_tabela_pedidos_itens_adicionais_X_tabela_adicionais$_id_adicional	
			FOREIGN KEY (id_adicional) REFERENCES prod.tabela_adicionais(id_adicional),
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'UX_tabela_pedidos_itens_adicionais$id_pedidos_item_X_id_adicional')
	BEGIN
		CREATE UNIQUE INDEX UX_tabela_pedidos_itens_adicionais$id_pedidos_item_X_id_adicional
		ON dbo.tabela_pedidos_itens_adicionais(id_pedidos_item, id_adicional)
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: UX_tabela_pedidos_itens_adicionais$id_pedidos_item_X_id_adicional'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Indx_tabela_pedidos_itens_adicionais$id_pedidos_item')
	BEGIN
		CREATE  nonclustered INDEX Indx_tabela_pedidos_itens_adicionais$id_pedidos_item	
		ON dbo.tabela_pedidos_itens_adicionais(id_pedidos_item) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Indx_tabela_pedidos_itens_adicionais$id_pedidos_item'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Indx_tabela_pedidos_itens_adicionais$_id_adicional')
	BEGIN
		CREATE  nonclustered INDEX Indx_tabela_pedidos_itens_adicionais$_id_adicional		
		ON dbo.tabela_pedidos_itens_adicionais(id_adicional) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Indx_tabela_pedidos_itens_adicionais$_id_adicional'
	END
END