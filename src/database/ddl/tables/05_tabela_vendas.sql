USE ladycake;
GO

--------------------------------------------------------------------------------
-- 05_tabela_vendas
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_vendas', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_vendas
		(
			id_venda			int identity(1,1),
			id_cliente			int not null,
			dt_venda			smalldatetime,
			nr_quantidade		tinyint not null,
			vl_gasto_em_compra	numeric(19,2) not null,
			vl_gasto_em_item	numeric(19,2),
			vl_total			numeric(19, 2) not null,

			CONSTRAINT		pk_tabela_vendas$id_vendas 
			PRIMARY KEY		(id_venda),

			CONSTRAINT		fk_tabela_vendas_X_tabela_clientes$id_cliente 
			FOREIGN KEY		(id_cliente) REFERENCES dbo.tabela_clientes(id_cliente)
		) ON dados

	CREATE NONCLUSTERED INDEX Idx_tabela_vendas$id_cliente	
	ON dbo.tabela_vendas(id_cliente)  WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Idx_tabela_vendas$_dt_venda		
	ON dbo.tabela_vendas(dt_venda) WITH(FILLFACTOR= 80) ON indices
END
