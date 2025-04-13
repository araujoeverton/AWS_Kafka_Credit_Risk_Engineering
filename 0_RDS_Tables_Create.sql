CREATE TABLE clientes (
    cliente_id INTEGER PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(14) UNIQUE,
    data_nascimento DATE,
    sexo VARCHAR(10),
    endereco TEXT,
    email VARCHAR(255),
    telefone VARCHAR(20)
);

CREATE TABLE transacoes (
    transacao_id VARCHAR(20) PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(cliente_id),
    data_transacao TIMESTAMP WITHOUT TIME ZONE,
    tipo_transacao VARCHAR(50),
    valor NUMERIC(10, 2),
    descricao VARCHAR(255)
);

CREATE TABLE emprestimos (
    emprestimo_id VARCHAR(20) PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(cliente_id),
    data_solicitacao TIMESTAMP WITHOUT TIME ZONE,
    tipo_emprestimo VARCHAR(50),
    valor_emprestimo NUMERIC(12, 2),
    taxa_juros NUMERIC(5, 4),
    prazo_meses INTEGER,
    data_aprovacao TIMESTAMP WITHOUT TIME ZONE,
    status VARCHAR(20)
);

CREATE TABLE pagamentos (
    pagamento_id VARCHAR(20) PRIMARY KEY,
    emprestimo_id VARCHAR(20) REFERENCES emprestimos(emprestimo_id),
    data_pagamento TIMESTAMP WITHOUT TIME ZONE,
    valor_pago NUMERIC(10, 2),
    status_pagamento VARCHAR(20)
);