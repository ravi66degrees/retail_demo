view: customers {
  sql_table_name: `looker-private-demo.retail.customers` ;;
  drill_fields: [id]

  dimension: id {
    description: "Primary key for this record."
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: address {
    description: "Street address."
    type: string
    sql: ${TABLE}.address ;;
    group_label: "Address Info"
    link: {
      url: "/dashboards/3OmU04xQdYtSVeq2Kf2GIj?Address=%22{{value | encode_uri}}%22&Date%20Range={{ _filters['transactions.transaction_date']}}"
      label: "Drill into this address"
      icon_url: "https://img.icons8.com/cotton/2x/worldwide-location.png"
    }
  }

  dimension: address_street_view {
    description: "Address street view."
    type: string
    group_label: "Address Info"
    sql: ${address} ;;
    html: <img src="https://maps.googleapis.com/maps/api/streetview?size=700x400&location={{value | encode_uri}}&fov=120&key=AIzaSyD7BvCbKqjStBl7r6AmDu1p8yGF-IxtFLs" ;;
  }

  dimension: age {
    description: "Customer age in years."
    type: number
    sql: ${TABLE}.AGE ;;
  }

  dimension: city {
    description: "City."
    type: string
    group_label: "Address Info"
    sql: ${TABLE}.CITY ;;
  }

  dimension: country {
    description: "Country."
    type: string
    group_label: "Address Info"
    map_layer_name: countries
    sql: ${TABLE}.COUNTRY ;;
  }

  dimension_group: registered {
    description: "Time attributes for Registered (available timeframes such as date, week, and month)."
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

  dimension: email {
    description: "Customer email address."
    type: string
    group_label: "Address Info"
    sql: ${TABLE}.EMAIL ;;
  }

  dimension: first_name {
    description: "First name."
    type: string
    hidden: yes
    sql: ${TABLE}.FIRST_NAME ;;
  }

  dimension: gender {
    description: "Customer gender."
    type: string
    sql: ${TABLE}.GENDER ;;
  }

  dimension: last_name {
    description: "Last name."
    type: string
    hidden: yes
    sql: ${TABLE}.LAST_NAME ;;
  }

  dimension: name {
    description: "Display name for this entity."
    type: string
    sql: CONCAT(${first_name}, " ", ${last_name}) ;;
  }

  dimension: latitude {
    description: "Latitude coordinate."
    hidden: yes
    type: number
    sql: ${TABLE}.LATITUDE ;;
  }

  dimension: longitude {
    description: "Longitude coordinate."
    hidden: yes
    type: number
    sql: ${TABLE}.LONGITUDE ;;
  }

  dimension: location {
    description: "Geographic location derived from latitude and longitude."
    type: location
    group_label: "Address Info"
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: state {
    description: "State or province."
    type: string
    group_label: "Address Info"
    sql: ${TABLE}.STATE ;;
  }

  dimension: traffic_source {
    description: "Traffic source."
    type: string
    sql: ${TABLE}.TRAFFIC_SOURCE ;;
  }

  dimension: postcode {
    description: "Postcode."
    type: zipcode
    group_label: "Address Info"
    sql: ${TABLE}.ZIP ;;
  }

  ##### CUSTOM DIMENSIONS #####

  filter: address_comparison_filter {
    description: "Filter on address comparison filter."
    type: string
    suggest_dimension: customers.address
  }

  dimension: address_comparison {
    description: "Address comparison."
    type: string
    group_label: "Address Info"
    sql: CASE
      WHEN {% condition address_comparison_filter %} ${address} {% endcondition %} THEN ${address}
      ELSE 'vs Average'
    END;;
    order_by_field: address_comparison_order
  }

  dimension: address_comparison_order {
    description: "Address comparison order."
    hidden: yes
    type: number
    sql: CASE
      WHEN {% condition address_comparison_filter %} ${address} {% endcondition %} THEN 1
      ELSE 2
    END;;
  }
}
