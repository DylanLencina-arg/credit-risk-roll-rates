WITH Bloque_A_Bucketing AS (
	SELECT SK_ID_CURR,MONTHS_BALANCE,AMT_BALANCE, 
		CASE 
			WHEN SK_DPD =0 THEN '1.AL DIA'
			WHEN SK_DPD BETWEEN 1 AND 30 THEN '2.1-30'
			WHEN SK_DPD BETWEEN 31 AND 60 THEN '3.31-60'
			ELSE '4.+60'
		END AS ESTADO_MORA
	FROM BALANCE_TARJETA_DE_CREDIT
),
Bloque_B_Viaje_en_el_tiempo as(
	SELECT 
		sk_id_curr,
		months_balance,
		amt_balance,
		estado_mora as estado_actual,
		lag	(estado_mora) over (partition by sk_id_curr order by months_balance asc) as estado_anterior
	from Bloque_a_bucketing
)
SELECT 
	ESTADO_ANTERIOR,
	ESTADO_ACTUAL,
	COUNT (SK_ID_CURR) AS CANTIDAD_CUENTAS,
	SUM (AMT_BALANCE) AS SALDO_TOTAL
FROM Bloque_B_Viaje_en_el_tiempo
WHERE ESTADO_ANTERIOR IS NOT NULL
GROUP BY
	ESTADO_ANTERIOR,
	ESTADO_ACTUAL;
	