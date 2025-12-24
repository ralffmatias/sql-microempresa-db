IF OBJECT_ID(N'cad.p_inserir_pessoas_contatos', N'P') IS NOT NULL
BEGIN
	DROP PROCEDURE cad.p_inserir_pessoas_contatos
END
GO

CREATE PROCEDURE cad.p_inserir_pessoas_contatos
	(
		@id_pessoa				int,
		@cd_tipo_contato		varchar(3),
		@nm_descricao			varchar(200) = NULL,
		@dv_principal			bit = 0,
		@nr_ddd					char(2) = NULL,
		@nr_telefone_celular	char(9) = NULL,
		@nm_email				varchar(150) = NULL,
		@id_pessoas_contato		int = NULL OUTPUT,
		@cd_retorno				int = NULL OUTPUT,
		@nm_retorno				varchar(200) = NULL OUTPUT
	)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRY

	DECLARE @id_tipo_contato	smallint,
			@dt_sistema			datetime = GETDATE()

	DECLARE @identity table (id int)

	SELECT	@id_tipo_contato = id_tipo_contato
	FROM	cad.tabela_tipo_contatos
	WHERE	cd_tipo_contato = @cd_tipo_contato
	AND		dv_ativo = 1

	-- Valida tipo de contato
	IF @id_tipo_contato IS NULL
	BEGIN
		SELECT	@cd_retorno = 1,
				@nm_retorno = 'Tipo de contato inválido ou inativo.'
		RETURN
	END

	-- Valida pessoa
	IF NOT EXISTS	(
						SELECT	top 1 1
						FROM	cad.tabela_pessoas
						WHERE	id_pessoa = @id_pessoa
					)
	BEGIN
		SELECT	@cd_retorno = 1,
				@nm_retorno = 'Pessoa não encontrada.'
		RETURN
	END

	-- CELULAR / WHATSAPP
	IF @cd_tipo_contato IN ('CEL', 'WTP', 'TEL')
	BEGIN
		IF @nr_ddd IS NULL OR @nr_telefone_celular IS NULL
		BEGIN
			SELECT	@cd_retorno = 1,
					@nm_retorno = 'DDD e número são obrigatórios para telefone, celular ou WhatsApp.'
			RETURN
		END

		IF @nr_ddd NOT LIKE '[1-9][0-9]'
		   OR NOT	(
						(@nr_telefone_celular LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND  @cd_tipo_contato IN ('CEL', 'WTP'))
						OR (@nr_telefone_celular LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND  @cd_tipo_contato IN ('TEL'))
					)
		BEGIN
			SELECT	@cd_retorno = 1,
					@nm_retorno = 'DDD ou número inválido.'
			RETURN
		END

		SET @nm_email = null
		

		IF EXISTS	(
						SELECT	TOP 1 1
						FROM	cad.tabela_pessoas_contatos
						WHERE	id_pessoa = @id_pessoa
						AND		nr_ddd = @nr_ddd
						AND		nr_telefone_celular = @nr_telefone_celular
					)
		BEGIN
			SELECT	@cd_retorno = 1,
					@nm_retorno = 'Este telefone já está registrado para essa pessoa.'
			RETURN
	END

	-- EMAIL
	ELSE IF @cd_tipo_contato = 'MAI'
	BEGIN
		IF @nm_email IS NULL
		BEGIN
			SELECT	@cd_retorno = 1,
					@nm_retorno = 'E-mail é obrigatório para este tipo de contato.'
			RETURN
		END

		-- regex simples e honesta
		IF @nm_email NOT LIKE '%_@_%._%'
		BEGIN
			SELECT	@cd_retorno = 1,
					@nm_retorno = 'Formato de e-mail inválido.'
			RETURN
		END

		SELECT @nr_ddd = NULL, @nr_telefone_celular = null

		IF EXISTS	(
						SELECT	TOP 1 1
						FROM	cad.tabela_pessoas_contatos
						WHERE	id_pessoa = @id_pessoa
						AND		nm_email = @nm_email
					)
		BEGIN
			SELECT	@cd_retorno = 1,
					@nm_retorno = 'Este email já está registrado para essa pessoa.'
			RETURN
		END
	END ELSE
	BEGIN
		SELECT  @cd_retorno = 1,
				@nm_retorno = 'Tipo de contato desconhecido.'
		RETURN
	END

	BEGIN TRANSACTION

		-- Se for principal, remove o principal anterior
		IF @dv_principal = 1
		BEGIN
			IF EXISTS	(
							SELECT TOP 1 1
							FROM	cad.tabela_pessoas_contatos
							WHERE	id_pessoa = @id_pessoa
							AND		dv_principal = 1
						)
			BEGIN
				UPDATE	cad.tabela_pessoas_contatos
				SET		dv_principal = 0,
						dt_alteracao = @dt_sistema
				WHERE	id_pessoa = @id_pessoa
				AND		dv_principal = 1
			END
		END

		INSERT INTO cad.tabela_pessoas_contatos
		(
			id_pessoa,
			nm_descricao,
			id_tipo_contato,
			dv_ativo,
			dv_principal,
			nr_ddd,
			nr_telefone_celular,
			nm_email,
			dt_inclusao
		)
		OUTPUT inserted.id_pessoas_contato INTO @identity(id)
		VALUES
		(
			@id_pessoa,
			@nm_descricao,
			@id_tipo_contato,
			1,
			@dv_principal,
			@nr_ddd,
			@nr_telefone_celular,
			@nm_email,
			@dt_sistema
		)

		SELECT @id_pessoas_contato = id FROM @identity

		IF @id_pessoas_contato IS NULL
		BEGIN
			THROW 50002, 'Falha ao gerar identificador do contato.', 1;
		END

		SELECT	@cd_retorno = 0,
				@nm_retorno = 'Contato inserido com sucesso.'

	IF @@TRANCOUNT > 0
	BEGIN
		COMMIT
	END

END TRY
BEGIN CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK
	END

	SELECT	@cd_retorno = 2,
			@nm_retorno = ERROR_MESSAGE()

END CATCH
