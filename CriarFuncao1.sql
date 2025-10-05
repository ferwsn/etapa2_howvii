	-- CRIAR UMA FUN��O QUE RETORNE UMA LISTA COM ID DE CADA IMOVEL + SOMA DE TODOS OS PAGAMENTOS
	-- Cria��o do select inicial para an�lise
	SELECT *
	  FROM (SELECT imv.cd_imovel,
				   SUM(pag.qt_pagamento) AS qt_pagamento
			  FROM tb_imoveis imv,
				   tb_pagamentos pag
			 WHERE imv.cd_imovel = pag.cd_imovel
		  GROUP BY imv.cd_imovel
				   UNION ALL
			SELECT imv2.cd_imovel,
				   '0' AS qt_pagamento
			  FROM tb_imoveis imv2
			 WHERE imv2.cd_imovel NOT IN (SELECT pag2.cd_imovel
											FROM tb_pagamentos pag2)) a
  ORDER BY a.cd_imovel;

	-- Cria��o de nova tabela
	CREATE TABLE [tb_histpag] (
		[cd_imovel] INT,
		[qt_pagamento] NUMERIC(10,2)
	);
	GO

	-- Inser��o de dados na tabela
	INSERT INTO [tb_histpag] ([cd_imovel], [qt_pagamento])
	SELECT *
	  FROM (SELECT imv.cd_imovel,
   				   SUM(pag.qt_pagamento) AS qt_pagamento
			  FROM tb_imoveis imv,
				   tb_pagamentos pag
			 WHERE imv.cd_imovel = pag.cd_imovel
		  GROUP BY imv.cd_imovel
				   UNION ALL
			SELECT imv2.cd_imovel,
				   '0' AS qt_pagamento
			  FROM tb_imoveis imv2
			 WHERE imv2.cd_imovel NOT IN (SELECT pag2.cd_imovel
											FROM tb_pagamentos pag2)) a
  ORDER BY a.cd_imovel;
  GO

	-- Cria��o de fun��o
	CREATE FUNCTION dbo.consulta_pagimovel (
		@imovel INT
	)
	RETURNS TABLE AS RETURN (
	   SELECT qt_pagamento
		 FROM tb_histpag
		WHERE cd_imovel = @imovel
	);

	-- Exemplo de uso
	SELECT *
	  FROM dbo.consulta_pagimovel(101);
