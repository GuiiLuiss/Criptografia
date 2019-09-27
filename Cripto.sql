IF EXISTS (SELECT * FROM sys.tables WHERE name = 'TBL_CTRL_ACESSO')
BEGIN
  DROP TABLE TBL_CTRL_ACESSO
END
GO

--Criando a tabela 'TBL_CTRL_ACESSO'
CREATE TABLE TBL_CTRL_ACESSO(
	Login VARCHAR(50),
	Senha VARBINARY(MAX),
	DicaSenha VARBINARY(MAX),
	CONSTRAINT pkLogin Primary Key (Login));

--Função 1-WAY (HASH)
CREATE FUNCTION pr_hash (@texto VARCHAR(100))
RETURNS VARCHAR (1000)
BEGIN
	DECLARE @salt VARCHAR(15) = 'Interative'
	RETURN (SELECT HASHBYTES('md5',@texto + @salt))
END
--Testanto a função: SELECT dbo.pr_hash('Amor')

--Criando a Chave Simétrica
CREATE SYMMETRIC KEY ChaveSimetrica01 
WITH ALGORITHM = AES_256
ENCRYPTION BY PASSWORD = N'!@@QW#E#$R%dreud76'
--Abrindo a chave
OPEN SYMMETRIC KEY ChaveSimetrica01 DECRYPTION BY PASSWORD = N'!@@QW#E#$R%dreud76';

--Função 2-WAY (pr_encrypt)
CREATE FUNCTION pr_encrypt (@texto VARCHAR(100))
RETURNS VARBINARY(MAX)
BEGIN
	DECLARE @key UNIQUEIDENTIFIER = (select Key_GUID('ChaveSimetrica01'))
	--Criptografando o texto
	DECLARE @resultado VARBINARY(MAX)
	SELECT @resultado = ENCRYPTBYKEY(@key, @texto)
	RETURN @resultado
END
--Testando função pr_encrypt: SELECT dbo.pr_encrypt('Faculdade Impacta')

--Função 2-WAY (pr_decrypt)
CREATE FUNCTION pr_decrypt(@cripto VARBINARY(max))
RETURNS VARCHAR(max)
BEGIN
	RETURN(SELECT CONVERT(VARCHAR,DECRYPTBYKEY(@cripto)))
END
--Testando função pr_decrypt: SELECT dbo.pr_decrypt(0x004C9F1586333545A07EA73E7FE7B23D020000006099934060A4D83D3E34EFF069D8B91AECB3C939073B9D22A5D42EA8EAEBC2F6F85E412F70C6ACE7295682030F8A6995)

--Inserindo dados na tabela TBL_CTRL_ACESSO:
INSERT INTO 
TBL_CTRL_ACESSO(Login, Senha, DicaSenha)
VALUES
('Mayarinha', CONVERT(VARBINARY, dbo.pr_hash ('Dashboard')), dbo.pr_encrypt('O que eu mais amo')),
('Gordão123', CONVERT(VARBINARY, dbo.pr_hash ('SESC')), dbo.pr_encrypt('Onde eu almoço todo final de semana')),
('DididiPower', CONVERT(VARBINARY, dbo.pr_hash ('Me efetiva dildil')), dbo.pr_encrypt('i4pro'))
--Testando inserção: SELECT * FROM TBL_CTRL_ACESSO

--Criando função pr_login 
CREATE FUNCTION pr_login (@login varchar(50),@senha varchar(50))
RETURNS BIT 
BEGIN
	DECLARE @confirma bit
	SELECT @confirma =  COUNT(*) FROM TBL_CTRL_ACESSO WHERE	Login = @login AND Senha = dbo.pr_hash (@senha)
	IF @confirma = 1
	BEGIN
		 SELECT @confirma = 1
	END
	ELSE
	BEGIN 
		SELECT @confirma = 0
	END
RETURN @confirma
END
--Testando função pr_login: SELECT dbo.pr_login('Mayarinha','Dashboard')

--Criando função pr_esqueci_senha
CREATE FUNCTION pr_esqueci_senha (@login varchar(50))
RETURNS VARCHAR (100)
BEGIN
	RETURN (SELECT dbo.pr_decrypt(DicaSenha) FROM TBL_CTRL_ACESSO WHERE Login = @login)
END
--Testando função pr_esqueci_senha: SELECT dbo.pr_esqueci_senha('Mayarinha')
