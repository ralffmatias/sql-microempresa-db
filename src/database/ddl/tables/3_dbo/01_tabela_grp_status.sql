USE ladycake
GO

--------------------------------------------------------------------------------
-- 05_tabela_grp_status
--------------------------------------------------------------------------------
IF object_id(N'dbo.tabela_grp_status', N'U') is null
BEGIN
	CREATE TABLE dbo.tabela_grp_status
		(
			id_grp_status			int identity(1,1),
			nm_grp_descricao		varchar(100),
			cd_grp_status			int,
			dv_ativo				bit default 1,

			CONSTRAINT		pk_tabela_grp_status$id_grp_status
			PRIMARY KEY		(id_grp_status)
		) ON dados
END
