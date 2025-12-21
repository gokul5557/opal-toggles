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

# --- HELPER RULES ---
is_senior_management {
    user.seniority == "director"
}
is_senior_management {
    user.seniority == "manager"
}
