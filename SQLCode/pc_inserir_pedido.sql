
USE LadyCake;

DROP PROCEDURE IF exists pc_inserir_pedido;
GO
CREATE PROCEDURE pc_inserir_pedido
(
		@nome				varchar(40)		= NULL,
		@endereco			varchar(45)		= NULL,
		@ddd				tinyint			= NULL,
		@celular			char(9)			= NULL,					
		@quantidade			tinyint			= NULL,
		@peso				varchar(10)		= NULL,
		@recheio			varchar(50)		= NULL,
		@massa				varchar(20)		= NULL,
		@evento				varchar(50)		= NULL,
		@dt_pedido			smalldatetime		= NULL,
		@dt_entrega			smalldatetime		= NULL,
		@topper				bit			= NULL,
		@tema				varchar(45)		= NULL,
		@vl_entrega			float			= NULL,
		@endereco_entrega		varchar(50)		= NULL,
		@vl_adicional			float			= NULL,
		@nm_adicional			varchar(50)		= NULL,
		@vl_desconto			float			= NULL,
		@nm_desconto			varchar(50)		= NULL,
		@gasto_em_compra		float			= NULL,
		@gasto_em_bolo			float			= NULL
	--      @return				varchar(50)		= NULL		retorno de saída com return.
)
	AS
			/*	Procedure pc_inserir_pedidos 
				Desenvolvedor: Ralff Matias
				ultima revisão 18/02/2023
				insere vendas in DataBase ladycake	*/
	BEGIN
	set nocount on

	DECLARE	
		@return			VARCHAR(50)		= NULL, --retorno com select
		@id_clientes		INT			= NULL,
		@id_pedidos		INT			= NULL,
		@id_recheios		INT			= NULL,
		@id_massas		INT			= NULL,
		@lucro_total		float			= NULL,
		@lucro_bruto		float			= NULL,
		@mes_de_compra		varchar(20)		= NULL,
		@valor			float			= NULL,
		@id_entrega		INT			= NULL,
		@id_adicional		INT			= NULL,
		@id_desconto		INT			= NULL,
		@dv_entrega		bit			= 0,
		@dv_adicional		bit			= 0,
		@dv_desconto		bit			= 0;

/*seta null para valores que permitem null*/
	IF	@endereco	= ''  BEGIN SET @endereco	= null END
	IF	@tema		= ''  BEGIN SET @tema		= NULL END	
	IF	@vl_entrega	=  0  BEGIN SET @tema		= NULL END	
	IF	@nm_adicional	= ''  BEGIN SET @nm_adicionaL	= NULL END
	IF	@nm_desconto	= ''  BEGIN SET @nm_desconto	= NULL END
	
/*digitos verificadores*/
	IF isnull(@topper, 0)		= 0 BEGIN SET @topper		= 0 END
	IF isnull(@vl_entrega, 0)	<> 0 BEGIN SET @dv_entrega	= 1 END
	IF isnull(@vl_adicional, 0)	<> 0 BEGIN SET @dv_adicional 	= 1 END
	IF isnull(@vl_desconto, 0)	<> 0 BEGIN SET @dv_desconto	= 1 END


/*retorna erro se campos obrigatorios receber null*/
	SET @return = 'Campos obrigatorios não foram preenchidos'

	IF isnull(@nome,'')		= '' BEGIN SELECT @return as error RETURN  END
	IF isnull(@ddd, 0)		=  0 BEGIN SELECT @return as error RETURN  END
	IF isnull(@celular, '')		= '' BEGIN SELECT @return as error RETURN  END
	IF isnull(@quantidade, 0)	=  0 BEGIN SELECT @return as error RETURN  END
	IF isnull(@peso, '')		= '' BEGIN SELECT @return as error RETURN  END
	IF isnull(@recheio, '')		= '' BEGIN SELECT @return as error RETURN  END
	IF isnull(@massa, '')		= '' BEGIN SELECT @return as error RETURN  END
	IF isnull(@evento, '')		= '' BEGIN SELECT @evento as error RETURN  END
	IF isnull(@dt_pedido, '')	= '' BEGIN SELECT @return as error RETURN  END
	IF isnull(@dt_entrega, '')	= '' BEGIN SELECT @return as error RETURN  END
	IF isnull(@gasto_em_compra, 0)	=  0 BEGIN SELECT @return as error RETURN  END
	IF isnull(@gasto_em_bolo, 0)	=  0 BEGIN SELECT @return as error RETURN  END


/* Verifica se o numero e ddd foram informados corretamente*/
	IF len(@ddd) <> 2 or len(@celular) <> 9 
	BEGIN
		SET	  @return = 'numero invalido'
		SELECT	  @return as error
		RETURN
	END

