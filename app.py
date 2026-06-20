from flask import Flask, request, jsonify
import mysql.connector
from dotenv import load_dotenv
import os
from twilio.rest import Client
from datetime import datetime

load_dotenv()
app = Flask(__name__)

# CONFIGURAÇÃO TWILIO
TWILIO_ACCOUNT_SID    = os.getenv("TWILIO_ACCOUNT_SID")
TWILIO_AUTH_TOKEN     = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_WHATSAPP_NUMBER = os.getenv("TWILIO_WHATSAPP_NUMBER")
TWILIO_SMS_NUMBER     = os.getenv("TWILIO_SMS_NUMBER")

twilio_client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

db_config = {
    'host':     os.getenv('DB_HOST'),
    'database': os.getenv('DB_NAME'),
    'user':     os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
}


def get_db_connection():
    return mysql.connector.connect(**db_config)


# ── ENVIO DE MENSAGENS ──────────────────────────────────────────────────────

def enviar_whatsapp(numero, mensagem):
    """Envia mensagem via WhatsApp usando Twilio."""
    try:
        resposta = twilio_client.messages.create(
            from_=f"whatsapp:{TWILIO_WHATSAPP_NUMBER}",
            body=mensagem,
            to=f"whatsapp:{numero}",
        )
        return {"sucesso": True, "sid": resposta.sid, "canal": "whatsapp"}
    except Exception as e:
        return {"sucesso": False, "erro": str(e), "canal": "whatsapp"}


def enviar_sms(numero, mensagem):
    """Envia mensagem via SMS usando Twilio."""
    try:
        resposta = twilio_client.messages.create(
            from_=TWILIO_SMS_NUMBER,
            body=mensagem,
            to=numero,
        )
        return {"sucesso": True, "sid": resposta.sid, "canal": "sms"}
    except Exception as e:
        return {"sucesso": False, "erro": str(e), "canal": "sms"}


# ── TRATAMENTO DE ERROS MySQL ───────────────────────────────────────────────

def tratar_erro_mysql(e):
    """Converte erros do MySQL em mensagens amigáveis."""
    codigo = e.errno
    mensagens = {
        1062: "Registro duplicado: já existe um cadastro com esse CPF, e-mail, celular ou CNPJ.",
        1452: "Registro relacionado não encontrado: verifique se o ID informado existe na tabela correspondente.",
        1451: "Não é possível excluir: este registro está sendo usado em outro cadastro (ex: funcionário com ASO vinculado).",
        1048: "Campo obrigatório não preenchido: verifique se todos os campos foram enviados corretamente.",
        1406: "Valor muito longo para um dos campos. Verifique o tamanho dos dados enviados.",
        1366: "Tipo de dado inválido: um dos campos recebeu um valor no formato incorreto.",
        1146: "Tabela não encontrada no banco de dados. Verifique a configuração do sistema.",
        2003: "Não foi possível conectar ao banco de dados. Verifique se o servidor está ativo.",
    }
    mensagem = mensagens.get(codigo, f"Erro interno no banco de dados. (código {codigo})")
    status   = 409 if codigo in (1062, 1451, 1452) else 500
    return jsonify({"erro": mensagem}), status


# ── CLASSES DE MODELO ───────────────────────────────────────────────────────

class Funcionarios:
    def __init__(self, nome, cpf, cargo, setor, email, id_empresa,
                 data_de_admissao, celular, whatsapp, condicao,
                 data_de_nascimento, id_funcionarios=None):
        self.id_funcionarios    = id_funcionarios
        self.nome               = nome
        self.cpf                = cpf
        self.cargo              = cargo
        self.setor              = setor
        self.email              = email
        self.id_empresa         = id_empresa
        self.data_de_admissao   = data_de_admissao
        self.celular            = celular
        self.whatsapp           = whatsapp
        self.condicao           = condicao
        self.data_de_nascimento = data_de_nascimento


class Aso:
    def __init__(self, id_funcionario, tipo_de_exame, data_de_vencimento,
                 data_de_emissao, resultado, medico_responsavel,
                 observacao, condicao, id_aso=None):
        self.id_aso             = id_aso
        self.id_funcionario     = id_funcionario
        self.tipo_de_exame      = tipo_de_exame
        self.data_de_vencimento = data_de_vencimento
        self.data_de_emissao    = data_de_emissao
        self.resultado          = resultado
        self.medico_responsavel = medico_responsavel
        self.observacao         = observacao
        self.condicao           = condicao


class Empresa:
    def __init__(self, nome_empresa, cnpj, email, telefone, endereco,
                 id_empresa=None):
        self.id_empresa   = id_empresa
        self.nome_empresa = nome_empresa
        self.cnpj         = cnpj
        self.email        = email
        self.telefone     = telefone
        self.endereco     = endereco


