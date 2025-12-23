USE ladycake
GO

--------------------------------------------------------------------------------
-- 11_tabela_pedido_valores
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_pedido_valores', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_pedido_valores
		(
			id_pedido_valor		int identity(1, 1),
			id_pedido			int not null,
			vl_itens			numeric(19,2) not null,
			vl_adicionais		numeric(19,2) not null,
			vl_descontos		numeric(19,2) default 0.00,
			vl_custo_estimado	numeric(19,2),
			vl_total			numeric(19, 2) not null,
			id_status			int not null,
			dt_calculo			datetime default getdate(),

			CONSTRAINT pk_tabela_pedido_valores$id_pedido_valor
			PRIMARY KEY (id_pedido_valor),

			CONSTRAINT fk_tabela_pedido_valores_X_tabela_pedidos$id_pedido
			FOREIGN KEY (id_pedido) REFERENCES dbo.tabela_pedidos(id_pedido),

			CONSTRAINT fk_tabela_pedido_valores_X_tabela_status$id_status
			FOREIGN KEY (id_status) REFERENCES dbo.tabela_status(id_status)
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Indx_tabela_pedido_valores$id_pedido')
	BEGIN
		CREATE  nonclustered INDEX Indx_tabela_pedido_valores$id_pedido	
		ON dbo.tabela_pedido_valores(id_pedido) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Indx_tabela_pedido_valores$id_pedido'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Indx_tabela_pedido_valores$id_status')
	BEGIN
		CREATE  nonclustered INDEX Indx_tabela_pedido_valores$id_status	
		ON dbo.tabela_pedido_valores(id_status) WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Indx_tabela_pedido_valores$id_status'
	END
END