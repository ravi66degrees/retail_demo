# If necessary, uncomment the line below to include explore_source.
include: "/models/omni_channel.model.lkml"

view: c360 {
  derived_table: {
    datagroup_trigger: new_day
    explore_source: customer_transaction_fact {
      column: cart_adds { field: customer_event_fact.cart_adds }
      column: event_count { field: customer_event_fact.event_count }
      column: purchases { field: customer_event_fact.purchases }
      column: session_count { field: customer_event_fact.session_count }
      column: count { field: customer_support_fact.count }
      column: acquisition_source {field: customer_event_fact.acquisition_source}
      column: curbside_transaction_count {}
      column: customer_id {}
      column: discounted_transaction_count {}
      column: first_purchase {}
      column: instore_transaction_count {}
      column: item_count {}
      column: l180_transaction_count {}
      column: l30_transaction_count {}
      column: l360_transaction_count {}
      column: l90_transaction_count {}
      column: last_purchase {}
      column: online_transaction_count {}
      column: return_count {}
      column: total_sales {}
      column: transaction_count {}
    }
  }
  dimension: acquisition_source {
    description: "Marketing or traffic source attributed to customer acquisition."
    drill_fields: [omni_channel_transactions.offer_type]
    type: string
    sql: COALESCE(${TABLE}.acquisition_source,'Unknown') ;;
  }
  dimension: customer_type {
    description: "Whether the customer shops online only, in-store only, or both."
    drill_fields: [acquisition_source,has_visited_website]
    case: {
      when: {
        sql: ${online_transaction_count} > 0 and ${instore_transaction_count} > 0 ;;
        label: "Online Only"
      }
      when: {
        sql: ${online_transaction_count} > 0 and ${instore_transaction_count} = 0 ;;
        label: "Instore Only"
      }
      when: {
        sql: ${online_transaction_count} = 0 and ${instore_transaction_count} > 0 ;;
        label: "Both Online and Instore"
      }

    }
  }

  dimension: cart_adds {
    description: "Number of add-to-cart events."
    type: number
  }
  dimension: event_count {
    description: "Count of tracked digital events."
    type: number
  }
  dimension: purchases {
    description: "Number of purchase events in the digital channel."
    type: number
  }
  dimension: session_count {
    description: "Count of website or app sessions."
    type: number
  }
  dimension: has_visited_website {
    description: "Whether the customer has any digital/website events."
    type: yesno
    sql: ${event_count} > 0 ;;
  }
  dimension: count {
    description: "Count of matching records."
    label: "Support Calls"
    type: number
  }
  dimension: curbside_transaction_count {
    description: "Count of curbside transactions for the customer."
    type: number
  }
  dimension: customer_id {
    description: "Unique identifier for a customer."
    value_format_name: id
    primary_key: yes
    type: number
  }
  dimension: discounted_transaction_count {
    description: "Count of transactions that included a discount or offer."
    type: number
  }
  dimension_group: first_purchase {
    description: "Date of the customer's first purchase."
    type: time
    timeframes: [raw,date]
    sql: CAST(${TABLE}.first_purchase as timestamp) ;;
  }
  dimension: instore_transaction_count {
    description: "Count of in-store transactions for the customer."
    type: number
  }
  dimension: item_count {
    description: "Number of items purchased."
    type: number
  }
  dimension: l180_transaction_count {
    description: "Transactions in the last 180 days."
    type: number
  }
  dimension: l30_transaction_count {
    description: "Transactions in the last 30 days."
    type: number
  }
  dimension: l360_transaction_count {
    description: "Transactions in the last 360 days."
    type: number
  }
  dimension: l90_transaction_count {
    description: "Transactions in the last 90 days."
    type: number
  }
  dimension_group: last_purchase {
    description: "Date of the customer's most recent purchase."
    type: time
    timeframes: [raw,date]
    sql: CAST(${TABLE}.last_purchase as timestamp) ;;
  }
  dimension: days_a_customer {
    description: "Days a customer."
    type: number
    sql: IF(DATE_DIFF(CURRENT_DATE(), ${first_purchase_date}, DAY) > 30,DATE_DIFF(CURRENT_DATE(), ${first_purchase_date}, DAY),30) ;;
  }
  dimension: days_since_last_purchase {
    description: "Days since last purchase."
    type: number
    sql: DATE_DIFF(CURRENT_DATE(), ${last_purchase_date}, DAY) ;;
  }
  dimension: average_days_between_transaction {
    description: "Average days between transaction."
    type: number
    sql: ${days_a_customer} / nullif(${purchases},0) ;;
  }
  dimension: risk_of_churn {
    description: "Relative likelihood that the customer will churn."
    type: number
    value_format_name: percent_1
    sql: IF(1 - (${average_days_between_transaction} / nullif(${days_since_last_purchase},0))<0,0,1 - (${average_days_between_transaction} / nullif(${days_since_last_purchase},0))) ;;
  }
  dimension: risk_of_churn_100 {
    description: "Risk of churn 100."
    type: number
    sql: ${risk_of_churn} * 100 ;;
  }
  dimension: online_transaction_count {
    description: "Count of online transactions for the customer."
    type: number
  }
  dimension: return_count {
    description: "Number of returned transactions or items."
    type: number
  }
  dimension: total_sales {
    description: "Sum of sale price / revenue."
    value_format_name: usd
    type: number
  }
  dimension: transaction_count {
    description: "Number of transactions for this customer or period."
    type: number
  }

#use customer transaction date

  dimension: months_since_first_purchase {
    description: "Months since first purchase."
    type: number
    sql: DATE_DIFF(${omni_channel_transactions.transaction_date}, ${first_purchase_date}, MONTH) ;;
  }

  dimension: transactions_per_month {
    description: "Transactions per month."
    type: number
    sql: ${transaction_count}/nullif(${months_since_first_purchase},0) ;;
  }

  dimension: recency_rating {
    description: "Recency rating."
    hidden: yes
    type: number
    sql: CASE WHEN ${l30_transaction_count} >= 1 THEN 5
              WHEN ${l30_transaction_count} < 1 AND ${l90_transaction_count} >=1 THEN 4
              WHEN ${l30_transaction_count} < 1 AND ${l90_transaction_count} < 1 AND ${l180_transaction_count} >= 1 THEN 3
              WHEN ${l30_transaction_count} < 1 AND ${l90_transaction_count} < 1 AND ${l180_transaction_count} < 1 AND ${l360_transaction_count} >= 2 THEN 2
              WHEN ${l360_transaction_count} < 2 THEN 1
              ELSE null
              END ;;
  }

# number of transactions/orders per month
  dimension: frequency_rating {
    description: "Frequency rating."
    hidden: yes
    type: number
    sql: CASE WHEN ${transactions_per_month} >= 2 THEN 5
              WHEN ${transactions_per_month} >= 1 THEN 4
              WHEN ${transactions_per_month} >= 0.5 THEN 3
              WHEN ${transactions_per_month} >= 0.25 THEN 2
              else 1
              END ;;
  }

  dimension: value_rating {
    description: "Value rating."
    hidden: yes
    type: number
    sql: CASE WHEN ${total_sales} >= 1000 THEN 5
              WHEN ${total_sales} < 1000 AND ${total_sales} >= 800 THEN 4
              WHEN ${total_sales} < 800 AND ${total_sales} >= 600 THEN 3
              WHEN ${total_sales} < 600 AND ${total_sales} >= 400 THEN 2
              WHEN ${total_sales} < 400 THEN 1
              ELSE null
              END ;;
  }

  dimension: rfm_rating {
    description: "Rfm rating."
    type: string
    sql: CASE WHEN ${recency_rating} = 5 AND (${frequency_rating} = 5 OR ${frequency_rating} = 4) THEN 'Champion'
              WHEN (${recency_rating} = 5 OR ${recency_rating} = 4) AND (${frequency_rating} = 3 OR ${frequency_rating} = 2) THEN 'Potential Loyalist'
              WHEN ${recency_rating} = 5 AND ${frequency_rating} = 1 THEN 'New Customer'
              WHEN ${recency_rating} = 4 AND ${frequency_rating} = 1 THEN 'Promising'
              WHEN (${recency_rating} = 4 OR ${recency_rating} = 3) AND (${frequency_rating} = 5 OR ${frequency_rating} = 4) THEN 'Loyal Customer'
              WHEN (${recency_rating} = 2 OR ${recency_rating} = 1) AND ${frequency_rating} = 5 THEN 'Cant lose them'
              WHEN (${recency_rating} = 2 OR ${recency_rating} = 1) AND (${frequency_rating} = 4 OR ${frequency_rating} = 3) THEN 'At Risk'
              WHEN ${recency_rating} = 3 AND ${frequency_rating} = 3 THEN 'Needs Attention'
              WHEN (${recency_rating} = 2 OR ${recency_rating} = 1) AND (${frequency_rating} = 2 OR ${frequency_rating} = 1) THEN 'Hibernating'
              WHEN ${recency_rating} = 3 AND (${frequency_rating} = 2 OR ${frequency_rating} = 1) THEN 'About to sleep'
              ELSE null
              END ;;
  }

  measure: customer_count {
    description: "Count of distinct customers."
    value_format:"[>=1000000]0.0,,\"M\";[>=1000]0.0,\"K\";0"
    drill_fields: [customer_id,customers.name,customers.email,customers.address,retail_clv_predict.predicted_clv,risk_of_churn,omni_channel_transactions__transaction_details.recommended_products]
    link: {
      label: "Top 100 Predicted CLV Customers"
      url: "{{ link }}&sorts=c360.predicted_clv+desc&limit=100"
    }
    type: count
  }

  measure: high_recency_customers {
    description: "High recency customers for the selected rows."
    group_label: "RFV Analysis"
    type: count
    filters: [recency_rating: "5"]
  }

  measure: low_recency_customers {
    description: "Low recency customers for the selected rows."
    group_label: "RFV Analysis"
    type: count
    filters: [recency_rating: "1"]
  }

  measure: high_frequency_customers {
    description: "High frequency customers for the selected rows."
    group_label: "RFV Analysis"
    type: count
    filters: [frequency_rating: "5"]
  }

  measure: low_frequency_customers {
    description: "Low frequency customers for the selected rows."
    group_label: "RFV Analysis"
    type: count
    filters: [frequency_rating: "1"]
  }

  measure: average_sales_amount {
    description: "Average sales amount for the selected rows."
    value_format:"[>=1000000]$0.0,,\"M\";[>=1000]$0.0,\"K\";$0.0"
    type: average
    sql: ${total_sales} ;;
  }

  measure: average_transaction_count {
    description: "Average transaction count for the selected rows."
    type: average
    sql: ${transaction_count} ;;
  }

  measure: high_monetary_value_customers {
    description: "High monetary value customers for the selected rows."
    group_label: "RFV Analysis"
    type: count
    filters: [value_rating: "5"]
  }

  measure: low_monetary_value_customers {
    description: "Low monetary value customers for the selected rows."
    group_label: "RFV Analysis"
    type: count
    filters: [value_rating: "1"]
  }

  # using retail_clv_predict.predicted_clv for CLV metrics below
  # see colab: https://colab.research.google.com/drive/1eLUqHgAv8gJig61t8NgrVzT7uv_pqsFi?resourcekey=0-E5aEzPTb44U80SLiE4NMvg&usp=sharing
  # view with predictions: https://googledemo.looker.com/projects/retail/files/omni_channel/lpd_retail_clv_predict_tbl.view.lkml

  # dimension: predicted_clv {
  #   value_format:"[>=1000000]$0.0,,\"M\";[>=1000]$0.0,\"K\";$0.0"
  #   type: number
  #   sql: (${total_sales} / NULLIF(${days_a_customer},0) * 365) / IF(${customer_type} = 'Both Online and Instore',0.05,0.1) ;;
  # }

  # measure: average_clv {
  #   value_format:"[>=1000000]$0.0,,\"M\";[>=1000]$0.0,\"K\";$0.0"
  #   type: average
  #   sql: ${predicted_clv} ;;
  # }

  # measure: customer_count_first_purchase {
  #   type: count
  #   filters: [months_since_first_purchase: "0"]
  # }

  # measure: sales_per_user {
  #   type: number
  #   sql: ${omni_channel_transactions__transaction_details.total_sales}/${customer_count_first_purchase} ;;
  # }
}
