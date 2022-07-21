view: orders {
  sql_table_name: public.orders ;;
  drill_fields: [id]

  parameter: select_timeframe {
    type: unquoted
    default_value: "created_month"
    allowed_value: {
      value: "created_date"
      label: "Date"
    }
    allowed_value: {
      value: "created_week"
      label: "Week"
    }
    allowed_value: {
      value: "created_month"
      label: "Month"
    }
  }

  dimension: dynamic_timeframe {
    label_from_parameter: select_timeframe
    type: string
    sql:
    {% if select_timeframe._parameter_value == 'created_date' %}
    ${created_date}
    {% elsif select_timeframe._parameter_value == 'created_week' %}
    ${created_week}
    {% else %}
    ${created_month}
    {% endif %} ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
  }
}
