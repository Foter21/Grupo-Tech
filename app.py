# Grupo-Tech
from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__) 



db_config = {
    'host': 'localhost',
    
    'database': 'aso_sistema',
    
    'user': 'root', 
    
    'password': 'Helio1505$' 
    
}

def get_db_connection(): 
    
    return mysql.connector.connect(**db_config)
    

class Funcionarios:
    
    def __init__(self, nome, cpf, cargo, setor, email, id_empresa, data_de_admissao, celular, condicao, criado_em, data_de_nascimento, id_funcionarios=None):
        self.id_funcionarios = id_funcionarios
        self.nome = nome 
        self.cpf = cpf 
        self.cargo = cargo 
        self.setor = setor 
        self.email = email
        self.id_empresa = id_empresa
        self.data_de_admissao = data_de_admissao
        self.celular = celular
        self.condicao = condicao
        self.criado_em = criado_em
        self.data_de_nascimento = data_de_nascimento

class Aso:
    def __init__(self, id_funcionario, tipo_de_exame, data_de_vencimento, data_de_emissao, resultado, medico_responsavel, observacao, condicao, criado_em, id_aso=None):
        self.id_aso = id_aso
        self.id_funcionario = id_funcionario
        self.tipo_de_exame = tipo_de_exame
        self.data_de_vencimento = data_de_vencimento
        self.data_de_emissao = data_de_emissao
        self.resultado = resultado
        self.medico_responsavel = medico_responsavel
        self.observacao = observacao
        self.condicao = condicao
        self.criado_em = criado_em
        


class Empresa:
    
    def __init__(self, nome_empresa, cnpj, email, telefone, endereco, criado_em,id_empresa=None):
        self.id_empresa = id_empresa
        self.nome_empresa = nome_empresa
        self.cnpj = cnpj
        self.email = email
        self.telefone = telefone
        self.endereco = endereco
        self.criado_em = criado_em

class Registro_Exclusao_Aso:

    def __init__(self, id_aso, motivo_exclusao, usuario_exclusao, data_exclusao, id_exclusao=None):

        self.id_exclusao = id_exclusao
        self.id_aso = id_aso
        self.motivo_exclusao = motivo_exclusao
        self.usuario_exclusao = usuario_exclusao
        self.data_exclusao = data_exclusao


@app.route('/api/funcionarios', methods=['POST'])

