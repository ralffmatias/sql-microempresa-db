USE ladycake
GO

--------------------------------------------------------------------------------
-- 01_tabela_log_deletes
--------------------------------------------------------------------------------
IF object_id(N'log.tabela_log_deletes', N'U') IS NULL
BEGIN
	CREATE TABLE log.tabela_log_deletes
	(
		id_log_delete			bigint identity(1,1),
		nm_tabela				varchar(128) not null,

		nm_identificador_1		varchar(50) not null,
		vl_identificador_1		varchar(100) not null,

		nm_identificador_2		varchar(50),
		vl_identificador_2		varchar(100),

		id_usuario_delete		int,
		dt_delete				datetime not null default getdate(),
		nm_motivo				varchar(500),
		nm_host					varchar(100),
		nm_aplicacao			varchar(100),

		CONSTRAINT pk_tabela_log_deletes$id_log_delete
		PRIMARY KEY (id_log_delete),

		CONSTRAINT CK_tabela_log_deletes$nm_tabela
		CHECK (LEN(LTRIM(RTRIM(nm_tabela))) >= 3)
	) ON dados

	IF NOT EXISTS (SELECT top 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_log_deletes$nm_tabela')
	BEGIN
		CREATE NONCLUSTERED INDEX Idx_tabela_log_deletes$nm_tabela
		ON log.tabela_log_deletes (nm_tabela)
		WITH (FILLFACTOR = 80) ON indices
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE name = 'Idx_tabela_log_deletes$dt_delete')
	BEGIN
		CREATE NONCLUSTERED INDEX Idx_tabela_log_deletes$dt_delete
		ON log.tabela_log_deletes (dt_delete)
		WITH (FILLFACTOR = 80) ON indices
	END
END
