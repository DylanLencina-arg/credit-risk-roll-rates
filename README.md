# 📊 Credit Risk & Roll Rate Transition Matrix Analysis

## 🎯 Objetivo de Negocio
Este proyecto evalúa el comportamiento de pago y el deterioro de la cartera de crédito B2C (Home Credit Dataset) mediante el cálculo de **Matrices de Transición (*Roll Rates*)**. El análisis busca identificar la tasa de rotación de mora entre periodos consecutivos para mitigar pérdidas crediticias, optimizar la provisión de balance y alimentar estrategias de cobranza temprana.

---

## 🛠️ Stack Tecnológico
* **Base de Datos & ETL:** PostgreSQL 18 (Consultas avanzadas con CTEs y Window Functions).
* **Visualización & BI:** Power BI Desktop (Visualización de matrices, 100% Stacked Bar Charts y Paleta Semántica de Riesgo).
* **Dataset:** `credit_card_balance.csv` (~3.8M registros procesados).

---

## 📐 Metodología TÉCNICA (SQL Pipeline)

El procesamiento de los datos se dividió en tres capas de abstracción dentro de PostgreSQL:

1. **Segmentación de Mora (*Bucketing*):** Estandarización de los días de atraso (`SK_DPD`) en tramos operativos de riesgo (`1. AL DIA`, `2. 1-30`, `3. 31-60`, `4. +60`).
2. **Análisis Longitudinal Temporal (*Time-Travel*):** Utilización de la función de ventana `LAG()` particionada por cliente (`SK_ID_CURR`) y ordenada por línea de tiempo (`MONTHS_BALANCE ASC`) para capturar el estado histórico del mes anterior frente al estado actual.
3. **Agregación y Consolidación de Cartera:** Agrupación matricial del estado previo vs. actual para calcular la densidad de cuentas y el volumen de saldo expuesto.

---

## 📈 Hallazgos Clave de Negocio (*Key Insights*)

* **Retención de Salud Operativa:** El **98.3%** de las cuentas en estado `1. AL DIA` se mantienen al día en el siguiente ciclo (~3.52M cuentas).
* **Deterioro Temprano (*Roll Rate 1-30 a 31-60*):** Un volumen significativo de **60,570 cuentas** rodó de `1. AL DIA` a mora temprana (`2. 1-30`), representando el mayor foco de riesgo de liquidez inicial.
* **Tasa de Cura (*Cure Rate*):** **57,619 cuentas** registradas en mora temprana (`2. 1-30`) lograron retornar a `1. AL DIA`, demostrando una alta efectividad en acciones de cobro preventivo en los primeros 30 días.
* **Mora Crítica Irrecuperable:** El **96.7%** de las cuentas que ingresan a `4. +60` permanecen retenidas en mora tardía o avanzan a *Castigo* (*Write-off*).

---

## 🚀 Cómo Replicar este Proyecto
1. Clonar el repositorio: `git clone https://github.com/DylanLencina-arg/proyecto-1-credit-risk-roll-rates.git`
2. Ejecutar `sql/01_create_table.sql` en PostgreSQL para preparar la base de datos.
3. Importar la data cruda `credit_card_balance.csv` mediante la función `COPY` de pgAdmin.
4. Correr `sql/02_roll_rates_analysis.sql` para generar la matriz consolidada.
5. Cargar el resultado resultante en Power BI y abrir `pbix/dashboard_riesgo_crediticio.pbix`.
