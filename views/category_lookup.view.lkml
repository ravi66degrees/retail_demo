view: category_lookup {
  sql_table_name: `looker-private-demo.retail.category_lookup` ;;

  dimension: category {
    description: "Product category."
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: category_code {
    description: "Category code."
    type: number
    sql: ${TABLE}.category_code ;;
  }

  dimension: item_code {
    description: "Item code."
    type: number
    sql: ${TABLE}.item_code ;;
  }

  measure: count {
    description: "Count of matching records."
    type: count
    drill_fields: []
  }
}
