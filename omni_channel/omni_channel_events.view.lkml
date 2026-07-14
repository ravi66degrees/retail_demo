view: omni_channel_events {
  derived_table: {
    datagroup_trigger: new_day
    sql:
    SELECT
    ID
    ,SEQUENCE_NUMBER
    ,SESSION_ID
    ,IP_ADDRESS
    ,OS
    ,BROWSER
    ,CASE WHEN RAND() < 0.34 THEN 'Organic'
            WHEN RAND() < 0.25 THEN 'Google Ads'
            WHEN RAND() < 0.2 THEN 'Bing Ads'
            WHEN RAND() < 0.15 THEN 'Yahoo Ads'
            WHEN RAND() < 0.1 THEN 'Other Search Engines'
            WHEN RAND() < 0.5 THEN 'Facebook'
            WHEN RAND() < 0.5 THEN 'Email'
            ELSE 'Display'
      END AS TRAFFIC_SOURCE
    ,USER_ID as CUSTOMER_ID
    ,URI
    ,EVENT_TYPE
    ,CREATED_AT
    FROM `looker-private-demo.ecomm.events`
    WHERE USER_ID >= 30000
    ;;
  }

  dimension: id {
    description: "Primary key for this record."
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: browser {
    description: "Browser."
    type: string
    sql: ${TABLE}.BROWSER ;;
  }

  dimension_group: created {
    description: "Time attributes for Created (available timeframes such as date, week, and month)."
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension: customer_id {
    description: "Unique identifier for a customer."
    type: number
    sql: ${TABLE}.CUSTOMER_ID ;;
  }

  dimension: event_type {
    description: "Event type."
    type: string
    sql: ${TABLE}.EVENT_TYPE ;;
  }

  dimension: ip_address {
    description: "Ip address."
    type: string
    sql: ${TABLE}.IP_ADDRESS ;;
  }

  dimension: os {
    description: "Os."
    type: string
    sql: ${TABLE}.OS ;;
  }

  dimension: sequence_number {
    description: "Sequence number."
    type: number
    sql: ${TABLE}.SEQUENCE_NUMBER ;;
  }

  dimension: session_id {
    description: "Identifier for session."
    type: string
    sql: ${TABLE}.SESSION_ID ;;
  }

  dimension: traffic_source {
    description: "Traffic source."
    type: string
    sql: ${TABLE}.TRAFFIC_SOURCE ;;
  }

  dimension: uri {
    description: "Uri."
    type: string
    sql: ${TABLE}.URI ;;
  }

  measure: event_count {
    description: "Count of tracked digital events."
    type: count
  }

  measure: cart_adds {
    description: "Number of add-to-cart events."
    filters: [event_type: "Cart"]
    type: count
  }

  measure: purchases {
    description: "Number of purchase events in the digital channel."
    filters: [event_type: "Purchase"]
    type: count
  }

  measure: acquisition_source {
    description: "Marketing or traffic source attributed to customer acquisition."
    type: string
    sql: SPLIT(MIN(CONCAT(CAST(${TABLE}.CREATED_AT as string),'|',${TABLE}.TRAFFIC_SOURCE)),'|')[OFFSET(1)] ;;
  }

  measure: session_count {
    description: "Count of website or app sessions."
    type: count_distinct
    sql: ${session_id} ;;
  }
}
