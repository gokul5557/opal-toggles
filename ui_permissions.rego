package app.ui_permissions

import input.user

# Default Deny
default can_access_admin = false
default can_view_hr_portal = false
default can_view_salary = false
default show_beta_tools = false
default show_marketing_banner = true
default allow_user_delete = false

# --- ADMIN ACCESS ---
# Only 'admin' role OR specific emails in data.json
can_access_admin {
    user.role == "admin"
}
can_access_admin {
    user.email == data.admin_emails[_]
}
allow_user_delete {
    can_access_admin
}

# --- HR PORTAL ACCESS ---
# HR Department OR Admins
can_view_hr_portal {
    user.department == "HR"
}
can_view_hr_portal {
    can_access_admin
}

# --- SALARY VISIBILITY ---
# Only if department settings allow it AND user is senior enough
can_view_salary {
    # Check data.json for department config
    data.department_settings[user.department].can_view_salary == true
    # AND user must be director or manager
    is_senior_management
}
can_view_salary {
    user.role == "admin"
}

# --- BETA TOOLS ---
# Only US/CA regions OR if globally active for everyone
show_beta_tools {
    data.global_settings.beta_program_active == true
    user.region == data.beta_features_enabled_for_regions[_]
}

# --- MARKETING ---
# Hide for Enterprise Plan
show_marketing_banner = false {
    user.plan == "enterprise"
}

# --- EXPERIMENTAL UI (Percentage Rollout) ---
# Deterministic rollout based on User ID
enable_experimental_new_ui {
    # Get the rollout percentage from data
    percentage := data.global_settings.new_ui_rollout_percentage
    percentage > 0
    
    # Calculate deterministic score for user (0-99)
    # Assumption: user.id is like "u123"
    # We strip the first char "u" and convert to number
    # In production, use crypto.md5 or sha256 and take modulo
    user_num := to_number(substring(user.id, 1, -1))
    score := user_num % 100
    
    # Enable if score is less than percentage
    score < percentage
}

# --- HELPER RULES ---
is_senior_management {
    user.seniority == "director"
}
is_senior_management {
    user.seniority == "manager"
}
