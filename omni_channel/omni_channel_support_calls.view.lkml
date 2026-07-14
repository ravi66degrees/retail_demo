view: omni_channel_support_calls {
  derived_table: {
    datagroup_trigger: new_day
    sql:
    SELECT * except(client_id)
    , cast(round(rand()*60000+25000,0) as INT64) as client_id
    FROM `looker-private-demo.call_center.transcript_with_messages`
 ;;
  }

  dimension: agent_id {
    description: "Identifier of the support agent."
    type: string
    sql: ${TABLE}.agent_id ;;
  }

  dimension: client_id {
    description: "Customer/client identifier associated with the support call."
    type: number
    sql: ${TABLE}.client_id ;;
  }

  dimension_group: conversation_end {
    description: "Time attributes for Conversation end (available timeframes such as date, week, and month)."
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
    sql: ${TABLE}.conversation_end_at ;;
  }

  dimension: conversation_id {
    description: "Unique identifier for the support conversation."
    type: string
    sql: ${TABLE}.conversation_id ;;
  }

  dimension_group: conversation_start {
    description: "Time attributes for Conversation start (available timeframes such as date, week, and month)."
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
    sql: ${TABLE}.conversation_start_at ;;
  }

  dimension: messages {
    description: "Nested message content from the support conversation."
    hidden: yes
    sql: ${TABLE}.messages ;;
  }

  dimension: resolved_on_call {
    description: "Whether the issue was resolved during the call."
    type: string
    sql: ${TABLE}.resolved_on_call ;;
  }

  measure: count {
    description: "Count of matching records."
    type: count
    drill_fields: []
  }
}

view: omni_channel_support_calls__messages {
  dimension: answer_end {
    description: "Answer end."
    type: number
    sql: ${TABLE}.answer_end ;;
  }

  dimension: answer_start {
    description: "Answer start."
    type: number
    sql: ${TABLE}.answer_start ;;
  }

  dimension: intent_id {
    description: "Identifier for intent."
    type: string
    sql: ${TABLE}.intent_id ;;
  }

  dimension: issue_subtopic {
    description: "Issue subtopic."
    type: string
    sql: ${TABLE}.issue_subtopic ;;
  }

  dimension: issue_topic {
    description: "Issue topic."
    type: string
    sql: ${TABLE}.issue_topic ;;
  }

  dimension: live_agent_speaking {
    description: "Live agent speaking."
    type: yesno
    sql: ${TABLE}.live_agent_speaking ;;
  }

  dimension: message_id {
    description: "Identifier for message."
    type: string
    sql: ${TABLE}.message_id ;;
  }

  dimension: response {
    description: "Response."
    type: string
    sql: ${TABLE}.response ;;
  }

  dimension: row {
    description: "Row."
    type: number
    sql: ${TABLE}.row ;;
  }

  dimension: sentiment {
    description: "Sentiment."
    type: number
    sql: ${TABLE}.sentiment ;;
  }

  dimension: user_end {
    description: "User end."
    type: number
    sql: ${TABLE}.user_end ;;
  }

  dimension: user_question {
    description: "User question."
    type: string
    sql: ${TABLE}.user_question ;;
  }

  dimension: user_start {
    description: "User start."
    type: number
    sql: ${TABLE}.user_start ;;
  }
}
