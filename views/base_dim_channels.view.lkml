view: channels {
  sql_table_name: `looker-private-demo.retail.channels` ;;

  dimension: id {
    description: "Primary key for this record."
    type: number
    hidden: yes
    sql: ${TABLE}.ID ;;
  }

  dimension: name {
    description: "Purchase channel name (for example in-store tills or online)."
    type: string
    label: "Channel Name"
    sql: ${TABLE}.NAME ;;
  }
}
