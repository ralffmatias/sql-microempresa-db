USE ladycake
GO

--------------------------------------------------------------------------------
-- 06_tabela_status
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_status', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_status
		(
			id_status				int identity(1,1),
			cd_status				char(1),
			nm_descricao			varchar(100),
			id_grp_status			int,
			dv_ativo				bit default 1,
			dv_permite_exclusao		bit default 0,

			CONSTRAINT		pk_tabela_status$id_status 
			PRIMARY KEY		(id_status),

			CONSTRAINT		fk_tabela_status_X_tabela_grp_status$id_grp_status
			FOREIGN KEY		(id_grp_status) REFERENCES dbo.tabela_grp_status(id_grp_status)
		) ON dados

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_status$cd_status')
	BEGIN
		CREATE NONCLUSTERED INDEX Idx_tabela_status$cd_status	
		ON dbo.tabela_status(cd_status)  WITH(FILLFACTOR= 80) ON indices
	END ELSE
	BEGIN
		PRINT 'Já existe um indice com o nome: Idx_tabela_status$cd_status'
	END
END