def cadastrar_funcionario():
    dados = request.get_json() 

    func = Funcionarios(dados['nome'], dados['cpf'], dados['cargo'], dados['setor'], dados['email'], dados['id_empresa'], dados['data_de_admissao'], dados['celular'], dados['condicao'], dados['criado_em'], dados['data_de_nascimento'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = 'INSERT INTO funcionarios (nome, cpf, cargo, setor, email, id_empresa, data_de_admissao, celular, condicao, criado_em, data_de_nascimento) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)'

    cursor.execute(sql,(
        func.nome, 
        func.cpf,
        func.cargo,
        func.setor, 
        func.email, 
        func.id_empresa, 
        func.data_de_admissao, 
        func.celular, 
        func.condicao, 
        func.criado_em, 
        func.data_de_nascimento))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify({"mensagem": "Funcionário cadastrado."}), 201


@app.route('/api/funcionarios', methods=['GET'])

def consultar_funcionarios():
    dados = request.get_json()


    func = Funcionarios(dados['nome'], dados['cpf'], dados['cargo'], dados['setor'], dados['email'], dados['id_empresa'], dados['data_de_admissao'], dados['celular'], dados['condicao'], dados['criado_em'], dados['data_de_nascimento'], dados['id_funcionarios'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "SELECT * FROM funcionarios"


    cursor.execute(sql)

    cursor.close()

    conn.close()

    return jsonify({"mensagem": "Funcionario consultado."}), 200


@app.route('/api/funcionarios', methods=['PUT'])

def atualizar_funcionarios():
    dados = request.get_json()

    func = Funcionarios(dados['nome'], dados['cpf'], dados['cargo'], dados['setor'], dados['email'], dados['id_empresa'], dados['data_de_admissao'], dados['celular'], dados['condicao'], dados['criado_em'], dados['data_de_nascimento'], dados['id_funcionarios'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = """
    UPDATE funcionarios
    SET nome = %s,
        cpf = %s,
        cargo = %s,
        setor = %s,
        email = %s,
        id_empresa = %s,
        data_de_admissao = %s,
        celular = %s,
        condicao = %s,
        criado_em = %s,
        data_de_nascimento = %s
    WHERE id_funcionarios = %s
    """

    cursor.execute(sql,(
        func.nome, 
        func.cpf, 
        func.cargo, 
        func.setor, 
        func.email, 
        func.id_empresa, 
        func.data_de_admissao, 
        func.celular, 
        func.condicao, 
        func.criado_em, 
        func.data_de_nascimento,
        func.id_funcionarios ))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify ({"mensagem": "Funcionário atualizado."}), 200


@app.route('/api/funcionarios', methods=['DELETE'])

def deletar_funcionarios():
    dados = request.get_json()
    
    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "DELETE FROM funcionarios WHERE id_funcionarios = %s"

    cursor.execute(sql,( 
        dados['id_funcionarios'],
        ))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify ({"mensagem": "Funcionário deletado."}), 200

@app.route('/api/aso', methods=['POST'])


def cadastrar_aso():
    dados = request.get_json()

    aso = Aso(dados['id_funcionario'], dados['tipo_de_exame'], dados['data_de_vencimento'], dados['data_de_emissao'], dados['resultado'], dados['medico_responsavel'], dados['observacao'], dados['condicao'], dados['criado_em'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "INSERT INTO aso(id_funcionario, tipo_de_exame, data_de_vencimento, data_de_emissao, resultado, medico_responsavel, observacao, condicao, criado_em) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)"

    cursor.execute(sql,(
        aso.id_funcionario,
        aso.tipo_de_exame,
        aso.data_de_vencimento, 
        aso.data_de_emissao, 
        aso.resultado, 
        aso.medico_responsavel,
        aso.observacao, 
        aso.condicao, 
        aso.criado_em,))

    conn.commit()

    cursor.close()
    
    conn.close()

    return jsonify ({"mensagem": "Aso cadastrado."}), 201

@app.route('/api/aso', methods=['GET'])

def consultar_aso():
    dados = request.get_json()

    aso = Aso(dados['tipo_de_exame'], dados['id_funcionario'], dados['data_de_vencimento'], dados['data_de_emissao'], dados['resultado'], dados['medico_responsavel'], dados['observacao'], dados['condicao'], dados['criado_em'], dados['id_aso'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "SELECT * FROM aso"

    cursor.execute(sql)

    cursor.close()

    conn.close()

    return jsonify({"mensagem": "Aso consultada."}), 200

@app.route('/api/aso', methods=['PUT'])

def atualizar_aso():
    dados = request.get_json()

    aso = Aso(dados['id_funcionario'], dados['tipo_de_exame'], dados['data_de_vencimento'], dados['data_de_emissao'], dados['resultado'], dados['medico_responsavel'], dados['observacao'], dados['condicao'], dados['criado_em'], dados['id_aso'],)

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = """
    UPDATE aso
    SET id_funcionario = %s,
        tipo_de_exame = %s,
        data_de_vencimento = %s,
        data_de_emissao = %s,
        resultado = %s,
        medico_responsavel = %s,
        observacao = %s,
        condicao = %s,
        criado_em = %s
    WHERE id_aso = %s
    """


    cursor.execute(sql,(
        aso.id_funcionario,
        aso.tipo_de_exame,
        aso.data_de_vencimento, 
        aso.data_de_emissao, 
        aso.resultado, 
        aso.medico_responsavel, 
        aso.observacao,
        aso.condicao, 
        aso.criado_em,
        aso.id_aso))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify ({"mensagem": "Aso atualizada."}), 200


@app.route('/api/aso', methods=['DELETE'])

def deletar_aso():
    dados = request.get_json()

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "DELETE FROM aso WHERE id_aso = %s"

    cursor.execute(sql,(
        dados['id_aso'],))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify({"mensagem": "Aso deletado."}), 200


@app.route('/api/empresa', methods=['POST'])

def cadastrar_empresa():
    dados = request.get_json()

    empr = Empresa(dados['nome_empresa'], dados['cnpj'], dados['email'], dados['telefone'], dados['endereco'], dados['criado_em'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "INSERT INTO empresa(nome_empresa, cnpj, email, telefone, endereco, criado_em) VALUES (%s,%s,%s,%s,%s,%s)"

    cursor.execute(sql,(
        empr.nome_empresa, 
        empr.cnpj, 
        empr.email, 
        empr.telefone, 
        empr.endereco, 
        empr.criado_em))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify({"mensagem": "Empresa cadastrada."}), 201


@app.route('/api/empresa', methods=['GET'])

def consultar_empresa():
    dados = request.get_json()

    empr = Empresa(dados['nome_empresa'], dados['cnpj'], dados['email'], dados['telefone'], dados['endereco'], dados['criado_em'], dados['id_empresa'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "SELECT * FROM empresa"

    cursor.execute(sql)


    cursor.close()

    conn.close()

    return jsonify({"mensagem": "Empresada consultada."}), 200


@app.route("/api/empresa", methods =["PUT"])

def atualizar_empresa():
    dados = request.get_json()

    empr = Empresa(dados['nome_empresa'], dados['cnpj'], dados['email'], dados['telefone'], dados['endereco'], dados['criado_em'], dados['id_empresa'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = """
    UPDATE empresa
    SET nome_empresa = %s,
        cnpj = %s,
        email = %s,
        telefone = %s,
        endereco = %s,
        criado_em = %s
    WHERE id_empresa = %s
    """

    cursor.execute(sql,(
        empr.nome_empresa, 
        empr.cnpj, 
        empr.email, 
        empr.telefone, 
        empr.endereco, 
        empr.criado_em, 
        empr.id_empresa))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify ({"mensagem": "Empresa atualizada."}), 200


@app.route('/api/empresa', methods=['DELETE'])

def deletar_empresa():
    dados = request.get_json()

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "DELETE FROM empresa WHERE id_empresa = %s"

    cursor.execute(sql,(
        dados['id_empresa'],))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify ({"mensagem": "Empresa deletada."}), 200


@app.route('/api/registro_exclusao_aso', methods=['POST'])

def cadastrar_exclusao():
    dados = request.get_json()

    exc = Registro_Exclusao_Aso(dados['id_aso'], dados['motivo_exclusao'], dados['usuario_exclusao'], dados['data_exclusao'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "INSERT INTO registro_exclusao_aso(id_aso, motivo_exclusao, usuario_exclusao, data_exclusao) VALUES(%s,%s,%s,%s)"

    cursor.execute(sql,(
        exc.id_aso, 
        exc.motivo_exclusao, 
        exc.usuario_exclusao, 
        exc.data_exclusao))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify ({"mensagem": "Registro de exclusão cadastrado."}),201

@app.route('/api/registro_exclusao_aso', methods=['GET'])

def consultar_registro_exclusao():

    dados = request.get_json()

    exc = Registro_Exclusao_Aso(dados['id_aso'], dados['motivo_exclusao'], dados['usuario_exclusao'], dados['data_exclusao'], dados['id_exclusao'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "SELECT * FROM registro_Exclusao_Aso"

    cursor.execute(sql)

    cursor.close()

    conn.close()

    return jsonify ({"mensagem": "Registro de exclusão consultado"}),200


@app.route('/api/registro_exclusao_aso', methods=['PUT'])

def atualizar_registro_exclusao():
    dados = request.get_json()

    exc = Registro_Exclusao_Aso(dados['id_aso'], dados['motivo_exclusao'], dados['usuario_exclusao'], dados['data_exclusao'], dados['id_exclusao'])

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = """
    UPDATE registro_exclusao_aso
    SET id_aso = %s,
        motivo_exclusao = %s,
        usuario_exclusao = %s,
        data_exclusao = %s
    WHERE id_exclusao = %s
    """

    cursor.execute(sql,(
        exc.id_aso, 
        exc.motivo_exclusao, 
        exc.usuario_exclusao, 
        exc.data_exclusao, 
        exc.id_exclusao))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify({"mensagem": "Registro de exclusão atualizado."}), 200

@app.route('/api/registro_exclusao_aso', methods=['DELETE'])

def deletar_registro_exclusao_aso():

    dados = request.get_json()

    conn = get_db_connection()

    cursor = conn.cursor()

    sql = "DELETE FROM registro_exclusao_aso WHERE id_exclusao = %s"

    cursor.execute(sql,(
        dados['id_exclusao'],))

    conn.commit()

    cursor.close()

    conn.close()

    return jsonify({"mensagem": "Registro de exclusão deletado"}),200

if __name__ == "__main__":
    app.run(debug=True)
