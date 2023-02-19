
DROP DATABASE IF exists ladycake
GO

CREATE DATABASE ladycake
ON PRIMARY
(
	NAME = 'primary',
	FILENAME = 'C:\path\ladycake_primary.ndf',
	SIZE = 1024MB,
	MAXSIZE = 1024MB
),

FILEGROUP dados
(
	NAME = 'DadosTransacionais1',                 
	FILENAME = 'C:\path\ladycake_Second1.ndf', 
	SIZE = 1024MB,
	MAXSIZE = 2GB
),

FILEGROUP indices 
( 
	NAME = 'indicesTransacionais', 
	FILENAME = 'C:\path\ladycake_indices.ndf', 
	SIZE = 512MB,
	MAXSIZE = 512MB
 )

LOG ON 
 (
	NAME = 'Log', 
	FILENAME = 'C:\path\ladycake_Log.ldf', 
	SIZE = 512MB 
)
GO

ALTER DATABASE [ladycake] MODIFY FILEGROUP [dados] DEFAULT 
GO

USE ladycake;

GO
CREATE TABLE medidas
(
    peso varchar(10) not null,
    tamanho_forma varchar(12) not null,
    fatias_100g tinyint not null,
    valor float not null,
    PRIMARY KEY (peso)
);

CREATE TABLE tradicional_adicional
(
    id_tradicional_adicional tinyint not null identity(1,1),
    tradicional_adicional bit not null,
    valor_adicional float,
    PRIMARY KEY (id_tradicional_adicional)
);

CREATE TABLE recheios
(
    id_recheios tinyint not null identity(1,1),
    recheio varchar(50) not null,
    id_tradicional_adicional tinyint,
    PRIMARY KEY (id_recheios),
    CONSTRAINT fk_recheios_tradiciional_adicional FOREIGN KEY (id_tradicional_adicional) 
    REFERENCES tradicional_adicional(id_tradicional_adicional)
);

CREATE TABLE massas
(
    id_massas tinyint not null identity(1,1),
    massa varchar(20) not null,
    PRIMARY KEY (id_massas)
);

CREATE TABLE topper
(
    topper bit not null,
    valor float,
    PRIMARY KEY (topper)
);

CREATE TABLE clientes
(
    id_clientes int not null identity(1,1),
    nome varchar(40) not null,
    endereco varchar(45),
    ddd tinyint not null,
    celular char(9) not null,
    PRIMARY KEY (id_clientes)
);

CREATE TABLE pedidos
(
    id_pedidos int not null identity(1,1),
    id_clientes int not null,
    PRIMARY KEY (id_pedidos),
    CONSTRAINT fk_pedidos_clientes FOREIGN KEY (id_clientes) REFERENCES clientes(id_clientes)
);

CREATE TABLE adicional
(
	id_adicional int not null identity(1,1),
	dv_adicional bit not null,
	nm_adicional varchar(50),
	vl_adicional float,
	PRIMARY KEY (id_adicional)
);

CREATE TABLE desconto
(
	id_desconto int not null identity(1,1),
	dv_desconto bit not null,
	nm_desconto varchar(50),
	vl_desconto float,
	PRIMARY KEY (id_desconto)
);

CREATE TABLE entrega
(
	id_entrega int not null identity(1,1),
	dv_endrega bit not null,
	endereco_entrega varchar(50),
	vl_entrega float,
	PRIMARY KEY (id_entrega)
);

CREATE TABLE detalhes_vendas
(
    id_detalhes_vendas int not null identity(1,1),
    id_pedidos int not null,
    quantidade tinyint not null,
    dt_pedido smalldatetime not null,
    dt_entrega smalldatetime not null,
    peso varchar(10) not null,
    id_recheios tinyint not null,
    id_massas tinyint not null,
    topper bit not null,
    tema varchar(45),
    evento varchar(50),
    id_entrega int not null,
    id_adicional int not null,
    id_desconto int not null,
    valor float not null,
    PRIMARY KEY (id_detalhes_vendas),
    CONSTRAINT fk_detalhes_v_pedidos	FOREIGN KEY (id_pedidos)	REFERENCES pedidos	(id_pedidos),
    CONSTRAINT fk_detalhes_v_medidas	FOREIGN KEY (peso)		REFERENCES medidas	(peso),
    CONSTRAINT fk_detalhes_v_recheios	FOREIGN KEY (id_recheios)	REFERENCES recheios	(id_recheios),
    CONSTRAINT fk_detalhes_v_massas	FOREIGN KEY (id_massas)		REFERENCES massas	(id_massas),
    CONSTRAINT fk_detalhes_v_topper	FOREIGN KEY (topper)		REFERENCES topper	(topper)
);

CREATE TABLE lucro_vendas
(
    id_lucro_vendas int not null identity(1,1),
    id_pedidos int not null,
    gasto_em_compra float not null,
    gasto_no_bolo float not null,
    lucro_total float not null,
    lucro_bruto float not null,
    PRIMARY KEY (id_lucro_vendas),
    CONSTRAINT fk_lucros_pedidos FOREIGN KEY (id_pedidos) REFERENCES pedidos(id_pedidos)
);

CREATE TABLE lucro_mensal
(
	mes varchar(20) not null,
	lucro_total float not null,
	lucro_bruto float not null
	PRIMARY KEY (mes)
);

CREATE  INDEX Idx_recheios		ON recheios		(recheio)	ON indices

CREATE  INDEX Idx_clientes		ON clientes		(celular, nome)	ON indices

CREATE  INDEX Idx_pedidos_clientes	ON pedidos		(id_clientes)	ON indices

CREATE  INDEX Indx_dv_pedidos		ON detalhes_vendas	(id_pedidos)	ON indices

CREATE  INDEX Indx_dv_dt_pedido		ON detalhes_vendas	(dt_pedido)	ON indices

CREATE  INDEX Indx_dv_dt_entrega	ON detalhes_vendas	(dt_entrega)	ON indices

CREATE  INDEX Indx_dv_peso		ON detalhes_vendas	(peso)		ON indices

CREATE  INDEX Indx_dv_id_recheios	ON detalhes_vendas	(id_recheios)	ON indices

CREATE  INDEX Indx_dv_topper		ON detalhes_vendas	(topper)	ON indices

