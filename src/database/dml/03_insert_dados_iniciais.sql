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
   - Dados da tabela_pessoas são fictícios e utilizados
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
INSERT INTO dbo.tabela_recheios
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
INSERT INTO dbo.tabela_massas
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
INSERT INTO dbo.tabela_adicionais
    (nm_adicional, vl_adicional, dv_ativo)
VALUES
    ('Topper personalizado', 15.00, 1),
    ('Embalagem especial',   10.00, 1),
    ('Entrega expressa',     20.00, 1),
    ('Mensagem personalizada', 5.00, 1)
GO

--------------------------------------------------------
-- tabela_grp_status
--------------------------------------------------------
INSERT INTO dbo.tabela_grp_status
    (nm_grp_descricao, cd_grp_status, dv_ativo)
VALUES
    ('Pedido', 1, 1),
    ('Item do pedido', 2, 1),
    ('Pagamento', 3, 1)
GO

--------------------------------------------------------
-- Status do Pedido
--------------------------------------------------------
INSERT INTO dbo.tabela_status
    (cd_status, nm_descricao, id_grp_status, dv_ativo, dv_permite_exclusao)
SELECT
		s.cd_status,
		s.nm_descricao,
		g.id_grp_status,
		1,
		dv_permite_exclusao
FROM	(
			SELECT	cd_status = 'A', 
					nm_descricao = 'Aberto',
					nm_grp_descricao = 'Pedido',
					dv_permite_exclusao = 1
			UNION ALL 
			SELECT	cd_status = 'F',
					nm_descricao =  'Finalizado',
					nm_grp_descricao = 'Pedido',
					dv_permite_exclusao = 0
			UNION ALL 
			SELECT	cd_status = 'C',
					nm_descricao = 'Cancelado',
					nm_grp_descricao = 'Pedido',
					dv_permite_exclusao = 1

			UNION ALL
			SELECT	cd_status = 'A', 
					nm_descricao = 'Ativo',
					nm_grp_descricao = 'Item do pedido',
					dv_permite_exclusao = 1
			UNION ALL 
			SELECT	cd_status = 'F',
					nm_descricao =  'Finalizado',
					nm_grp_descricao = 'Item do pedido',
					dv_permite_exclusao = 0
			UNION ALL 
			SELECT	cd_status = 'C',
					nm_descricao = 'Cancelado',
					nm_grp_descricao = 'Item do pedido',
					dv_permite_exclusao = 1

			UNION ALL
			SELECT	cd_status = 'P', 
					nm_descricao = 'Pendente',
					nm_grp_descricao = 'Pagamento',
					dv_permite_exclusao = 1
			UNION ALL 
			SELECT	cd_status = 'Q',
					nm_descricao =  'Quitado',
					nm_grp_descricao = 'Pagamento',
					dv_permite_exclusao = 0
			UNION ALL 
			SELECT	cd_status = 'C',
					nm_descricao = 'Cancelado',
					nm_grp_descricao = 'Pagamento',
					dv_permite_exclusao = 1
		) s
JOIN	dbo.tabela_grp_status g
ON		g.nm_grp_descricao = s.nm_grp_descricao
GO

INSERT INTO cad.tabela_tipo_contatos
(
    cd_tipo_contato,
    nm_tipo_contato,
    dv_ativo,
    dt_inclusao,
    dt_alteracao
)
VALUES
    ('EMA', 'E-mail',           1, GETDATE(), NULL),
    ('CEL', 'Celular',          1, GETDATE(), NULL),
    ('TEL', 'Telefone fixo',    1, GETDATE(), NULL),
    ('WPP', 'WhatsApp',         1, GETDATE(), NULL);
GO

INSERT INTO cad.tabela_tipo_enderecos
(
    cd_tipo_endereco,
    nm_tipo_endereco,
    dv_ativo,
    dt_inclusao,
    dt_alteracao
)
VALUES
    ('RES', 'Residencial', 1, GETDATE(), NULL),
    ('COM', 'Comercial',   1, GETDATE(), NULL),
    ('ENT', 'Entrega',     1, GETDATE(), NULL),
    ('COB', 'Cobrança',    1, GETDATE(), NULL);
GO

INSERT INTO cad.tabela_papeis
(
    cd_papel,
    nm_papel,
    dv_ativo,
    dt_inclusao,
    dt_alteracao
)
VALUES
    ('C', 'Cliente',             1, GETDATE(), NULL),
    ('F', 'Fornecedor',          1, GETDATE(), NULL),
    ('U', 'Usuário do sistema',  1, GETDATE(), NULL),
    ('A', 'Administrador',       1, GETDATE(), NULL),
    ('E', 'Funcionário',         1, GETDATE(), NULL);