/*Cadastrar o cliente caso ele não esteja cadastrado*/
	IF not exists (SELECT TOP 1 1 FROM clientes WHERE nome = @nome and celular = @celular)
	BEGIN
		INSERT INTO clientes VALUES (@nome, @endereco, @ddd, @celular)
	END

/*Procura o cliente*/
	SET @id_clientes = (SELECT TOP 1 id_clientes FROM clientes WHERE nome = @nome and celular = @celular);

/*verifica se o pedido ja foi inserido */
	IF exists 
	(
		SELECT 
		TOP		1 1 
		FROM		pedidos pd 
		join		detalhes_vendas dv 
		ON		dv.id_pedidos		=	pd.id_pedidos 
		WHERE		pd.id_clientes		=	@id_clientes 
		and		dv.dt_pedido		=	@dt_pedido 
		and		dv.dt_entrega		=	@dt_entrega
	)
	BEGIN
		SET	@return = 'pedido já inserido'
		SELECT	@return as error
		RETURN
	END

/*insere o pedido*/
	INSERT INTO pedidos VALUES (@id_clientes)

	SET @id_pedidos = 
	(
		SELECT TOP		1 id_pedidos 
		FROM			pedidos 
		WHERE			id_clientes	   =	@id_clientes
		ORDER BY		id_pedidos DESC
	);

	SET @id_recheios  = (SELECT TOP 1 id_recheios	FROM recheios	WHERE recheio	= @recheio);
	SET @id_massas	  = (SELECT TOP 1 id_massas	FROM massas	WHERE massa	= @massa);
	SET @valor			= 
	(
		(SELECT valor FROM medidas WHERE peso 	= @peso) + 
		(SELECT valor  FROM topper WHERE topper = @topper) + 
		(
			SELECT		ta.valor_adicional 
			FROM		tradicional_adicional ta 
			join		recheios rc 
			on		ta.id_tradicional_adicional		=	rc.id_tradicional_adicional 
			WHERE		rc.recheio				=	@recheio
		)
	) * @quantidade + isnull(@vl_adicional, 0) + isnull(@vl_entrega, 0) - isnull(@vl_desconto, 0);
		
/* Iinsere valores adicional, desconto e entrega */
	INSERT INTO adicional	VALUES (@dv_adicional, @nm_adicional, @vl_adicional)
	INSERT INTO desconto	VALUES (@dv_desconto, @nm_desconto, @vl_desconto)
	INSERT INTO entrega	VALUES (@dv_entrega, @endereco_entrega, @vl_entrega)

	SET @id_entrega	  = (SELECT TOP 1 id_entrega    FROM entrega	ORDER BY id_entrega   DESC)
	SET @id_adicional = (SELECT TOP 1 id_adicional  FROM adicional	ORDER BY id_adicional DESC)
	SET @id_desconto  = (SELECT TOP 1 id_desconto	FROM desconto	ORDER BY id_desconto  DESC)

/*Insere detales de vendas e lucros */
	INSERT INTO detalhes_vendas VALUES 
	(
		@id_pedidos,	@quantidade,	@dt_pedido,		@dt_entrega,	@peso, 
		@id_recheios,	@id_massas,	@topper,		@tema,		@evento,		
		@id_entrega,	@id_adicional,	@id_desconto,		@valor
	)


	SET @lucro_total    = (@valor - @gasto_em_compra); 
	SET @lucro_bruto    = (@valor - @gasto_em_bolo);

	INSERT INTO lucro_vendas VALUES (@id_pedidos, @gasto_em_compra, @gasto_em_bolo, @lucro_total, @lucro_bruto)

/*Transforma a data de entrega para o formato monthname/year e depois insere os valores na tabela lucro_mensal*/
	SET @mes_de_compra = (SELECT CONCAT(DATENAME(MONTH, @dt_entrega),' de ',DATENAME(YEAR, @dt_entrega)));
	
	IF @mes_de_compra in (SELECT mes FROM lucro_mensal WHERE mes = @mes_de_compra)
	BEGIN
		UPDATE 		lucro_mensal 
		SET		lucro_total	=	lucro_total	 +	@lucro_total,		
				lucro_bruto	=	lucro_bruto	 +	@lucro_bruto 
		WHERE		mes		=	@mes_de_compra
	END
	ELSE
	BEGIN
		INSERT INTO lucro_mensal values (@mes_de_compra, @lucro_total, @lucro_bruto)
	END


/*
EXECUTE pc_inserir_pedido	'Nome',		  Endereço',	  DDD,			 'Celular',		
				quantidade,	  'peso',	  'recheio',		 'Massa',	 
				'Evento',	  'dt_pedido',	  'dt_entrega',		 topper,		
				'Tema',		  vl_entrega,	  'Endereco_entrega',	 vl_adicional,
				'nm_adicional',	  vl_desconto,	  'nm_desconto',	 gasto_em_compras,			 
				Gaso_em_bolo;	  */

END
