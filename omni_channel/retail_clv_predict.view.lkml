view: retail_clv_predict {
  sql_table_name: `retail_ltv.lpd_retail_clv_predict_tbl` ;;
  drill_fields: [customer_id]

  dimension: customer_id {
    description: "Unique identifier for a customer."
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: email {
    description: "Customer email address."
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    description: "First name."
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    description: "Last name."
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: monetary_future {
    description: "Monetary future."
    type: number
    sql: ${TABLE}.monetary_future ;;
  }

  dimension: monetary_so_far {
    description: "Monetary so far."
    type: number
    sql: ${TABLE}.monetary_so_far ;;
  }

  dimension: predicted_clv {
    description: "Predicted customer lifetime value from the CLV model."
    alias: [c360.predicted_clv]
    value_format:"[>=1000000]$0.0,,\"M\";[>=1000]$0.0,\"K\";$0.0"
    label: "Predicted CLV"
    type: number
    sql: ${TABLE}.monetary_predicted ;;
  }

  measure: average_clv {
    description: "Average predicted CLV across the selected customers."
    alias: [c360.average_clv]
    value_format:"[>=1000000]$0.0,,\"M\";[>=1000]$0.0,\"K\";$0.0"
    label: "Average CLV"
    type: average
    sql: ${predicted_clv} ;;
  }
}
