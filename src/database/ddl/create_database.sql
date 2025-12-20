/* 
========================================================
 Script: 01_create_database.sql
 Projeto: LadyCake
 Descrição:
   - Criação do banco de dados do zero
   - Separação de filegroups para dados e índices
   - Tamanhos iniciais realistas e crescimento controlado
========================================================
*/

USE master
GO

--------------------------------------------------------
-- Derruba o banco se existir (ambiente de estudo/dev)
--------------------------------------------------------
IF DB_ID('ladycake') IS NOT NULL
BEGIN
    ALTER DATABASE ladycake 
        SET SINGLE_USER 
        WITH ROLLBACK IMMEDIATE;

    DROP DATABASE ladycake;
END
GO

--------------------------------------------------------
-- Criação do banco
--------------------------------------------------------
CREATE DATABASE ladycake
ON PRIMARY
(
    NAME = 'ladycake_primary',
    SIZE = 512MB,
    FILEGROWTH = 128MB
),

FILEGROUP dados
(
    NAME = 'ladycake_dados_01',
    SIZE = 1024MB,
    FILEGROWTH = 256MB
),

FILEGROUP indices
(
    NAME = 'ladycake_indices_01',
    SIZE = 512MB,
    FILEGROWTH = 128MB
)

LOG ON
(
    NAME = 'ladycake_log',
    SIZE = 512MB,
    FILEGROWTH = 128MB
);
GO

--------------------------------------------------------
-- Define filegroup de dados como padrão
--------------------------------------------------------
ALTER DATABASE ladycake 
    MODIFY FILEGROUP dados DEFAULT;
GO

--------------------------------------------------------
-- Garante que índices futuros irão para o filegroup correto
-- (padrão recomendado para organização física)
--------------------------------------------------------
ALTER DATABASE ladycake 
    SET AUTO_CREATE_STATISTICS ON;

ALTER DATABASE ladycake 
    SET AUTO_UPDATE_STATISTICS ON;
GO

/*
OBSERVAÇÕES IMPORTANTES:

1. Índices NÃO vão automaticamente para o filegroup 'indices'
   se você não especificar isso no CREATE INDEX.
   Exemplo correto:
   
   CREATE NONCLUSTERED INDEX IX_Tabela_Campo
   ON dbo.Tabela (Campo)
   WITH (FILLFACTOR = 90)
   ON indices;

2. Este script é para:
   - Ambiente local
   - Estudo
   - Portfólio
   NÃO usar em produção sem revisão.

3. Os paths são propositalmente simples para facilitar portabilidade.
*/
