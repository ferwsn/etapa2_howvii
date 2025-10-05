    -- CRIAR UMA FUNÇÃO QUE RETORNE LISTA COM TOTAL DE PAGAMENTOS POR MÊS
    -- Criação do select inicial para análise
    SELECT a.dt_periodo,
           SUM(qt_pagamento) AS qt_pagamento
      FROM (SELECT CONCAT(YEAR(dt_pagamento),'/',MONTH(dt_pagamento)) AS dt_periodo,
                   qt_pagamento
              FROM tb_pagamentos) a
  GROUP BY a.dt_periodo

    -- Criar função
    CREATE FUNCTION dbo.consulta_vlrmes (
        @periodo VARCHAR(36)
    )
    RETURNS TABLE AS RETURN (
        SELECT a.qt_pagamento
          FROM (SELECT aa.dt_periodo,
                       SUM(aa.qt_pagamento) AS qt_pagamento
                  FROM (SELECT CONCAT(YEAR(dt_pagamento),'/',MONTH(dt_pagamento)) AS dt_periodo,
                               qt_pagamento
                          FROM tb_pagamentos) aa
              GROUP BY aa.dt_periodo) a
         WHERE a.dt_periodo = @periodo
    );
 
    -- Exemplo de uso
    SELECT *
      FROM dbo.consulta_vlrmes('2023/11');