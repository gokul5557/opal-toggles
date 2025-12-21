package app.ui_permissions

import input.user

# Default: All flags off
default show_admin_dashboard = false
default show_beta_features = false
default show_premium_content = false
default show_debug_logs = false
default allow_user_delete = false
default show_analytics = false
default enable_dark_mode = false
default show_onboarding = true
default allow_file_upload = false
default show_marketing_banner = true
default allow_invites = false
default show_billing_info = false
default enable_experimental_new_ui = false
default allow_api_key_generation = false
default show_system_health = false

# --- Role Based Logic ---

# Admins see almost everything
show_admin_dashboard { user.role == "admin" }
allow_user_delete { user.role == "admin" }
show_analytics { user.role == "admin" }
show_billing_info { user.role == "admin" }
show_system_health { user.role == "admin" }
allow_invites { user.role == "admin" }
show_debug_logs { user.role == "admin" }

# Developers see debug tools
show_debug_logs { user.role == "developer" }
enable_experimental_new_ui { user.role == "developer" }
allow_api_key_generation { user.role == "developer" }
show_system_health { user.role == "developer" }

# Premium Users
show_premium_content { user.plan == "premium" }
allow_file_upload { user.plan == "premium" }
allow_invites { user.plan == "premium" }

# --- Attribute Based Logic ---

# Beta Testers (using data.json)
allow_beta_features {
    # Check if global beta program is active from data.json
    data.global_settings.beta_program_active == true
    # Check if user email is in the list from data.json
    user.email == data.beta_user_emails[_]
}

# Also allow if explicitly set on user object
allow_beta_features { user.is_beta_tester == true }

# Onboarding hidden for old users
show_onboarding = false {
    user.account_age_days > 7
}

# Marketing banner hidden for paying users
show_marketing_banner = false {
    user.plan == "premium"
}
show_marketing_banner = false {
    user.role == "admin"
}

# Dark mode for everyone who prefers it
enable_dark_mode {
    user.preferences.theme == "dark"
}
