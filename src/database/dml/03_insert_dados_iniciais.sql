USE ladycake
GO

/*
========================================================
 Script: 03_insert_dados_iniciais.sql
 Projeto: LadyCake
 Tipo: DML / Seed Data

 Descrição:
   - Inserção dos dados iniciais do sistema LadyCake
   - Contém produtos reais utilizados pela empresa
     (medidas, massas, recheios e adicionais)

 Observações:
   - Script destinado a ambiente de estudo e portfólio
   - Não utilizar em produção sem validação prévia
========================================================
*/


--------------------------------------------------------
-- tabela_medidas
--------------------------------------------------------
INSERT INTO prod.tabela_medidas
    (nm_peso, nm_tamanho_forma, nr_fatias_100g, vl_preco, dv_ativo)
VALUES
    ('1Kg',   '13cm X 10cm', 10,  50.00, 1),
    ('1,5Kg', '15cm X 10cm', 15,  75.00, 1),
    ('2Kg',   '20cm X 10cm', 20, 100.00, 1),
    ('3Kg',   '26cm X 10cm', 25, 150.00, 1),
    ('4Kg',   '30cm X 10cm', 30, 200.00, 1)
GO

--------------------------------------------------------
-- tabela_recheios
-- dv_especial:
-- 0 = padrão
-- 1 = especial (valor adicional)
--------------------------------------------------------
INSERT INTO prod.tabela_recheios
    (nm_recheio, dv_especial, vl_especial, dv_ativo)
VALUES
    ('Brigadeiro',                0, 0.00, 1),
    ('Beijinho',                  0, 0.00, 1),
    ('Prestígio',                 0, 0.00, 1),
    ('Doce de leite',             0, 0.00, 1),
    ('Brigadeiro branco',         0, 0.00, 1),
    ('Mousse de brigadeiro',      0, 0.00, 1),
    ('Brigadeiro de ninho',       1, 10.00, 1),
    ('Mousse de ninho',           1, 10.00, 1),
    ('Sensação',                  1, 12.00, 1),
    ('Ninho com frutas',          1, 15.00, 1),
    ('Ninho com coco',            1, 12.00, 1),
    ('Brigadeiro com frutas',     1, 15.00, 1),
    ('Coco com abacaxi',          1, 12.00, 1)
GO

--------------------------------------------------------
-- tabela_massas
--------------------------------------------------------
INSERT INTO prod.tabela_massas
    (nm_massa, dv_ativo)
VALUES
    ('Pão de ló', 1),
    ('Chocolate', 1),
    ('Red velvet', 1),
    ('Amanteigada', 1)
GO

--------------------------------------------------------
-- tabela_adicionais
--------------------------------------------------------
INSERT INTO prod.tabela_adicionais
    (nm_adicional, vl_adicional, dv_ativo)
VALUES
    ('Topper personalizado', 15.00, 1),
    ('Embalagem especial',   10.00, 1),
    ('Entrega expressa',     20.00, 1),
    ('Mensagem personalizada', 5.00, 1)
GO