class Registro_Exclusao_Aso:
    def __init__(self, id_aso, motivo_exclusao, usuario_exclusao,
                 data_exclusao, id_exclusao=None):
        self.id_exclusao      = id_exclusao
        self.id_aso           = id_aso
        self.motivo_exclusao  = motivo_exclusao
        self.usuario_exclusao = usuario_exclusao
        self.data_exclusao    = data_exclusao


# ── ROTAS – FUNCIONÁRIOS ────────────────────────────────────────────────────

@app.route('/api/funcionarios', methods=['POST'])
def cadastrar_funcionario():
    try:
        dados = request.get_json()
        func  = Funcionarios(
            dados['nome'], dados['cpf'], dados['cargo'], dados['setor'],
            dados['email'], dados['id_empresa'], dados['data_de_admissao'],
            dados['celular'], dados['whatsapp'], dados['condicao'],
            dados['data_de_nascimento'],
        )
        conn   = get_db_connection()
        cursor = conn.cursor()
        sql = """
            INSERT INTO funcionarios
                (nome, cpf, cargo, setor, email, id_empresa,
                 data_de_admissao, celular, whatsapp, condicao, data_de_nascimento)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """
        cursor.execute(sql, (
            func.nome, func.cpf, func.cargo, func.setor, func.email,
            func.id_empresa, func.data_de_admissao, func.celular,
            func.whatsapp, func.condicao, func.data_de_nascimento,
        ))
        conn.commit()
        novo_id = cursor.lastrowid
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "Funcionário cadastrado.", "id": novo_id}), 201

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


@app.route('/api/funcionarios', methods=['GET'])
def consultar_funcionarios():
    try:
        conn   = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM funcionarios")
        resultado = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(resultado), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)


@app.route('/api/funcionarios', methods=['PUT'])
def atualizar_funcionarios():
    try:
        dados = request.get_json()
        func  = Funcionarios(
            dados['nome'], dados['cpf'], dados['cargo'], dados['setor'],
            dados['email'], dados['id_empresa'], dados['data_de_admissao'],
            dados['celular'], dados['whatsapp'], dados['condicao'],
            dados['data_de_nascimento'], dados['id_funcionarios'],
        )
        conn   = get_db_connection()
        cursor = conn.cursor()
        sql = """
            UPDATE funcionarios
            SET nome = %s, cpf = %s, cargo = %s, setor = %s,
                email = %s, id_empresa = %s, data_de_admissao = %s,
                celular = %s, whatsapp = %s, condicao = %s,
                data_de_nascimento = %s
            WHERE id_funcionarios = %s
        """
        cursor.execute(sql, (
            func.nome, func.cpf, func.cargo, func.setor, func.email,
            func.id_empresa, func.data_de_admissao, func.celular,
            func.whatsapp, func.condicao, func.data_de_nascimento,
            func.id_funcionarios,
        ))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "Funcionário atualizado."}), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


@app.route('/api/funcionarios', methods=['DELETE'])
def deletar_funcionarios():
    try:
        dados  = request.get_json()
        conn   = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "DELETE FROM funcionarios WHERE id_funcionarios = %s",
            (dados['id_funcionarios'],),
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "Funcionário deletado."}), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


# ── ROTAS – ASO ─────────────────────────────────────────────────────────────

@app.route('/api/aso', methods=['POST'])
def cadastrar_aso():
    try:
        dados = request.get_json()
        aso   = Aso(
            dados['id_funcionario'], dados['tipo_de_exame'],
            dados['data_de_vencimento'], dados['data_de_emissao'],
            dados['resultado'], dados['medico_responsavel'],
            dados['observacao'], dados['condicao'],
        )
        conn   = get_db_connection()
        cursor = conn.cursor()
        sql = """
            INSERT INTO aso
                (id_funcionario, tipo_de_exame, data_de_vencimento,
                 data_de_emissao, resultado, medico_responsavel,
                 observacao, condicao)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
        """
        cursor.execute(sql, (
            aso.id_funcionario, aso.tipo_de_exame, aso.data_de_vencimento,
            aso.data_de_emissao, aso.resultado, aso.medico_responsavel,
            aso.observacao, aso.condicao,
        ))
        conn.commit()
        novo_id = cursor.lastrowid
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "ASO cadastrado.", "id": novo_id}), 201

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


@app.route('/api/aso', methods=['GET'])
def consultar_aso():
    try:
        conn   = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM aso")
        resultado = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(resultado), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)


