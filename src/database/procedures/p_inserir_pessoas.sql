IF OBJECT_ID(N'cad.p_inserir_pessoas', N'P') IS NOT NULL
BEGIN
	DROP PROCEDURE cad.p_inserir_pessoas
END
GO

CREATE PROCEDURE cad.p_inserir_pessoas
	(
		@nm_pessoa		varchar(150),
		@nm_cpf_cnpj	varchar(15) = NULL,
		@nm_endereco	varchar(150) = NULL,
		@nm_ddd			char(4) = NULL,
		@nm_celular		char(9) = NULL,
		@id_pessoa		int = NULL OUTPUT,
		@cd_retorno		int = NULL OUTPUT,
		@nm_retorno		varchar(200) = NULL OUTPUT
	)
AS
/*	
	-- Procedure p_inserir_pessoas 
	-- Desenvolvedor: Ralff Matias
	-- Desenvolvimento: 22/12/2025
	-- Ultima modificação: 22/12/2025
	-- Objetivo: Fazer o cadastro de pessoas - Usado via sistema e no processo de inserir pedido.

	
	begin tran
		declare @id_pedido			int = 1,
				@cd_retorno			int = null,
				@nm_retorno			varchar(200) = NULL
					
		EXEC cad.p_inserir_pessoas	
				@id_pedido		= @id_pedido,	
				@cd_retorno		= @cd_retorno output,	
				@nm_retorno		= @nm_retorno output

		select cd_retorno = @cd_retorno, nm_retorno = @nm_retorno
	rollback
	
*/
	
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRY

	-- Validação mínima
	IF NULLIF(LTRIM(RTRIM(@nm_pessoa)), '') IS NULL
	BEGIN
		SELECT	@cd_retorno = 1,
				@nm_retorno = 'Nome do pessoa é obrigatório.'
		RETURN
	END

	-- Evita duplicidade básica por CPF/CNPJ (se informado)
	IF @nm_cpf_cnpj IS NOT NULL
	AND EXISTS (
		SELECT 1
		FROM cad.tabela_pessoas
		WHERE nm_cpf_cnpj = @nm_cpf_cnpj
	)
	BEGIN
		SELECT	@cd_retorno = 2,
				@nm_retorno = 'pessoa já cadastrado com este CPF/CNPJ.'
		RETURN
	END

	BEGIN TRANSACTION

		INSERT INTO cad.tabela_pessoas
		(
			nm_pessoa,
			nm_cpf_cnpj,
			nm_endereco,
			nm_ddd,
			nm_celular
		)
		VALUES
		(
			@nm_pessoa,
			@nm_cpf_cnpj,
			@nm_endereco,
			@nm_ddd,
			@nm_celular
		)

		SET @id_pessoa = SCOPE_IDENTITY()

		IF @id_pessoa IS NULL
		BEGIN
			THROW 50001, 'Falha ao gerar o identificador do pessoa.', 1;
		END
	
		select	@cd_retorno = 0,
				@nm_retorno = 'Processamento efetuado com sucesso.'

	-- Encerra transação
	IF @@TRANCOUNT > 0
	BEGIN
		COMMIT
	END

END	TRY
BEGIN CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK
	END

	SELECT	@cd_retorno = 2,
			@nm_retorno = ERROR_MESSAGE()

END CATCH
