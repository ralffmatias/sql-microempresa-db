/* 
========================================================
 Script: 02_create_schemas.sql
 Projeto: LadyCake

 Descrição:
   - Criação dos Shemas do banco de dados
========================================================
*/

USE ladycake
GO

-------------------------------------------------------------------------------
-- Schema: cad (cadastros / pessoas / usuários)
-------------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 
    FROM sys.schemas 
    WHERE name = 'cad'
)
BEGIN
    EXEC ('CREATE SCHEMA cad AUTHORIZATION dbo');
END
GO

-------------------------------------------------------------------------------
-- Schema: log (auditoria / rastreabilidade)
-------------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 
    FROM sys.schemas 
    WHERE name = 'log'
)
BEGIN
    EXEC ('CREATE SCHEMA log AUTHORIZATION dbo');
END
GO

-------------------------------------------------------------------------------
-- Schema: dbo
-- Obs: normalmente já existe, mas deixamos explícito
-------------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 
    FROM sys.schemas 
    WHERE name = 'dbo'
)
BEGIN
    EXEC ('CREATE SCHEMA dbo AUTHORIZATION dbo');
END
GO
