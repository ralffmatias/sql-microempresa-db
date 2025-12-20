USE ladycake
GO

--------------------------------------------------------------------------------
-- 08_tabela_itens_vendas_adicionais
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_itens_vendas_adicionais', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_itens_vendas_adicionais
		(
			id_itens_vendas_adicional	int identity(1,1),
			id_itens_venda				int,
			id_adicional				int,

			CONSTRAINT pk_tabela_itens_vendas_adicionais$id_itens_vendas_adicional
			PRIMARY KEY (id_itens_vendas_adicional),

			CONSTRAINT fk_tabela_itens_vendas_adicionais_X_tabela_itens_vendas$id_itens_venda		
			FOREIGN KEY (id_itens_venda) REFERENCES dbo.tabela_itens_vendas(id_itens_venda),

			CONSTRAINT fk_tabela_itens_vendas_adicionais_X_tabela_adicionais$_id_adicional	
			FOREIGN KEY (id_adicional) REFERENCES dbo.tabela_adicionais(id_adicional),
		) ON dados

	CREATE  nonclustered INDEX Indx_tabela_itens_vendas_adicionais$id_itens_venda	
	ON dbo.tabela_itens_vendas_adicionais(id_itens_venda) WITH(FILLFACTOR= 80) ON indices

	CREATE  nonclustered INDEX Indx_tabela_itens_vendas_adicionais$_id_adicional		
	ON dbo.tabela_itens_vendas_adicionais(id_adicional) WITH(FILLFACTOR= 80) ON indices
END