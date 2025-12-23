USE ladycake
GO

--------------------------------------------------------------------------------
-- 05_tabela_grp_status
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_grp_status', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_grp_status
		(
			id_grp_status		smallint identity(1,1),
			nm_grp_descricao	varchar(100) not null,
			cd_grp_status		char(3) unique not null,
			dv_ativo			bit not null default 1,
			dt_inclusao			datetime not null default getdate(),
			dt_alteracao		datetime,

			CONSTRAINT pk_tabela_grp_status$id_grp_status
			PRIMARY KEY	(id_grp_status),

			CONSTRAINT CK_tabela_grp_status$cd_grp_status
			CHECK (cd_grp_status LIKE '[A-Z][A-Z][A-Z]')
		) ON dados

	-- Grupos de status
	INSERT INTO dbo.tabela_grp_status (nm_grp_descricao, cd_grp_status, dv_ativo, dt_inclusao)
	VALUES
		('Pedido', 'PED', 1, GETDATE()),
		('Item do pedido', 'ITM', 1, GETDATE()),
		('Pagamento', 'PAG', 1, GETDATE())
END
