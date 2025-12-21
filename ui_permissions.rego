package app.ui_permissions

import input.user

default show_admin_dashboard = false
default allow_beta_features = false

# Allow admin dashboard for 'admin' role
show_admin_dashboard {
    user.role == "admin"
}

# Allow beta features for specific users
allow_beta_features {
    user.email == "alice@example.com"
}

# Allow beta features for 'beta_tester' role
allow_beta_features {
    user.role == "beta_tester"
}