@app.route('/api/aso', methods=['PUT'])
def atualizar_aso():
    try:
        dados = request.get_json()
        aso   = Aso(
            dados['id_funcionario'], dados['tipo_de_exame'],
            dados['data_de_vencimento'], dados['data_de_emissao'],
            dados['resultado'], dados['medico_responsavel'],
            dados['observacao'], dados['condicao'], dados['id_aso'],
        )
        conn   = get_db_connection()
        cursor = conn.cursor()
        sql = """
            UPDATE aso
            SET id_funcionario = %s, tipo_de_exame = %s,
                data_de_vencimento = %s, data_de_emissao = %s,
                resultado = %s, medico_responsavel = %s,
                observacao = %s, condicao = %s
            WHERE id_aso = %s
        """
        cursor.execute(sql, (
            aso.id_funcionario, aso.tipo_de_exame, aso.data_de_vencimento,
            aso.data_de_emissao, aso.resultado, aso.medico_responsavel,
            aso.observacao, aso.condicao, aso.id_aso,
        ))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "ASO atualizado."}), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


@app.route('/api/aso', methods=['DELETE'])
def deletar_aso():
    try:
        dados  = request.get_json()
        conn   = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM aso WHERE id_aso = %s", (dados['id_aso'],))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "ASO deletado."}), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


# ── ROTAS – EMPRESA ─────────────────────────────────────────────────────────

@app.route('/api/empresa', methods=['POST'])
def cadastrar_empresa():
    try:
        dados = request.get_json()
        empr  = Empresa(
            dados['nome_empresa'], dados['cnpj'], dados['email'],
            dados['telefone'], dados['endereco'],
        )
        conn   = get_db_connection()
        cursor = conn.cursor()
        sql = """
            INSERT INTO empresa (nome_empresa, cnpj, email, telefone, endereco)
            VALUES (%s,%s,%s,%s,%s)
        """
        cursor.execute(sql, (
            empr.nome_empresa, empr.cnpj, empr.email,
            empr.telefone, empr.endereco,
        ))
        conn.commit()
        novo_id = cursor.lastrowid
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "Empresa cadastrada.", "id": novo_id}), 201

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


@app.route('/api/empresa', methods=['GET'])
def consultar_empresa():
    try:
        conn   = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM empresa")
        resultado = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(resultado), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)


@app.route('/api/empresa', methods=['PUT'])
def atualizar_empresa():
    try:
        dados = request.get_json()
        empr  = Empresa(
            dados['nome_empresa'], dados['cnpj'], dados['email'],
            dados['telefone'], dados['endereco'], dados['id_empresa'],
        )
        conn   = get_db_connection()
        cursor = conn.cursor()
        sql = """
            UPDATE empresa
            SET nome_empresa = %s, cnpj = %s, email = %s,
                telefone = %s, endereco = %s
            WHERE id_empresa = %s
        """
        cursor.execute(sql, (
            empr.nome_empresa, empr.cnpj, empr.email,
            empr.telefone, empr.endereco, empr.id_empresa,
        ))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "Empresa atualizada."}), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


@app.route('/api/empresa', methods=['DELETE'])
def deletar_empresa():
    try:
        dados  = request.get_json()
        conn   = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "DELETE FROM empresa WHERE id_empresa = %s",
            (dados['id_empresa'],),
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "Empresa deletada."}), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


# ── ROTAS – REGISTRO DE EXCLUSÃO DE ASO ────────────────────────────────────

@app.route('/api/registro_exclusao_aso', methods=['POST'])
def cadastrar_exclusao():
    try:
        dados = request.get_json()
        exc   = Registro_Exclusao_Aso(
            dados['id_aso'], dados['motivo_exclusao'],
            dados['usuario_exclusao'], dados['data_exclusao'],
        )
        conn   = get_db_connection()
        cursor = conn.cursor()
        sql = """
            INSERT INTO registro_exclusao_aso
                (id_aso, motivo_exclusao, usuario_exclusao, data_exclusao)
            VALUES (%s,%s,%s,%s)
        """
        cursor.execute(sql, (
            exc.id_aso, exc.motivo_exclusao,
            exc.usuario_exclusao, exc.data_exclusao,
        ))
        conn.commit()
        novo_id = cursor.lastrowid
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "Registro de exclusão cadastrado.", "id": novo_id}), 201

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


@app.route('/api/registro_exclusao_aso', methods=['GET'])
def consultar_registro_exclusao():
    try:
        conn   = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM registro_exclusao_aso")
        resultado = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(resultado), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)


