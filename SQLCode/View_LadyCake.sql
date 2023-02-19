
USE ladycake

go
CREATE VIEW vw_visao_vendas
	AS
	SELECT 
				cl.nome				AS cliente,		dv.quantidade, 
				dv.peso,							ms.massa,
				rch.recheio,						tp.topper, 
				dv.tema,							dv.evento, 
				dv.dt_entrega,						ent.vl_entrega,
				ds.vl_desconto,						ds.nm_desconto,	
				ad.vl_adicional,					ad.nm_adicional,
				dv.valor,							lv.lucro_total	
				
	AS			lucro
	FROM		clientes cl
	JOIN		
				pedidos pd
	ON			cl.id_clientes				=		pd.id_clientes
	JOIN
				detalhes_vendas dv
	ON			pd.id_pedidos				=		dv.id_pedidos
	JOIN		
				massas ms
	ON			ms.id_massas				=		dv.id_massas
	JOIN		
				recheios rch
	ON			rch.id_recheios				=		dv.id_recheios
	JOIN
				topper tp
	ON			tp.topper					=		dv.topper
	JOIN		
				entrega ent
	ON			ent.id_entrega				=		dv.id_entrega
	JOIN		
				adicional ad
	ON			ad.id_adicional				=		dv.id_adicional
	JOIN		
				desconto ds
	ON			ds.id_desconto				=		dv.id_desconto
	JOIN		
				lucro_vendas lv
	ON			lv.id_pedidos				=		dv.id_pedidos

