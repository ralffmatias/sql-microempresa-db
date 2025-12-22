USE ladycake
GO

--------------------------------------------------------------------------------
-- 09_tabela_pedidos_itens
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_pedidos_itens', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_pedidos_itens
		(
			id_pedidos_item		int identity(1,1),
			id_pedido			int not null,
			dt_entrega			smalldatetime not null,
			id_medida			int not null,
			id_recheio			tinyint,
			id_massa			tinyint not null,
			dv_topper			bit default 0,
			vl_topper			numeric(19, 2) default 0.00,
			nm_tema				varchar(50),
			nm_evento			varchar(50),
			dv_entrega			bit default 0,
			vl_entrega			numeric(19, 2)  default 0.00,
			vl_desconto			numeric(19, 2)  default 0.00,
			id_status			int not null,

			CONSTRAINT pk_tabela_pedidos_itens$id_pedidos_item 
			PRIMARY KEY (id_pedidos_item),

			CONSTRAINT fk_tabela_pedidos_itens_X_tabela_pedidos$id_pedido		
			FOREIGN KEY (id_pedido)	REFERENCES dbo.tabela_pedidos(id_pedido),

			CONSTRAINT fk_tabela_pedidos_itens_X_tabela_medidas$_id_medida		
			FOREIGN KEY (id_medida)	REFERENCES dbo.tabela_medidas(id_medida),

			CONSTRAINT fk_tabela_pedidos_itens_X_tabela_recheios$_id_recheio		
			FOREIGN KEY (id_recheio) REFERENCES dbo.tabela_recheios(id_recheio),

			CONSTRAINT fk_tabela_pedidos_itens_X_tabela_massas$_id_massa		
			FOREIGN KEY (id_massa) REFERENCES dbo.tabela_massas(id_massa),

			CONSTRAINT		fk_tabela_pedidos_itens_X_tabela_status$id_status 
			FOREIGN KEY		(id_status) REFERENCES dbo.tabela_status(id_status)
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Indx_tabela_pedidos_itens$id_pedido')
	BEGIN
		CREATE  nonclustered INDEX Indx_tabela_pedidos_itens$id_pedido		
		ON dbo.tabela_pedidos_itens(id_pedido) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Indx_tabela_pedidos_itens$id_pedido'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Indx_tabela_pedidos_itens$_dt_entrega')
	BEGIN
		CREATE  nonclustered INDEX Indx_tabela_pedidos_itens$_dt_entrega		
		ON dbo.tabela_pedidos_itens(dt_entrega) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Indx_tabela_pedidos_itens$_dt_entrega'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Indx_tabela_pedidos_itens$_id_medida')
	BEGIN
		CREATE  nonclustered INDEX Indx_tabela_pedidos_itens$_id_medida		
		ON dbo.tabela_pedidos_itens(id_medida) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Indx_tabela_pedidos_itens$_id_medida'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Indx_tabela_pedidos_itens$_id_recheio')
	BEGIN
		CREATE  nonclustered INDEX Indx_tabela_pedidos_itens$_id_recheio		
		ON dbo.tabela_pedidos_itens(id_recheio) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Indx_tabela_pedidos_itens$_id_recheio'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Indx_tabela_pedidos_itens$_id_massa')
	BEGIN
		CREATE  nonclustered INDEX Indx_tabela_pedidos_itens$_id_massa		
		ON dbo.tabela_pedidos_itens(id_massa) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Indx_tabela_pedidos_itens$_id_massa'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_pedidos_itens$id_status')
	BEGIN
		CREATE  nonclustered INDEX Idx_tabela_pedidos_itens$id_status		
		ON dbo.tabela_pedidos_itens(id_status) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_pedidos_itens$id_status'
	END
END
