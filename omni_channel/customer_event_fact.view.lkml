# If necessary, uncomment the line below to include explore_source.
include: "/explores/*.lkml"

view: customer_event_fact {
  derived_table: {
    datagroup_trigger: new_day
    explore_source: omni_channel_events_base {
      column: customer_id {}
      column: acquisition_source {}
      column: cart_adds {}
      column: event_count {}
      column: purchases {}
      column: session_count {}
    }
  }
  dimension: customer_id {
    description: "Unique identifier for a customer."
    type: number
  }
  dimension: acquisition_source {
    description: "Marketing or traffic source attributed to customer acquisition."
    type: string
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
}