@app.route('/api/registro_exclusao_aso', methods=['PUT'])
def atualizar_registro_exclusao():
    try:
        dados = request.get_json()
        exc   = Registro_Exclusao_Aso(
            dados['id_aso'], dados['motivo_exclusao'],
            dados['usuario_exclusao'], dados['data_exclusao'],
            dados['id_exclusao'],
        )
        conn   = get_db_connection()
        cursor = conn.cursor()
        sql = """
            UPDATE registro_exclusao_aso
            SET id_aso = %s, motivo_exclusao = %s,
                usuario_exclusao = %s, data_exclusao = %s
            WHERE id_exclusao = %s
        """
        cursor.execute(sql, (
            exc.id_aso, exc.motivo_exclusao,
            exc.usuario_exclusao, exc.data_exclusao, exc.id_exclusao,
        ))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "Registro de exclusão atualizado."}), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


@app.route('/api/registro_exclusao_aso', methods=['DELETE'])
def deletar_registro_exclusao_aso():
    try:
        dados  = request.get_json()
        conn   = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "DELETE FROM registro_exclusao_aso WHERE id_exclusao = %s",
            (dados['id_exclusao'],),
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"mensagem": "Registro de exclusão deletado."}), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except KeyError as e:
        return jsonify({"erro": f"Campo obrigatório ausente: {e}"}), 400


# ── ROTAS – TESTES DE ENVIO ─────────────────────────────────────────────────

@app.route('/api/teste-whatsapp', methods=['POST'])
def teste_whatsapp():
    """Endpoint de teste para envio via WhatsApp."""
    dados = request.get_json()
    resultado = enviar_whatsapp(
        dados["numero"],
        "Mensagem de teste enviada pela API de controle de ASO.",
    )
    return jsonify(resultado), 200


@app.route('/api/teste-sms', methods=['POST'])
def teste_sms():
    """Endpoint de teste para envio via SMS."""
    dados = request.get_json()
    resultado = enviar_sms(
        dados["numero"],
        "Mensagem de teste enviada pela API de controle de ASO.",
    )
    return jsonify(resultado), 200


# ── ROTAS – NOTIFICAÇÕES ────────────────────────────────────────────────────

def _montar_mensagem_aso(nome, tipo_de_exame, data_de_vencimento):
    """Monta o texto de notificação de vencimento de ASO."""
    return (
        f"Olá {nome}.\n\n"
        f"Seu ASO está próximo do vencimento.\n\n"
        f"Tipo do exame: {tipo_de_exame}\n"
        f"Data de vencimento: {data_de_vencimento}\n\n"
        f"Favor procurar o RH para renovação."
    )


@app.route('/api/notificar-aso', methods=['POST'])
def notificar_aso():
    """
    Notifica por WhatsApp todos os funcionários com ASO vencendo
    nos próximos 30 dias.
    """
    try:
        conn   = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        sql = """
            SELECT
                a.id_aso,
                a.tipo_de_exame,
                a.data_de_vencimento,
                f.nome,
                f.whatsapp
            FROM aso a
            INNER JOIN funcionarios f ON a.id_funcionario = f.id_funcionarios
            WHERE DATEDIFF(a.data_de_vencimento, CURDATE()) BETWEEN 0 AND 30
        """
        cursor.execute(sql)
        registros = cursor.fetchall()
        cursor.close()
        conn.close()

        resultado = []
        for reg in registros:
            mensagem = _montar_mensagem_aso(
                reg['nome'], reg['tipo_de_exame'], reg['data_de_vencimento']
            )
            envio = enviar_whatsapp(reg['whatsapp'], mensagem)
            resultado.append({
                "id_aso":      reg["id_aso"],
                "funcionario": reg["nome"],
                "resultado":   envio,
            })

        return jsonify(resultado), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except Exception as e:
        return jsonify({"erro": str(e)}), 500


@app.route('/api/notificar-aso-sms', methods=['POST'])
def notificar_aso_sms():
    """
    Notifica por SMS todos os funcionários com ASO vencendo
    nos próximos 30 dias.
    """
    try:
        conn   = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        sql = """
            SELECT
                a.id_aso,
                a.tipo_de_exame,
                a.data_de_vencimento,
                f.nome,
                f.celular
            FROM aso a
            INNER JOIN funcionarios f ON a.id_funcionario = f.id_funcionarios
            WHERE DATEDIFF(a.data_de_vencimento, CURDATE()) BETWEEN 0 AND 30
        """
        cursor.execute(sql)
        registros = cursor.fetchall()
        cursor.close()
        conn.close()

        resultado = []
        for reg in registros:
            mensagem = _montar_mensagem_aso(
                reg['nome'], reg['tipo_de_exame'], reg['data_de_vencimento']
            )
            envio = enviar_sms(reg['celular'], mensagem)
            resultado.append({
                "id_aso":      reg["id_aso"],
                "funcionario": reg["nome"],
                "resultado":   envio,
            })

        return jsonify(resultado), 200

    except mysql.connector.Error as e:
        return tratar_erro_mysql(e)
    except Exception as e:
        return jsonify({"erro": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True)
