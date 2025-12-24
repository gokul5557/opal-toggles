package app.rbac

import future.keywords.if

default allow = false

# Levels: "edit", "read_only", "no_access"
# "NA" in CSV is treated as "no_access"

# Data is now loaded from data.json (data.role_permissions)
# role_permissions := data.role_permissions

# Helper: Get user's permission level for a resource
permission_level = level if {
    role := input.user.role
    resource := input.resource
    level := data.role_permissions[role][resource]
}

# Rule: Can the user perform the action?
allow if {
    permission_level == "edit"
}

allow if {
    permission_level == "read_only"
    input.action == "view"
}

# Specific Allow Rules (Dynamic)
can_create if { permission_level == "edit" }
can_edit if { permission_level == "edit" }
can_delete if { permission_level == "edit" }
can_view if { permission_level == "edit" }
can_view if { permission_level == "read_only" }

# Return all permissions for the UI
ui_permissions[resource] = level if {
    role := input.user.role
    resource_map := data.role_permissions[role]
    level := resource_map[resource]
}
