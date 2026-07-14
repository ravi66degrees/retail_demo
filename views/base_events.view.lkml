view: events {
  sql_table_name: `looker-private-demo.retail.events` ;;
  drill_fields: [id]

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

  dimension: city {
    description: "City."
    type: string
    sql: ${TABLE}.CITY ;;
  }

  dimension: country {
    description: "Country."
    type: string
    map_layer_name: countries
    sql: ${TABLE}.COUNTRY ;;
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

  dimension: latitude {
    description: "Latitude coordinate."
    type: number
    sql: ${TABLE}.LATITUDE ;;
  }

  dimension: longitude {
    description: "Longitude coordinate."
    type: number
    sql: ${TABLE}.LONGITUDE ;;
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

  dimension: state {
    description: "State or province."
    type: string
    sql: ${TABLE}.STATE ;;
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

  dimension: user_id {
    description: "Identifier for user."
    type: number
    # hidden: yes
    sql: ${TABLE}.USER_ID ;;
  }

  dimension: zip {
    description: "Postal / ZIP code."
    type: zipcode
    sql: ${TABLE}.ZIP ;;
  }

  measure: count {
    description: "Count of matching records."
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id]
  }
}
