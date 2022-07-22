view: brand_order_facts {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_revenue {}
      derived_column: brand_rank {
        sql: row_number() over (order by total_revenue desc) ;;
      }
    }
  }

  dimension: brand_rank {
    type: number
  }

  dimension: brand {}
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
}
