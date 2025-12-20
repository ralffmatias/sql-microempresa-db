USE ladycake
GO

--------------------------------------------------------------------------------
-- 07_tabela_itens_vendas
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_itens_vendas', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_itens_vendas
		(
			id_itens_venda		int identity(1,1),
			id_venda			int not null,
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

			CONSTRAINT pk_tabela_itens_vendas$id_itens_venda 
			PRIMARY KEY (id_itens_venda),

			CONSTRAINT fk_tabela_itens_vendas_X_tabela_vendas$id_venda		
			FOREIGN KEY (id_venda)	REFERENCES dbo.tabela_vendas(id_venda),

			CONSTRAINT fk_tabela_itens_vendas_X_tabela_medidas$_id_medida		
			FOREIGN KEY (id_medida)	REFERENCES dbo.tabela_medidas(id_medida),

			CONSTRAINT fk_tabela_itens_vendas_X_tabela_recheios$_id_recheio		
			FOREIGN KEY (id_recheio) REFERENCES dbo.tabela_recheios(id_recheio),

			CONSTRAINT fk_tabela_itens_vendas_X_tabela_massas$_id_massa		
			FOREIGN KEY (id_massa) REFERENCES dbo.tabela_massas(id_massa)
		) ON dados

	CREATE  nonclustered INDEX Indx_tabela_itens_vendas$id_venda		
	ON dbo.tabela_itens_vendas(id_venda) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_itens_vendas$_dt_entrega		
	ON dbo.tabela_itens_vendas(dt_entrega) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_itens_vendas$_id_medida		
	ON dbo.tabela_itens_vendas(id_medida) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_itens_vendas$_id_recheio		
	ON dbo.tabela_itens_vendas(id_recheio) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_itens_vendas$_id_massa		
	ON dbo.tabela_itens_vendas(id_massa) WITH(FILLFACTOR= 80) ON indices
END
