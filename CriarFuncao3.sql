    -- CRIAR UMA FUNÇÃO QUE RETORNE PERCENTUAL DE PAGAMENTO POR TIPO DE IMOVEL
    -- Criação do select inicial para análise
    SELECT *
      FROM (SELECT a.ds_tpimovel,
                   ROUND((CAST(a.qt_pagamento AS FLOAT) / CAST(b.qt_pagamento AS FLOAT)) * 100, 2) AS perc_pagamento
              FROM (SELECT tpi.ds_tpimovel,
                           SUM(pag.qt_pagamento) AS qt_pagamento
                      FROM tb_tpimovel tpi,
                           tb_imoveis imv
                           LEFT JOIN tb_pagamentos pag
                                  ON imv.cd_imovel = pag.cd_imovel
                     WHERE tpi.cd_tpimovel = imv.tp_imovel
                  GROUP BY tpi.ds_tpimovel) a,
                   (SELECT SUM(pag.qt_pagamento) AS qt_pagamento
                      FROM tb_pagamentos pag) b) perc

    -- Criar função
    CREATE FUNCTION dbo.consulta_perctpimv (
        @tpimovel VARCHAR(36)
    )
    RETURNS TABLE AS RETURN (
        SELECT perc.perc_pagamento
          FROM (SELECT a.ds_tpimovel,
                       ROUND((CAST(a.qt_pagamento AS FLOAT) / CAST(b.qt_pagamento AS FLOAT)) * 100, 2) AS perc_pagamento
                  FROM (SELECT tpi.ds_tpimovel,
                               SUM(pag.qt_pagamento) AS qt_pagamento
                          FROM tb_tpimovel tpi,
                               tb_imoveis imv
                               LEFT JOIN tb_pagamentos pag
                                      ON imv.cd_imovel = pag.cd_imovel
                         WHERE tpi.cd_tpimovel = imv.tp_imovel
                      GROUP BY tpi.ds_tpimovel) a,
                       (SELECT SUM(pag.qt_pagamento) AS qt_pagamento
                          FROM tb_pagamentos pag) b) perc
         WHERE perc.ds_tpimovel = @tpimovel
    );

    -- Exemplo de uso
    SELECT *
      FROM dbo.consulta_perctpimv('CASA');