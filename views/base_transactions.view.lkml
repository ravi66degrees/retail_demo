include: "date_comparison.view.lkml"

view: transactions {
  sql_table_name: `looker-private-demo.retail.transaction_detail` ;;
  extends: [date_comparison]


  dimension: transaction_id {
    description: "Unique identifier for a transaction/receipt."
    type: number
    primary_key: yes
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: channel_id {
    description: "Unique identifier for the purchase channel."
    type: number
    hidden: yes
    sql: ${TABLE}.channel_id ;;
  }

  dimension: customer_id {
    description: "Unique identifier for a customer."
    type: number
    hidden: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension: line_items {
    description: "Nested array of line items on the transaction (unnest to analyze products)."
    hidden: yes
    sql:
    -- spectacles: ignore
    ${TABLE}.line_items ;;
  }

  dimension: store_id {
    description: "Unique identifier for a store location."
    type: number
    hidden: yes
    sql: ${TABLE}.store_id ;;
  }

  dimension_group: transaction {
    description: "Time attributes for Transaction (available timeframes such as date, week, and month)."
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      hour_of_day,
      week,
      month,
      quarter,
      year,
      week_of_year,
      month_num
    ]
    sql: ${TABLE}.transaction_timestamp ;;
  }

  ##### DERIVED DIMENSIONS #####

  extends: [date_comparison]

  set: drill_detail {
    fields: [transaction_date, stores.name, products.area, products.name, transactions__line_items.total_sales, number_of_transactions]
  }

  dimension_group: since_first_customer_transaction {
    description: "Time attributes for Since first customer transaction (available timeframes such as date, week, and month)."
    type: duration
    intervals: [month]
    sql_start: ${customer_facts.customer_first_purchase_raw} ;;
    sql_end: ${transaction_raw} ;;
  }

  ##### MEASURES #####

  measure: number_of_transactions {
    description: "Count of distinct transactions."
    type: count_distinct
    sql: ${transactions.transaction_id} ;;
    value_format_name: decimal_0
    drill_fields: [drill_detail*]
  }

  measure: number_of_customers {
    description: "Count of distinct customers."
    type: count_distinct
    sql: ${transactions.customer_id} ;;
    value_format_name: decimal_0
    drill_fields: [drill_detail*]
  }

  measure: number_of_stores {
    description: "Count metric: number of stores."
    view_label: "Stores 🏪"
    type: count_distinct
    sql: ${transactions.store_id} ;;
    value_format_name: decimal_0
    drill_fields: [drill_detail*]
  }

  measure: number_of_customer_transactions {
    description: "Count of transactions associated with a known customer."
    hidden: yes
    type: count_distinct
    sql: ${transaction_id} ;;
    filters: {
      field: customer_id
      value: "NOT NULL"
    }
  }

  measure: percent_customer_transactions {
    description: "Share of transactions linked to identified customers."
    type: number
    sql: ${number_of_customer_transactions}/NULLIF(${number_of_transactions},0) ;;
    value_format_name: percent_1
    drill_fields: [drill_detail*]
  }

  measure: first_transaction {
    description: "First transaction for the selected rows."
    type: date
    sql: MIN(${transaction_raw}) ;;
    drill_fields: [drill_detail*]
  }

  ##### DATE COMPARISON MEASURES #####

  measure: number_of_transactions_change {
    description: "Count metric: number of transactions change."
    view_label: "Date Comparison"
    label: "Number of Transactions Change (%)"
    type: number
    sql: COUNT(distinct CASE WHEN ${transactions.selected_comparison} LIKE 'This%' THEN ${transaction_id} ELSE NULL END) / NULLIF(COUNT(distinct CASE WHEN ${transactions.selected_comparison} LIKE 'Prior%' THEN ${transaction_id} ELSE NULL END),0) -1;;
    value_format_name: percent_1
    drill_fields: [drill_detail*]
  }

  measure: number_of_customers_change {
    description: "Count metric: number of customers change."
    view_label: "Date Comparison"
    label: "Number of Customers Change (%)"
    type: number
    sql: COUNT(distinct CASE WHEN ${transactions.selected_comparison} LIKE 'This%' THEN ${customer_id} ELSE NULL END) / NULLIF(COUNT(distinct CASE WHEN ${transactions.selected_comparison} LIKE 'Prior%' THEN ${customer_id} ELSE NULL END),0) -1;;
    value_format_name: percent_1
    drill_fields: [drill_detail*]
  }

  ##### PER STORE MEASURES #####

  measure: number_of_transactions_per_store {
    description: "Count metric: number of transactions per store."
    view_label: "Stores 🏪"
    type: number
    sql: ${number_of_transactions}/NULLIF(${number_of_stores},0) ;;
    value_format_name: decimal_0
    drill_fields: [transactions.drill_detail*]
  }
}
