USE ladycake
GO

--------------------------------------------------------------------------------
-- 06_tabela_status
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_status', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_status
		(
			id_status				smallint identity(1,1),
			cd_status				char(1) not null,
			nm_descricao			varchar(100) not null,
			id_grp_status			smallint not null,
			dv_ativo				bit not null default 1,
			dv_permite_exclusao		bit not null default 0,
			dt_inclusao				datetime not null default getdate(),
			dt_alteracao			datetime,

			CONSTRAINT		pk_tabela_status$id_status 
			PRIMARY KEY		(id_status),

			CONSTRAINT		fk_tabela_status_X_tabela_grp_status$id_grp_status
			FOREIGN KEY		(id_grp_status) REFERENCES dbo.tabela_grp_status(id_grp_status),

			CONSTRAINT CK_tabela_status$cd_status
			CHECK (cd_status LIKE '[A-Z]')
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'UX_tabela_status$cd_status_X_id_grp_status')
	BEGIN
		CREATE UNIQUE INDEX UX_tabela_status$cd_status_X_id_grp_status
		ON dbo.tabela_status(cd_status, id_grp_status)
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: UX_tabela_status$cd_status_X_id_grp_status'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_status$cd_status')
	BEGIN
		CREATE NONCLUSTERED INDEX Idx_tabela_status$cd_status	
		ON dbo.tabela_status(cd_status)  WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_status$cd_status'
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_status$id_grp_status')
	BEGIN
		CREATE NONCLUSTERED INDEX Idx_tabela_status$id_grp_status	
		ON dbo.tabela_status(id_grp_status)  WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_status$id_grp_status'
	END
	
	-- Status
	INSERT INTO dbo.tabela_status (cd_status, nm_descricao, id_grp_status, dv_ativo, dv_permite_exclusao, dt_inclusao)
	SELECT	s.cd_status, s.nm_descricao, g.id_grp_status, 1, s.dv_permite_exclusao, GETDATE()
	FROM	(	
				VALUES
						('A', 'Aberto', 'PED', 1),
						('F', 'Finalizado', 'PED', 0),
						('C', 'Cancelado', 'PED', 1),
						('A', 'Ativo', 'ITM', 1),
						('F', 'Finalizado', 'ITM', 0),
						('C', 'Cancelado', 'ITM', 1),
						('P', 'Pendente', 'PAG', 1),
						('Q', 'Quitado', 'PAG', 0),
						('C', 'Cancelado', 'PAG', 1)
			) AS s(cd_status, nm_descricao, cd_grp_status, dv_permite_exclusao)
	JOIN	dbo.tabela_grp_status g 
	ON		g.cd_grp_status = s.cd_grp_status
	ORDER	BY id_grp_status
END
