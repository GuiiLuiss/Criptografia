# Criptografia
Criptografia no banco SQL Server

Imagine uma tabela que contenha as seguintes colunas: Login, Senha, DicaSenha 
O objetivo é automatizar os processos de armazenamento e utilização das informações utilizando-se de criptografia da seguinte maneira:
- Login, não precisa nem deve ser criptografado na base
- Senha, deve ser armazenado com criptografia 1-WAY
- Dica_senha, deve ser armazenado com criptografia 2-WAY

Depois:
- Utilizando-se das procedures/funções criadas, insira valores na tabela obedecendo às recomendações.
- Crie uma procedure ou função que: dado um login e senha, devolva “1” se validado e “0” caso contrário.
- Crie uma procedure ou função que: dado um login, devolva a dica da senha, decriptografada.

