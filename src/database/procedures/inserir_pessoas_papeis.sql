IF OBJECT_ID(N'cad.p_inserir_pessoas_papeis', N'P') IS NOT NULL
BEGIN
	DROP PROCEDURE cad.p_inserir_pessoas_papeis
END
GO

CREATE PROCEDURE cad.p_inserir_pessoas_papeis
	
	(
		@id_pessoa				int,
		@cd_papel				char(1) = NULL,
		@id_pessoa_papel		int = NULL OUTPUT,
		@cd_retorno				int = NULL OUTPUT,
		@nm_retorno				varchar(200) = NULL OUTPUT
	)
AS
/*	
	-- Procedure p_inserir_pessoas_papeis 
	-- Desenvolvedor: Ralff Matias
	-- Desenvolvimento: 24/12/2025
	-- Ultima modificação: 24/12/2025
	-- Objetivo: Registrar o papel de pessoas no sistema - Usado via sistema e no processo de inserir pessoas.

	
	begin tran
		declare @cd_papel				char(1) = 'C',
				@id_pessoa				int = 1,
				@id_pessoa_papel		int = NULL,
				@cd_retorno				int = NULL,
				@nm_retorno				varchar(200) = NULL
					
		EXEC cad.p_inserir_pessoas_papeis	
				@cd_papel			= @cd_papel,		
				@id_pessoa			= @id_pessoa,
				@id_pessoa_papel	= @id_pessoa_papel output,
				@cd_retorno			= @cd_retorno output,			
				@nm_retorno			= @nm_retorno output		

		select id_pessoa_papel = @id_pessoa_papel, cd_retorno = @cd_retorno, nm_retorno = @nm_retorno
	rollback
	
*/
	
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRY

	DECLARE @id_papel smallint = null

	DECLARE @identity table (id int)

	-- Evita duplicidade básica por CPF/CNPJ (se informado)
	IF NOT EXISTS	(
						SELECT	top 1 1
						FROM	cad.tabela_pessoas
						WHERE	id_pessoa = @id_pessoa
					)
	BEGIN
		SELECT	@cd_retorno = 1,
				@nm_retorno = 'Registro de pessoa invalido.'
		RETURN
	END

	SELECT	@id_papel = id_papel
	FROM	cad.tabela_papeis
	WHERE	cd_papel = ISNULL(@cd_papel, 'C')

	IF @id_papel is null
	BEGIN
		SELECT	@cd_retorno = 1,
				@nm_retorno = 'Código de papel não encontrado.'
		RETURN
	END

	BEGIN TRANSACTION

		INSERT INTO cad.tabela_pessoas_papeis
			(
				id_pessoa,
				id_papel,
				dv_ativo,
				dt_inclusao
			)
		OUTPUT inserted.id_pessoa_papel INTO @identity(id)
		VALUES
			(
				@id_pessoa,
				@id_papel,
				1,
				getdate()
			)

		SELECT @id_pessoa_papel = id from @identity

		DELETE FROM @identity

		IF @id_pessoa_papel IS NULL
		BEGIN
			THROW 50001, 'Falha ao gerar o identificador de pessoa.', 1;
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
