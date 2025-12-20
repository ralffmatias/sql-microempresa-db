USE ladycake;
GO

--------------------------------------------------------------------------------
-- 07_tabela_detalhes_vendas
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_detalhes_vendas', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_detalhes_vendas
		(
			id_detalhes_venda	int identity(1,1),
			id_pedido			int not null,
			nr_quantidade		tinyint not null,
			dt_pedido			smalldatetime,
			dt_entrega			smalldatetime not null,
			id_medida			int not null,
			id_recheio			tinyint,
			id_massa			tinyint not null,
			dv_topper			bit default 0,
			vl_topper			numeric(19, 2),
			nm_tema				varchar(50),
			nm_evento			varchar(50),
			dv_entrega			bit default 0,
			vl_entrega			numeric(19, 2),
			id_adicional		int not null,
			vl_desconto			numeric(19, 2) not null,
			vl_total			numeric(19, 2) not null,
			CONSTRAINT pk_tabela_detalhes_vendas$id_detalhes_venda PRIMARY KEY (id_detalhes_venda),

			CONSTRAINT fk_tabela_detalhes_vendas_X_tabela_pedidos		FOREIGN KEY (id_pedido)	REFERENCES dbo.tabela_pedidos(id_pedido),
			CONSTRAINT fk_tabela_detalhes_vendas_X_tabela_medidas		FOREIGN KEY (id_medida)	REFERENCES dbo.tabela_medidas(id_medida),
			CONSTRAINT fk_tabela_detalhes_vendas_X_tabela_recheios		FOREIGN KEY (id_recheio)REFERENCES dbo.tabela_recheios(id_recheio),
			CONSTRAINT fk_tabela_detalhes_vendas_X_tabela_massas		FOREIGN KEY (id_massa)	REFERENCES dbo.tabela_massas(id_massa)
		) ON dados
		/*
	CREATE NONCLUSTERED INDEX Idx_tabela_pedidos$id_cliente	
	ON dbo.tabela_pedidos(id_cliente)  WITH(FILLFACTOR= 80) ON indices*/

	CREATE  nonclustered INDEX Indx_tabela_detalhes_vendas$id_pedido		
	ON dbo.tabela_detalhes_vendas(id_pedido) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_detalhes_vendas$_dt_pedido		
	ON dbo.tabela_detalhes_vendas(dt_pedido) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_detalhes_vendas$_dt_entrega		
	ON dbo.tabela_detalhes_vendas(dt_entrega) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_detalhes_vendas$_id_medida		
	ON dbo.tabela_detalhes_vendas(id_medida) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_detalhes_vendas$_id_recheio		
	ON dbo.tabela_detalhes_vendas(id_recheio) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_detalhes_vendas$_id_massa		
	ON dbo.tabela_detalhes_vendas(id_massa) WITH(FILLFACTOR= 80) ON indices
END
