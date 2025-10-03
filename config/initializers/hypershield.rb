# Specify which environments to use Hypershield
Hypershield.enabled = true

# Specify the schema to use and columns to show and hide
Hypershield.schemas = {
  hypershield: {
    # columns to hide
    # matches table.column
    hide: ["encrypted", "password", "token", "secret", "readonly_api_token", "refresh_token"],
    # overrides hide
    # matches table.column
    show: []
  }
}

# Log SQL statements
Hypershield.log_sql = false
