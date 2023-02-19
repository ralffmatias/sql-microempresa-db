
USE ladycake

DROP PROCEDURE IF exists pc_deletar_pedido
GO
CREATE PROCEDURE pc_deletar_pedido
(
	@id_pedidos			int				= NULL,
	@nome				varchar(40)		= NULL,
	@celular			char(9)			= NULL,
	@dt_pedido			smalldatetime	= NULL,
	@dt_entrega			smalldatetime	= NULL
--  @return				varchar(50)		= NULL		retorno de saída com return.
)
	AS
			/*	Procedure pc_deletar_pedido 
				Desenvolvedor: Ralff Matias
				ultima revisão 18/02/2023
				deleta vendas in DataBase ladycake	*/
	BEGIN
	set nocount on

	DECLARE	
		@return			varchar(50)		= NULL, --retorno com select
		@id_adicional		int				= NULL,
		@id_desconto	int				= NULL,
		@id_entrega		int				= NULL,
		@lucro_total	float			= NULL,
		@lucro_bruto	float			= NULL,
		@id_clientes	int				= NULL,
		@mes			varchar(20)		= NULL,
		@max			int				= 0

/*Busca o id_pedido caso ele seja = null*/
	IF isnull(@id_pedidos, 0) = 0
	BEGIN
		SET @id_clientes = (SELECT TOP 1 id_clientes FROM clientes WHERE nome = @nome and celular = @celular)
		SET @id_pedidos = 
		(
			SELECT TOP	1 pd.id_pedidos 
			FROM		pedidos pd 
			join		detalhes_vendas dv 
			ON			pd.id_pedidos			= dv.id_pedidos 
			WHERE		pd.id_clientes			= @id_clientes
			and			dv.dt_entrega			= @dt_entrega
			and			dv.dt_pedido			= @dt_pedido
			ORDER BY	id_pedidos DESC					  
		)
	END

	IF not exists (SELECT TOP 1 1 FROM pedidos WHERE id_pedidos = @id_pedidos)
	BEGIN
		SET @return = 'Campos obrigatoriios não preenchidos corretamente: preencha o id pedido ou todos os outros campos.'
		SELECT @return as erro
	END

/*Busca o id de adicional, desconto e entrega*/
	SELECT
				@id_adicional		= id_adicional,
				@id_desconto	= id_desconto,
				@id_entrega		= id_entrega
	FROM		detalhes_vendas
	WHERE		id_pedidos		= @id_pedidos

/*Busca o id de lucro bruto total*/
	SELECT 
			@lucro_bruto	= lucro_bruto,
			@lucro_total	= lucro_total
	FROM	lucro_vendas
	WHERE	id_pedidos		= @id_pedidos

/*Busca o mes do pedido*/
	IF isnull(@dt_entrega, '') = ''
	BEGIN
		SET @dt_entrega = (SELECT TOP 1 dt_entrega FROM detalhes_vendas	WHERE id_pedidos = @id_pedidos)
	END

	SET @mes = (SELECT CONCAT(DATENAME(MONTH, @dt_entrega),' de ',DATENAME(YEAR, @dt_entrega)))

/*executa o delete*/
	DELETE FROM detalhes_vendas	WHERE id_pedidos	= @id_pedidos
	DELETE FROM lucro_vendas	WHERE id_pedidos	= @id_pedidos
	DELETE FROM adicional		WHERE id_adicional	= @id_adicional
	DELETE FROM desconto		WHERE id_desconto	= @id_desconto
	DELETE FROM entrega			WHERE id_entrega	= @id_entrega
	DELETE FROM pedidos			WHERE id_pedidos	= @id_pedidos

	UPDATE lucro_mensal	set	lucro_total =  lucro_total - @lucro_total, lucro_bruto = lucro_bruto - @lucro_bruto WHERE mes = @mes
	
/*
EXEC pc_deletar_pedido	id_pedidos,		'nome',		
						'celular',		'dt_pedido',
						'dt_entrega'	*/

	END
