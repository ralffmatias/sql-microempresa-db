USE ladycake
GO

/*
========================================================
 Script: 02_insert_dados_iniciais.sql
 Projeto: LadyCake
 Tipo: DML / Seed Data

 Descrição:
   - Inserção dos dados iniciais do sistema LadyCake
   - Contém produtos reais utilizados pela empresa
     (medidas, massas, recheios e adicionais)
   - Dados da tabela_clientes são fictícios e utilizados
     exclusivamente para testes e desenvolvimento local

 Observações:
   - Script destinado a ambiente de estudo e portfólio
   - Não utilizar em produção sem validação prévia
========================================================
*/


--------------------------------------------------------
-- tabela_medidas
--------------------------------------------------------
INSERT INTO dbo.tabela_medidas
    (nm_peso, nm_tamanho_forma, nr_fatias_100g, vl_preco)
VALUES
    ('1Kg',   '13cm X 10cm', 10,  50.00),
    ('1,5Kg', '15cm X 10cm', 15,  75.00),
    ('2Kg',   '20cm X 10cm', 20, 100.00),
    ('3Kg',   '26cm X 10cm', 25, 150.00),
    ('4Kg',   '30cm X 10cm', 30, 200.00)
GO

--------------------------------------------------------
-- tabela_recheios
-- dv_especial:
-- 0 = padrão
-- 1 = especial (valor adicional)
--------------------------------------------------------
INSERT INTO dbo.tabela_recheios
    (nm_recheio, dv_especial, vl_especial)
VALUES
    ('Brigadeiro',                0, NULL),
    ('Beijinho',                  0, NULL),
    ('Prestígio',                 0, NULL),
    ('Doce de leite',             0, NULL),
    ('Brigadeiro branco',         0, NULL),
    ('Mousse de brigadeiro',      0, NULL),
    ('Brigadeiro de ninho',       1, 10.00),
    ('Mousse de ninho',           1, 10.00),
    ('Sensação',                  1, 12.00),
    ('Ninho com frutas',          1, 15.00),
    ('Ninho com coco',            1, 12.00),
    ('Brigadeiro com frutas',     1, 15.00),
    ('Coco com abacaxi',          1, 12.00)
GO

--------------------------------------------------------
-- tabela_massas
--------------------------------------------------------
INSERT INTO dbo.tabela_massas
    (nm_massa)
VALUES
    ('Pão de ló'),
    ('Chocolate'),
    ('Red velvet'),
    ('Amanteigada')
GO

--------------------------------------------------------
-- tabela_clientes
--------------------------------------------------------
INSERT INTO dbo.tabela_clientes
    (nm_cliente, nm_cpf_cnpj, nm_endereco, nm_ddd, nm_celular)
VALUES
    ('Cliente 1', NULL, NULL, '61', '999999991'),
    ('Cliente 2', NULL, NULL, '61', '999999992'),
    ('Cliente 3', NULL, NULL, '61', '999999993'),
    ('Cliente 4', NULL, NULL, '61', '999999994')
GO

--------------------------------------------------------
-- tabela_adicionais
--------------------------------------------------------
INSERT INTO dbo.tabela_adicionais
    (nm_adicional, vl_adicional)
VALUES
    ('Topper personalizado', 15.00),
    ('Embalagem especial',   10.00),
    ('Entrega expressa',     20.00),
    ('Mensagem personalizada', 5.00)
GO
