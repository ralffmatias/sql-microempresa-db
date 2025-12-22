IF OBJECT_ID(N'dbo.p_excluir_pedidos', N'P') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.p_excluir_pedidos
END
GO

CREATE PROCEDURE dbo.p_excluir_pedidos
	(
		@id_pedido			int,
		@cd_retorno			int = null output,
		@nm_retorno			varchar(200) = NULL output
	)
AS
/*	
	-- Procedure p_excluir_pedidos 
	-- Desenvolvedor: Ralff Matias
	-- Desenvolvimento: 18/02/2023
	-- Ultima modificação: 22/12/2025
	-- Objetivo: deleta pedidos - Usado em caso de erro durante processo de inserir pedido, ou outros casos especiais.

	
	begin tran
		declare @id_pedido			int = 1,
				@cd_retorno			int = null,
				@nm_retorno			varchar(200) = NULL
					
		EXEC dbo.p_excluir_pedidos	
				@id_pedido		= @id_pedido,	
				@cd_retorno		= @cd_retorno output,	
				@nm_retorno		= @nm_retorno output

		select cd_retorno = @cd_retorno, nm_retorno = @nm_retorno
	rollback
	
*/
	
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRY

	-- Verifica a existência do pedido.
	IF NOT EXISTS	(	
						SELECT	TOP 1 1 
						FROM	dbo.tabela_pedidos tp
						JOIN	dbo.tabela_status ts
						ON		tp.id_status = ts.id_status
						AND		ts.dv_permite_exclusao = 1
						WHERE	id_pedido = @id_pedido
					)
	BEGIN
		SELECT	@cd_retorno = 1,
				@nm_retorno = 'O pedido não foi encontrado ou não permite exclusão via processo.'
		RETURN
	END

	-- Inicia transação.
	BEGIN TRANSACTION

		-- Deleta os itens adicionais.
		DELETE	tpia
		FROM	dbo.tabela_pedidos_itens_adicionais tpia
		JOIN	dbo.tabela_pedidos_itens tpi
		ON		tpia.id_pedidos_item = tpi.id_pedidos_item
		AND		tpi.id_pedido = @id_pedido

		-- Deleta os itens.
		DELETE FROM	dbo.tabela_pedidos_itens WHERE id_pedido = @id_pedido

		-- Deleta os valores.
		DELETE FROM	dbo.tabela_pedido_valores WHERE id_pedido = @id_pedido

		-- Deleta pedido.
		DELETE FROM	dbo.tabela_pedidos WHERE id_pedido = @id_pedido


		-- Valida apenas o último delete.
		IF @@ROWCOUNT = 0
		BEGIN
			THROW 50001, 'Falha ao excluir o pedido. Registro não encontrado no momento da exclusão.', 1;
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
