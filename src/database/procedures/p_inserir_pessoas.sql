IF OBJECT_ID(N'cad.p_inserir_pessoas', N'P') IS NOT NULL
BEGIN
	DROP PROCEDURE cad.p_inserir_pessoas
END
GO

CREATE PROCEDURE cad.p_inserir_pessoas
	
	(
		@nr_cpf_cnpj			varchar(14) = null,
		@nm_pessoa				varchar(150),
		@nm_pessoa_fantasia		varchar(150) = null,
		@cd_tipo_pessoa			char(1) = null,
		@dt_nascimento			date = null,
		@cd_papel				char(3),
		@cd_usuario				varchar(50) = null,
		@id_pessoa				int = NULL OUTPUT,
		@cd_retorno				int = NULL OUTPUT,
		@nm_retorno				varchar(200) = NULL OUTPUT
	)
AS
/*	
	-- Procedure p_inserir_pessoas 
	-- Desenvolvedor: Ralff Matias
	-- Desenvolvimento: 24/12/2025
	-- Ultima modificação: 24/12/2025
	-- Objetivo: Fazer o cadastro de pessoas - Usado via sistema e no processo de inserir pedido.

	
	begin tran
		declare @nr_cpf_cnpj			varchar(14) = '25468412568',
				@nm_pessoa				varchar(150)= 'Pessoa Teste da Silva',
				@cd_tipo_pessoa			char(1) = 'F',
				@dt_nascimento			date = '19980522',
				@cd_papel				char(1) = 'C',
				@cd_usuario				varchar(50) = null,
				@id_pessoa				int = NULL,
				@cd_retorno				int = NULL,
				@nm_retorno				varchar(200) = NULL
					
		EXEC cad.p_inserir_pessoas	
				@nr_cpf_cnpj		= @nr_cpf_cnpj,
				@nm_pessoa			= @nm_pessoa,
				@cd_tipo_pessoa		= @cd_tipo_pessoa,
				@dt_nascimento		= @dt_nascimento,		
				@cd_papel			= @cd_papel,
				@cd_usuario			= @cd_usuario,
				@id_pessoa			= @id_pessoa output,			
				@cd_retorno			= @cd_retorno output,			
				@nm_retorno			= @nm_retorno output		

		select id_pessoa = @id_pessoa, cd_retorno = @cd_retorno, nm_retorno = @nm_retorno
	rollback
	
*/
	
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRY

	DECLARE @id_usuario int

	DECLARE @identity table (id int)

	-- Evita duplicidade básica por CPF/CNPJ (se informado)
	IF @nr_cpf_cnpj IS NOT NULL
	AND EXISTS	(
					SELECT	top 1 1
					FROM	cad.tabela_pessoas
					WHERE	nr_cpf_cnpj = @nr_cpf_cnpj
				)
	BEGIN
		SELECT	@cd_retorno = 1,
				@nm_retorno = 'pessoa já cadastrado com este CPF/CNPJ.'
		RETURN
	END

	SELECT	@cd_tipo_pessoa = isnull(@cd_tipo_pessoa, 'F'),
			@id_usuario = id_usuario_sistema
	FROM	cad.tabela_usuarios_sistema
	WHERE	cd_usuario = ISNULL(@cd_usuario, 'system')

	IF @cd_tipo_pessoa NOT IN ('F', 'J')
	BEGIN
		SELECT	@cd_retorno = 1,
				@nm_retorno = 'cd_tipo_pessoa invalido, certifique-se de inserir F pessoa fisica ou J para juridico.'
		RETURN
	END

	BEGIN TRANSACTION

		INSERT INTO cad.tabela_pessoas
			(
				nr_cpf_cnpj,
				nm_pessoa,
				nm_pessoa_fantasia,
				cd_tipo_pessoa,
				dt_nascimento,
				dv_ativo,
				dt_inclusao,
				id_usuario_inclusao
			)
		OUTPUT inserted.id_pessoa INTO @identity(id)
		VALUES
			(
				@nr_cpf_cnpj,
				@nm_pessoa,
				@nm_pessoa_fantasia,
				@cd_tipo_pessoa,
				@dt_nascimento,
				1,
				getdate(),
				@id_usuario
			)

		SELECT @id_pessoa = id from @identity

		DELETE FROM @identity

		IF @id_pessoa IS NULL
		BEGIN
			THROW 50001, 'Falha ao gerar o identificador de pessoa.', 1;
		END

		EXEC cad.inserir_pessoas_papeis
			@id_pessoa	= @id_pessoa,
			@cd_papel	= @cd_papel,
			@cd_retorno	= @cd_retorno OUTPUT,
			@nm_retorno	= @nm_retorno OUTPUT

		IF @cd_retorno > 0
		BEGIN
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK
			END

			return
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
