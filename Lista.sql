-- =====================================================
-- Projeto: Gerenciamento de Alunos, Disciplinas e Professores
-- Plataforma: Oracle Live SQL
-- Autor: Lucas
-- Data: 07/12/2024
-- Descrição: Criação de tabelas, inserção de dados e pacotes
-- =====================================================



CREATE TABLE alunos (
    id_aluno NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    data_nascimento DATE
);

CREATE TABLE disciplinas (
    id_disciplina NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    descricao VARCHAR2(200),
    carga_horaria NUMBER
);

CREATE TABLE matriculas (
    id_matricula NUMBER PRIMARY KEY,
    id_aluno NUMBER REFERENCES alunos(id_aluno),
    id_disciplina NUMBER REFERENCES disciplinas(id_disciplina)
);

CREATE TABLE professores (
    id_professor NUMBER PRIMARY KEY,
    nome VARCHAR2(100)
);

CREATE TABLE turmas (
    id_turma NUMBER PRIMARY KEY,
    id_disciplina NUMBER REFERENCES disciplinas(id_disciplina),
    id_professor NUMBER REFERENCES professores(id_professor)
);



INSERT INTO alunos (id_aluno, nome, data_nascimento) VALUES (1, 'Lucas', TO_DATE('2000-01-01', 'YYYY-MM-DD'));
INSERT INTO disciplinas (id_disciplina, nome, descricao, carga_horaria) VALUES (1, 'Matemática', 'Cálculo básico', 40);
INSERT INTO matriculas (id_matricula, id_aluno, id_disciplina) VALUES (1, 1, 1);
INSERT INTO professores (id_professor, nome) VALUES (1, 'Professor A');
INSERT INTO turmas (id_turma, id_disciplina, id_professor) VALUES (1, 1, 1);


-- Pacote PKG_ALUNO
CREATE OR REPLACE PACKAGE PKG_ALUNO AS
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER);
END PKG_ALUNO;
/

CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER) IS
    BEGIN
        DELETE FROM matriculas WHERE id_aluno = p_id_aluno;
        DELETE FROM alunos WHERE id_aluno = p_id_aluno;
    END excluir_aluno;
END PKG_ALUNO;
/

-- Pacote PKG_DISCIPLINA
CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
    PROCEDURE cadastrar_disciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER);
END PKG_DISCIPLINA;
/

CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS
    PROCEDURE cadastrar_disciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER) IS
    BEGIN
        INSERT INTO disciplinas (nome, descricao, carga_horaria)
        VALUES (p_nome, p_descricao, p_carga_horaria);
    END cadastrar_disciplina;
END PKG_DISCIPLINA;
/

-- Pacote PKG_PROFESSOR
CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS
    FUNCTION total_turmas_professor(p_id_professor NUMBER) RETURN NUMBER;
END PKG_PROFESSOR;
/

CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS
    FUNCTION total_turmas_professor(p_id_professor NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total
        FROM turmas
        WHERE id_professor = p_id_professor;

        RETURN v_total;
    END total_turmas_professor;
END PKG_PROFESSOR;
/



-- Testar aluno
BEGIN
    PKG_ALUNO.excluir_aluno(1);
END;
/

-- Testar cadastro de disciplina
BEGIN
    PKG_DISCIPLINA.cadastrar_disciplina('Física', 'Mecânica Clássica', 60);
END;
/

-- Testar total de turmas de um professor
SELECT PKG_PROFESSOR.total_turmas_professor(1) FROM dual;
